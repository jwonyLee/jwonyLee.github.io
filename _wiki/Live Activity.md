---
layout: wiki
title: "[iOS] Live Activity"
permalink: dda861ad-c5d0-9e0b-e516-e0ea209f7761
publish: true
date: 2022-08-13
---

```
이 글은 사내에서 발표한 내용을 재구성했습니다. 잘못된 부분이 있으면 댓글로 남겨주세요.
```

WWDC22 에서 iOS 16 소개에서 Live Activity 가 발표됐다. 영상을 보는 순간 우리 회사 도메인과 잘 어울리는 API 라고 생각했고, 관련 영상이 나오기를 기다리고 있었다. 하지만 영상도 나오지 않았고, 문서도 나오지 않아서 그저 실망만 하고 있었는데, 최근에 문서가 업데이트 됐다.

## 개요

Live Activity 는 iOS 16 부터 지원하는 API다. ActivityKit 에 있고, WidgetKit 과 ActivityKit 의 조합으로 구성한다. 

애플에서는 이를 스포츠 게임 중계 같은 실시간 상황에서 사용할 수 있다고 소개한다. 

## 이 글의 목표

[문서](https://developer.apple.com/documentation/activitykit/displaying-live-data-on-the-lock-screen-with-live-activities)에서는 피자 딜리버리를 예시로 들고 있다. 피자 딜리버리도 분명 좋은 예시지만, 더 익숙하게 우리 회사 도메인과 어울리게 구성해볼까 한다.

요금, 주행 거리, 주행 시간 으로 구성한 자전거 라이딩 기록을 보여줄 것이다. 

## 프로젝트 구성

본문에서 작성한 코드는 [jwonyLee/LiveActivitiesPractice](https://github.com/jwonyLee/LiveActivitiesPractice) 에서 볼 수 있다.

### 1. 새로운 iOS 프로젝트 생성

> 기존 프로젝트에 적용한다면 2. Widget Extension 추가하기로 건너뛴다.

Live Activity(= ActivityKit)은 Xcode 14 부터 사용 가능하다. 나는 Xcode 14-Beta4 로 프로젝트를 생성했다. 그 이하 버전에서도 동작하는 지는 모르겠다. (확인 필요)

iOS 16 부터 사용 가능하기 때문에 iOS Deployment Target 을 16 이상으로 설정하거나, 그 이하의 버전을 지원하는 프로젝트라면 `available` 구문으로 iOS 16 이상에서 동작한다고 명시해야 한다.

### 2. Widget Extension 추가하기

개요에서도 설명했다시피 Live Activity 는 WidgetKit 과 ActivityKit 의 조합으로 구현한다. 프로젝트에 Widget Extension 을 추가한다.

![File > New > Target](/assets/img/LiveActivity/File%20new%20Target.png)

![Choose a template for your new target:](/assets/img/LiveActivity/Choose%20a%20templete%20for%20your%20new%20target.png)

![Choose options for your new target:](/assets/img/LiveActivity/Choose%20options%20for%20your%20new%20target.png)

Product Name 은 적절하게 지어주면 되는데, 나는 대략 `LiveActivitiesDashboard` 라는 이름으로 지정했다.

Live Activity 를 사용하기 위해서 Info.plist 에 `NSSuppoortedLiveActivities` 를 추가하고, YES 로 설정해야 한다.

> Widget Target 의 Info.plist 에 추가하면 안되고, App Target 의 Info.plist 에 추가해야 한다. 그렇지 않으면 Live Activity 를 시도했을 때, `com.apple.ActivityKit.ActivityInput error1` 에러가 발생한다.

## 구현

### Live Activity 에 사용할 모델 구현하기

Live Activity 가 사용할 모델은 `ActivityAttributes` 를 채택해서 구현한다. 이 때, 동적 데이터는 ContentState 에 정의하고, 정적 데이터는 외부, 즉 Attributes 에 정의한다.

```swift
public struct RidingAttributes: ActivityAttributes {
    public typealias RidingStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var fee: Int
        var estimatedDistance: Double
        var estimatedRidingTime: Date
    }
}
```

### 잠금 화면에 표시할 UI 구현

`ActivityConfiguration(attributesType:)`로 잠금 화면에 표시할 UI 를 구성한다.

```swift
@main
struct LiveActivitiesDashboard: WidgetBundle {
    var body: some Widget {
        RidingActivityWidget()
    }
}

struct RidingActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(attributesType: RidingAttributes.self) { context in
            VStack {
                HStack {
                    VStack(alignment: .center) {
                        Text("\(context.state.fee) 원")
                            .font(.headline)
                        Text("요금")
                    }
                    .frame(maxWidth: .infinity)

                    // 생략 ...
                }
            }
        }
    }
}
```

> 만약 모델 파일과 위젯 파일의 타겟이 달라서 위젯에서 모델 타입을 찾지 못한다면? 모델 파일의 Target Member 에 위젯 타겟을 체크한다.

### App 의 UI 구현

앱의 UI 는 간단하게 Live Activity 를 시작하고 종료하는 버튼 두 개로 구성했다.

```swift
var body: some View {
    VStack {
        Button("Start Live Activities") {
            startLiveActivities()
            updateData()
        }
        .padding()

        Button("Stop Live Activites") {
            stopLiveActivities()
        }
        .padding()
    }
}
```

~허접~

메서드를 구현해보자.

### `startLiveActivities()`

Live Activity 는 여러개가 실행될 수 있다. 나는 하나만 실행하고 싶어서 옵셔널 프로퍼티로 갖게 해서, 중복 실행을 방지하고자 했다.

```swift
@State private var fee: Int = 0
@State private var estimatedDistance: Double = 0.0
@State private var estimatedRidingTime: Date = Date()

@State private var ridingActivity: Activity<RidingAttributes>?

private func startLiveActivities() {
    if ridingActivity != nil {
        return
    }

    let ridingAttributes = RidingAttributes()

    let initialContentState = RidingAttributes.RidingStatus(
        fee: fee,
        estimatedDistance: estimatedDistance,
        estimatedRidingTime: estimatedRidingTime
    )

    do {
        ridingActivity = try Activity<RidingAttributes>.request(
            attributes: ridingAttributes,
            contentState: initialContentState,
            pushType: nil
        )
        print("Requested a riding Live Activity \(ridingActivity?.id)")
    } catch (let error) {
        print("Error requesting riding Live Activity \(error.localizedDescription)")
    }
}
```

### `updateLiveActivities()`

Widget 이 timeline 매커니즘을 사용해서 데이터를 업데이트 하는 것과 달리 Live Activity 는 다른 방식으로 데이터를 갱신한다.

1. ActivityKit 을 이용해서 데이터를 전달한다.
2. Remote Push Notification 을 이용해서 데이터를 갱신한다.

여기서는 1번 방식을 사용했다. 시간 부족으로 Remote Push Notification 방식은 살펴보지 못했다.

```swift
@State private var timer: Timer? = nil

private func updateData() {
    timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
        self.estimatedDistance += Double.random(in: 0...3)
        self.fee = 400 + (150 * Int(estimatedDistance))
        self.updateLiveActivities()
    }
}
```

`Timer(withDuration:block:)`를 이용해서 주기적으로 데이터를 갱신한다.

```swift
private func updateLiveActivities() {
    Task {
        let updatedRidingStatus = RidingAttributes.RidingStatus(
            fee: fee,
            estimatedDistance: estimatedDistance,
            estimatedRidingTime: estimatedRidingTime
        )

        await ridingActivity?.update(using: updatedRidingStatus)
    }
}
```

갱신한 데이터는 `RidingStatus` 로 만들어서 `Activity<Attributes>.update(using:)` 메서드로 전달한다.

### `cancleLiveActivities()`

```swift
private func stopLiveActivities() {
    Task {
        let updatedRidingStatus = RidingAttributes.RidingStatus(
            fee: 0,
            estimatedDistance: 0,
            estimatedRidingTime: Date()
        )

        do {
            try await ridingActivity?.end(using: updatedRidingStatus, dismissalPolicy: .immediate)
            timer?.invalidate()
        } catch(let error) {
            print("Error ending activity \(error.localizedDescription)")
        }
    }
}
```

`Activity<Attributes>.end(using:dismissalPolicy:)` 메서드를 이용해서 종료한다. 이것을 사용하면서 생소했던 부분은, 그냥 종료시키는게 아니라 초기화된 Status 를 만들어서 전달하는 것이다.

`dismissalPolicy` 는 종료 시점을 설정한다. `default`, `immediate`, `after(_:)`가 있다.

`immediate` 는 즉각 종료이다. `after(_:)` 는 지정한 시간이 지나면 종료한다.

Live Activity 는 최대 8시간까지 활성화될 수 있다. 그 이상의 시간이 지나면 시스템에서 자동으로 종료한다. 그 후에는 최대 4시간까지 잠금화면에서 남아있다. 그래서 도합 12시간까지 잠금화면에 남아있을 수 있다.

## 동작

![동작](/assets/img/LiveActivity/Play.gif)

- `Date` 를 timer 로 표시할 때, 정렬이 안되는 버그가 있다.
- 생각보다 매끄럽지 않음. 약간의 딜레이가 있다.
    - 짧은 주기로 계속 갱신하는 경우, 일정 시간 이후 앱이 죽는다. (1초)
    - 간혈적으로 갱신할 때, 뷰가 깨지는 경우가 있다.
- 역시 베타답게 아직 불안정한듯 하다.

## 질문

> 공유하고 나서 다른 분들께 받은 질문

- 앱의 Life Cycle 과 연관되어 있는지
    - 별도의 라이프 사이클을 가지고 있는 것 같다: 앱을 백그라운드에서 죽여도 살아 있다.
- 액티비티를 종료시킨다의 의미
    - 잠금화면에서 제거한다는 뜻, 혹은.. 더 이상 사용하지 않겠다고 시스템에 알리는 것. 

## 참고 자료

- [ActivityKit](https://developer.apple.com/documentation/ActivityKit)
- [Displaying live data on the Lock Screen with Live Activities](https://developer.apple.com/documentation/activitykit/displaying-live-data-on-the-lock-screen-with-live-activities)

## 태그

#iOS/ActivityKit
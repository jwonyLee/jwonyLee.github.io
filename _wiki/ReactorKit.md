---
layout: wiki
title: ReactorKit
summary: 
permalink: 10bb6466-6b17-6b9d-fcc7-09e3f262cdb1
date: 2022-07-17 00:00:00 +09:00
updated: 2022-07-17 00:00:00 +09:00
tag: iOS 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

> **Note**
> ReactorKit 공식문서를 참고하여 정리한 글입니다.

## ReactorKit

- 반응형 + 단방향 스위프트 어플리케이션 아키텍처 프레임워크
- Flux + Reactive Programming

## View

- ViewController, Cell 은 View 로 취급한다.
- View 는 오로지 action stream 과 state stream 을 매핑하는 방법을 정의한다.
- 기존 객체에 `View` 프로토콜을 채택한다. 그러면 자동으로 `reactor` 라는 이름의 프로퍼티를 갖게 된다. 이 프로퍼티는 외부에서 주입한다.
- `reactor` 프로퍼티가 변경될 때, `bind(reactor:)` 메서드가 호출된다. action stream 과 state stream 을 바인딩하려면 이 메서드를 구현한다.
- Storyboard 를 사용하기 위해서는 `StoryboardView` 프로퍼티를 채택한다. `View` 프로퍼티와 모든 것이 동일하지만, 한 가지 다른 점은 `StroyboardView` 는 뷰가 로드 된 후(viewDidLoad)에 바인딩을 한다.

## Reactor

- 뷰의 상태를 관리하는 UI와 독립적인 레이어다.
- reactor 의 가장 중요한 것은 뷰의 제어 흐름(control flow)을 분리하는 것이다.
- 모든 뷰는 그에 상응하는 reactor 를 가지고 있으며, 모든 로직을 reactor 에 위임한다.
- reactor 는 view 에 의존성을 갖고 있지 않기 때문에 테스트가 쉽다.
- reactor 를 정의하려면 `Reactor` 프로토콜을 채택한다. 이 프로토콜은 세 개의 타입 정의를 요구한다. 또한 `initialState` 라는 프로퍼티를 요구한다.
    - Action: 사용자의 상호 작용을 나타낸다.
    - Mutation: Action 과 State 사이의 중간 역할을 한다.
    - State: 뷰의 상태를 나타낸다.
- reactor 는 두 개의 단계로 action stream 을 state stream 로 변환한다.
    - `mutate()`, `reduce()`
- `mutate()`
    - `mutate()` 는 Action 을 받아서 `Observable<Mutation>`으로 만든다.
    - `func mutate(action: Action) -> Observable<Mutation>`
        - 비동기 operation 혹은 API 콜과 같은 모든 사이드 이펙트는 이 메서드에서 실행된다.
    
    ```swift
    func mutate(action: Action) -> Observable<Mutation> {
    	switch action {
    		case let .refreshFollowingStatus(userID): // receive an action
    			return UserAPI.isFollowing(userID) // create an API stream
    			.map { (isFollowing: Bool) -> Mutation in
    				return Mutation.setFollowing(isFollowing) // convert to Mutation stream
    			}
    		case let .follow(userID):
    			return UserAPI.follow()
    			.map { _ -> Mutation in
    				return Mutation.setFollowing(true)
    			}
    	}
    }
    ```
    
- `reduce()`
    - `reduce()`는 이전의 `State`와 `Mutation`으로부터 새로운 `State`를 만든다.
    - `func reduce(state: State, mutation: Mutation) -> State`
        - 이 메서드는 순수 함수이다. 오로지 동기적으로 새로운 `State`를 반환해야 한다. 이 메서드에서 어떠한 사이드 이펙트도 만들면 안된다.
- `transform()`
    - `transform()` 는 스트림을 각각 변환시킨다. 세 개의 `transform()` 메서드가 있다.
    
    ```swift
    func transform(action: Observable<Action>) -> Observable<Action>
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation>
    func transform(state: Observable<State>) -> Observable<State>
    ```
    
    - 이러한 메서드를 구현하여 다른 관찰 가능한 스트림과 변환하고 결합하라. 예를 들어, `transform(mutation:)` 는 전역 이벤트 스트림(global event stream)을 mutation stream 과 조합하기에 좋은 장소이다. Global States 섹션에서 더 자세한 것을 살펴볼 수 있다.
    - 디버깅을 목적으로 사용할 수도 있다.
    
    ```swift
    func transform(action: Observable<Action>) -> Observable<Action> {
    	return action.debug("action")
    }
    ```
    

## Advanced

### Global States

Redux와 달리, ReactorKit 은 앱의 전역 상태를 제공하지 않는다. 이것이 의미하는 바는 전역 상태를 관리하기 위해 무엇이든 사용할 수 있다는 것이다. `BehaviorSubject`, `PublishSubject` 혹은 reactor 조차 사용할 수 있다. ReactorKit 은 global state 를 가지는 것을 강제하지 않는다. 그래서 애플리케이션의 특정 기능에 ReactorKit 을 사용할 수 있다.

**Action -> Mutation -> State** 흐름에는 global state 가 없다. `transform(mutation:)` 을 사용해서 global state 를 mutation 으로 변환할 수 있다. 현재 인증된 사용자를 저장하는 global `BehaviorSubject` 를 가진다고 가정해보자. `Mutation.setUser(User?)` 를 방출하고 싶다면, `currentUser` 가 변경될 때, 다음과 같이 할 수 있다.

```swift
var currentUser: BehaviorSubject<User> // global state

func transform(mutation: Observable<Mustation>) -> Observavle<Mustation> {
	return Observable.merge(mutation, currentUser.map(Mutation.setUser))
}
```

그런 다음 view가 reactor에 action을 보내고 `currentUser` 가 변경될 때마다 mutation이 방출된다.

### View Communication

여러 뷰 사이의 통신을 하기 위해 callback closure 혹은 delegate 패턴에 익숙해져야 한다. 이를 위해 Reacotkit 은 reactive extensions 사용을 추천한다. 일반적으로 가장 자주 사용되는 `Control Event`의 `UIButton.rx.tap` 이 있다. 핵심 개념은 커스텀 뷰를 UIButton 이나 UILabel 처럼 다루는 것이다.

메세지를 보여주는 `ChatViewController` 를 가지고 있다고 가정해보자. `ChatViewController`는 `MessageInputView` 를 소유하고 있다. 사용자가 `MessageInputView`에 있는 보내기 버튼을 탭했을 때, 텍스트는 `ChatViewController` 에 보내져야 한다. 그리고 `ChatViewController` 는 이를 reactor의 액션과 묶어야 한다. (bind)

아래는 `MessageInputView` 의 reative extension 을 활용한 예시이다.

```swift
extension Reactive where Base: MessageInputView {
	var sendButtonTap: ControlEvent<String> {
		let source = base.sendButton.rx.tap.withLatestFrom(...)
		return ControlEvent(events: source)
	}
}
```

이 익스텐션을 `ChatVeiwController`에서 사용할 수 있다:

```swift
extension Reactive where Base: MessageInputView {
	var sendButtonTap: ControlEvent<String> {
		let source = base.sendButton.rx.tap.withLatestFrom(...)
		return ControlEvent(events: source)
	}
}
```

### Testing

ReactiorKit 은 테스트를 위한 기능이 내장되어 있다.

**What to test (무엇을 테스트?)**

우선 무엇을 테스트할 지 결정해야 한다. 두 개의 테스트가 있다: view 와 reactor

- View
    - Action: 주어진 사용자 상호작용이 reactor에게 적절히 보내졌는가?
    - State: 뷰의 속성이 state 에 맞게 제대로 설정되었는가?
- Reactor
    - State: state가 action에 맞춰 적절히 변경되었는가?

**View testing**

뷰는 stub reactor 에서 테스트 할 수 있다. reactor는 `stub` 이라는 actions 를 기록하고, state를 강제로 변경하는 프로퍼티를 가진다. reactor의 stub 을 활성화 하면, `mutate()` 와 `reduce()` 둘 다 실행되지 않는다. stub은 다음과 같은 프로퍼티들을 가진다.

```swift
var state: StateRelay<Reactor.State> { get }
var action: ActionSubject<Reactor.Action> { get }
var actions: [Reactor.Action] { get } // recorded actions
```

테스트 케이스 예제가 있다.

```swift
func testAction_refresh() {
	// 1. stub reactor 를 준비한다.
	let reactor = MyReactor()
	reactor.isStubEnabled = true

	// 2. strub reactor 와 함께 view 를 준비한다.
	let view = MyView()
	view.reactor = reactor
	
	// 3. 사용자 상호 작용을 보낸다.
	view.refreshControl.sendActions(for: .valueChanged)
	
	// 4. actions 를 검증한다.
	XCTAssertEqual(reactor.stub.actions.last, .refresh)
}

func testState_isLoading() {
	// 1. stub reactor 를 준비한다.
	let reactor = MyReactor()
	reactor.isStubEnabled = true
	
	// 2. strub reactor 와 함께 view 를 준비한다.
	let view = MyView()
	view.reactor = reactor
	
	// 3. stub 의 상태를 설정한다.
	reactor.stub.state.value = MyReactor.State(isLoading: true)
	
	// 4. view 의 속성을 검증한다.
	XCTAssertEqual(view.activityIndicator.isAnimating, true)
}
```

**Reactor testing**

reactor 의 테스트는 독립적이다.

```swift
func testIsBookmarked() {
	let reactor = MyReactor()

	reactor.action.onNext(.toggleBookmarked)
	XCTAssertEqual(reactor.currentState.isBookmarked, true)

	reactor.action.onNext(.toggleBookmarked)
	XCTAssertEqual(reactor.currentState.isBookmarked, false)

}
```

때때로 상태는 한 번의 action 을 위해 한 번보다 많이 변한다. 예를 들어, `.refresh` action은 처음에 `state.isLoading`을 `true`로 설정하고, 새로고침 후에 `false`로 설정한다. 이 경우에 있어서 `state.isLoading`과 `currentState` 는 테스트하기 어렵다. 그래서 아마 `RxTest` 또는 `RxExpect`가 필요하다. 여기 `RxSwift` 를 이용한 테스트 케이스 예시가 있다.

```swift
func testIsLoading() {
	// given
	let scheduler = TestScheduler(initialClock: 0)
	let reactor = MyReactor()
	let disposeBag = DisposeBag()
	
	// when
	scheduler
		.createHotObservable([
		.next(100, .refresh) // send .refresh at 100 scheduler time
		])
		.subscribe(reactor.action)
		.disposed(by: disposeBag)
		
	// then
	let response = scheduler.start(date: 0, subscribed: 0, disposed: 1000) {
		reactor.state.map(\.isLoading)
	}
	
	XCTAssertEqual(response.events.map(\.value.element), [
		false, // initial state
		true,  // just after .refresh
		false  // after refreshing
	])
}
```

### Scheduling

`scheduler` 프로퍼티를 정의한다.

state stream을 줄이고 관찰하는 데 사용되는 스케줄러를 지정하기 위해 scheduler 프로퍼티를 정의하라. 이 queue는 serial queue이어야 한다. 기본 스케줄러는 `CurrentThreadScheduler` 이다.

```swift
final class MyReactor: Reactor {
	let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .default)
	
	func reduce(state: State, mutation: Mutation) -> State {
		// executed in a background thread
		heavyAndImportantCalculation()
		return state
	}
}
```

### Pulse

`Pulse`는 변화가 있을 때만 차이가 있다. 아래 예시로 살펴보자.

```swift
var messagePulse: Pulse<String?> = Pulse(wrappedValue: "Hello tokijh")
let oldMessagePulse: Pulse<String?> = messagePulse
messagePulse.value = "Hello tokijh" // add valueUpdatedCount +1
oldMessagePulse.valueUpdatedCount != messagePulse.valueUpdatedCount // true
oldMessagePulse.value == messagePulse.value // true
```

동일한 값인 경우에도 새 값이 할당된 경우에만 이벤트를 수신할 때 사용한다. 경고 메시지를 띄우는 경우를 예로 들 수 있다. 이러한 경우를 위해 Pulse 를 사용하면, 값이 중복되어 들어오더라도(연속적으로 똑같은 에러 메시지를 표시애햐 할 때) 사용자에게 경고 메시지를 보여줄 수 있다.

## 참고 자료

- [ReactorKit/ReactorKit: A library for reactive and unidirectional Swift applications](https://github.com/ReactorKit/ReactorKit)

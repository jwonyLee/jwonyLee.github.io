---
layout: post
title: "[RxSwift] RxSwiftExt 일부 연산자 정리"
subtitle:
categories: RxSwift
tags: [RxSwift, RxSwiftExt]
published: true
---

`RxSwiftCommunity` 에서 하는 프로젝트
- [https://github.com/RxSwiftCommunity/RxSwiftExt](https://github.com/RxSwiftCommunity/RxSwiftExt)
- RxSwift에서 제공하지 않는 다양한 상황을 처리할 때 도움이 되는 연산자를 제공한다.

24(+2)개의 연산자를 제공하는데 아래에는 일부 연산자만 정리했다.

## distinct

일련의 값에서 중복을 제거할 때 사용한다.

```swift
_ = Observable.of("a", "b", "a", "c", "b", "a", "d")
  .distinct()
  .toArray()
  .subscribe(onNext: { print($0) })
```

```
["a", "b", "c", "d"]
```

## mapAt

`Keypaths`를 활용하여 데이터를 추출할 때 사용한다.

```swift
struct Person {
    let name: String
}

Observable
  .of(Person(name: "Bart"),
      Person(name: "Lisa"),
      Person(name: "Maggie"))
  .mapAt(\.name)
```

```
Bart
Lisa
Maggie
```

## retry, repeatWithBehavior

시퀀스가 완료되거나 오류가 발생하면 시퀀스를 다시 구독하는 동시에 재구독이 발생하는 방법과 시기를 제어한다.

다음 열거형 중 하나를 사용하여 지정한다.
  - `.immediate(maxCount:)` → 최대 `maxCount`번까지 즉시 구독한다.
  - `.delay(maxCount: UInt, time: Double)` → 동일하지만 초 단위로 지연시킨다.
  - `.exponentialDelayed(maxCount: UInt, initial: Double, multiplier: Double)` → 매 주기마다 재구독 지연을 곱한다.
  - `.customTimerDelayed(maxCount: UInt, delayCalculator: (UInt) -> Double)` → 현재 반복을 수신하고 재구독이 지연되어야 하는 시간(초)을 반환하는 클로저를 제공한다.

```swift
// 요청을 최대 3회 시도한다.
// 각 시도에서 지연 시간을 3초 곱한다.
// 그래서 1, 3, 9초 후에 다시 시도한다.
let request = URLRequest(url: url)
let tryHard = URLSession.shared.rx.response(request: request)
  .map { response in
      // process response here
}
  .retry(.exponendialDelayed(maxCount: 3, inital: 1.0,
multiplier: 3.0))
```

## catchErrorJustComplete

오류를 무시하고 싶을 때 사용하는 연산자다.

```swift
let neverErrors = someObservable.catchErrorJustComplete()
```

## withUnretained

주어진 객체에 대한 약한 참조를 유지하고 시퀀스가 무언가를 방출할 때마다 여전히 존재하는 지 여부를 테스트한다. 객체가 여전히 참도되는 경우 전달한 클로저가 실행되고, 반환되는 값은 새로 내보낸 값이다.

```swift
var anObject: SomeClass! = SomeClass()
_ = Observable.of(1, 2, 3, 5, 8, 13, 18, 21, 23)
  .withUnretained(anObject)
  .debug("Combined Object with Emitted Events")
  .do(onNext: { _, value in
      if value == 13 {
        // anObject가 nil이 되면, 새로운 값으로 넘어간다.
        // 시퀀스가 실패하면... 완료된다.
        anObject = nil
        }
    })
  .subscribe()
```

이 연산자는 `guard let self = self` 를 피하면서 안전하게 `self` 를 캡처하려고 할 때 유용하다.

```swift
message
  .withUnretained(self) { vc, message in
    vc.showMessage(message)
  }
```

그리고 RxSwift 6부터 공식적으로 포함되었다. 

## partition

조건에 따라 스트림을 두 개의 스트림으로 분할할 때 사용한다.

```swift
let (evens, odds) = Observable
                      .of(1, 2, 3, 5, 6, 7, 8)
                      .partition { $0 % 2 == 0 }
_ = evens.debug("evens").subscribe() // Emits 2, 6, 8
_ = odds.debug("odds").subscribe() // Emits 1, 3, 5, 7
```

## mapMany

컬렉션 타입의 시퀀스 내부의 모든 개별 요소를 매핑한다.

```swift
_ = Observable.of(
  [1, 3, 5],
[2, 4] )
.mapMany { pow(2, $0) }
.debug("powers of 2")
.subscribe() // Emits [2, 8, 32] and [4, 16]
```
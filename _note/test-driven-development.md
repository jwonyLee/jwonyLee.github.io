---
layout: post
title: 테스트 주도 개발
subtitle: 
notetype: feed
tags: [TDD, 테스트-주도-개발]
created: 2022-01-06 16:29:11+09:00
updated: 2022-01-09 16:02:13+09:00
published: true
---

## 기록

테스트 주도 개발(TDD)의 리듬
1. 재빨리 테스트를 하나 추가한다.
2. 모든 테스트를 실행하고 새로 추가한 것이 실패하는지 확인한다.
3. 코드를 조금 바꾼다.
4. 모든 테스트를 실행하고 전부 성공하는지 확인한다.
5. 리팩토링을 통해 중복을 제거한다.

## 생각

1. 재빨리 테스트를 하나 추가한다. → 테스트를 실행하고 실패하는지 확인한다.
```swift
func test_달러를_곱한다() {
	let five: Dollar = Dollar(5)
	five.times(2)
	XCTAssertEqual(10, five.amount)
}
```

현재 컴파일 에러를 하나씩 **빠르게** 해결한다.
- `Dollar` 클래스가 없음
	```swift
class Dollar {}
	```
- 생성자가 없음
	```swift
class Dollar {
	init(_ amount: Int) {}
}
	```
- `times(_:)` 메서드가 없음
	```swift
class Dollar {
	// ...생략
	func times(_ multiplier: Int) {}
}
	```
- `amount` 필드가 없음
	```swift
class Dollar {
	var amount: Int = 10
}
	```


3 ~ 5. 코드를 수정하고, 테스트를 실행해서 성공을 확인하고, 리팩토링해서 중복을 제거한다.
```swift
class Dollar {
  var amount: Int

  init(_ amount: Int) {
	self.amount = amount
  }

  func times(_ multiplier: Int) {
	amount *= multiplier
  }
}
```

## 출처
- 

## 연결고리
-
---
layout: wiki
title: Optional 이란 무엇인지 설명하시오.
summary:
permalink: 7972af36-2e95-e5a9-936b-b2d8008d0dd2
date: 2020-09-08 00:00:00 +09:00
updated: 2020-09-08 00:00:00 +09:00
tag: Swift Optional iOSInterviewquestions  
public: true
parent: [[iOSInterviewquestions]]
latex: true
comment: true
---

* TOC
{:toc}

## 개요

```
💡 옵셔널 체이닝 등 일부 빠진 개념은 좀 더 공부하고서 채울 예정
```

```
💡 스위프트에서는 `NULL` 을 `nil` 로 표기한다.
```

스위프트를 처음 접하면서 가장 먼저 만나는 생소한 문법은 `Optional` 이 아닐까 생각한다. 코틀린에는 `Nullable` 이라는 개념이 있지만 내가 주로 사용했던 자바나 파이썬에는 없는 문법이었다. (Java8 부터 도입되었다.)

일단, `Optional`에 대해서 알아보자. 

[The Swift Programming Language (Swift 5.3)](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html#ID330) 페이지에서 `Optional`을 이렇게 설명한다.

> You use optionals in situations where a value may be absent. An optional represents two possibilities: Either there is a value, and you can unwrap the optional to access that value, or there isn’t a value at all.

> 값이 없을 수 있는 상황에서 옵셔널을 사용합니다. 옵셔널은 두가지 가능성을 나타낸다: 값이 있고 옵셔널을 풀어서 해당 값에 액세스할 수 있거나 값이 전혀 없는 경우.

## 옵셔널 변수(또는 상수)를 만드는 법

`Int`형 변수를 만든다고 해보자. 우리는 모종의 이유로 변수를 생성하고 나중에 값을 초기화해주고 싶다. 그리고 이러한 상황을 파이썬으로 작성한다면 다음과 같다.

```python
num = None
num = 7
print(num) # 7
```

나중에 넣은 7이 잘 출력되는 걸 확인할 수 있다. 똑같이 스위프트로 작성하면 어떨까?

```swift
var num: Int = nil // 🛑 'nil' cannot initialize specified type 'Int'
num = 7
print(num)
```

스위프트는 `nil`에 대해서 엄격한 편이다. 그래서 우리가 평소에 다른 언어에서 사용하던 것처럼 변수 생성 시 `nil`을 넣고 나중에 초기화 하려고 하면 `Xcode`에서는 `'nil' cannot initialize specified type 'Int'` 이라는 문구와 함께 빨간줄이 뜬다. 

위 상황처럼 일반 변수에 `nil`을 할당하려고 하면, 컴파일 오류가 우리를 반긴다. 스위프트에서는 옵셔널 변수(상수)가 아니면 `nil`을 할당할 수 없다. 

옵셔널 변수(상수)를 생성하고 `nil`을 할당해보자. 타입 뒤에 `?`를 붙이면 된다.

```swift
var num: Int? = nil
num = 7
print(num) // Optional(7)
```

`num`변수에 7을 넣고 출력을 해보니 출력이 되긴 하는데, 뭔가 이상하다. 값이 `Optional()`로 감싸져서 출력된다. 이제, 옵셔널 값을 과일 깎듯 알맹이만 뽑아내는 방법을 알아보자.

## 강제 추출(Forced Unwrapping)

옵셔널 값을 강제로 추출하려면 옵셔널 값 뒤에 `!`를 붙인다. 이 방법은 확실하지만 위험하다. 벗겨내려는 옵셔널이 값이 있다면 문제가 없겠지만, 값이 없는 상황이라면 오류가 우리를 반긴다.

```swift
var num: Int? = 7
if num != nil {
	print("num is \(num!)") // num is 7
}
```

가급적이면 사용하지 않고, 혹시라도 쓰게 된다면 **반드시 값이 있음을 보장하는 상황에서만** 쓰자.

## 옵셔널 바인딩(Optional Binding) - if

옵셔널 바인딩은 옵셔널 변수(상수)에 값이 있는지 확인하고, 해당 값을 임시 변수(상수)에 할당해서 사용하는 기법이다. `if`문이나 `while`문과 함께 사용된다. 

```swift
func output(_ myName: String?) {
	if let name = myName {
		print("my name is \(name)")
	} else {
		print("unknown name")
	}
}

var myName: String? = "지원"
output(myName) // my name is 지원
```

`if`문에서 생성한 임시 상수 `name`은 `if`문 내부에서만 사용할 수 있다.

위와 같은 상황을 `guard`문을 이용해서 처리할 수도 있다.

## 옵셔널 바인딩(Optional Binding) - guard

`guard`문에 있는 조건이 `false`인 경우에는 `guard`문 내부로 진입하고, `true`인 경우에는 바깥 코드를 진행한다.

`if`문으로 생성한 임시 상수는 `if`문 내부에서만 사용할 수 있지만, `guard`문으로 생성한 상수는 `guard`구문이 끝나고 난 뒤부터 함수 내부의 지역 상수처럼 사용할 수 있다. 

```swift
func output(_ name: String?) {
	guard let name = myName else {
		print("unknown name")
		return
	}
	print("my name is \(name)")
}

var myName: String? = nil
output(myName) // unknown name
```

`guard`문 내부의 끝에는 `return`, `break`, `continue`, `throw`가 포함되어야 한다.

## Nil-Coalescing Operator - ??

`??`연산자는 값이 포함되어 있는 경우에는 옵셔널을 벗긴 값을 반환하고, 없는 경우에는 default 값을 설정해줄 수 있다.

```swift
var myNickname: Int? = nil
let nickname = myNickname ?? "먹구름"
print(nickname) // "먹구름"
```

## !!

[Double exclamation !! mark in Swift?](https://stackoverflow.com/questions/31467510/double-exclamation-mark-in-swift) 이라는 스택오버플로우 글을 보면, `Optional(Optional(value))`와 같이 이중으로 포장 되어있는 상황에서 사용하는 거 같지만, 더 자세한 자료는 찾지 못해서 일단 이 부분은 좀 더 찾아보는 걸로....

## 참고 자료

- [The Swift Programming Language (Swift 5.3)](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html#ID330)
- [스위프트 프로그래밍: Swift 5](http://www.kyobobook.co.kr/product/detailViewKor.laf?ejkGb=KOR&mallGb=KOR&barcode=9791162242223&orderClick=LEa&Kc=)
- [guard let과 if let의 차이점](https://velog.io/@dev-lena/guard-let과-if-let의-차이점)
- [Swift guard statement](https://www.programiz.com/swift-programming/guard-statement)

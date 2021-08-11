---
layout: post
title: Delegate란 무언인가 설명하고, retain 되는지 안되는지 그 이유를 함께 설명하시오.
subtitle: iOSInterviewquestions
categories: iOSInterviewquestions
tags: [iOS, iOSInterviewquestions]
emoji: 📱
---

## Delegate
_Delegation_ 은 클래스 또는 구조체가 책임의 일부를 다른 유형의 인스턴스에 넘겨주거나 _위임_ 할 수 있도록 하는 디자인 패턴이다. 이 디자인 패턴은 위임된 기능을 제공하기 위해 준수 형식(대리자라고 함)이 보장되도록 위임된 책임을 캡슐화하는 프로토콜을 정의하여 구현된다.

## retain
```swift
protocol SomeDelegate {
    func something()
}
```

```swift
class SomeClass {
    var delegate: SomeDelegate?
}

var some1: SomeClass? = SomeClass()
var some2: SomeClass? = SomeClass()

some1.delegate = some2
some2.delegate = some1

some1 = nil
some2 = nil
```

위의 코드와 같은 경우에는 retain cycle이 발생한다. 왜냐하면 `SomeClass`의 `delegate`가 `strong`으로 선언되어 있는데, 이렇게 강한 참조를 하면 상위 객체의 `nil`을 할당해도 메모리에서 해제되지 않는다.

```swift
class SomeClass {
    weak var delegate: SomeDelegate?
}

var some1: SomeClass? = SomeClass()
var some2: SomeClass? = SomeClass()

some1.delegate = some2
some2.delegate = some1

some1 = nil
some2 = nil
```

두번째 코드처럼 `delegate`에 `weak` 키워드를 포함하여 선언하면, 상위 객체에 `nil`을 할당할 때 메모리에서 같이 해제된다.

---

## 참고 자료
- [[Swift] Retain cycle, weak, unowned [번역]](https://baked-corn.tistory.com/30)
- [Protocols - The Swift Programming Language](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html)

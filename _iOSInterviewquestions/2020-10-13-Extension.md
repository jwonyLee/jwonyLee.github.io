---
layout: post
title: Extension에 대해 설명하시오.
subtitle: iOSInterviewquestions
categories: iOSInterviewquestions
tags: [Swift, iOSInterviewquestions]
emoji: 🍎
---

이미 만들어진 클래스, 구조체, 열거형의 기능을 확장하고 싶을 때 사용하는 키워드

- 상속은 수직 확장이고, Extension은 수평 확장
- 확장하려는 클래스, 구조체, 열거형의 내용?을 몰라도 구현할 수 있음
    - String, Int를 확장한다거나...

```swift
extension ExtensionType {

}
```

- 프로토콜도 확장 가능
- 추가할 수 있는 기능
    - 연산 타입 프로퍼티 / 연산 인스턴스 프로퍼티
    - 타입 메서드 . 인스턴스 메서드
    - 이니셜라이저
    - 서브스크립트
    - 중첩 타입
    - 특정 프로토콜을 준수할 수 있도록 기능 추가
- 타입에 새로운 기능을 추가할 수는 있지만, 기존에 존재하는 기능을 재정의할 수 없음
- 이니셜라이저를 추가할 수 있지만, 지정 이니셜라이저와 디이니셜라이저는 반드시 클래스 타입의 구현부에 위치해야 함
    - 지정 이니셜라이저, 디이니셜라이저가 뭔지 찾아보기
    
---

## 스터디

- 가독성있는 코드를 작성할 때 사용
- 외부 라이브러리, `String`, `Int`와 같은 Original 코드에 접근할 수 없는 것에 기능을 추가할 때 사용
    - retroactive modeling
- 기존에 존재하던 프로퍼티에 프로퍼티 감시자를 추가할 수 없음
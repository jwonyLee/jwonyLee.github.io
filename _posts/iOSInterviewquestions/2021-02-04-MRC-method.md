---
layout: post
title: ARC 대신 Manual Reference Count 방식으로 구현할 때 꼭 사용해야 하는 메서드들을 쓰고 역할을 설명하시오.
subtitle: iOSInterviewquestions
categories: iOSInterviewquestions
tags: [ARC, iOSInterviewquestions]
emoji: 💾
---

## alloc/init

`alloc` → 수신 클래스의 새 인스턴스를 반환. 새 인스턴스의 isa 인스턴스 변수는 클래스를 설명하는 데이터 구조로 초기화됨. 다른 모든 인스턴스 변수의 메모리는 0으로 설정됨. 새 인스턴스는 기본 영역에서 할당됨. `allocWithZone:` 을 사용하여 특정 영역을 지정

초기화를 완료하려면 `init` 메소드를 이용해야한다.

```objectivec
TheClass *newObject = [[TheClass alloc] init];
```

`init` → 메모리가 할당된 직후에 새 객체(수신자)를 초기화하기 위해 서브 클래스에 의해 구현됨. `init` 은 일반적으로 동일한 코드 라인에서 `alloc` 또는 `allocWithZone:` 과 같이 사용함

## retain

수신자의 참조 횟수를 증가시킴

## release

수신자의 참조 횟수를 감소시킴

## autorelease

> Decrements the receiver’s retain count at the end of the current autorelease pool block.

현재 autorelease pool block의 끝에서 수신자의 참조 횟수를 감소시킴

---

## 참고 자료

- [About Memory Management](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html)
- [retain - Apple Developer Documentation](https://developer.apple.com/documentation/objectivec/1418956-nsobject/1571946-retain)
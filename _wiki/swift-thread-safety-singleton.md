---
layout: wiki
title: thread safety한 싱글톤
summary: 
permalink: dcded7c6-5ce0-ebca-6536-e7323d041de4
date: 2024-04-13 20:05:32 +09:00
updated: 2024-04-13 20:05:32 +09:00
tag: Swift/Design-Patterns 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

# thread safety한 싱글톤

일반적인 싱글톤 패턴 만드는 방법

```swift
final class Singleton {
    static let shared: Singleton = Singleton()

    private init() { }
}
```

Java에서는 싱글톤 패턴으로 객체를 thread-safety하게 만들기 위해 다양한 방법들이 존재한다. 

1. `synchronized` 동기화 키워드를 사용한다.
이 방법은 매번 스레드 환경에서 락이 걸리기 때문에, 부가적인 성능 부하가 발생할 수 있다.
2. 이른 초기화 사용
일반적인 스위프트의 싱글톤 객체를 만드는 방법과 동일하다. 미리 만든다는 것 자체가 단점이 될 수 있다. 왜냐하면 해당 객체의 인스턴스를 생성하는 비용이 많이 드는데, 사용하지 않게 된다면? 사용 여부와 상관없이 만들기 때문에 불필요한 비용이 발생할 수 있다.
3. double checked locking
`synchronized`를 내부에서 사용한다. 인스턴스를 필요한 시점에 만들 수 있다.
4. 내부에 Holder 클래스를 만들어서 초기화 하는 방식. 이것이 현재 자바에서 가장 이점인 방식인 듯 하다.

그러나 스위프트에서는 맨 위에 소개한 코드처럼 이른 초기화로 구현하면 된다. <mark>전역 변수를 사용하여 인스턴스를 생성하면 사용 시점에 초기화가 된다고 한다.</mark>

## 참고 자료

- https://medium.com/@jang.wangsu/swfit-thread-safety-한-싱글톤-사용은-75c43e567acf

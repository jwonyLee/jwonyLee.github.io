---
layout: wiki
title: Identifiable
summary: 
permalink: 23541f6b-c82d-d953-2284-dde1ad84ec46
date: 2024-01-01
updated: 2024-01-01
tag: Swift
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

# Identifiable

> A class of types whose instances hold the value of an entity with stable identity.

인스턴스가 stable 한 신원(identity)을 갖는 걸 보장하게 하는 프로토콜

```swift
class User: Identifiable {
	var id: UUID = UUID() // id 의 타입이 Hashable 만 만족하면 된다.
}
```

## 참고 자료

- https://developer.apple.com/documentation/swift/identifiable

## 태그


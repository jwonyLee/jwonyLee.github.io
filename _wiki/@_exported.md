---
layout: wiki
title: "@_exported"
summary: 
permalink: 1df01bae-fd61-4f66-6b54-0d30064add73
date: 2024-09-19 00:00:00 +09:00
updated: 2024-09-20 00:53:04 +09:00
tag: SPM
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

SPM 에서 A 패키지가 B 패키지를 포함하고 있으면 A 패키지만 import 해도 B 패키지를 import 하는 것처럼의 효과를 내려면 다음과 같이 작성하기

```swift
@_exported import UIKit
```

`UIKit` 이 import 가능한 상황에서만 import 하고싶다면 다음과 같은 전처리문을 포함하여 작성.

```swift
#if canImport(UIKit)
@_exported import UIKit
#endif
```

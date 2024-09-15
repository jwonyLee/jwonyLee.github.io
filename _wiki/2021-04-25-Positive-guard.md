---
layout: wiki
title: 긍정적인 Guard 사용
summary: 
permalink: 21b56994-cc18-9f41-e982-cf9735b9d345
date: 2021-04-25
updated: 2021-04-25
tag: Swift 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

# \[Swift] 긍정적인 Guard 사용

레츠스위프트 30호를 읽다가, 와닿는 부분이 있어서 요약, 정리했다. 알고리즘 풀 때도 비슷하게 많이 쓰는데 (`while !queue.isEmpty`) 이걸 읽고서 고쳐야겠다는 생각이 들었다.

## Use Positive Guards

`guard` 키워드의 주요 용도

1.  계산에 필요한 옵션을 언랩핑
2.  기능에 대한 전제 조건을 명시

여기서는 두 번째 용도에 대해 설명한다.

```swift
guard !pieces.isEmpty else {
    return
}
```

위 코드는 두 가지 단점이 있다.

1.  오류가 발생하기 쉬움 → `!`를 잊기 쉽다.
2.  내재화하기 어렵다. 조건을 읽을 때, 코드의 의미를 제대로 이해하기 위해 읽은 단어의 의미를 뒤집어야 한다.

`Collection` 프로토콜에 사소한 도우미를 추가하여 이 문제를 쉽게 해결할 수 있다.

```swift
extension Collection {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}

// ...

guard pices.isNotEmpty else {
    return
}
```

---

## 참고 자료

- [깔끔한 스위프트 코드를 위한 5가지 팁](https://betterprogramming.pub/5-tips-to-write-clean-swift-code-2ef287a11500)

## 태그


---
layout: wiki
title: 코드로 버튼에 이미지와 텍스트 넣기
summary: 
permalink: a1e1ff84-afb9-3cd4-779b-ffac01f78ed8
date: 2021-04-16 00:00:00 +09:00
updated: 2021-04-16 00:00:00 +09:00
tag: iOS
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

```swift
let button = UIButton()
button.translatesAutoresizingMaskIntoConstraints = false
button.titleLabel?.adjustsFontForContentSizeCategory = true
button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
button.tintColor = .secondaryLabel
button.setTitle("5", for: .normal)
button.setTitleColor(.secondaryLabel, for: .normal)
button.semanticContentAttribute = .forceLeftToRight
button.contentVerticalAlignment = .center
button.contentHorizontalAlignment = .leading
```

이미지를 텍스트의 오른쪽으로 변경하려면 `semanticContentAttribute` 속성을 `.forceRightToLeft`로 변경한다.

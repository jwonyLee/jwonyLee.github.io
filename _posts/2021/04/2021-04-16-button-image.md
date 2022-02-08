---
title: '[iOS] 코드로 버튼에 이미지와 텍스트 넣기'
tags: [iOS, Programmatically]
categories: iOS
comments: true
---

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
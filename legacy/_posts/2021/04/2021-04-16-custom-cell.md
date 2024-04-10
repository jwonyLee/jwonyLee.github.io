---
title: '[iOS] 커스텀 셀 적용하기'
tags: [iOS, Programmatically, UICollectionView]
categories: iOS
comments: true
---

## 코드로 만든 경우

```swift
collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
```

## `xib`로 만든 경우

```swift
let nib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
collectionView.register(nib, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
```
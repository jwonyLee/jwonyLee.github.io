---
title: "[iOS] 커스텀 셀 적용하기"
permalink: e6ad015d-77c7-a653-dd35-5830c489dcd0
publish: true
created: 2021-04-16
---

# \[iOS] 커스텀 셀 적용하기

## 코드로 만든 경우

```swift
collectionView.register(CustomCollectionViewCell.self, forCellWithReusepermalink: CustomCollectionViewCell.identifier)
```

## `xib`로 만든 경우

```swift
let nib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
collectionView.register(nib, forCellWithReusepermalink: CustomCollectionViewCell.identifier)
```

## 태그

#iOS/UICollectionView
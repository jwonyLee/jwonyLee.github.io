---
layout: wiki
title: 커스텀 셀 적용하기
summary: 
permalink: e6ad015d-77c7-a653-dd35-5830c489dcd0
date: 2021-04-16
updated: 2021-04-16
tag: iOS 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

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


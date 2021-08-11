---
layout: post
title: "[iOS] 컬렉션뷰 최상단으로 이동하기"
subtitle: Programmatically go to the top of the UICollectionView
categories: iOS
tags: [iOS, Programmatically, UICollectionView]
---

```swift
@objc func scrollToTop(_ sender: UIButton) {
    collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	// collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
}
```
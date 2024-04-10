---
title: '[iOS] 컬렉션뷰 최상단으로 이동하기'
tags: [iOS, Programmatically, UICollectionView]
categories: iOS
comments: true
---

```swift
@objc func scrollToTop(_ sender: UIButton) {
    collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	// collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
}
```
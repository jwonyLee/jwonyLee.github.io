---
layout: wiki
title: 컬렉션뷰 최상단으로 이동하기
summary: 
permalink: 794a8fe6-1bd9-f907-b97f-5c8d58f174c9
date: 2021-04-16
updated: 2021-04-16
tag: iOS UICollectionView 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

# \[iOS] 컬렉션뷰 최상단으로 이동하기

```swift
@objc func scrollToTop(_ sender: UIButton) {
    collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	// collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
}
```

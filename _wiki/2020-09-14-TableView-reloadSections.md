---
layout: wiki
title: 
summary: 
permalink: 6818f72c-8679-19ea-5849-0fa044b8e138
date: 2020-09-14
updated: 2020-09-14
tag: iOS/UIKit/UITableView iOSInterviewquestions Knowledge 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

# \[iOS] TableView.reloadSections(_:with:)

```swift
TableView.reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)
```

특정 섹션의 데이터를 `Reload`하는 메소드

`sections`에 들어가는 매개변수는 범위를 나타나는데, 만약 첫번째 섹션만 `Reload` 하고 싶다면,

```swift
TableView.reloadSections(IndexSet(0...0), with: .automatic)
```

범위를 0부터 0까지 포함으로 설정해주면 된다. 첫번째부터 두번째 섹션까지 `Reload` 하고 싶다면,

```swift
TableView.reloadSections(IndexSet(0...1), with: .automatic)
```

`StartIndex...EndIndex`형태로 작성해주면 된다. `...`을 사용할 경우 `EndIndex`를 포함하고 `EndIndex` 이전까지만 하고 싶으면 `StartIndex..<EndIndex`로 작성하면 된다.

---
layout: post
title: TableView.reloadSections(_:with:)
subtitle: 
categories: iOS
tags: [iOS, UITableView]
emoji: ๐ฑ
---

```swift
TableView.reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)
```

ํน์  ์น์์ ๋ฐ์ดํฐ๋ฅผ `Reload`ํ๋ ๋ฉ์๋

`sections`์ ๋ค์ด๊ฐ๋ ๋งค๊ฐ๋ณ์๋ ๋ฒ์๋ฅผ ๋ํ๋๋๋ฐ, ๋ง์ฝ ์ฒซ๋ฒ์งธ ์น์๋ง `Reload` ํ๊ณ  ์ถ๋ค๋ฉด,

```swift
TableView.reloadSections(IndexSet(0...0), with: .automatic)
```

๋ฒ์๋ฅผ 0๋ถํฐ 0๊น์ง ํฌํจ์ผ๋ก ์ค์ ํด์ฃผ๋ฉด ๋๋ค. ์ฒซ๋ฒ์งธ๋ถํฐ ๋๋ฒ์งธ ์น์๊น์ง `Reload` ํ๊ณ  ์ถ๋ค๋ฉด,

```swift
TableView.reloadSections(IndexSet(0...1), with: .automatic)
```

`StartIndex...EndIndex`ํํ๋ก ์์ฑํด์ฃผ๋ฉด ๋๋ค. `...`์ ์ฌ์ฉํ  ๊ฒฝ์ฐ `EndIndex`๋ฅผ ํฌํจํ๊ณ  `EndIndex` ์ด์ ๊น์ง๋ง ํ๊ณ  ์ถ์ผ๋ฉด `StartIndex..<EndIndex`๋ก ์์ฑํ๋ฉด ๋๋ค.
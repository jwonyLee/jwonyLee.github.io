---
layout: wiki
title: TabView + ScrollView
summary: 
permalink: a6f7c741-4d45-d56e-7c60-aea6037ccc1a
date: 2024-05-19 19:12:52 +09:00
updated: 2024-05-19 19:12:52 +09:00
tag: iOS SwiftUI 삽질 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

탭 뷰의 배경색, 구분선 색상 지정을 하려면:

```swift
TabView {
	// 생략
}
.onAppear() {
	let appearance = UITabBarAppearance()
	appearance.configureWithTransparentBackground()
	appearance.shadowColor = UIColor(Color.blue) // <-- 구분선
	appearance.backgroundColor = UIColor(Color.white) // <-- 배경색
	
	UITabBar.appearance().scrollEdgeAppearance = appearance
}
```

하지만 이상하게 [[TabView]] 에서 띄워주는 하위 뷰의 내부가 [[ScrollView]]로 감싸져 있다면 다음과 같이 색상이 적용되지 않는 현상이 있음.

![탭 뷰 배경색이 적용되지 않은 이미지](https://private-user-images.githubusercontent.com/15073405/331861964-e1a28823-e48e-441b-8bb9-8f7db8437c00.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MTYxMTIyMzksIm5iZiI6MTcxNjExMTkzOSwicGF0aCI6Ii8xNTA3MzQwNS8zMzE4NjE5NjQtZTFhMjg4MjMtZTQ4ZS00NDFiLThiYjktOGY3ZGI4NDM3YzAwLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDA1MTklMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwNTE5VDA5NDUzOVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWI0MWQ0ZmU0NTQ0ZTBkNDg5Mzk2YjlmZTg1ZGQxYjU4MjNiYjg3NTNlYjk1YjNjN2I3YzhhMWRjOGI3ZjNiNjgmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.2ZMZ12NhBYxdj9_QdOtxhGdJpS_DLgb6hz1B-gsoGlE)

이걸로 삽질을 좀 열심히 했는데 ... `onAppear` 에서 다음 한 줄 추가하는 것으로 해결함:

```diff
TabView {
	// 생략
}
.onAppear() {
	let appearance = UITabBarAppearance()
	appearance.configureWithTransparentBackground()
	appearance.shadowColor = UIColor(Color.blue) // <-- 구분선
	appearance.backgroundColor = UIColor(Color.white) // <-- 배경색

+	UITabBar.appearance().standardAppearance = appearance
	UITabBar.appearance().scrollEdgeAppearance = appearance
}
```

`scrollEdgeAppearance` 에 할당한 것을 빼면 [[ScrollView]]로 감싸져있지 않은 하위 뷰에서 [[TabView]] 배경색이 적용되지 않으므로, 두 개 다 할당해줘야 함.

[scrollEdgeAppearance](https://developer.apple.com/documentation/uikit/uinavigationbar/3198027-scrolledgeappearance)
> The appearance settings for the navigation bar when the edge of scrollable content aligns with the edge of the navigation bar.

[standardAppearance](https://developer.apple.com/documentation/uikit/uinavigationbar/3198028-standardappearance)
> The appearance settings for a standard-height navigation bar.

`scrollEdgeAppearance` 는 스크롤 가능한 컨텐츠일 때 **스크롤이 가장자리(뷰의 최하단)에 닿은 경우 적용**
`standardAppearance` 는 표준 높이의 네비게이션에 적용

---

그래서 `scrollEdgeAppearance` 만 적용되어 있는 경우에 스크롤이 있는 컨텐츠에서는 스크롤을 내려 하단에 닿지 않으면 appearance 가 적용되지 않았던 것.

잘 이해가 안 가는 부분은, `standardAppearance` 만 적용했을 때, 스크롤뷰로 감싸져 있지 않은 하위 뷰에서 appearance가 적용되지 않는 이유를 모르겠음. 설명에 나오는 standard-height 가 무엇인지 모르겠다... 

## 참고 자료

- https://stackoverflow.com/questions/75256478/how-to-make-swiftui-tabbar-background-always-transparent
- https://developer.apple.com/documentation/uikit/uinavigationbar/3198027-scrolledgeappearance

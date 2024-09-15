---
layout: wiki
title: Safe area 를 변경하려면
summary: 
permalink: 7cfc1bcf-a5a7-b153-4d67-19da5e04a55c
date: 2024-04-13 20:05:38 +09:00
updated: 2024-04-13 20:05:38 +09:00
tag: 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

# Safe area 변경하기

1. `UIEdgeInsets` 을 만든다.
	1. 추가하고자 하는 방향의 너비를 더한다.
2. 뷰 컨트롤러에 `additionalSafeAreaInsets` 에 1에서 만든 값을 지정한다.

## 참고 자료

- [Positioning content relative to the safe area | Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area)

## 태그


---
layout: wiki
title: hugging, resistance에 대해서 설명하시오.
summary: 
permalink: 1aa547a5-41c4-8dd1-b435-17560674ca3a
date: 2021-01-14 00:00:00 +09:00
updated: 2021-01-14 00:00:00 +09:00
tag: iOS iOSInterviewquestions
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

![hugging resistance](/resource/default/4062ed51-59a1-4f05-9c37-91378a8ff770)

## Content hugging

늘어나지 않으려고 하는 힘, 최대 크기에 제한을 두는 것. 뷰를 안쪽으로 당겨 콘텐츠 주변에 꼭 맞도록 한다. 
→ 주어진 크기보다 작아질 수 있음

## Compression resistance

외부에서 압력을 줄 때 버티는 힘, 최소 크기에 제한을 두는 것. 콘텐츠를 자르지 않도록 뷰를 바깥쪽으로 밀어낸다.
→ 주어진 크기보다 커질 수 있음

Content hugging은 기본값이 250, Compression Resistance는 기본값이 750이다. 따라서 뷰를 줄이는 것보다 늘리는 게 더 쉽다.

| Place a label on a storyboard | Constraints |
| ----------------------------- | ----------- |
| ![Place a label on a storyboard](/resource/default/a6b2be5a-a632-4b04-aa68-2e829aa8f932) | ![Constraints](/resource/default/b2044835-ea78-46e7-9865-3c39a4175cc4) |

![Error](/resource/default/f4043f40-1ca2-47d6-9f0a-11005a81481d)

| Right Label Content Hugging Priority = 750 | Left Label Content Hugging Priority = 750 | 
| ------------------------------------------ | ------------------------------------ |
| ![Right Label Content Hugging Priority = 750](/resource/default/34831f78-4df8-4804-abd0-faf3445b2df5) | ![Left Label Content Hugging Priority = 750](/resource/default/e1c17a97-028e-4f3d-87de-72e1a6717b8b) |

## 참고 자료

- [Anatomy of a Constraint](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/AnatomyofaConstraint.html#//apple_ref/doc/uid/TP40010853-CH9-SW21)
- [Content hugging vs Compression resistance 차이점 알기!](https://ontheswift.tistory.com/21)
- [[AutoLayout] Hugging priority와 Compression Resistance priority 비교](https://eunjin3786.tistory.com/43)

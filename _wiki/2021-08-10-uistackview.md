---
layout: wiki
title: UIStackView
summary: 
permalink: 5b441ad2-f77c-e2c0-5787-e4ed4138ec3c
date: 2021-08-10
updated: 2021-08-10
tag: iOS 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

## 개요

이번에 UI 구성하면서 스택 뷰를 사용하게 되었다. 이미 한 번 본 내용인데도, 막상 다시 하려니까 어렵고, 헷갈려서 다시 공부하면서 내용을 정리했다.

## UIStackView

```swift
@MainActor class UIStackView: UIView
```

> A streamlined interface for laying out a collection of views in either a column or a row.

> 열이나 행에 뷰 컬렉션을 배치하기 위한 간소화된 인터페이스입니다.

쉽게 말하면, 가로나 세로로 레이아웃을 배치할 때 사용한다. 스택 뷰 내부에 다른 스택 뷰를 중첩해서 더 복잡한 레이아웃을 만들 수 있다. Android의 `LinearLayout`과 유사하다. 

오토 레이아웃으로 직접 잡아줄 수도 있는 건데, 이걸 쓰면 뭐가 좋냐? → 장치의 방향, 화면 크기, 사용할 수 있는 공간의 변경 사항에 동적으로 반응할 수 있는 인터페이스를 만들 수 있다. 

`UIStackView`는 `arrangedSubviews` 프로퍼티에 있는 모든 뷰의 레이아웃을 관리한다. 추가한 순서대로 스택 뷰 내에서 정렬된다.

```
💡 일반적으로 상위 뷰에 하위 뷰를 추가할 때 `addSubview(_ view: UIView)` 메서드를 이용하는 것과 달리 `UIStackView`는 `addArrangedSubview(_ view: UIView)`를 이용한다.
```

스택뷰는 주요 4가지 속성에 의해 레이아웃이 변경된다.

### axis

> 수평 또는 수직으로 스택의 방향을 결정한다. 기본 값은 수평이다.

#### vertical

![stack view axis vertical](axis-vertical.png)

#### horizontal

![stack view axis horizontal](axis-horizontal.png)

### distribution

> 스택 뷰의 축(axis)의 따라 정렬된 뷰의 레이아웃을 정의한다. 기본 값은 `fill`이다.

사실 이거만 봐서는 이해가 안 가니까 하나하나 살펴보자.

#### fill

> 스택 뷰가 스택 뷰의 축을 따라 사용 가능한 공간을 채우도록 정렬된 뷰(arrangedSubviews)의 크기를 조정하는 레이아웃이다. 각 뷰의 CHCR에 따라 조정된다. Compression Resistance에 따라 뷰가 축소되고, Content Hugging에 따라 뷰가 늘어난다. 모호한 부분이 있으면 배열의 인덱스를 기반으로 조정한다.

→ CHCR에 자세한 내용은 [[iOS] Anatomy of a Constraint](https://jwonylee.github.io/ios/Anatomy-of-a-Constraint#고유-콘텐츠-크기)를 참조

각 뷰에 CHCR을 주지 않고, `distribution.fill`을 하게 되면 어떻게 될까?

![stack view distribution fill](distribution-fill.png)

제약 사항을 찾을 수 없다는 오류가 뜬다. 이게 왜 뜨냐면, 각 뷰마다 높이(혹은 넓이)가 없어서 누가 늘어나야할 지 모르기 때문이다. 누가 늘어나야 할 지 알고있다면 이런 오류는 당연히 뜨지 않는다. 

예를 들어, 세 개의 뷰 중에 두 개의 뷰에 높이를 지정해주면 당연히 위와 같은 오류는 발생하지 않는다. 왜냐하면 두 개의 뷰에 높이를 알고 있기 때문에, 공간이 남는다면 높이를 지정하지 않은 뷰를 늘리면 된다는 걸 알고 있기 때문이다.

#### fillEquality

![stack view distribution fillEquality](distribution-fillEquality.png)

말 그대로 동일한 비율로 크기로 채운다! `axis`에 나와있는 사진의 구성이 `fillEquality` 였다.

#### fillProportionally

> 스택 뷰의 축을 따라 고유 콘텐츠 크기에 따라 비례해서 크기가 조정된다.

공식 문서에는 부연 설명이 없어서 이해가 잘 안 갈 수 있다. `fillProportionally`가 제대로 동작하려면 뷰가 고유한 콘텐츠 크기(intrinsicContentSize)를 가지고 있어야 한다. 일반적으로 Button, Label, Slider 등이 갖고 있다.

예시를 통해 자세히 알아보자. 고유한 콘텐츠 크기를 갖고 있는 `UILabel`를 두 개 배치해보면, 동등한 비율로 크기를 갖고 있는 걸 알 수 있다.

![distribution fillProportionally 1](distribution-fillProportionally-1.png)

이제 왼쪽의 텍스트를 더 길게 바꿔보자. 텍스트가 길어지면서 스택뷰 내에서 더 많은 너비를 차지하고 있다는 걸 알 수 있다.

![distribution fillProportionally 2](distribution-fillProportionally-2.png)

초록색 뷰도 더 길게 작성하면 어떻게 될까? 미세하게 더 많은 비율로 커진 걸 볼 수 있고, 나머지 텍스트는 `...`으로 처리된 걸 알 수 있다.

![distribution fillProportionally 3](distribution-fillProportionally-3.png)

#### equalSpacing

> 스택 뷰의 축을 따라 균일한 간격으로 뷰를 배치한다. 정렬된 뷰가 스택 뷰에 맞지 않으면 Compression Resistance에 따라 뷰가 축소된다.

`UIStackView.spacing`의 간격으로 뷰를 배치한다. `spacing` 값이 크면 어떤 뷰가 작아져야할 지 정해줘야 한다.

![distribution equalSpacing](distribution-equalSpacing.png)

#### equalCentering

> 스택 뷰의 `spacing` 값을 간격을 유지하면서 스택 뷰의 축을 따라 중앙에서 중앙까지의 간격이 같도록 배치한다. 정렬된 뷰가 스택 뷰에 맞지 않으면 Compression Resistance에 따라 뷰가 축소된다.

뷰의 중앙 축을 기준으로 간격을 유지하는데, 문장만 봐선 감이 잘 안 잡힌다. 그림으로 보는 게 이해하기 쉽다.

![distributuion equalCentering](distribution-equalCentering.png)

### alignment

> 스택 뷰의 축에 수직인 뷰의 레이아웃을 정의한다. 기본값은 `fill` 이다.

`alginment`는 `Axis`에 따라 선택할 수 있는 속성이 달라진다.

#### Vertical
- Fill
  - 뷰의 크기를 스택 뷰의 넓이 전체만큼 채운다.
  ![Vertical Alignment Fill](vertical-alignment-fill.png)
- Leading
  - 뷰를 스택 뷰의 `Leading`을 기준으로 정렬한다. (왼쪽 정렬 X)
  ![Vertical Alignment Leading](vertical-alignment-leading.png)
- Center
  - 뷰를 스택 뷰의 가운데로 정렬한다.
  ![Vertical Alignment Center](vertical-alignment-center.png)
- Trailing 
  - 뷰를 스택 뷰의 `Trailing`을 기준으로 정렬한다. (오른쪽 정렬 X)
  ![Vertical Alginment Trailing](vertical-alignment-trailing.png)

#### Horizontal

Vertical 예제와 달리 가운데 Label만 여러 줄로 작성했다. 이렇게 구성해야 차이가 눈에 띈다.

- Fill
  - 뷰의 크기를 스택 뷰의 높이만큼 채운다.
  ![Horizontal Alignment Fill](horizontal-alignment-fill.png)
- Top
  - 뷰를 스택 뷰의 상단을 기준으로 정렬한다.
  ![Horizontal Alignment Top](horizontal-alignment-top.png)
- Center
  - 뷰를 스택 뷰의 가운데로 정렬한다.
  ![Horizontal Alignment Center](horizontal-alignment-center.png)
- Bottom
  - 뷰를 스택 뷰의 하단을 기준으로 정렬한다.
  ![Horizontal Alignment Bottom](horiziontal-alginment-bottom.png)
- First Baseline (only Horizontal)
  - 뷰를 first Baseline을 기준으로 정렬한다. 
  ![Horizontal Alignment First Baseline](horizontal-alignment-first-baseline.png)
- Last Baseline (only Horizontal)
  - 뷰를 last Baseline을 기준으로 정렬한다.
  ![Horizontal Alignment Last Baseline](horizontal-alignment-last-baseline.png)

First Baseline과 Last Baseline은 사진만 봐서는 Top, Bottom과 비슷해보이지만 실제론 이렇다.

![[lastBaseline.png]]

### spacing

> 인접한 뷰 사이의 공간의 크기를 정의한다.

`equalSpacing`이나 `equalCentering`에서 사용하는 간격의 값이다. 

## 참고 자료

- [UIStackView - Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uistackview)
- [Exploring UIStackView Distribution Types](https://spin.atomicobject.com/2016/06/22/uistackview-distribution/)

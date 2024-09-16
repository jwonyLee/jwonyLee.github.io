---
layout: wiki
title: UIView.clipToBounds와 layer.masksToBounds
summary: 
permalink: 10a55411-2e65-1d24-1465-93b6a7ef8317
date: 2021-04-16 00:00:00 +09:00
updated: 2021-04-16 00:00:00 +09:00
tag: iOS 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

## `UIView.clipToBounds`

이 값을 `true`로 설정하면 서브 뷰가 수신자의 경계에 잘린다. `false`로 설정하면 프레임이 수신기의 가시적 경계를 넘어 확장되는 서브 뷰는 잘리지 않는다. 기본값은 `false`이다.

> Setting this value to true causes subviews to be clipped to the bounds of the receiver. If set to false, subviews whose frames extend beyond the visible bounds of the receiver are not clipped. The default value is false.

## `layer.masksToBounds`

이 속성의 값이 `true`이면 Core Animation은 레이어의 경계와 일치하고 모서리 반경 효과를 포함하는 암시적 클리핑 마스크를 만든다. 마스크 속성 값도 지정하면 두 마스크를 곱하여 최종 마스크 값을 얻는다. 이 속성의 기본값은 `false`이다.

> When the value of this property is true, Core Animation creates an implicit clipping mask that matches the bounds of the layer and includes any corner radius effects. If a value for the mask property is also specified, the two masks are multiplied to get the final mask value.
The default value of this property is false.

두 가지를 모두 사용해보았을 때 동일한 결과를 보여준다. 그런데, 버튼의 그림자 효과를 넣었을 때 `clipToBounds` 속성을 이용하면 해당 효과가 적용되지 않았고, `masksToBounds`를 사용했을 때 제대로 적용되었다.

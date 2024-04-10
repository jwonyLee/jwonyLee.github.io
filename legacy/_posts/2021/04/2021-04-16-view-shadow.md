---
title: '[iOS] 뷰의 그림자 만들기'
tags: [iOS, Programmatically]
categories: iOS
comments: true
---

```swift
button.layer.shadowColor = UIColor.black.cgColor
button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
button.layer.shadowRadius = 1.0
button.layer.shadowOpacity = 0.5
```
기존 플로팅 버튼은 위와 같이 그림자를 적용했는데, 디버깅을 해보니까 다음과 같은 경고가 떴다.

> The layer is using dynamic shadows which are expensive to render. If possible try setting 'shadowPath', or pre-rendering the shadow into an image and putting it under the layer.

렌더링 비용이 많이 드니까 `shadowPath`를 변경하라는 경고여서, 해결책을 찾아보았다. 두 가지 방식이 있는데,

첫 번째는 `UIBezierPath`를 사용하면 된다. 다음과 같은 코드를 한 줄 추가하면 된다.

```swift
button.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.layer.cornerRadius).cgPath
```

두 번째는 그림자를 다시 그릴 필요없이 iOS에 렌더링된 그림자를 캐시하도록 요청할 수 있다.

```swift
button.layer.shouldRasterize = true
```

---

## 참고 자료

- [How to add a shadow to a UIView](https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-shadow-to-a-uiview)
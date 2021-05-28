---
layout: post
title: 오토 레이아웃 기반 뷰에 cornerRadius 적용하기
subtitle: 초기화할 때 frame.size.height는 왜 안 먹히는가
categories: iOS
tags: [iOS, AutoLayout]
emoji: 📱
---

```swift
private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = imageView.frame.size.height * 0.5
    return imageView
}()
```
이미지 뷰를 만들고 `cornerRadius` 값을 `imageView.frame.size.height / 2`를 하면 적용이 안된다. 이게 왜 안되는지 몰라서 다른 코드에서는 임의의 상수로 적용했었다. 나는 이미지뷰의 크기를 오토 레이아웃으로 지정해줘서(`leadingAnchor`, `trailingAnchor`) 프레임 값이 없었고, 없는 프레임 값을 가지고 적용하려고 안되는 거 였다. 그래서 이 문제를 해결하기 위해 찾아보니까 `cornerRadius` 값을 `viewWillLayoutSubviews` 때 업데이트 하라는 것이었다. 뷰의 생명주기를 이용한 방법이다. 이 방법 말고도 `UIButton`의 서브클래스를 만들어서 하는 방식도 있는데 후자의 방법으로 리팩토링 때 적용할 예정이다.

나중에 생명주기를 이용하는 방식으로 문제를 해결했다.

```swift
override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tweetFloatingButton.layer.cornerRadius = tweetFloatingButton.frame.size.height / 2
}
```

---

## 참고 자료

- [Setting corner radius through viewDidAppear() or viewWillLayoutSubviews()?](https://stackoverflow.com/questions/53971385/setting-corner-radius-through-viewdidappear-or-viewwilllayoutsubviews)
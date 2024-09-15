---
layout: wiki
title: 중첩 클로저의 캡처 리스트
summary: 
permalink: 6e52590c-ff19-5ed6-6c98-ea043d0ef93a
date: 2022-01-25
updated: 2022-01-25
tag: Swift 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

프로젝트에서 아래의 코드를 작성했다.

```swift
func bindNotificationPassSelectPHAssets() {
	NotificationCenter.default.rx
		.notification(.passSelectAssets, object: nil)
		.map { notification -> [PHAsset] in
			notification.userInfo?[Notification.Name.passSelectAssets] as? [PHAsset] ?? []
		}
		.bind { assets in
			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
				self.selectedImages = self.viewModel.requestThumbnailImages(with: assets)
			}
		}.disposed(by: disposeBag)
}
```

코드 리뷰를 받으면서 해당 부분에서 메모리 누수가 발생한다는 점을 알려주셨다. 그러면서 아래의 코드로 수정하니, 메모리 누수가 발생하지 않는다면서 이유는 모르시겠다는 답변을 남기셨다.

```swift
func bindNotificationPassSelectPHAssets() {
	NotificationCenter.default.rx
		.notification(.passSelectAssets, object: nil)
		.map { notification -> [PHAsset] in
			notification.userInfo?[Notification.Name.passSelectAssets] as? [PHAsset] ?? []
		}
		.bind { [weak self] assets in
			DispatchQueue.main.async {
				guard let self = self else { return }
				self.selectedImages = self.viewModel.requestThumbnailImages(with: assets)
			}
		}.disposed(by: disposeBag)
}
```

이유를 찾아보다가 [이 글](https://medium.com/flawless-app-stories/the-nested-closure-trap-356a0145b6d)을 읽게 되었다. 요약하면, `중첩된 클로저가 있을 때 더 높은 수준(바깥)의 클로저에서 [weak self]를 호출해야 한다. 내부 클로저에 추가하면 메모리 누수가 발생한다.` 였다. 

더불어 해당 글과 연결된 글쓴이의 [\[weak self\]](https://medium.com/@almalehdev/you-dont-always-need-weak-self-a778bec505ef)의 관한 글을 읽으면서 몰랐던 사실을 추가로 알게 되었다. GCD(DispatchQueue)에서 일반적으로 나중에 호출하기 위해서 저장하지 않는 이상 `[weak self]`를 쓰지 않아도 무관하다는 것이다.

예를 들어,
```swift
DispatchQueue.main.async {
	self.view.backgroundColor = .black
}
```

이렇게 참조해도 무관하다는 것. 이 외에도 글에 다양한 예제가 나와있다. 

## 참고 자료

- [The Nested Closure Trap. Revisiting [weak self] to avoid retain…](https://medium.com/@almalehdev/the-nested-closure-trap-356a0145b6d)
- [You don’t (always) need [weak self]](https://medium.com/@almalehdev/you-dont-always-need-weak-self-a778bec505ef)

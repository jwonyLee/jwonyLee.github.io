---
layout: wiki
title: UITextField.text의 변경을 감지하지 못할 때
summary: 
permalink: 71f3e025-53b0-9a83-78df-fbf9c5bba6f6
date: 2021-06-02
updated: 2021-06-02
tag: RxSwift 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

# \[RxSwift] UITextField.text의 변경을 감지하지 못할 때

현재 하고 있는 토이 프로젝트에서 사용자에게 이모지를 입력받는다. 일반적인 키보드로 입력받는 것이 아니라 [ISEmojiView](https://github.com/isaced/ISEmojiView) 라는 라이브러리를 사용했는데, 이 라이브러리는 `EmojiViewDelegate`를 구현해야 한다. 그중에서 핵심은 이 부분이다.

```swift
// callback when tap a emoji on keyboard
func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
    textView.insertText(emoji)
}
```

나는 딱 하나의 이모지만 입력받고 싶어서, `insertText()`를 호출하는 대신에 `emojiField.text = emoji`로 변경했다. 그런데, 여기서 문제점이 생겼는데 `emojiField`에 바인드 한 `PublishRelay`에서 텍스트 변경을 감지하지 못했다.

그래서 나는 단순하게, 직접 이벤트를 넘겨주는 방식으로 해결했다.

```swift
// callback when tap a emoji on keyboard
func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
    emojiField.text = emoji
    viewModel.emojiField.accept(emoji)
}
```

그런데...!

스터디에서 다른 분이 본인 문제 해결한 걸 공유하셨는데 그게 나와 같은 문제였었다. 해결책은 역시나, 수동으로 알려주는 것인데 다른 점은 나처럼 특정 옵저버블에 이벤트를 전달하는 게 아니라, 이벤트가 발생했다는 걸 `UITextField`에 알리는 것이다.

```swift
// callback when tap a emoji on keyboard
func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
    emojiField.text = emoji
    emojiField.sendActions(for: .valueChanged)
}
```

이렇게 하면, 여러 개의 옵저버블에 바인딩이 되어 있어도 내가 했던 방식처럼 일일이 알려줄 필요가 없다.

와! 개꿀!

해결하고 나니까 드는 생각은 왜 직접 대입하는 건 이벤트를 감지하지 못하는 것일까? 였는데 그것마저도 답변에 쓰여있었다.

~해결책 보느라 내용은 보지도 않았음.~

> On digging a little bit more, I realized that the rx.text depends on UIControlEvents and these are not triggered when you explicitly set the text.  
> 조금 더 자세히 살펴보면, rx.text가 UIControlEvents에 의존하고 명시적으로 텍스트를 설정할 때 트리거 되지 않는다는 것을 깨달았습니다.

어.. 어려워... 🤯

## 참고 자료

- [How do you get a signal every time a UITextField text property changes in RxSwift](https://stackoverflow.com/questions/45633173/how-do-you-get-a-signal-every-time-a-uitextfield-text-property-changes-in-rxswif)

## 태그


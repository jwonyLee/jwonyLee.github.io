---
layout: note
title: 커스텀 폰트 적용하기 with Dynamic Type
summary: 
permalink: 087cf713-71b1-fed1-92de-eb4eb894c0d4
date: 2022-01-02 00:00:00 +09:00
updated: 2022-01-02 00:00:00 +09:00
tag: iOS 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

```
🎯 커스텀 폰트 적용하기 (with Dynamic Type)
```

## 폰트 추가하기

![폰트 파일](/resource/default/021afdd8-6267-43a4-b295-4cdc1a36438f)

적당한 위치에 폰트 파일을 추가한다.

`Info.plist`에 `Fonts provided by application` 항목을 추가한다. 그리고 하위 항목에 추가한 파일이름을 추가한다.

![Info.plist](/resource/default/34cbdf59-80cd-4f1f-8ef5-eeab9f9ad8d6)

## 폰트 사용하기

```swift
let pretendardBody: UIFont = UIFont(name: "Pretendard-Regular", size: 14)!
label.font = pretendardBody
```

이렇게 사용할 수 있다. 

점진적으로 코드를 개선해보자.

## 폰트 스타일

폰트마다 스타일을 제공하는 경우가 있다. bold, light 등.. Pretendard는 9개의 스타일을 제공한다. 상황에 맞게 폰트 스타일(파일 이름)을 바꿔야 하는데 문자열을 직접 넣어 사용하는 건 파일 이름이 바뀌었을 때 등의 상황을 대응하기 불편하다. 프로토콜 + 열거형으로 관리해보자.

```swift
protocol FontStyle {
    static var black: Self { get }
    static var bold: Self { get }
    static var extraBold: Self { get }
    static var extraLight: Self { get }
    static var light: Self { get }
    static var medium: Self { get }
    static var regular: Self { get }
    static var semiBold: Self { get }
    static var thin: Self { get }
    
    var name: String { get }
}
```

`FontStyle`이라는 프로토콜을 정의한다. `static var property: Self { get }` 형식으로 프로퍼티를 정의하고 열거형에서 해당 프로토콜을 채택하면 해당 case를 반드시 구현해야 한다. 👍

이제 `FontStyle`을 채택한 열거형을 갖고 있는 폰트 구조체를 만든다.

```swift
struct Pretendard {
    enum style: String, FontStyle {
        case black = "Pretendard-Black"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case semiBold = "Pretendard-SemiBold"
        case thin = "Pretendard-Thin"
        
        var name: String { 
            rawValue 
        }
    }
}
```

별도로 `name` 프로퍼티를 만든 이유는 폰트 스타일이 선언해둔 9개보다 적을 경우를 위해서이다.

일반적으로 스타일을 한 개만 제공한 경우는 regular 밖에 없을텐데 그럼 나머지 case에 대해서 대응할 수가 없다. 물론 파일 이름을 모두 복사-붙여넣기 해도 되지만 좋은 대안이 아니라고 생각했다.

```swift
struct Cafe24Ssurround {
    enum style: String, FontStyle {
        case black
        case bold
        case extraBold
        case extraLight
        case light
        case medium
        case regular = "Cafe24Ssurround"
        case semiBold
        case thin
        
        var name: String {
            Self.regular.rawValue
        }
    }
}
```

혹은, 프로토콜을 선언할 때 `optional` 키워드를 선언하는 방식도 있다.
```swift
@objc
protocol FontStyle {
    @objc optional static var black: Self { get }
    // ... 생략
    static var regular: Self { get }
    // ... 생략
}
```

폰트 스타일은 하나 이상 있으니까 기본값을 제외한 나머지 프로퍼티에 대해 옵셔널로 선언하면 `name` 프로퍼티를 별도로 둘 필요가 없다. 그런데 내가 이 방식을 선택하지 않은 이유는 열거형이나 구조체에서 사용할 수 없기 때문이다. 클래스보다는 열거형으로 선언해서 관리하는 게 더 낫다고 생각했다.

이제 아래의 코드처럼 폰트 이름을 관리할 수 있다.

```swift
let pretendardBody: UIFont = UIFont(name: Pretendard.style.regular.name, size: 14)!
label.font = pretendardBody
```

## Typography

타이포그래피를 프로토콜로 만들고 폰트에서 해당 프로토콜을 채택하면 일관적인 경험을 제공할 수 있다. 아래에 적힌 것들 이 외에도 Button, Overline, alert 등을 추가해서 상황마다 쓸 스타일을 미리 정의해둔다. 

```swift
protocol Fontable {
    /// The font for body text
    static var body: UIFont { get }
    /// The font for callouts
    static var callout: UIFont { get }
    /// The font for standard captions
    static var caption1: UIFont { get }
    /// The font for alternate captions
    static var caption2: UIFont { get }
    /// The font fot footnotes
    static var footnote: UIFont { get }
    /// The font for headings
    static var headline: UIFont { get }
    /// The font for subheadings
    static var subheadline: UIFont { get }
    /// The font style for large titles
    static var largeTitle: UIFont { get }
    /// The font for first-level hierarchical headings
    static var title1: UIFont { get }
    /// The font for second-level hierarchical headings
    static var title2: UIFont { get }
    /// The font for thrid-level hierarchical headlings
    static var title3: UIFont { get }
}
```

위에서 만들었던 `Pretendard` 구조체에 `Fontable` 프로토콜을 채택하고, 요구 사항을 구현한다.

```swift
struct Pretendard: Fontable {
    static var body: UIFont { UIFont(name: Pretendard.style.regular.name, size: 14)! }
    static var callout: UIFont { UIFont(name: Pretendard.style.regular.name, size: 16)! }
    // ... 생략
}
```

```swift
struct Cafe24Ssurround: Fontable {
    static var body: UIFont { UIFont(name: Cafe24Ssurround.regular.name, size: 14)! }
    // ... 생략
}
```

스타일을 미리 정의해뒀기 때문에 상황에 맞게 스타일을 적용할 수 있다.

```swift
headlineLabel.font = Pretendard.headline
bodyLabel.font = Cafe24Ssurround.body
```

## 접근성 지원 (with Dynamic Type)

접근성 지원과 관련해서 류성두님의 글과 영상을 보면 정말 좋다. 정말 좋다는 표현밖에 못해서 아쉬운데, 달리 설명할 길이 없다. 안 본 사람이 없게 해주세요. 🙏

- [접근성 지원, 개발자의 빠른 성장을 도와줍니다.](https://www.sungdoo.dev/retrospective-or-psa/how-accessibility-nudges-you-to-be-better-developer)
- [접근성 지원을 미루는 일, 인종차별입니다.](https://www.sungdoo.dev/opinion/accessibility-and-racism)
- [접근성 지원 != 시각장애인 대응](https://www.sungdoo.dev/programming/accessibility-is-not-about-supporting-blind-people)
- [iOS VoiecOver 무엇을 어떻게 할까? Intro - YouTube](https://www.youtube.com/watch?v=G46RS-fuT5A&list=PLtaz5vK7MbK3tvJ81_uRKIxFZ235QuJe9)

커스텀 폰트에서도 Dynamic Type을 지원해보자. 

먼저 Dynamic Type을 지원할 뷰의 `adjustsFontForContentSizeCategory` 값을 `true`로 지정한다. 이 프로퍼티는 사용자가 설정한 시스템 글꼴 크기에 따라 뷰의 글꼴 크기를 반영할 것인지를 나타내는 값이다. 기본값은 `false`이다.

```swift
label.adjustsFontForContentSizeCategory = true
```

스토리보드에서는 Attribute Inspector에서 변경할 수 있다.

![Attribute Inspector](/resource/default/fb8596c4-a1fc-4e8b-91b8-d2246932ce07)

`Fontable` 프로토콜에 두 개의 메서드를 추가한다.

```swift
protocol Fontable {
    static func scaledFont(with type: FontStyle, textStyle: UIFont.TextStyle) -> UIFont
    static func scaledFont(with type: FontStyle, textStyle: UIFont.TextStyle, size: CGFloat) -> UIFont
    // ... 생략
}
```

하나는 시스템에서 제공하는 TextStyle만 이용하는 방법이고, 다른 하나는 사이즈도 바꿀 수 있는 메서드다. `Fontable`을 채택한 구조체에서 구현해도 되는 부분이지만, `extension`을 이용해 프로토콜 초기구현을 한다. 

```swift
extension Fontable {
    static func scaledFont(with type: FontStyle, textStyle: UIFont.TextStyle) -> UIFont {
        let fontDescriptor: UIFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        
        guard let font = UIFont(name: type.name, size: fontDescriptor.pointSize) else {
            fatalError("""
                Failed to load the \(type.name) font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """)
        }
        
        return UIFontMetrics.default.scaledFont(for: font)
    }
    
    static func scaledFont(with type: FontStyle, textStyle: UIFont.TextStyle, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.name, size: size) else {
            fatalError("""
                Failed to load the \(type.name) font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """)
        }
        
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
}
```

아까부터 계속 폰트를 만들 때마다 강제 언랩핑하고 있었는데 `guard`문을 이용해 안전하게 언랩핑했다.
`Fontable` 채택하면서 구현했던 스타일들을 `scaledFont(with:textStyle:)`을 이용한 코드로 변경한다.

```swift
struct Pretendard: Fontable {
    // ... 생략
    static var body: UIFont { scaledFont(with: Pretendard.style.regular, textStyle: .body) }
    static var callout: UIFont { scaledFont(with: Pretendard.style.regular, textStyle: .callout)}
    static var caption1: UIFont { scaledFont(with: Pretendard.style.regular, textStyle: .caption1, size: 18) }
    // ... 생략
}
```

![dynamic type 적용 사진](/resource/default/62d88097-0995-43c3-8f67-2bef7b899270)

끝!

## 참고 자료

- [Enum cases as protocol witnesses – available from Swift 5.3](https://www.hackingwithswift.com/swift/5.3/enum-protocol-witnesses)

---
layout: note
title: 컬렉션뷰에 뱃지 추가하기
summary: 
permalink: 354752f2-0c01-5d34-7214-bacd077e4153
date: 2021-11-07 00:00:00 +09:00
updated: 2021-11-07 00:00:00 +09:00
tag: iOS 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

```
🎯 Compositional Layout을 이용해 컬렉션뷰에 뱃지 추가하기
```

구현하려는 모양은 다음과 같다.

![구현하려는 모양](/resource/default/1721f57a-3e45-4880-9807-dcacafb9c24a)

가운데에는 이미지를 표시하고 우측 상단에는 뱃지 형태의 버튼을 넣는 형태다. 그리고 이런 구성은 Compositonal layout을 이용하면 쉽게 만들 수 있다.

## Compositional Layout

iOS 13.0 부터 도입된 UICollectionView 레이아웃의 새로운 방식이다. 기존에 사용하던 UICollectionViewFlowLayout 보다 조금 더 많은 걸 지원하는데 자세한 내용은 다음에... (기약없는 약속)

아무튼, Compositional Layout을 이용하면 뱃지를 가진 셀을 쉽게 구현할 수 있다. 뱃지를 구현하는 방법은 다음과 같다.

1. `UICollectionReusableView`를 서브 클래싱해서 뱃지를 구현한다.
2. UICollectionView 에 사용할 뱃지를 등록한다.
3. Compositional Layout을 이용해 뱃지를 포함한 레이아웃을 구성한다.
4. 셀을 그린다. 

## UICollectionReusableView

> A view that defines the behavior for all cells and supplementary views presented by a collection view.

> 컬렉션뷰에서 제공하는 모든 셀과 보조 뷰에 대한 동작을 정의하는 뷰입니다.

```swift
import UIKit

final class CloseButtonView: UICollectionReusableView {
    // MARK: View
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenAssets.closeBadge.image, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

extension CloseButtonView {
    func configure() {
        addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
```

버튼 하나만 이용해 간단하게 만들었다. 메인으로 그려지는 셀의 보조 뷰라서 많은 걸 담기에 적합하지도 않다. (뇌피셜)

## UICollectionView.register(_:forSupplementaryViewOfKind:withReusepermalink:)

```swift
func register(_ viewClass: AnyClass?,
              forSupplementaryViewOfKind elementKind: String, 
              withReuseIdentifier permalink: String)
```

구현한 뱃지를 컬렉션 뷰에 등록한다. 커스텀 셀 등록할 때 쓰는 `register(_:forCellWithReusepermalink:)`랑 비슷하지만 `elementKind`라는 매개변수가 하나 더 있다. 아래에도 나오겠지만 레이아웃을 구성할 때 생성했던 `CloseButtonView`(뱃지 클래스)로 직접 구분하지 않고 여기서 등록하는 `elementKind`로 구분하기 때문에 유니크한 값을 넣어줘야 한다. 

```swift
collectionView.register(CloseButtonView.self, forSupplementaryViewOfKind: "close-badge", withReusepermalink: "close-badge")
```

`elementKind`는 Supplementary Item 을 만들 때 사용하고, `identifier`는 컬렉션 뷰에서 셀 재활용할 때 사용하는 거라서 같은 값을 넣어도 상관없다.

## Compositional Layout을 이용해 레이아웃 구성

[Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)에서 **Add Badges to Items** 항목을 보면 어떻게 구성하는 지 나와있다. 

예시로 나와있는 레이아웃 구성 코드를 한 줄씩 보자면,

```swift
let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3)) // 1
let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20),
                                      heightDimension: .absolute(20)) // 2
let badge = NSCollectionLayoutSupplementaryItem(
    layoutSize: badgeSize,
    elementKind: ItemBadgeSupplementaryViewController.badgeElementKind,
    containerAnchor: badgeAnchor) // 3

let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                     heightDimension: .fractionalHeight(1.0))
let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge]) // 4
item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
```

1. `NSCollectionLayoutAnchor`는 컬렉션 뷰의 Supplementary Item의 위치를 정의하는 객체다. 아래 사진은 값에 따라 어떻게 배치되는 지를 나타낸다. 오프셋은 `fractionalOffset`과 `absoluteOffset`으로 나뉜다.  
    ![NSCollectionLayoutAnchor 배치](/resource/default/b73ab63d-5efc-4feb-a086-42b76b100ee5)
2. 뱃지의 크기를 지정한다. 여기서는 20 만큼의 절대값으로 지정했다. 
3. `NSCollectionLayoutSupplementaryItem` 객체를 생성한다. 여기서 `elementKind`로 들어가는 값은 컬렉션 뷰에 등록할 때 사용했던 `elementKind`랑 같은 값을 작성한다.
4. `supplementaryItems`에 3에서 생성한 SupplementaryItem을 넣는다.

예시 코드와 실제 레이아웃 구성하는 부분은 크게 다르지 않아서 생략한다. 

## 셀을 그린다.

일반적으로 셀 그리는 거랑 똑같이 그려주면 된다.

```swift
func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let badge = collectionView.dequeueReusableSupplementaryView(ofKind: CloseButtonView.reuseIdentifier, withReusepermalink: CloseButtonView.reuseIdentifier, for: indexPath) as? CloseButtonView else {
        return CloseButtonView()
    }

    return badge
}
```

이렇게 하면 끝!!!! 인데 아주 큰 문제가 있다.

나는 컬렉션 뷰를 가로로 스크롤하기 위해서 `section.orthogonalScrollingBehavior`를 사용했는데, 이걸 사용하면 뷰의 계층 구조가 엉망이 되버려서 Supplementary View가 제대로 표시되지 않는다. 

![계층 구조가 깨진 모습](/resource/default/2f6a5c4e-4996-4cb4-be28-241c1a4321ae)

`orthogonalScrollingBehavior`를 사용하지 않으면 정상적으로 나온다.

![정상적으로 보이는 모습](/resource/default/4e812870-0e8b-4d43-90c2-de24a6827b28)

알려주신 현수님께 무한한 감사의 말씀을 드리며... 🙏 

결국 최종 구현물에서는 셀 안에 버튼 만드는 방식으로 바꿨다. 이러면 무슨 소용이냐고 🤦‍♂️

## 참고 자료

- [Implementing Modern Collection Views - Apple Developer Documentation](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [UICollectionViewCompositionalLayout - Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout)
- [NSCollectionLayoutSupplementaryItem - Apple Developer Documentation](https://developer.apple.com/documentation/uikit/nscollectionlayoutsupplementaryitem)
- [NSCollectionLayoutAnchor - Apple Developer Documentation](https://developer.apple.com/documentation/uikit/nscollectionlayoutanchor)
- [register(_:forSupplementaryViewOfKind:withReusepermalink:) - Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uicollectionview/1618103-register)
- [UICollectionReusableView - Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uicollectionreusableview)

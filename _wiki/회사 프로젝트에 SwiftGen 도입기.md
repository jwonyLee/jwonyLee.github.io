---
layout: wiki
title: 회사 프로젝트에 SwiftGen 도입기
summary: 
permalink: 3acba79d-c253-a833-0fb8-9534af3cdffc
date: 2022-06-12 00:00:00 +09:00
updated: 2022-06-12 00:00:00 +09:00
tag: iOS SwiftGen 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

> 어제의 코드는 어제의 최선이다

내 옆자리에 앉아 계신 사수이자 팀장님이 자주 하시는 말이다.

우리 회사 iOS 프로젝트는 3년 동안 착실히 쌓아온 팀장님 노력의 산물인데 입사하고 나서 처음에 구조를 파악하면서 한숨 푹푹 쉬었다. MVC로 되어 있는데 정말 비대한 뷰 컨트롤러를 마주쳤을 때의 아찔함이란... 어디서부터 손대야 할지 엄두가 안 날 정도였다.

서비스를 잘 만든다는 건 뭘까? 모바일 개발자가 프로덕트를 더 좋게 만들려면 어떻게 해야 할까? 기획에 맞춰 기능을 잘 구현하는 것도 분명 필요하지만, 협업을 잘하기 위해 기반을 다지고, 이후에 신규 입사자들이 코드를 파악하기 쉽게 해두는 것도 중요하다고 생각한다.

그래서일까? 프로젝트를 살펴보면서 개선하고 싶은 것들이 많이 보였다. 그중에서 일단 내가 할 수 있는 것을 먼저 하기로 했다. 리소스 관리가 잘 안되어있는 점이 눈에 띄었다. 이미지를 사용하기 위해서 여기도 느낌표, 저기도 느낌표. 강제 언랩핑으로 범벅이 된 코드를 고치기로 마음먹었다.

기존에는 이미지를 아래처럼 사용해왔다.

```swift
lazy var markerImage = UIImage(named: "marker")!.imageWithImage(scaledToSize: markerIconSize)
```

내가 생각하는 위 방식의 단점은 문자열로 이미지를 찾는 방식이라 이미지가 있을 수도 있고 없을 수도 있다. 그래서 강제 언랩핑을 하거나 `if let`, `guard let` 등을 통해 언랩핑 해야 한다는 것이다. 그리고 우리 프로젝트는 강제 언랩핑이 남발된 모습이었다. 앱 안정성 저하의 지름길이라고 생각했다. 만약 중간에 파일 이름이 바뀌었는데 놓친 부분이 있다면? 상상만 해도 끔찍하다. 더불어 문자열로 직접 접근하기 때문에 발생하는 휴먼 에러도 있다.

`ImageStore` 같은 객체를 만들어서 직접 구현할 수도 있는 부분이지만 번거로움이 너무 크다는 생각이 들어서 라이브러리의 도움을 받기로 했다. 수십 개의 에셋에 일일이 guard 문으로 언랩핑 해주는 것도 일이었고, 앞으로도 에셋이 추가될 텐데 그때마다 번거로이 수동으로 작성해줘야 하는 비용도 만만치 않을 거로 생각했다.

도입하기에 앞서 사전 조사를 했다. 가장 많이 쓰이는 건 SwiftGen 과 R.Swift 인 것 같아서 두 개 위주로 조사를 했다.

### SwiftGen

[GitHub - SwiftGen/SwiftGen](https://github.com/SwiftGen/SwiftGen)  
[SwiftGen](https://zeddios.tistory.com/1017?category=682196)

- Assets 을 선택해서 build 할 수 있다.
  - 대신 각 에셋마다 설정을 해줘야 한다.

완전 새로운 Assets 을 추가하는 경우: 

```shell
Pods/SwiftGen/bin/swiftgen config run
```

outputs 으로 생긴 파일(들)을 프로젝트에 추가해야 한다.

기존에 있는 Assets 에 항목을 추가/삭제하는 경우: build

### R.swift

[GitHub - mac-cain13/R.swift](https://github.com/mac-cain13/R.swift)  
[R.swift](https://zeddios.tistory.com/1016)

- 모든 Assets 을 build 함 → 선택적 취사 불가
- 리소스 파일을 탐색하는 게 아니라, 프로젝트 파일(project.xcodeproj)을 탐색해서 변경 사항에 대응하는 방식

> R.swift stays very close to the vanilla Apple API's, it's a minimal code change with maximum impact

Apple의 API 와 유사하게 구현되어 있다고 한다(?)

결과적으로 SwiftGen 을 선택한 이유는
선택적 취사를 할 수 없다는 점이 컸다. 아니었다면 R.swift 를 썼을 지도 모른다.

> 이제 와서 다시 살펴보니까 R.swift 가 더 좋아보이는 거 같다. SwiftGen은 nib을 지원안하는데, R.swift는 nib 을 지원한다.

### 적용 이후 기존 코드 수정하기

관리해야 하는 리소스 목록은 다음과 같다.

- Icons
- Colors
- Storyboard
- Font
- Strings

당시에 우리 프로젝트는 Swift 4 여서 설정 파일도 Swift4 에 맞춰서 구성했는데, 이후에 Swift 5 로 올렸다. SwiftGen 설정 파일을 따로 건들이지 않았는데도 오류 없이 잘 동작하는 걸 보아 크게 문제는 없는 듯하다.

PR 을 세개로 나눠서 올렸는데도 무수한 파일의 변경이 있었다. 

![File Change 86](https://github.com/user-attachments/assets/e9529db9-bc01-440a-945d-35212dd3c088)

ㅇ<-<

### 바뀐 점

기존 코드

```swift
lazy var parkingRackIcon = NMFOverlayImage(image: UIImage(named: "parking_rack_icon")!.imageWithImage(scaledToSize: CGSize(width: 20, height: 20)))
```

바뀐 코드

```swift
 lazy var parkingRackIcon = NMFOverlayImage(
    image: Images.parkingRackIcon.image.imageWithImage(
        scaledToSize: CGSize(width: 20, height: 20)
    )
)
```

강제 언랩핑 아웃!

그리고 커뮤니케이션 미스를 방지하기 위해 폰트도 디자인 시스템에 있는 그대로 사용하기 용이하게 한번 더 랩핑해서 만들었다.

```swift
extension Fonts {
     enum Typography1 {
         static let black: FontConvertible.Font = Fonts.NotoSansKR.black.font(size: 25.0)
         static let bold: FontConvertible.Font = Fonts.NotoSansKR.bold.font(size: 25.0)
         static let medium: FontConvertible.Font = Fonts.NotoSansKR.medium.font(size: 25.0)
         static let regular: FontConvertible.Font = Fonts.NotoSansKR.regular.font(size: 25.0)
         static let light: FontConvertible.Font = Fonts.NotoSansKR.light.font(size: 25.0)
     }
    // 생략
}
```

사실 난 이것보다 한 단계 더 나아가서 색상이나 폰트에도 의미 있는 이름을 부여했으면 좋겠다고 생각하는데 (예: backgroundColor, secondaryColor) 이건 혼자서 뚝딱 할 수 있는 게 아니고 디자이너님과 기획자들이 붙어서 같이 작업해야 하는 부분이기 때문에 이 부분은 아쉽지만, 혼자만의 생각으로 고이 묻어두는 것으로.

SwiftGen 을 도입하면서 가장 좋았던 점은 화면을 이동하기 위해서 Storyboard 에 있는 ViewController 를 만들 때 언랩핑 하기 위해 depth 가 깊어진 부분이 한 단계 줄어들었다는 것이다.

```swift
if let mainVC = .... {
    // 내용
    self.present(mainVC, animated: true)
}
```

혹은

```swift
let mainVC = ...!
self.present(mainVC, animated: true)
```

와 같았던 코드가

```swift
let mainVC = Storyboard.main.instantiateInitialViewController()
```

와 같이 대체되어서 비교적 안전해졌다는 것이다.

다만 여기서도 불편한 점은 Storyboard 가 여러 개로 구성되어 있어서 특정 화면이 있는 스토리보드 이름을 알아야 한다는 것이다. 어느 스토리보드에 어떤 화면이 있는지 전부 파악하고 있으면 좋겠지만, 그건 우리 팀장님이나 그렇고 나는 아는 게 없다. 그래서 매번 command + shift + f 로 뷰 컨트롤러 이름 검색해서 찾고 있다.

미처 파악하지 못한 레거시가 더 남아 있을 수도 있지만, 큰 틀에서 리소스 관리는 이렇게 마무리를 지었다. 작업할 땐 단순 반복 작업이 많아서 너무 지루하고 재미없었다.

그리고 완전히 제거하지 못하는 부분들도 있다. 예를 들어, 카드 이미지 같은 경우 switch 문 쓰는 것보다 직접 접근하는 게 더 나은 거 같아서 그대로 두었다.

```swift
if let name = card.name() {
    self.cardImage.image = UIImage(named: "card_\(name)")
} else {
    self.cardImage.image = UIImage()
}
```

이 글을 쓰면서 코드 다시 찾아보다가 레거시 생각보다 더 남아있다는 거 알았다. 🤦‍♀️

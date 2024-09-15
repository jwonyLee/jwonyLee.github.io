---
layout: wiki
title: Swift Package 만들기
summary: 
permalink: b6e7d281-7f11-d868-7945-9704afcaccaa
date: 2022-05-29
updated: 2022-05-29
tag: iOS 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

```markdown
📌 기존 프로젝트에서 기능을 분리해서 Swift Package로 모듈화하기
```

iOS 프로젝트에서 모듈화 하는 방식은 아래와 같다.
- Swift Package 로 만들기
- (Dynamic/Static) Framework 로 만들기
- (Dynamic/Static) Library 로 만들기

이 글에서는 Swift Package 로 만든다.

## 패키지 생성과 기본 설정

`File > New > Package` 를 선택한다.

![File > New > Package](/assets/img/create-SPM/file-new-package.png)

패키지 이름과 위치를 지정해준다. 공통 모듈을 만들기 위해서 `Platform` 이라는 이름으로 지정해주었고, 위치는 기존 프로젝트로 지정해주었다. 그리고 하단에 Add to: Group: 이라는 부분에 기존 프로젝트를 선택한다.

![create Package](/assets/img/create-SPM/create-package.png)

Create 를 누르면 패키지가 생성이 된다. 기본으로 생성되는 구조는 다음과 같다.

```
Platform (패키지 이름)
├── README.md
├── Package.swift
├── Sources
│   └── Platform
│       └── Platform.swift
└── Tests
    └── PlatformTests
        └── PlatformTests.swift
```

`Package.swift`는 패키지의 설정을 정의하는 파일이다. 새로운 모듈을 추가하거나, 의존성을 추가하는 등의 작업은 여기서 한다.

```swift
// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Platform",
            targets: ["Platform"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Platform",
            dependencies: []),
        .testTarget(
            name: "PlatformTests",
            dependencies: ["Platform"]),
    ]
)
```

가장 먼저 해줘야 하는 것은, 이 패키지의 플랫폼(not my package)을 지정해주는 것이다. 플랫폼은 이 패키지의 지원하고자 하는 플랫폼과 버전을 지정하는 것이다. 기존 프로덕트의 iOS Deployment Target 과 동일하게 설정하면 된다. 왜 이 값이 기본값으로 안 들어갔는지가 의문이다. 


```swift
import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [
        .iOS(.v12)
    ],
    products: [
```

만약 이 값을 지정하지 않거나, 내가 이 패키지를 사용하는 프로젝트 버전이 더 낮다면 다음과 같은 빌드 에러가 뜬다.

```
The package product '디펜던시 이름' requires minimum platform version 10.0 for the iOS platform, but this target supports 9.0
```

## 모듈 추가하기

`Network` 라는 모듈을 추가하고 싶다.

먼저 기본으로 생성된 `Sources/Platform` 과 `Tests/PlatformTests` 디렉토리를 삭제한다. 이 상태에서 빌드하면 실패하고, 에러가 뜬다.

```
Source files for target Platform should be located under 'Sources/Platform', or a custom sources path can be set with the 'path' property in Package.swift
```

`Package.swift` 파일에서 `Platform` 이라는 모듈과 `PlatformTests` 라는 모듈을 추가해뒀는데, 찾지 못해서 뜨는 에러다.


```swift
products: [
    .library(
        name: "Platform",
        targets: ["Platform"]
    ),
],
```

`Platform` 이라고 쓰여있는 부분을 `Network`로 대체한다. `Network` 모듈 뿐만 아니라 `Core` 라는 모듈도 추가하고 싶다면? 다음과 같이 작성한다.

```swift
products: [
    .library(
        name: "Network",
        targets: ["Network"]
    ),
    .library(
        name: "Core",
        targets: ["Core"]
    )
],
```

그런 다음 targets 항목에 Network 모듈을 추가한다. (기존에 있던 PlatformTests 타겟은 제거)

```swift
targets: [
    .target(
        name: "Network",
        dependencies: []
    )
]
```

이렇게 작성하면 설정은 끝이 났고, 빌드하면 역시나 경로를 찾지 못한다는 에러가 뜬다. Sources 디렉토리 내에 Network 디렉토리를 생성하면 된다.

만약 Network 모듈에서 외부 라이브러리를 사용하고 싶다면 어떻게 해야할까? dependencies 항목에 사용하고자 하는 외부 라이브러리를 추가하면 된다. 

```swift
dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.5.0"))
],
```

이렇게 디펜던시를 추가한 뒤에,

```swift
targets: [
    .target(
        name: "Network",
        dependencies: ["RxSwift"]
    )
]
```

외부 라이브러리를 사용하는 target의 dependencies 에 해당 디펜던시 이름을 넣어준다.

---

추가적으로 이건 내가 자주 놓치는 부분인데, Swift 에서는 주로 접근 지정자를 기본값인 `internal` 과 `private` 을 많이 쓴다. 그래서 기존 프로젝트에 있던 클래스/구조체/열거형을 모듈로 옮겨서 사용하면 `internal`에서 범위(모듈 내부만 가능)가 벗어났기 때문에 나는 분명 import 도 잘해줬는데 모듈을 찾을 수 없다고 뜬다. 모듈로 분리한 객체는 잊지말고 `public`으로 지정해주자. 이걸로 삽질 꽤나 했다. 흑흑.

그리고 가끔, 잘했는데도 빌드가 안된다면, Xcode 를 껐다 켜자.

## 태그


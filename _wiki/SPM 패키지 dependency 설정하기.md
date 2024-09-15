---
layout: wiki
title: SPM 패키지 dependency 설정하기
permalink: c7df7494-6ac2-77d5-5367-d34e3b260d71
publish: true
updated: 2024-04-13T20:07:13+09:00
---

# SPM 패키지 dependency 설정하기

모듈화 하는 방식이 다양한데,
- Swift Package 로 만들기
- (Dynamic/Static) Framework 로 만들기
- (Dynamic/Static) Library 로 만들기

여기서는 Swift Package 로 만든다.

만약 Swift Package 로 만드는 모듈에서 다른 라이브러리를 사용하고 있다면, Package 파일을 수정할 필요가 있는데,

```swift
dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", from: "1.5.1"),
        .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.0")
    ],
```

이렇게 디펜던시를 추가한 뒤에,

```swift
targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AddPaymentMethod",
            dependencies: ["CombineExt", "ModernRIBs"]
        )
    ]
```

target 에 dependencies 에 해당 디펜던시 이름을 반드시!! 넣어준다.

이렇게 빌드했을 때 만약, 디펜던시들이 지원하는 버전이 내가 만든 패키지보다 높다고 하면, (당연하게도) 빌드에ㅓㄹ가 뜨는데

```
The package product '디펜던시 이름' requires minimum platform version 10.0 for the iOS platform, but this target supports 9.0
```

다음과 같이 플랫폼을 지정해주면 된다.

```swift
platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v5),
        .macOS(.v10_15)
    ],
```

라잌 디스..

## 태그

#iOS/PackageManager/SPM
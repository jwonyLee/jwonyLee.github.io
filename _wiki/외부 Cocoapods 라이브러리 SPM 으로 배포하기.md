---
layout: wiki
title: 
summary: 
permalink: 1339c97d-6732-f545-94d4-6a7453b9e1b2
date: 2023-10-23
updated: 2024-06-27 11:15:06 +09:00
tag: Knowledge iOS/PackageManager/SPM 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

# 외부 Cocoapods 라이브러리 SPM 으로 배포하기

## 문제

- 회사 프로젝트의 의존성 관리 도구를 전부 Swift Package Manager(이하 SPM)으로 변경하고 싶다.
- SPM 을 지원하지 않는 외부 라이브러리는 어떻게 해야 하지?

## 해결

1. github 저장소 생성
2. 필요한 cocoapods 을 받기 위한 샘플 프로젝트 생성 (이하 SampleProject)
3. pod init
4. SampleProject/Podfile 에 필요한 cocoapods 라이브러리를 추가
5. pod install
6. SampleProject/Pods 폴더 안에 내려 받은 라이브러리 폴더에서 {라이브러리}.xcframework 찾기
7. 해당 파일 압축
8. 1에서 생성한 github 저장소의 release 에 6번 파일 업로드
9. 배포할 Package 생성: SamplePackage
10. 5번에서 압축한 파일을 SamplePackage 최상단으로 이동
11. 터미널에서 다음 명령어 실행: `swift package compute-checksum ./{라이브러리}.xcframework.zip`
12. Package.swift 파일 수정
```swift
// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "{기존 라이브러리와 동일한 이름}",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "{기존 라이브러리와 동일한 이름}",
            targets: ["{기존 라이브러리와 동일한 이름}"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "{기존 라이브러리와 동일한 이름}",
            url: "{7번에서 업로드한 zip 파일 url}",
            checksum: "{10번에서 얻은 checksum}"
        )
    ]
)
```
13. 9번에 추가한 파일은 제거하고 1번에서 만든 저장소에 업로드

이후 다른 패키지에서 dependency 추가할 때

```swift
// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPMTest",
    products: [
        .library(
            name: "SPMTest",
            targets: ["SPMTest"]
        )
    ],
    dependencies: [
        .package(url: "{1번 저장소 주소}.git", branch: "main") // branch, upToNextMajor 등 상관 없음
    ],
    targets: [
        .target(
            name: "SPMTest",
            dependencies: [
                .product(name: "{기존 라이브러리 이름}", package: "{1번 저장소 이름}") // package 이름을 라이브러리 이름과 동일하게 작성했을 때 동작하지 않았음
            ]
        )
    ]
)

```

## 그 외

- 외부 라이브러리가 소스 파일을 공개하는 경우에는 위 방식과 다르게 구성. 해당 부분은 다른 블로그의 SPM 배포 참고
- 이렇게 구성했을 때의 단점은 라이브러리의 버전을 수동으로 관리해줘야 한다는 단점이 있음. 관리 포인트가 늘어남.
	- 하지만 외부 라이브러리에서 SPM 을 지원할 계획이 없다면 괜찮은 선택이라고 생각함.

## 참고 자료

- [swift - How can I get checksum for a Binary Package? - Stack Overflow](https://stackoverflow.com/questions/68529771/how-can-i-get-checksum-for-a-binary-package)
- [Distribute binary frameworks as Swift packages - WWDC20 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2020/10147)

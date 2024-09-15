---
layout: wiki
title: 회사 프로젝트에 SwiftLint 도입기
summary: 
permalink: 98e2a8e5-c76c-0e4c-0d1c-d9c4ae71426c
date: 2022-06-26
updated: 2022-06-26
tag: iOS SwiftLint 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

# \[iOS] 회사 프로젝트에 SwiftLint 도입기

> SwiftLint 는 Realm 에서 만든 스위프트 스타일 및 컨벤션을 강제하기 위한 도구다.

그간은 팀장님 혼자 만드느라 *컨벤션이 뭐죠? 규칙 따위 없다* 였다. 둘이서 일하게 된 순간부터 나는 이걸 뜯어고쳐야겠다는 생각이 들었다.
혼자만의 규칙이라도 있었다면 모르겠는데 3년 전의 팀장님과 2년 전의 팀장님, 1년 전의 팀장님은 전부 다른 사람이 작성한 것처럼 일관성이 없었다. 그래서 SwiftLint 도입을 통해 강제성을 만들어서 가독성 좋은 코드를 만들기로 했다. 코드 컨벤션을 정하고, lint를 적용하는 건 코드에 맞춤법을 지키는 것과 같다고 생각한다.

SwiftLint 규칙은 Raywenderlich 와 재르시님이 공개해둔 lint 파일을 기반으로 만들었다. SwiftLint 에서 잡아내지 못하는 규칙은 StyleShare 에서 공개해둔 Swift Style Guide를 참고해서 프로젝트 README 파일에 명시해놨다.

나는 원래 아래와 같은 스타일을 더 선호했다.

```swift
func doSomething(parameter1: Int,
                parameter2: String) -> String {
    // do something
}

doSomething(parameter1: 1,
            parameter2: "hello world")
```

파라미터가 많아지니까 깊이가 깊어지면서 좌우 스크롤이 길어져서 다음과 같은 방식으로 바꿨다.

```swift
func doSomething(
    parameter1: Int,
    parameter2: String
) -> String {
    // do something
}

doSomething(
    parameter1: 1,
    parameter2: "hello world"
)
```

위와 같이 바꾼 이후로 코드 읽기가 한결 편해졌다.

이 글을 작성하면서 생각이 난 건데, 당시에 메서드, 타입, 파일의 적절한 크기가 어느 정도인지 몰라서 규칙에는 추가하지 않았다. 아직도 어느 정도가 적당한 선인지 모르겠다. 클린 코드에서는 메서드 하나에 20줄? 이라고 했던 거 같은데 지금 프로젝트 코드를 보면 어림도 없다. 잘게 쪼개면 그건 그거대로 불필요한 분리를 하는 게 아닐까? 생각이 들기도 한다.

---

lint를 적용하고 나니 프로젝트가 빌드가 안되는 사태가 발생했다. 두둥

SwiftLint 에 기본으로 적용되어 있는 객체나 메서드, 파일의 적절한 크기도 초과했고, 적용한 규칙에 맞지 않는 코드들이 산더미였다. 

![Error 578, Warning 11492](/assets/img/improve-with-swiftlint/warning-error.png)

많이 수정해서 이 정도였고, 그 전엔 더 많았다. 나는 규칙만 만들고, 초반 에러를 제거하는 작업은 팀장님이 진행하셨다. 그리고 나는 로직의 변경 사항이 없는지, 바꾼 코드에서 더 좋은 방식으로 작성할 수 없는지를 리뷰했다. 이후에는 나도 수정 작업을 했다. 

에러를 없애기 위해 다음과 같은 작업을 주로 했다.
1. 강제 언랩핑 하고 있던 코드를 대거 guard 혹은 if let 구문으로 변경
2. 변수에 쓰고 있던 언더스코어(_) 제거
3. Colon Spacing Violation 규칙: 콜론 사이에 스페이스가 없어야 함
4. Line Length Violation 규칙: 코드의 길이를 제한함

한동안은 SwiftLint 규칙도 다 만들어놓고 빌드가 안되서 SwiftLint 를 끄고 빌드했었다. 이후에 추가로 파일 분리, 타입 분리 등이 이루어졌고 지금은 규칙을 켜고도 빌드가 된다. Warning 도 4000 여개로 줄어들었다.

Warning 은 권고사항 정도라서 각자 작업하는 파일에 Warning 제거를 하고 PR 을 올리기로 합의봤다. 나는 요즘 다른 프로젝트를 하느라 이 합의가 잘 돌아가고 있는지 모르겠다.

노란 줄이 상시 표시되니까, 무던해지는 거 같아서 Github Action 도 적용했다. [링크](https://github.com/norio-nomura/action-swiftlint) 이건 PR 에 적용된 파일만 검사하게 설정했다. 

lint를 적용하고 나서 좋은 점은, 부수적인 부분에 신경을 뺏기지 않아도 된다는 것이다. 코드 컨벤션의 합의가 없다면 코드 리뷰가 전부 컨벤션에 관한 토론의 장이 될 수도 있다(고 생각한다). 매번 고쳐달라고 하기도 눈치보이고. 

글로 쓰니까 짧고, 후루룩 뚝딱 끝난 것처럼 보이지만 스프린트 외에 진행되었고, 단순 반복 노동이긴 하지만 적은 작업은 아니어서 한 달 정도 소요됐다. 시기상으로 SwiftGen 도입보다 먼저였는데, 실제 출시 버전에 들어가는 건 더 나중이 되었다.

## 참고 자료

- [realm/SwiftLint: A tool to enforce Swift style and conventions.](https://github.com/realm/SwiftLint)
- [raywenderlich/swift-style-guide: The official Swift style guide for raywenderlich.com.](https://github.com/raywenderlich/swift-style-guide)
- [StyleShare/swift-style-guide: StyleShare에서 작성한 Swift 한국어 스타일 가이드](https://github.com/StyleShare/swift-style-guide)

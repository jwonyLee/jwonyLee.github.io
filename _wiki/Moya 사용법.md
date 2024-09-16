---
layout: wiki
title: Moya 사용법
summary: 
permalink: 1ff142a9-0d9f-cb69-7893-6ed85e7501cc
date: 2022-03-22 00:00:00 +09:00
updated: 2022-03-22 00:00:00 +09:00
tag: iOS 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

## 기록

기존에 내가 `EndPoint` 프로토콜을 정의하고, 해당 프로토콜을 채택한 `EndPointCases` 를 만드는 방식과 유사하게 사용한다.

먼저 `***Service` 라는 타입의 열거형을 선언한다. 

```swift
enum PaymentService {
    case getUserCoupon(size: Int)
}
```

그 다음에 해당 서비스를 확장해서, `TargetType`을 채택하고 구현한다.
이 때 구현해야 하는 필수 요소는 다음과 같다.

```swift
protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: Method { get }
    var task: Task { get }
    var headers: [String: String]? { get }
}
```

그 다음에는 `MoyaProvider` 라는 인스턴스를 만들고 (제네릭 타입, 위에서 만든 `Service`를 넣어서 생성)
```swift
let provider = MoyaProvider<PaymentService>()
```

`provider`를 통해 `request`를 날리고, 클로저로 응답받은 데이터를 처리하면 된다.

```swift
provider.request(.getUserCoupon(size: 100)) { result in
    // do someting
}
```

> provider를 어딘가에 유지해야 하는데, 그렇지 않으면 자동으로 해제되고 잠재적으로 응답을 받기 전에 해제 된다.

### Moya (for Rx)

일반적인 request 날리는 방법

```swift
provider.request(Service.something) { result in
    // do something
}
```

for Rx

```swift
provider.rx.request(Service.something)
    .subscribe(with: self) { owner, response in
        // do something
    }
    .disposed(by: disposeBag)
```

## 생각

- `Endpoint`를 만드는 것도 나와 있는데 이건 좀 더 살펴봐야 할 거 같음 (무엇이 이점이 있는지)

- 온전히 `Alamofire`를 wrapping 한 라이브러리인줄 알았는데, 무거운 작업은 `Alamofire`를 사용하고 그걸 다시 `Moya`로 wrapping 해서 보여준다는 말이 있는 걸 보아.. 또 그건 아닌 듯

## 참고 자료

- [Moya/Moya: Network abstraction layer written in Swift.](https://github.com/Moya/Moya)

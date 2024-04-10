---
title: "[Swift] Writing High Performance Swift Code"
categories: Swift
tags: [Swift]
published: true
---

> [Writing High-Performance Swift Code](https://github.com/apple/swift/blob/main/docs/OptimizationTips.rst#writing-high-performance-swift-code)를 읽고 정리했습니다.

## Enabling Optimizations

스위프트는 세 가지 최적화 수준을 제공한다.

- `-Onone`: 최소한의 최적화를 수행하고 모든 디버그 정보를 보존한다.
- `-O`: 대부분의 Product(실제 서비스)를 위한 것이다. 공격적인 최적화를 수행한다. 디버그 정보는 일부 손실된다.
- `-Osize`: 컴파일러가 성능보다 코드 크기를 우선시하는 특수 최적화 모드이다.

프로젝트 파일을 통해 설정할 수 있다.

## Whole Module Optimizations (WMO)

기본적으로 스위프트는 각 파일을 개별적으로 컴파일한다. 이를 통해 Xcode는 여러 파일을 병렬로 매우 빠르게 컴파일 할 수 있다. 그러나, 각 파일을 별도로 컴파일하면 특정 컴파일러 최적화가 방지된다. 스위프트는 전체 프로그램을 하나의 파일인 것처럼 컴파일하고 프로그램을 단일 컴파일 단위인 것처럼 최적화 할 수 있다.

swiftc 명령줄 플래그 `-whole-module-optimization`를 사용하여 활성화 할 수 있다. 이 모드에서 컴파일된 프로그램은 컴파일하는 데 더 오래 걸릴 가능성이 높지만, 더 빨리 실행될 수 있다.

이 모드는 Xcode 빌드 설정 'Whole Module Optimizations`에서 활성화 할 수 있다.

## Dynamic Dispatch 줄이기

> Dynamic Dispatch
> 
> In computer science, dynamic dispatch is the process of selecting which implementation of a polymorphic operation (method or function) to call at run time. It is commonly employed in, and considered a prime characteristic of, object-oriented programming (OOP) languages and systems.
> 컴퓨터 과학에서 Dynamic Dispatch는 런타임에 호출할 다형성 작업(메서드 또는 함수)의 구현을 선택하는 과정이다. 그것은 일반적으로 객체 지향 프로그래밍(OOP) 언어와 시스템의 주요 특성으로 여겨진다.

Dynamic Dispatch 는 기본적으로 vtable 을 통해 간접 호출한다.

> vtable
>
> vtable is a mechanism used in a programming language to support dynamic dispatch (or run-time method binding).
> Dynamic Dispatch(또는 런타임 메소드 바인딩)를 지원하기 위해 프로그래밍 언어에서 사용되는 메커니즘이다.

간접 호출 자체는 오버헤드 외에도 많은 컴파일러 최적화를 방지하기 때문에 직접 함수 호출하는 것보다 느리다.

### 상속하지 않는 경우 `final` 키워드 사용하기

`final` 키워드를 사용하면 컴파일러가 직접 함수 호출을 할 수 있음을 의미한다.

### 파일 외부에서 액세스할 필요가 없는 경우 `private`, `fileprivate` 사용하기

`private`, `fileprivate`을 적용하면 선언된 파일에 대한 선언의 가시성이 제한된다. 이를 통해 컴파일러는 잠재적으로 재정의할 수 있는 다른 모든 선언을 확인할 수 있다. ?? 

컴파일러가 `private`, `fileprivate` 키워드를 통해 동일한 파일에 대한 상속.. 재선언이 없다고 가정 하고 `final` 키워드로 자동 유추 + 직접 호출한다.

### Whole Module Optimization 이 활성화된 경우, 모듈 외부에서 액세스할 필요가 없을 때 `internal` 키워드 사용

`WMO`는 컴파일러가 모듈의 소스를 한 번에 모두 컴파일하도록 한다. `internal`은 현재 모듈 외부에서 볼 수 없기 때문에 잠재적으로 재정의될 수 있는 모든 선언을 자동으로 검색하여 `final`로 유추한다.

*: Swift 는 기본 액세스 제어 수준이 `internal`이기 때문에 따로 선언하지 않았으면 자동으로 이득(?)을 얻을 수 있다.

## 컨테이너 유형을 효율적으로 사용

*Container: Array, Dictionary, (maybe Set?)

### 배열에서 값 타입 사용

```swift
// Don't use a class here.
struct PhonebookEntry {
  var name: String
  var number: [Int]
}

var a: [PhonebookEntry]
```

큰 값 유형을 사용하는 것과 참조 유형을 사용하는 것 사이에는 trade-off 가 있음을 명심해야 한다. 어떤 경우에는 큰 값 유형을 복사하고 이동하는 오버헤드가 bridiging 과 retain/release 오버헤드를 제거하는 비용보다 크다.

생각) 값 유형이 너무 크면 그걸 복사하는 비용보다 참조 유형의 레퍼런스를 복사하는 것이 더 싸다는 뜻인듯?

### `NSArray` 브리징이 필요하지 않은 경우 참조 유형과 함께 `ContigousArray`를 사용

`NSArray` 를 직접 사용해본 경험이 전무해서 어떤 때에 사용해야 할 지 아직까진 와닿지 않는다. 그래도 브리징이라는 개념을 알기 위해서 아래의 글들을 읽어보았는데, Objective-C 에서 타입 캐스팅을 브리징이라고 표현하는 것으로 파악했다.

- [(Swift) Array - 05. NSArray · Wireframe](https://soooprmx.com/swift-array-05-nsarray/)
- [Objective-C) ARC와 Toll-Free Bridging](https://babbab2.tistory.com/62)

### 객체 재할당 대신 내부 변경을 사용한다.

Swift의 모든 표준 라이브러리 컨테이너는 명시적 복사 대신 복사를 수행하기 위해 COW(copy-on-write)를 사용하는 값 유형이다. 많은 경우 컴파일러가 깊은 복사 대신 컨테이너를 유지하여 불필요한 복사본을 제거할 수 있다. 이는 컨테이너의 참조 횟수가 1보다 크고 컨테이너가 변경된 경우에만 기본 컨테이너를 복사하여 수행된다.

```swift
var c: [Int] = [1, 2, 3]
var d = c // 여기에서 복사가 발생하지 않는다.
d.append(2) // 여기에서 복사가 발생한다.
```

때때로 COW 는 사용자가 주의하지 않으면 예상치 못한 추가 복사본을 도입할 수 있다. 이에 대한 예시는 함수에서 객체 재할당을 통해 mutation(변경) 를 수행하려고 시도하는 것이다. Swift 에서 모든 매개변수는 +1에서 전달된다. 즉 매개변수는 호출 시점 이전에 유지되고 호출 수신자의 끝에서 해제된다. 이것은 다음과 같은 함수를 작성하는 경우를 의미한다.

```swift
func append_one(_ a: [Int]) -> [Int] {
    var a = a
    a.append(1)
    return a
}

var a = [1, 2, 3]
a = append_one(a)
```

> a may be copied despite the version of a without one appended to it has no uses after append_one due to the assignment. This can be avoided through the usage of inout parameters:

할당으로 인해 `append_one` 이후에는 사용되지않는 버전이 추가되었음에도 불구하고 복사될 수 있다. 이것은 `inout` 매개변수를 사용하여 피할 수 있다.

```swift
func append_one_in_place(a: inout [Int]) {
    a.append(1)
}

var a = [1, 2, 3]
append_one_in_place(&a)
```

## Wrapping operations (Wrapping 작업)

Swift 는 일반 산술을 수행할 때 오버플로를 확인하여 정수 오버플로 버그를 제거한다. 오버플로가 발생할 수 없거나 작업을 래핑하도록 허용한 결과가 올바른 경우 이러한 검사는 고성능 코드에서 적절하지 않을 수 있다.

### 오버플로가 발생할 수 없음을 증명할 수 있는 경우 wrapping interger 산술을 사용한다.

성능이 중요한 코드에서는 wrapping arithmetic 을 사용하여 안전하다는 것을 알고 있으면 오버플로 검사를 방지할 수 있다.

```swift
a: [Int]
b: [Int]
c: [Int]

// 전제 조건: 모든 a[i], b[i]: a[i] + b[i]가 오버플로 되지 않거나,
// 또는 래핑 결과가 필요하다.
for i in 0...n {
    c[i] = a[i] &+ b[i]
}
```

&+, &-, &* 연산자의 동작은 완전히 정의되어 있다. 결과는 오버플로가 발생할 경우 단순히 래핑된다. 따라서 Int.max &+ 1은 Int.min으로 보장된다 (C에서 INT_MAX + 1이 정의되지 않은 동작임).

## 제네릭

이 부분은 이해를 못했기 때문에 추가로 다시 공부할 예정이다.

> When optimizations are enabled, the Swift compiler looks at each invocation of such code and attempts to ascertain the concrete (i.e. non-generic type) used in the invocation. If the generic function's definition is visible to the optimizer and the concrete type is known, the Swift compiler will emit a version of the generic function specialized to the specific type. This process, called specialization, enables the removal of the overhead associated with generics. Some more examples of generics:

최적화가 활성화 되면, ~~~ 과정을 거쳐서 제네릭과 관련된 오버헤드를 제거할 수 있게 해준다. 에서 과정을 이해 못함.


## The cost of large Swift values

Swift 에서 값은 데이터의 고유한 복사본을 유지한다. 값이 독립적인 상태를 갖도록 하는 것과 같이 값 유형을 사용하면 몇 가지 이점이 있다. 값을 복사할 때(할당, 초기화 및 인수 전달의 영향) 프로그램은 값의 새 복사본을 만든다. 일부 큰 값의 경우 이러한 복사본은 시간이 많이 걸리고 프로그램 성능을 저하시킬 수 있다.

"값" 노드를 사용하여 트리를 정의하는 아래의 예가 있다. 

```swift
protocol P {}
struct Node: P {
  var left, right: P?
}

struct Tree {
  var node: P?
  init() { ... }
}
```

트리가 복사될 때(인수로 전달, 초기화 또는 할당) 전체 트리를 복사해야 한다. 우리 트리의 경우 이것은 malloc/free 에 대한 많은 호출과 상당한 참조 카운팅 오버헤드를 필요로 하는 값비싼 작업이다.

그러나, 값의 의미가 남아 있는 한 값이 메모리에 복사되는지 여부는 크게 신경쓰지 않는다.

### 큰 값에 대해 copy-on-write semantics 를 사용하라.

큰 값을 복사하는 비용을 없애기 위해 cow 를 채택하라. cow를 구현하는 가장 쉬운 방법은 Array와 같은 cow 구조를 사용하는 것이다. Swift 배열은 값이지만, 배열의 내용은 배열의 내용은 copy on write 특성을 특징으로 하기 때문에 배열이 인수로 전달될 때마다 복사되지 않는다.

이 간단한 변경은 트리 데이터 구조의 성능에 큰 영향을 미치며, 배열을 인수로 전달하는 비용은 트리 크기에 따라 O(n)에서 O(1)로 떨어진다.

```swift
struct Tree: P {
    var node: [P?]
    init() {
        node = [thing]
    }
}
```

이 방식을 사용하면 두 가지 단점이 있다. 
1. Array가 값 래퍼의 컨텍스트에서 의미가 없는 `append`, `count`와 같은 메서드를 노출한다는 것이다. 이러한 방법은 참조 래퍼를 사용하기 어렵게 만들 수 있다.
2. Array에 프로그램 안정성과 Objective-C 와의 상호 작용을 보장하기 위한 코드가 있다는 것이다. Swift 는 인덱싱된 액세스가 배열 범위 내에서 속하는지 확인하고 배열 저장소를 확장해야 하는 경우 값을 저장할 때 확인한다. 이러한 런타임 검사는 속도를 늦출 수 있다.

그래서 이것의 대안은 값 래퍼로 Array를 대체하기 위해 전용 copy-on-write 데이터 구조를 구현하는 것이다.

```swift
final class Ref<T> {
  var val: T
  init(_ v: T) {val = v}
}

struct Box<T> {
    var ref: Ref<T>
    init(_ x: T) { ref = Ref(x) }

    var value: T {
        get { return ref.val }
        set {
          if !isKnownUniquelyReferenced(&ref) {
            ref = Ref(newValue)
            return
          }
          ref.val = newValue
        }
    }
}
```

`Box` 타입은 위의 코드 샘플에서 배열을 대체할 수 있다.

## 프로토콜

### 클래스에 의해서만 만족되는 프로토콜을 클래스 프로토콜로 표시하라.

Swift는 프로토콜 채택을 클래스로만 제한할 수 있다. 프로토콜을 클래스 전용으로 표시하는 것의 한 가지 이점은 클래스만 프로토콜을 충족한다는 지식을 기반으로 컴파일러가 프로그램을 최적화할 수 있다는 것이다. 예를 들어, ARC 메모리 관리 시스템은 클래스를 다루고 있다는 것을 알고 있으면 쉽게 유지(객체의 참조 횟수 증가)할 수 있다. 이 지식이 없으면 컴파일러는 구조체가 프로토콜을 충족할 수 있다고 가정해야 하며 비용이 많이 들 수 있는 중요하지 않은 구조체를 유지하거나 해제할 준비가 필요하다.

프로토콜의 채택을 클래스로 제한하는 것이 합리적이라면 프로토콜을 클래스 전용 프로토콜로 표시하여 더 나은 런타임 성능을 얻을 수 있다.

```swift
protocol Pinable: AnyObject {
    func ping() -> Int
}
```

## 생각

쉽게 적용할 수 있는 부분은 네 가지 인 것 같다.
- 프로젝트 최적화 모드 설정하기
- 상속하지 않는 경우 `final` 키워드 명시하기
- 외부로 노출되지 않는 경우 `private`, `fileprivate` 명시하기
- 클래스 프로토콜 표시하기

최근에 회사 프로젝트도 코드 정리하면서 `final` 키워드부터 열심히 명시하고 있다. 프로퍼티/메서드 숨기기도 해야하는데, 이건 도무지 엄두가 안나네. 😩

## 참고 자료

- [Writing High-Performance Swift Code](https://github.com/apple/swift/blob/main/docs/OptimizationTips.rst#writing-high-performance-swift-code)
- [Dynamic dispatch - Wikipedia](https://en.wikipedia.org/wiki/Dynamic_dispatch)
- [Virtual method table - Wikipedia](https://en.wikipedia.org/wiki/Virtual_method_table)
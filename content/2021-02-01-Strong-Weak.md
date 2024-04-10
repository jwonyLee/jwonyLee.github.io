---
title: "[Swift] Strong 과 Weak 참조 방식에 대해 설명하시오."
permalink: "7c62d9b2-06d5-65d7-6898-1046353eebd0"
publish: true
---

# \[Swift] Strong 과 Weak 참조 방식에 대해 설명하시오.

## Strong Reference (강한참조)

클래스 타입의 프로퍼티, 변수, 상수 등을 선언할 때 별도의 식별자를 명시하지 않으면 강한 참조를 하게 된다.

```swift
var globalReference: Person?

func foo() {
	let john: Person = Person(name: "john") // john is being initialized
	// 인스턴스의 참조 횟수: 1

	globalReference = john // 인스턴스의 참조 횟수 2

	// 함수 종료 시점
	// 인스턴스의 참조 횟수: 1
}
foo()
```

인스턴스가 강한참조를 하는 전역변수 `globalReference`에 강한참조되면서 참조 횟수가 1 더 증가하여 2가 된다. 그 상태에서는 함수가 종료되면 참조 횟수가 1 감소하여도 여전히 참조 횟수가 1이므로 메모리에서 해제되지 않는다.

## Weak Reference (약한참조)

강한참조와 달리 자신이 참조하는 인스턴스의 참조 횟수를 증가시키지 않는다. 참조 타입의 프로퍼티나 변수의 선언 앞에 `weak` 키워드를 써주면 그 프로퍼티나 변수는 자신이 참조하는 인스턴스를 약한참조한다.

> 약한참조는 상수에서 쓰일 수 없다. 만약 자신이 참조하던 인스턴스가 메모리에서 해제된다면 `nil`이 할당될 수 있어야 하기 때문이다. 그래서 약한참조를 할 때는 자신의 값을 변경할 수 있는 변수로 선언해야 한다. 더불어 `nil`이 할당될 수 있어야 하므로 약한참조는 항상 옵셔널이어야 한다. 즉, 옵셔널 변수만 약한참조를 할 수 있다.

---

## 참고 자료

- 스위프트 프로그래밍 3판

## 태그

#Swift/ARC #iOSInterviewquestions
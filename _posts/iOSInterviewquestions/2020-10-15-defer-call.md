---
layout: post
title: defer가 호출되는 순서는 어떻게 되고, defer가 호출되지 않는 경우를 설명하시오.
subtitle: iOSInterviewquestions
categories: iOSInterviewquestions
tags: [Swift, iOSInterviewquestions]
emoji: 🍎
---

## defer가 호출되는 순서

- defer가 하나만 선언되어 있다면, 해당 구문이 끝나는 시점에 실행된다.

```swift
func testDefer() {
	defer {
		print("run defer")
	}

	print("testDefer")
}
```

```swift
testDefer
run defer
```

- 한 구문 내에 defer가 여러개 선언되어 있다면, 선언한 순서에 역순으로 실행된다.

```swift
func testDefer() {
	defer {
		print("run 1")
	}
	
	defer {
		print("run 2")
	}

	defer {
		print("run 3")
	}

	print("end")
}
```

```swift
end
run 3
run 2
run 1
```

## defer가 호출되지 않는 경우

1. `throw` 를 이용해서 오류를 던질 경우
중간에 `throw` 가 발생해서 함수가 종료될 경우 아래에 선언된 `defer`에 도달하지 못해 함수가 종료 되어도 `defer`가 호출되지 않음
2. `guard` 문을 사용하여 중간에 함수를 종료하는 경우
`throw` 의 경우와 비슷함
3. 리턴값이 `Never`(비반환함수)인 경우
에러가 발생하면서 함수를 반환하지 않고 실행을 종료하기 때문에 `defer` 가 호출되지 않음

---

## 참고 자료

- [defer 구문 알아보기 - 뀔뀔(swieeft)의 개발새발기](https://swieeft.github.io/2020/02/26/defer.html)
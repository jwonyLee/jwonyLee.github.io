---
title: "[Book] 동시성 프로그래밍"
categories: Book
tags: [Book, 서평, 동시성]
published: true
---

<p align="center">
<img alt="동시성 프로그래밍 표지" src="https://www.hanbit.co.kr/data/books/B9078925849_l.jpg"><br />
<a href="https://www.hanbit.co.kr/media/books/book_view.html?p_code=B9078925849">동시성 프로그래밍</a>
</p>

동시성은 정말 어렵다. 나는 여전히 어려움을 느끼고 있고, 그것을 해소하고자 4월 서평 도서로 이 책을 선택했다.

## 기록

동시성 → 2개 이상의 프로세스가 동시에 계산 중인 상태 (실행 상태 + 대기 상태)  
병렬성 → 여러 프로세스가 동시에 계산을 실행하는 상태 (Only 실행 상태)

병렬화를 통한 고속화  
→ 병렬화를 함으로써 수반되는 오버헤드가 있음. 이를 포함한 수행시간이 순차 실행보다 빠른 경우에 병렬화를 고려(적용) 해야 한다.

병렬 처리 → 성능 향상을 위해 필요함

동시 처리
  - 장점
    1. 효율적인 계산 리소스 활용: A라는 일 수행 중에 B 수행
    2. 공평성 (공정성): 동시에 수행하지 못하는 것은 한쪽 처리에 치우쳐진 것
    3. 편리성: 공평성과 비슷한 맥락에 존재
  - 단점
    - 복잡성: 계산 경로 수의 급증

Rust 에서 `if`, `match`(switch 와 유사함) 는 식이어서 값을 반환해야 한다. → 엄청 신기하다.

> 비동기 프로그래밍은 콜백을 이용해서도 기술된다고 설명했다. 하지만 콜백을 이용하는 방법은 가독성이 낮아진다. 특히 콜백을 연속해서 호출하면 매우 읽기 어려운 코드가 되어 콜백 지옥이라 불리기도 한다. 

완전 공감.

## 좋았던 점

- 도식이 있어서 (비교적) 이해하기 쉽다. 처음에 동시성과 병렬성 설명을 보면서 뭐가 다른지 이해하기 어려웠는데, 그림을 보니까 훨씬 이해하기 쉬웠다.
- 코드에 번호를 붙여 설명이 기술되어 있는데, 설명이 자세해서 Rust를 몰라도 전체적인 흐름을 이해하는 데 무리가 없었다. (그래도 여전히 어렵다.)

## 아쉬웠던 점

- 어렵다!  
내가 기대한 것보다 더 깊이가 깊어서 어려웠다. 정신 놓고 읽기에 마냥 쉬운 책은 아니었다. 어영부영 읽는 걸 많이 미루기도 했다. 게다가 이름은 익히 들었지만, 자주 접한 언어도 아닐뿐더러 익숙한 언어가 아니다 보니 언어적인 측면에서도 수월하게 읽을 수 없는 어려움도 있었다. 더 얕고 쉬운 책을 원한 나에게는 적합하지 못했다.

---

한빛미디어 \<나는 리뷰어다> 활동을 위해서 책을 제공받아 작성된 서평입니다.
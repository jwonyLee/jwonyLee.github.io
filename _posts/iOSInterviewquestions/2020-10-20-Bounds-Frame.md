---
layout: post
title: Bounds 와 Frame 의 차이점을 설명하시오.
subtitle: iOSInterviewquestions
categories: iOSInterviewquestions
tags: [iOS, iOSInterviewquestions]
emoji: 📱
---

## Frame과 Bounds

view의 위치와 크기를 표현하는 property

## Bounds

View의 위치와 크기를 자신만의 좌표 시스템 안에서 나타냄
→ 상위뷰와 아무런 상관이 없음
- 회전된 뷰의 width, height 를 알기에 적합함
    → Frame은 view가 회전하면 그에 맞춰 커짐

## Frame

SuperView의 좌표 시스템 안에서 View의 위치와 크기를 나타냄
→ SuperView안에서 상대적인 위치?를 나타냄
- 좌표를 기준으로 움직이는 애니메이션에 사용되기 적합함

### 참고 자료

- [iOS ) Frame과 Bounds의 차이 (1/2)](https://zeddios.tistory.com/203)
- [[iOS] Frame과 Bounds의 차이](https://velog.io/@cskim/iOS-Frame-vs.-Bound-t7k1gdd4kj)
- [[ios] Bounds vs Frame?](https://baked-corn.tistory.com/81)
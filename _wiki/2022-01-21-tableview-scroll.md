---
layout: wiki
title: 원하는 위치의 셀로 이동
summary: 
permalink: af9b3263-31b2-74e1-2656-1c20982834e6
date: 2022-01-21 00:00:00 +09:00
updated: 2022-01-21 00:00:00 +09:00
tag: iOS 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

## 상황
- A 화면: 썸네일로 이루어진 컬렉션 뷰가 있다.
- B 화면: 상세 정보를 표시하는 테이블 뷰가 있다.

## 목표

A 화면의 특정 썸네일을 선택하면 B 화면으로 이동한다. 이 때, B 화면의 가장 첫번째 셀을 표시하는 것이 아니라, A 화면의 썸네일 위치와 동일한 위치에 있는 셀로 이동해야 한다.

## 첫번째 시도

`viewDidAppear`에서 `scrollToRow(at:)`을 호출했다. `viewWillAppear`에서 호출하지 않은 이유는 뷰가 그려지기 전이라서 이동을 할 수 없었다. 이렇게 하고 나니, 뷰를 이미 그린 후에 이동하기 때문에, 가장 첫번째 셀이 잔상처럼 보이는 현상이 있었다.

문제는 아니지만, 사용자 경험에 좋은 영향은 끼치지 못하는 것이 분명했다. 그러나, 출시에 급급해서(...) 어느 한 편으로 묻어두고 있었는데, 해당 부분을 고쳐달라는 요청을 받았다.

## 두번째 시도

고쳐달라는 요청을 받았을 때, 이동하는 시간 동안 스켈레톤 뷰를 띄워달라고 하셨기에 [Juanpe/SkeletonView](https://github.com/Juanpe/SkeletonView) 를 도입하고자 했다. 

스켈레톤 뷰를 적용했더니, 첫번째 셀 표시 → 스켈레톤 뷰 → 이동한 셀 순서대로 화면에 표시되는 현상이 나타났다. 이 문제를 해결하기 위해 처음 생각했던 것은, `첫번째 셀이 나타나기 전에 스켈레톤 뷰를 띄우면 되지 않을까?` 였고 첫번째 셀이 나타나는 것을 감지하기 위해 테이블 뷰가 그려지는 주기를 찾아봤다. TableView Delegate에 있는 `tableView(_:willDisplay:forRowAt:)`는 셀이 표시되기 전에 호출된다. 

그래서 이 때 스켈레톤 뷰를 띄우기 위한 전초 작업을 했다.
- 이동하려는 위치가 첫번째라면 스켈레톤 뷰를 띄울 필요가 없다.
- 이동하려는 위치가 첫번째가 아니면서 && 한 번만 작동하기 위한 변수로 검사하고, 조건에 맞으면 스켈레톤 뷰를 표시한다.
  - B 화면에서 C, D 화면으로 이동했다가 되돌아올 경우에는 이동할 필요가 없기 때문에 한 번만 작동하기 위한 변수를 별도로 두었다.

첫번째 셀 표시 전에 스켈레톤 뷰가 나오고 원하는 위치로 이동까지 잘 되었다. 그러나 이미 데이터가 다 그려진 상태에서 스켈레톤 뷰를 띄우기 때문에 스켈레톤 뷰의 길이가 예쁘게 안 나온다는 문제점이 있었다. 표시하는 데이터에서 값이 없는 경우가 있을 수 있었기 때문이다.

## 세번째 시도

원초로 돌아가서 생각했다. 스켈레톤 뷰를 띄우려는 목적은? 첫번째 셀이 표시 되지 않고 특정 위치로 이동해야 하는데 첫번째 셀이 표시 된다. 이를 숨기고자 한다. 첫번째 셀이 표시되지 않고 바로 특정 위치로 이동할 수 있다면, 스켈레톤 뷰를 띄울 필요가 없다. 그러려면 첫번째 셀을 표시하기 전에 이동해야 하는 것 아닌가? `viewDidAppear`는 이미 뷰가 그려진 난 후이기 때문에 적절하지 못하다. `viewWillAppear`도 뷰가 그려지기 전이기 때문에 적절하지 못하다. 두 개 사이의 다른 생명 주기는 없을까?

그렇게 해서 나온 해결책이 `viewDidLayoutSubviews`이다. `viewDidLayoutSubviews`는 서브 뷰들이 배치가 된 후에 호출된다. 대략 `viewDidAppear`와 `viewWillAppear` 사이 어디쯔음에 있지 않을까?

어쨌든 이 `viewDidLayoutSubviews`는 서브 뷰들이 배치가 된 후에 호출이 되기 때문에, 여러 번 호출될 수 있다. 그래서 여기서도 한 번만 작동하기 위해 `isFirstLoad`라는 변수를 두고 검사하는 방식으로 작성했다. 더 좋은 방법이 있는 지는 모르겠다. 기존에 사용하던 `isMovingToParent` 값이 `false`로 나와서 별도의 변수를 둔 것이기 때문이다.

잘 동작하는 것을 확인하고 테스트 플라이트에 올렸는데(테스트는 시뮬레이터에서만 했었다.) 아예 이동하지 않는 현상이 발발했다. 그래서 또 열심히 구글링했더니, `scrollToRow(at:at:animated)`를 메인 스레드에서 실행하길래 메인 스레드에서 실행하게끔 수정했더니 실 기기에서도 제대로 동작했다.

## 궁금한 점

`viewDidLayoutSubviews`도 생명 주기의 일부니까 무조건 메인 스레드에서 실행되고 있다고 생각했는데, 왜 별도로 메인 스레드를 태워야 하는 지 모르겠다. 이 문제 말고도 다른 문제도 있었는데, 그 문제들도 메인 스레드에서 실행하게 수정하니까 제대로 작동했다. 생명 주기에 있는 코드들은 메인 스레드에서 실행되니까 당연히 그 안에 작성한 UI 관련 코드들도 메인 스레드에서 실행된다고 생각했는데, 그게 아닌가?

생명 주기에 대해서 더 공부해야 할 것 같다.


## 참고 자료, 참고
- [[iOS] viewDidLayoutSubviews란? viewWillLayoutSubviews란? : 네이버 블로그](https://blog.naver.com/PostView.naver?blogId=soojin_2604&logNo=222437253619&parentCategoryNo=&categoryNo=64&viewDate=&isShowPopularPosts=false&from=postView)

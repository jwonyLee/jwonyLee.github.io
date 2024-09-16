---
layout: wiki
title: throttle, debounce
summary: 
permalink: 255d538c-8044-4bbd-05a9-c125b5d505ee
date: 2022-03-06 00:00:00 +09:00
updated: 2022-03-06 00:00:00 +09:00
tag: RxSwift 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

## 기록

`RxSwift`는 관찰 가능한 스트림을 이용한 비동기 프로그래밍 API

하나 또는 연속된 항목이 들어온다. 연속된 값을 일부 제한해서 사용해야 한다면? `throttle` 또는 `debounce`를 사용한다.

### throttle: 페이지네이션 구현

테이블 뷰나 컬렉션 뷰를 이용해서 데이터를 표시할 때, 페이지네이션을 구현하게 된다. 이 때, 화면 끝에 도달하면 다음 데이터를 표시하기 위해 API를 호출한다. 

테이블 뷰나 컬렉션 뷰를 이용해 데이터를 표시하고, 페이지네이션을 구현한다면 다음과 같은 방식으로 작동한다.

1. 초기 데이터를 표시한다.
2. 스크롤이 끝에 도달했는 지 감지한다.
3. 다음 데이터를 표시하기 위한 API를 호출한다.
4. 가져온 데이터를 화면에 표시한다.
5. 2~4의 과정을 반복한다.

이것을 RxSwift로 해결한다면 이렇게 만들 수 있다.

```swift
tableView.rx.contentOffset
    .filter { $0.y > (self.tableView.contentSize.height - self.tableView.frame.height) }
    .subscribe(onNext: { [weak self] _ in
        self?.viewModel.next()
    })
    .disposed(by: disposeBag)
```

이 코드의 문제는, 스크롤은 연속적으로 동작하기 때문에 여러 번 불필요한 API 호출을 하게 된다. 불필요한 호출을 방지하기 위해서 특정 시간동안 여러 번 호출이 들어오면 한 번만 동작하게 해주는 연산자가 있다. 그게 바로 `throttle`

그래서 위의 코드에 `throttle`을 추가해주면 다음과 같다.

```swift
tableView.rx.contentOffset
    .filter { $0.y > (self.tableView.contentSize.height - self.tableView.frame.height) }
    .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
    .subscribe(onNext: { [weak self] _ in
        self?.viewModel.next()
    })
    .disposed(by: disposeBag)
```

첫 번째 인자로 들어가는 값은 제한 시간이다. 이벤트가 방출되면 제한 시간동안 이벤트가 더 방출되지 않는다.
두 번째 인자로 들어가는 값은 `true`로 주면, 첫번째 + 마지막 이벤트를 실행한다. `false`로 주면, 마지막 이벤트만 넘긴다.

### debounce: 자동 완성 검색

그렇다면 `debounce`는 언제 사용할까? `debounce`는 특정 시간마다 그 시점에 존재하는 항목을 배출한다. 그래서 나는 0.5초마다 텍스트 필드에 있는 텍스트를 검색하는 로직을 작성할 때 사용했다.

```swift
searchBar.rx.text.orEmpty
    .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
    .distinctUntilChanged()
    .bind(to: self.viewModel.keywordRelay)
    .disposed(by: disposeBag)
```

더불어 `distinctUntilChanged()`를 사용해서 중복 값은 배출하지 않도록 작성했다.

## 생각

## 참고 자료

- [Rxswift Debounce / Throttle :: kkimin's swift](https://kkimin.tistory.com/43?category=955083)

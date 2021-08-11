---
layout: post
title: "[RxSwift] Single, Maybe, Completable"
subtitle: 
categories: RxSwift
tags: [RxSwift]
emoji: 🍎
---

## Single

`Single` 은 특수한 `Observable` 이다. `.success(Value)` 이벤트 또는 `.error` 중 한 번만 내보낼 수 있는 시퀀스를 나타낸다. 내부적으로 `.success` 는 `.next` + `.completed` 로 이루어져있다.

이러한 종류의 특성은 파일 저장, 파일 다운로드, 디스크에서 데이터 로드 또는 기본적으로 값을 생성하는 모든 비동기 작업과 같은 상황에서 유용하다.

1. 성공 시 정확히 하나의 요소를 내보내는 래핑 작업에 사용됨
2. 시퀀스에서 단일 요소를 사용하려는 의도를 더 잘 표현하고 시퀀스가 둘 이상의 요소를 방출하는지 확인하기 위해 구독 오류가 발생된다.

## Maybe

observable이 성공적으로 완료되면 값을 방출하지 않을 수 있다는 유일한 차이점을 제외하고는 `Single` 과 매우 유사하다.

## Completable

구독이 삭제되기 전에 단일 `.completed` 또는 `.error` 이벤트만 생성되도록 허용함

비동기 작업이 성공했는지 여부만 알면 되는 사용 사례가 엄청 많아서 생겨났다.
---
layout: wiki
title: Repository 패턴
summary: 
permalink: e41ac27e-0ce9-c443-2af4-7ceef30ec815
date: 2021-08-20 00:00:00 +09:00
updated: 2021-08-20 00:00:00 +09:00
tag: Design Pattern 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

클린 코드 2장 의미있는 이름에서 `Manager`, `Processor`, `Data`와 같은 동사는 클래스 이름으로 적합하지 않다고 설명한다. BeepBeep 프로젝트에서 Realm 클래스 이름이 `RealmManager` 였다. 그 때는 클린 코드 이미 한 번 읽은 상태였다. 그 때도 다른 적합한 이름이 뭐가 있을 지 고민을 했었는데, 생각이 잘 나지 않아서 그냥 Manager로 작명했었다. `Helper`도 고민했는데 이것도 그다지 적합하지 않다고 생각했다. `뭘 도와줄건데?` 라는 생각이 들었다.

이번에 Core Data 데이터 구조 설계랑 API를 내가 만들기로 해서 더 고민을 해봤다. 이것저것 찾아보다가 Repository 패턴에 대해서 보게 되었다.

Repository 에 대한 공식 문서같은 게 있나? 싶어서 찾아봤는데 마이크로소프트 닷넷 문서에서 찾을 수 있었다.

[인프라 지속성 계층 디자인](https://docs.microsoft.com/ko-kr/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/infrastructure-pers이istence-layer-design)

> 리포지토리는 데이터 원본에 액세스하는 데 필요한 논리를 캡슐화하는 클래스 또는 구성 요소입니다. 

첫 문장에서 아주 명료하게 설명을 한다. 

데이터 레이어와 비즈니스(로직) 레이어 사이에 있는 중간 계층이라고 이해했다. 그래 너 데이터 관련된 거 하는 구나? 하긴 책임과 역할은 잘 쪼개는 게 중요하지 그렇지 ㅇㅋ

그럼 여기서 드는 의문은 dao랑 뭐가 다른거지? 

- https://www.baeldung.com/java-dao-vs-repository
- https://stackoverflow.com/questions/8550124/what-is-the-difference-between-dao-and-repository-patterns



repository 패턴은 필수가 아니다. 프로젝트 규모에 따라 적절하게... 하면 되는 데 그래도 이번에 해보면 좋을 거 같아서 연습중이다. 같이 연습해봅시다.

https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/

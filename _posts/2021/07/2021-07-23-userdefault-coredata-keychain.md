---
layout: post
title: "[iOS] UserDefaults, KeyChain, Core Data"
subtitle: 
categories: iOS
tags: [UserDefaults, KeyChain, Core Data]
---

## UserDefaults

-   데이터를 저장할 때Info.plist와 유사한 구조로 저장한다.
    -   UserDefaults.plist는 앱 폴더 내의 Library 폴더에 저장된다.
-   저장할 수 있는 형식
    -   NSString
    -   NSNumber
    -   NSData
    -   NSArray NSDictionary
    -   NSData
        -   사용자 객체를 저장하려면Codable로 만들어서NSData로 변환해서 저장한다.
-   최근 검색 목록, 온보딩 여부 등 (보안에) 민감하지 않은 데이터를 저장한다.
-   많은 양의 데이터를 저장하기 위한 것이 아니다!
-   앱이 시작될 때 UserDefaults.plist 파일이 메모리에 로드된다. 그래서 많은 양의 데이터를 UserDefaults에 저장하면 앱 성능에 상당한 영향을 미칠 수 있다.
-   사용자가 탐색기 앱을 사용하여 액세스할 수 있다. (보안에 취약하다.)
-   **UserDefaults에 인앱 구매 여부를 저장하면 안된다.**
-   사용자 비밀번호/API 키를 저장하면 안된다.

## KeyChain

[Apple Developer Documentation](https://developer.apple.com/documentation/security/keychain_services/keychain_items/using_the_keychain_to_manage_user_secrets)

-   암호화된 데이터베이스
-   암호, 키, 인증서 같은 민감한 데이터를 저장하려면 키체인을 사용해야 한다.
-   키체인에 저장된 데이터는 동일한 개발자의 다른 앱에서 액세스할 수 있다.
    -   SSO → 한 앱에 로그인하면 다른 앱이 자동으로 로그인하는 것과 같은 보안 로그인

## Core Data

-   데이터베이스가 아니다.
-   객체 관계를 관리하기 위한 프레임워크
-   저장할 수 있는 데이터 형식
    -   SQLite 파일
    -   XML 파일
    -   바이너리 파일
    -   인메모리(RAM)
-   저장/로드할 데이터의 양이 많을 때 유용하다.
-   데이터에 몇 가지 관계가 있는 경우, 쿼리/필터링이 필요한 경우, 정렬 기능이 필요한 경우 등 에서 사용된다.
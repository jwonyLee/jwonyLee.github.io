---
layout: post
title: UserDefaults 사용하기
subtitle:
categories: iOS
tags: [iOS, UserDefaults]
emoji: 📱
---

## 개요

`UserDefaults`를 이용해서 앱이 종료될 때 객체를 저장하고, 앱이 다시 실행될 때 마지막 상태를 복원하고 싶었다.

## 어려웠던 점

[[ios] userDefaults를 이용한structure 타입 Data 저장하기](https://velog.io/@cooo002/ios-userDefaults%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9Cstructure-%ED%83%80%EC%9E%85-Data-%EC%A0%80%EC%9E%A5%ED%95%98%EA%B8%B0)

처음에는 위 글을 보고 `PropertyListEncoder` & `PropertyListDecoder` 를 이용하는 방법을 해봤다. 안된다고 생각해서 다른 방법을 찾았는데, 문제를 해결하고 나니 (확인은 안 해봤는데) 저장은 됐지만, 읽어오는 과정에서 문제가 있었던 거 같다.

## 해결한 방법

scene의 생명 주기를 이용해서 저장과 불러오기를 수행했다.

1.  앱이 종료될 때 데이터를 저장한다. `sceneWillResignActive(_ scene: UIScene)`
    
    ```swift
     func sceneWillResignActive(_ scene: UIScene) {
         if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
             do {
                 try UserDefaults.standard.setObject(appDelegate.someObject, forKey: "someObject")
                 UserDefaults.standard.synchronize()
             } catch {
                 print(error.localizedDescription)
             }
         }
     }
    ```
    
2.  앱이 시작될 때 데이터를 불러온다. `sceneDidBecomeActive(_ scene: UIScene)`
    
    ```swift
     func sceneDidBecomeActive(_ scene: UIScene) {
         do {
             let someObject = try UserDefaults.standard.getObject(forKey: "someObject", castTo: SomeObject.self)
             if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                 appDelegate.someObject = someObject
                 NotificationCenter.default.post(name: Notification.Name.DidChangeSomePropertyNotification, object: nil)
             }
         } catch {
             print(error.localizedDescription)
         }
     }
    ```
    
    화면에서 `someObject`에 있는 프로퍼티를 출력하는데, 계속 0으로 뜨길래 저장이 안된다고 생각했었다. 직접 출력해보니 값이 제대로 뜨길래 UI를 업데이트해주면 되겠다 싶어서 `NotificationCenter`를 이용해서 값이 변경됐다고 발행하니까 정상적으로 출력됐다.
    
    ```
    ❓ sceneDidBecomeActive(_:) 는 UI를 표시하기 전에 실행된다고 쓰여있는데, 왜 UI를 업데이트 해줘야 데이터가 정상 출력 되는 지 모르겠다.
    ```
    

다른 로직에 문제가 있어서 그 부분을 고치고 있지만, 일단 데이터 저장은 해결!

---

## 참고 자료

- [Save custom objects into UserDefaults using Codable in Swift 5.1 (Protocol Oriented Approach)](https://medium.com/flawless-app-stories/save-custom-objects-into-userdefaults-using-codable-in-swift-5-1-protocol-oriented-approach-ae36175180d8)

## 새로 배운점

-   UserDefaults
-   NotifiactionCenter 활용
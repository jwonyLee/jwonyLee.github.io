---
layout: post
title: UserDefaults ์ฌ์ฉํ๊ธฐ
subtitle:
categories: iOS
tags: [iOS, UserDefaults]
emoji: ๐ฑ
---

## ๊ฐ์

`UserDefaults`๋ฅผ ์ด์ฉํด์ ์ฑ์ด ์ข๋ฃ๋  ๋ ๊ฐ์ฒด๋ฅผ ์ ์ฅํ๊ณ , ์ฑ์ด ๋ค์ ์คํ๋  ๋ ๋ง์ง๋ง ์ํ๋ฅผ ๋ณต์ํ๊ณ  ์ถ์๋ค.

## ์ด๋ ค์ ๋ ์ 

[[ios] userDefaults๋ฅผ ์ด์ฉํstructure ํ์ Data ์ ์ฅํ๊ธฐ](https://velog.io/@cooo002/ios-userDefaults%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9Cstructure-%ED%83%80%EC%9E%85-Data-%EC%A0%80%EC%9E%A5%ED%95%98%EA%B8%B0)

์ฒ์์๋ ์ ๊ธ์ ๋ณด๊ณ  `PropertyListEncoder` & `PropertyListDecoder` ๋ฅผ ์ด์ฉํ๋ ๋ฐฉ๋ฒ์ ํด๋ดค๋ค. ์๋๋ค๊ณ  ์๊ฐํด์ ๋ค๋ฅธ ๋ฐฉ๋ฒ์ ์ฐพ์๋๋ฐ, ๋ฌธ์ ๋ฅผ ํด๊ฒฐํ๊ณ  ๋๋ (ํ์ธ์ ์ ํด๋ดค๋๋ฐ) ์ ์ฅ์ ๋์ง๋ง, ์ฝ์ด์ค๋ ๊ณผ์ ์์ ๋ฌธ์ ๊ฐ ์์๋ ๊ฑฐ ๊ฐ๋ค.

## ํด๊ฒฐํ ๋ฐฉ๋ฒ

scene์ ์๋ช ์ฃผ๊ธฐ๋ฅผ ์ด์ฉํด์ ์ ์ฅ๊ณผ ๋ถ๋ฌ์ค๊ธฐ๋ฅผ ์ํํ๋ค.

1.  ์ฑ์ด ์ข๋ฃ๋  ๋ ๋ฐ์ดํฐ๋ฅผ ์ ์ฅํ๋ค. `sceneWillResignActive(_ scene: UIScene)`
    
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
    
2.  ์ฑ์ด ์์๋  ๋ ๋ฐ์ดํฐ๋ฅผ ๋ถ๋ฌ์จ๋ค. `sceneDidBecomeActive(_ scene: UIScene)`
    
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
    
    ํ๋ฉด์์ `someObject`์ ์๋ ํ๋กํผํฐ๋ฅผ ์ถ๋ ฅํ๋๋ฐ, ๊ณ์ 0์ผ๋ก ๋จ๊ธธ๋ ์ ์ฅ์ด ์๋๋ค๊ณ  ์๊ฐํ์๋ค. ์ง์  ์ถ๋ ฅํด๋ณด๋ ๊ฐ์ด ์ ๋๋ก ๋จ๊ธธ๋ UI๋ฅผ ์๋ฐ์ดํธํด์ฃผ๋ฉด ๋๊ฒ ๋ค ์ถ์ด์ `NotificationCenter`๋ฅผ ์ด์ฉํด์ ๊ฐ์ด ๋ณ๊ฒฝ๋๋ค๊ณ  ๋ฐํํ๋๊น ์ ์์ ์ผ๋ก ์ถ๋ ฅ๋๋ค.
    
    ```
    โ sceneDidBecomeActive(_:) ๋ UI๋ฅผ ํ์ํ๊ธฐ ์ ์ ์คํ๋๋ค๊ณ  ์ฐ์ฌ์๋๋ฐ, ์ UI๋ฅผ ์๋ฐ์ดํธ ํด์ค์ผ ๋ฐ์ดํฐ๊ฐ ์ ์ ์ถ๋ ฅ ๋๋ ์ง ๋ชจ๋ฅด๊ฒ ๋ค.
    ```
    

๋ค๋ฅธ ๋ก์ง์ ๋ฌธ์ ๊ฐ ์์ด์ ๊ทธ ๋ถ๋ถ์ ๊ณ ์น๊ณ  ์์ง๋ง, ์ผ๋จ ๋ฐ์ดํฐ ์ ์ฅ์ ํด๊ฒฐ!

---

## ์ฐธ๊ณ  ์๋ฃ

- [Save custom objects into UserDefaults using Codable in Swift 5.1 (Protocol Oriented Approach)](https://medium.com/flawless-app-stories/save-custom-objects-into-userdefaults-using-codable-in-swift-5-1-protocol-oriented-approach-ae36175180d8)

## ์๋ก ๋ฐฐ์ด์ 

-   UserDefaults
-   NotifiactionCenter ํ์ฉ
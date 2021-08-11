---
layout: post
title: scene delegate에 대해 설명하시오.
subtitle: iOSInterviewquestions
categories: iOSInterviewquestions
tags: [iOS, iOSInterviewquestions]
emoji: 📱
---

## ~ iOS 12

in `App Delegate`
- App Life Cycle
- UI Life Cycle

## iOS 13 ~ 

iOS 13부터 `AppDelegate`의 책임이 `AppDelegate`와 `SceneDelegate`로 분리되었다.

`App Delegate` → 애플리케이션 생명주기 및 설정 담당
- App Life Cycle
- Session Life Cycle

`Scene Delegate` → 화면에 표시되는 내용(Windows 또는 Scenes)을 처리하고 앱이 표시되는 방식을 관리
- UI Life Cycle

`window` → `scene`

## Scene Delegate

```swift
optional func scene(_ scene: UIScene, 
      willConnectTo session: UISceneSession, 
            options connectionOptions: UIScene.ConnectionOptions)
```

`UISceneSession` 라이프 사이클에서 호출되는 첫번째 메서드. 새 `UIWindow`를 만들고 루트 뷰 컨트롤러를 설정하며 이 창을 표시 할 키 창으로 만든다.

```swift
optional func sceneWillEnterForeground(_ scene: UIScene)
```

앱이 처음 활성화 될 때 또는 background에서 foreground로 전환할 때처럼 scene이 시작되려고 할 때 호출된다.

```swift
optional func sceneDidBecomeActive(_ scene: UIScene)
```

`WillEnterForeground` 메서드 바로 다음에 호출되며, 여기에서 scene이 설정, 표시되고 사용할 준비를 마친다.

```swift
optional func sceneWillResignActive(_ scene: UIScene)
```

```swift
optional func sceneDidEnterBackground(_ scene: UIScene)
```

앱이 background로 스테이징될 때 호출된다.

```swift
optional func sceneDidDisconnect(_ scene: UIScene)
```

scene이 background로 갈 때마다 iOS는 리소스를 확보하기 위해 scene을 삭제하는 것을 결정할 수 있다. 이것은 앱이 종료되거나 실행되지 않음을 의미하지는 않지만 scene만 세션에서 연결 해제되고 활성화되지 않는다. iOS는 사용자가 특정 scene을 다시 foreground로 가져올 때 이 scene을 scene 세션에 다시 연결하도록 결정할 수 있다. 이 방법은 더 이상 사용되지 않는 리소스를 삭제하는 데 사용할 수 있다.

---

## 참고 자료

- [[iOS] AppDelegate와 SceneDelegate](https://velog.io/@dev-lena/iOS-AppDelegate와-SceneDelegate)
- [Understanding Scene Delegate & App Delegate](https://medium.com/@kalyan.parise/understanding-scene-delegate-app-delegate-7503d48c5445)
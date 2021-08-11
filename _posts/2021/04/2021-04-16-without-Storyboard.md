---
layout: post
title: "[iOS] 스토리보드없이 코드로 개발하기"
subtitle: 
categories: iOS
tags: [iOS, Storyboard]
---

1.  `SceneDelegate` 내용을 다음과 같이 변경
    
    ```swift
    class SceneDelegate: UIResponder, UIWindowSceneDelegate {
       var window: UIWindow?
    
       func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
           guard let scene = (scene as? UIWindowScene) else { return }
           window = UIWindow(windowScene: scene)
           window?.rootViewController = ViewController()
           window?.makeKeyAndVisible()
       }
    
       /* 생략 */
    }
    ```
    
2.  `ViewController`를 다음과 같이 구성
    
    ```swift
    class ViewController: UITabBarController {
     override func viewDidLoad() {
         super.viewDidLoad()
         let timelineViewController = UINavigationController(rootViewController: TimelineViewController())
         timelineViewController.tabBarItem = UITabBarItem(title: "",
                                                          image: UIImage(systemName: "house"),
                                                          selectedImage: UIImage(systemName: "house.fill"))
    
         let tabBars = [timelineViewController]    
         viewControllers = tabBars
     }
    }
    ```
    

\+ 다른 화면을 추가로 개발하게 되면 뷰 컨트롤러 객체 생성 후 `tabBars`에 추가
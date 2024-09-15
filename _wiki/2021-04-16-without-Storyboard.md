---
layout: wiki
title: 스토리보드없이 코드로 개발하기
summary: 
permalink: 8e6f8bf9-13fb-aef8-f6d5-701c02bc7ec2
date: 2021-04-16
updated: 2021-04-16
tag: iOS 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

# \[iOS] 스토리보드없이 코드로 개발하기

1. `SceneDelegate` 내용을 다음과 같이 변경
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

2. `ViewController`를 다음과 같이 구성
```swift
class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let timelineViewController = UINavigationController(rootViewController: TimelineViewController())
        timelineViewController.tabBarItem = UITabBarItem(
	        title: "",
	        image: UIImage(systemName: "house"),
			selectedImage: UIImage(systemName: "house.fill")
		)

        let tabBars = [timelineViewController]    
        viewControllers = tabBars
    }
}
```
    

\+ 다른 화면을 추가로 개발하게 되면 뷰 컨트롤러 객체 생성 후 `tabBars`에 추가

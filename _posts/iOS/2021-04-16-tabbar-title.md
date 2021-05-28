---
layout: post
title: 네비게이션 타이틀 변경
subtitle: Programmatically change navigation title
categories: iOS
tags: [iOS, Programmatically, UINavigationController]
emoji: 📱
---

```swift
let button = UIButton(type: .custom)
button.setImage(UIImage(systemName: "cloud.bolt.fill"), for: .normal)
button.addTarget(self, action: #selector(scrollToTop(_:)), for: .touchUpInside)
self.tabBarController?.navigationItem.titleView = button
```

문자열 대신 버튼이나 이미지를 넣고 싶으면 위 코드처럼 `titleView`에 대입하면 된다.(`UIView` 객체)

## 잘못 알고 있던 내용

일반적으로 네비게이션 컨트롤러만 사용한다면 `self.navigationItem`을 통해 접근한다. ~~하지만 탭 바를 같이 사용하고 있으면 `self.tabBarController?.navigationItem`으로 접근해야 한다.~~

처음 `SceneDelegate`에서 `window`의 루트 뷰 컨트롤러를 다음과 같이 작성했었다.
```swift
window?.rootViewController = UINavigationController(rootViewController: ViewController())
```
탭(내부 뷰 컨트롤러)이 하나일 때는 무엇이 문제인지 몰랐는데, 검색 화면을 추가 하니까 문제점이 눈에 보였다. 타임라인 화면과 검색 화면 둘 다 네비게이션 컨트롤러를 사용하는데, 탭 바 컨트롤러(타임라인, 검색의 상위 뷰 컨트롤러)에서 네비게이션 컨트롤러를 공유하고 있는 것이었다. 

다음과 같이 고치는 걸로 해결했다.
```swift
window?.rootViewController = ViewController()
```
```swift
class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        let timelineViewController = UINavigationController(rootViewController: TimelineViewController(collectionViewLayout: layout))
        timelineViewController.tabBarItem = UITabBarItem(title: "",
                                                         image: UIImage(systemName: "house"),
                                                         selectedImage: UIImage(systemName: "house.fill"))
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        searchViewController.tabBarItem = UITabBarItem(title: "",
                                                         image: UIImage(systemName: "magnifyingglass"),
                                                         selectedImage: UIImage(systemName: "magnifyingglass"))
        let tabBars = [timelineViewController, searchViewController]

        viewControllers = tabBars
    }
}
```
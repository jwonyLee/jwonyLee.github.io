---
layout: note
title: 사진 촬영 기능 구현하기
summary: 
permalink: ad896c4a-9cb1-57eb-6f2d-ed0f91110a7f
date: 2021-12-04 00:00:00 +09:00
updated: 2021-12-04 00:00:00 +09:00
tag: iOS 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

```
🎯 UIImagePickerController를 이용해서 사진 촬영 기능 구현하기
```

iOS에서 카메라 기능을 구현할 때, `AVFoundation`에 `AVCam`을 이용하는 방법과 `UIImagePickerController`를 이용하는 방법이 있다. `AVCam`은 iOS 13 이상, `UIImagePickerController`는 iOS 10 이상을 지원한다. 우리 앱은 iOS 13부터 지원하기 때문에 어느 방법을 선택해도 무관했으나, `UIImagePickerController`가 구현이 간단해서 이 방식을 선택했다.

## 화면 구성

<img src="/resource/default/cc9c200e-fa09-4761-910f-556ad8fe2408" width="50%" alt="화면 구성">

화면은 스토리보드로 간단하게 촬영한 사진을 보여줄 이미지뷰와 사진 촬영 화면으로 이동하는 버튼으로 구성했다.

구성한 뷰를 각각 뷰 컨트롤러와 연결한다.

```swift
final class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapped(_ sender: Any) {
        // 사진 촬영 버튼
    }
}
```

## Info.plist 카메라 권한 추가

iOS에서 앱이 카메라를 사용하려면 사용자에게 명시적으로 권한을 요청해야 한다. `Info.plist`에서 `Privacy - Camera Usage Description`을 추가하고, 사용자에게 권한이 왜 필요한지에 대한 설명을 작성한다.

![Info.plist](/resource/default/ef3e14d8-4c89-413f-bb09-f645f21bc0e0)

## UIImagePickerController

> A view controller that manages the system interfaces for taking pictures, recording movies, and choosing items from the user's media library.  
> 사진을 찍고, 동영상을 녹화하고, 사용자의 미디어 라이브러리에서 항목을 선택하기 위한 시스템 인터페이스를 관리하는 뷰 컨트롤러입니다.

```swift
final class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        return imagePickerController
    }()

    // 생략 ...
}
```

`UIImagePickerController`를 이용해서 사진을 촬영하려면 `sourceType` 프로퍼티를 `UIImagePickerController.SourceType.camera`로 지정한다. 이 밖에도 `.photoLibrary`, `.savedPhotosAlbum`가 있는데 iOS 15부터 `Deprecated` 되었다. 나중에는 `UIImagePickerController` 자체가 사라질 수도 있을 거 같다.

사진 촬영 이후에 1:1로 이미지를 편집하기 위해 `allowsEditing`을 `true`로 지정한다. 

`delegate`도 구현해줄 예정이므로 `delegate`도 ViewController(`self`)로 지정한다.

## 사진 촬영 버튼 선택

`UIImagePickerController`를 표시하면 알아서 권한 요청 알럿을 띄워준다. 문제는, 이렇게 하면 사용자가 권한 거부를 해도 이미 카메라 화면을 표시하고 있기 때문에 아무것도 보이지 않는다. 그래서 `UIImagePickerController`를 표시하기 전에 따로 권한 확인을 하고 허용 시 사진 촬영 이동, 거절 시 설정 화면으로 안내하는 알럿 표시하게끔 구성했다.

`UIImagePickerController`를 표시만 해도 권한 요청을 하므로 권한이 있는지 없는지 여부를 확인할 수 있는 메서드나 프로퍼티가 있는지 확인했지만 없었다. 대신 `AVCaptureDevice` 객체를 사용하면 카메라 권한 여부 확인, 권한 요청을 할 수 있다. `AVCaptureDeivce`는 `AVFoundation`에 포함되어 있으므로 `AVFoundation`을 import 해야 한다.

### 권한 요청을 받은 적이 없을 때 || 권한 허용 시

권한을 요청받은 적이 없다면 `AVCaptureDeivce.requestAccess(for:completionHandler:)`를 사용해서 따로 권한을 요청한다. 권한을 요청하고 허가받았을 때 `UIImagePickerController`를 표시하면 사용자가 카메라 사용 권한을 거부했을 때 아무것도 보이지 않는 사진 촬영 화면 대신 권한을 재요청하는 알럿을 띄우는 등 별도의 처리를 할 수 있다.

사용자가 권한을 허용했다면 `UIImagePickerController`를 표시한다. `AVCaptureDevice.requestAccess` 핸들러는 Dispatch Queue에서 실행될 수 있으므로 `권한 요청>권한 허용`일 때 `UIImagePickerController`를 표시하려면 메인 스레드에서 실행할 수 있게 해야 한다.

```swift
switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized: // 권한 허용
        present(imagePickerController, animated: true)
    case .notDetermined: // 권한 요청을 받은 적이 없음
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
        guard let self = self else { return }
            if granted {
                DispatchQueue.main.async {
                    self.present(self.imagePickerController, animated: true)
                }
            }
        }
    // 생략 ...
}
```

### 권한 거절 시 설정 화면으로 이동 안내 알럿 표시

권한이 거절되었거나, 제한되었을 때는 어떻게 해야할까? 보통 다른 앱을 보면 사용자에게 권한이 필요한 이유를 설명하면서 앱 설정 화면으로 안내하는 알럿을 표시한다.

```swift
/// 사용자에게 카메라 촬영 권한에 관한 알럿을 표시한다.
func showMoveSettingAlert() {
    let alert: UIAlertController = UIAlertController(title: "",
                                                    message: "카메라 촬영 권한이 없습니다.\n카메라 권한을 허용해주세요.",
                                                    preferredStyle: .alert)
    let cancleAction: UIAlertAction = UIAlertAction(title: "취소",
                                                    style: .cancel,
                                                    handler: nil)
    let settingAction: UIAlertAction = UIAlertAction(title: "설정",
                                                    style: .default,
                                                    handler: { [weak self] _ in
        self?.moveAppSetting()
    })

    alert.addAction(cancleAction)
    alert.addAction(settingAction)
    present(alert, animated: true, completion: nil)
}

/// 앱 설정 화면으로 이동한다.
func moveAppSetting() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}
```

```swift
// 사진 촬영 버튼 선택 시
@IBAction func tapped(_ sender: Any) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
        // 생략 ...
        case .denied, .restricted: // 권한 요청 거부, 제한
            showMoveSettingAlert()
        @unknown default: // 그 외
            showMoveSettingAlert()
    }
}
```

이제 `Take a Button`을 누르면 사용자에게 카메라 권한을 요청하고, 허용 시 사진 촬영 화면을 표시 / 거부 시 앱 설정 화면으로 안내하는 알럿을 표시한다.

## 촬영한 사진 편집 && 편집한 이미지 표시

촬영한 사진을 편집하기 위해 `UIImagePickerController`를 생성할 때 `allowsEditing`를 `true`로 지정했었다. 편집한 사진을 `imageView`에 표시해보자.

### UINavigationControllerDelegate, UIImagePickerControllerDelegate 구현

`UIImagePickerController.delegate` 는 `UINavigationControllerDelegate`과 `UIImagePickerControllerDelegate`를 모두 만족해야 한다. 편집이 끝난 이미지를 가져오기 위해서 `imagePickerController(_:didFinishPickingMediaWithInfo:)`를 구현한다.

```swift
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) // 편집이 끝났으므로 UIImagePickerController를 닫는다.

        // 편집된 이미지를 가져온다.
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // imageView에 이미지를 지정한다.
        imageView.image = image
    }
}
```

### 이미지 편집 시 중앙으로 이동할 수 없는 문제

끝날 때까지 끝난 게 아니다. ^_ㅠ 

`UIImagePickerController`를 이용해 사진 촬영 후, 이미지를 편집할 때 이미지 중앙에서 이동할 수 없는 문제가 있다. 찾아보니 iOS 6부터 발생한 고질적인 문제다. iOS 15까지도 여태껏 고쳐지지 않았다. 

다행스럽게도 [스택 오버플로](https://stackoverflow.com/questions/12630155/uiimagepicker-allowsediting-stuck-in-center)에서 해결책을 찾을 수 있었다. 

`UIImagePickerController`의 익스텐션으로 아래 코드를 추가한다. 원문에는 iOS 11에 대응하는 부분이 있는데 우리 앱에서는 필요가 없는 부분이라 제거했다.

```swift
extension UIImagePickerController {
    open override var childForStatusBarHidden: UIViewController? {
        return nil
    }

    open override var prefersStatusBarHidden: Bool {
        return true
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fixCannotMoveEditingBox()
    }

    func fixCannotMoveEditingBox() {
        if let cropView = cropView,
           let scrollView = scrollView,
           scrollView.contentOffset.y == 0 {

            let top: CGFloat = cropView.frame.minY
            let bottom = scrollView.frame.height - cropView.frame.height - top
            scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)

            var offset: CGFloat = 0
            if scrollView.contentSize.height > scrollView.contentSize.width {
                offset = 0.5 * (scrollView.contentSize.height - scrollView.contentSize.width)
            }
            scrollView.contentOffset = CGPoint(x: 0, y: -top + offset)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.fixCannotMoveEditingBox()
        }
    }

    var cropView: UIView? {
        return findCropView(from: self.view)
    }

    var scrollView: UIScrollView? {
        return findScrollView(from: self.view)
    }

    func findCropView(from view: UIView) -> UIView? {
        let width = UIScreen.main.bounds.width
        let size = view.bounds.size
        if width == size.height, width == size.height {
            return view
        }
        for view in view.subviews {
            if let cropView = findCropView(from: view) {
                return cropView
            }
        }
        return nil
    }

    func findScrollView(from view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }
        for view in view.subviews {
            if let scrollView = findScrollView(from: view) {
                return scrollView
            }
        }
        return nil
    }
}
```

## 완성

<img src="/resource/default/b6a23614-1d29-44e5-8647-ce0943ec11cb" alt="동작 화면" width="50%" />

<p align="center">
<i>마우스에 먼지는 무시해주세요...</i>
</p>

끝!

---
title: "[iOS] WWDC2021: Meet async/await in Swift"
permalink: d749ec3d-86c8-8b21-144b-74fa7b69819a
publish: true
created: 2021-06-10
---

# \[iOS] WWDC2021: Meet async/await in Swift

관심 있는 세션을 하나씩 보고 있는데, 그중 첫 번째로 시청한 것이 "Meet async/await in Swift"다. 중반부까지의 내용을 정리했다. `completionHandler`를 사용했을 때와 `async/await`을 사용했을 때를 비교하는 내용인데 이것만 봐도 어느 정도 감이 잡힌다.

기존에는 `completionHandler`를 이용해 비동기 작업을 처리했다. 비동기 작업을 하면, 스레드가 시간이 오래 걸리는 작업을 완료할 때까지 다른 작업을 수행할 수 있는 장점이 있다.

많은 사람들에게 친숙할 수 있는 예를 살펴보면, 테이블 뷰가 있고, 여기에는 서버에 저장된 썸네일 이미지가 표시된다. 썸네일 이미지를 가져오는 과정을 다음과 같다.

ViewModel에서 `fetchThumbnail` 메서드를 호출한다. 다음과 같은 작업들이 진행된다.

1.  `thumbnailURLRequest` 메서드를 호출한다. 이 메서드는 문자열에서 `URLRequest`를 생성한다.
2.  1에서 생성한 `URLRequest`를 이용해 `URLSession.dataTask(with:completion:)`을 호출한다. 이 메서드는 요청에 대한 `Data`를 가져온다.
3.  `UIImage(data:)`를 이용해 `Data`를 `UIImage`로 변경한다.
4.  마지막으로 `UIImage.prepareThumbnail`을 통해 원본 이미지에서 축소해 렌더링한다.

이러한 작업에서 1과 3의 작업은 아주 빠르게 처리가 된다. 그러나 2, 4의 작업은 시간이 걸린다. 그래서 2, 4 작업을 위해 (지금까지는) `completionHandler`를 사용했었다. 코드로 살펴보자.

```swift
func fetchThumbnail(for id: String, completion: @escaping (UIImage?, Error?) -> Void) {
    let request = thumbnailURLRequest(for: id)
    let task = URLSession.shared.dataTask(withL request) { data, response, error in 
        if let error = error {
            completion(nil, error)
        } else if (response as? HTTPURLResponse)?.statusCode != 200 {
            completion(nil, FetchError.badID)
        } else {
            guard let image = UIImage(data: data!) else {
                return
            }
            image.prepareThumbnail(of: CGSize(width: 40, height: 40)) { thumbnail in 
                guard let thumbnail = thumbnail else {
                    return
                }
                completion(thumbnail, nil)
            }
        }
    }
    task.resume()
}
```

이 코드의 문제점으로, 데이터에서 `UIImage`를 만들거나 썸네일 준비가 실패하면 `fetchThumbnail`의 호출자에게 알림이 전송되지 않는다. 게다가 개인적인 의견으로 코드의 depth가 깊어져서 복잡하다.

그래서 다음과 같이 모든 경우에 알림을 보내게 작성해야 한다.

```swift
func fetchThumbnail(for id: String, completion: @escaping (UIImage?, Error?) -> Void) {
    let request = thumbnailURLRequest(for: id)
    let task = URLSession.shared.dataTask(withL request) { data, response, error in 
        if let error = error {
            completion(nil, error)
        } else if (response as? HTTPURLResponse)?.statusCode != 200 {
            completion(nil, FetchError.badID)
        } else {
            guard let image = UIImage(data: data!) else {
                completion(nil, FetchError.badImage)
                return
            }
            image.prepareThumbnail(of: CGSize(width: 40, height: 40)) { thumbnail in 
                guard let thumbnail = thumbnail else {
                    completion(nil, FetchError.badImage)
                    return
                }
                completion(thumbnail, nil)
            }
        }
    }
    task.resume()
}
```

그런데, 문제는 `Swift`에서는 이 과정을 강제할 수 있는 방법이 없다는 것이다. 게다가 원하던 동작은 네 가지 작업을 순서대로 수행하는 것뿐이었는데, 코드는 따라가기 복잡하고 어려워졌다는 거다. 의도가 모호해졌다.

`Result` 타입을 사용하여 이것을 좀 더 안전하게 만들 수 있다. 그러나 이것은 코드를 더 추하고 약간 더 길게 만든다.

그리고 이 과정을 `async/await`를 사용하면 더 좋게 만들 수 있다.

```swift
func fetchThumbnail(for id: String) async throws -> UIImage {
    let request = thumbnailURLRequest(for: id)
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        throw FetchError.badID
    }
    let maybeImage = UIImage(data: data)
    guard let thumbnail = await maybeImage?.thumbnail else { 
        throw FetchError.badImage 
    }
    return thumbnail
}
```

`async`를 표시할 때는 `throws` 직전 또는 함수가 throw 되지 않는다면 화살표 앞에 가야 한다. 이렇게 `async`를 사용하면 시그니처가 더 간단해진다. 이미지가 성공적으로 축소되면 썸네일 이미지가 반환되고, 오류가 발생하면 그냥 오류를 던진다.

더 자세한 내용과 뒷부분이 궁금하다면 하단 링크를 통해 직접 시청하면 좋을 거 같다. 

### 참고 자료

-   [Meet async/await in Swift - WWDC 2021](https://developer.apple.com/videos/play/wwdc2021/10132/)

## 태그

#Swift #iOS/WWDC/2021 #Swift/Async-Await
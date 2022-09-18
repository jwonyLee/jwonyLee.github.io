---
title: "[iOS] DateFormatter 는 비싸다."
categories: iOS
tags: [iOS, DateFormatter]
published: true
---

지난 스프린트에서 A 라는 화면을 MVC 에서 ReactorKit 으로 리팩토링했다.

> 이 글에서는 ReactorKit 에 관한 내용은 담지 않았다.

해당 뷰 컨트롤러는 `DateFormatter` 인스턴스를 가지고 있고, 각 테이블뷰 셀을 설정할 때 `DateFormatter` 인스턴스를 넘겨주는 형식으로 구성되어 있었다.

코드로 간략하게 표현하면 다음과 같다. 

```swift
class ViewController: UIViewController {
	private let dateFormatter: DateFormatter
	private let timeFormatter: DateFormatter

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: Cell = tableView.dequeueReusableCell(indexPath: indexPath)
		let data = datas[indexPath.row]
		cell.setView(
			data,
			dateFormatter,
			timeFormatter
		)
	}
}
```

처음 든 생각은 '불필요하게 왜 이렇게 작성했지?' 였다. 왜냐하면 ViewController 에서는 `DateFormatter` 인스턴스를 사용하지 않고, 각 셀을 설정할 때 전달하는 용도로 사용하고 있었기 때문이다. 그래서 해당 `DateFormatter` 인스턴스를 사용하는 하위 뷰의 인스턴스로 옮기고, 뷰 컨트롤러에 있는 인스턴스를 제거하는 식으로 리팩토링을 마쳤다.

그리고 PR 을 남겼는데, 다음과 같은 리뷰를 받았다.

![PR 리뷰](/assets/img/dateformatter/review.png)

`DateFormatter` 가 비용이 많이 드는 작업이라니!  
처음 안 사실이었다. 블로그 내용을 요약하자면, `DateFormatter` 인스턴스를 생성하는 것, 해당 인스턴스의 프로퍼티를 변경하는 것 모두 제법 비싸다(expensive)는 것이었다. 

해당 글의 다음 시리즈에서 `DateFormatter` 의 extension 으로 정적 메서드를 구현하거나, 싱글톤을 구현하는 해결책을 제시하고 있었다. 전자의 방식은 프로퍼티가 변경할 수 있어서(해당 작업도 비싼 작업에 속한다), 나는 후자를 택하면서 글의 내용과는 조금 다르게 구현해보았다. 

싱글톤 객체를 그다지 좋아하지 않지만, 글에서 제시한 싱글톤 객체에서 모든 Formatter 를 다루는 것은 여러 가지 역할을 한다고 생각이 들었고, 그러한 형태의 `Manager` 객체가 생성되는 걸 원하지 않았다.

먼저 `CustomFormatter` 라는 프로토콜을 정의한다. 싱글톤 객체여야 하므로 `AnyObject` 를 채택해야 한다고 명시했다.

```swift
protocol CustomFormatter: AnyObject {
    static var shared: CustomFormatter { get }

    func string(from date: Date) -> String
    func date(from string: String) -> Date?
}
```

그리고 표시하고 싶은 format 에 맞게 해당 프로토콜을 채택해서 구현한다.

```swift
/// yyyy.MM.dd 형식으로 포맷팅한다.
final class StandardDateFormatter: CustomFormatter {
    static var shared: CustomFormatter = StandardDateFormatter()

    private init() {}

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()

    func string(from date: Date) -> String {
        return formatter.string(from: date)
    }

    func date(from string: String) -> Date? {
        return formatter.date(from: string)
    }
}
```

이것이 전부다!

```swift
return StandardDateFormatter.shared.string(from: date) + " " + TimeFormatter.shared.string(from: date) + " 까지"
```

---

짧은 코드지만, 이렇게 작성하고 나서 제법 마음에 들었는데 그 이유는
- 싱글톤으로 구현함으로써 `DateFormatter` 인스턴스를 생성/프로퍼티를 변경하는 데 드는 비용을 줄일 수 있다.
- 각 `***Formatter` 객체는 단 하나의 책임을 갖고, 한 가지 동작만 수행한다. (= 특정 포맷의 날짜를 변환한다.)
- 애플의 메서드 네이밍을 차용했는데, 깔끔하게 보여서 좋았다.
- 최근 관심사가 Protocol/Generic 을 잘 활용하는 것이었다. 그의 연장선으로 해당 코드가 프로덕트에 적용됨으로써 이론에서 그치는 것이 아니라 제대로 사용했다는 느낌이 들었다. 드디어 한 걸음 뗀 기분?

앞으로 남은 숙제는  `DateFormatter` 인스턴스를 사용하고 있는 코드를 싱글톤 객체로 수정하는 것뿐이다. 이제 더 이상 `setView()` 메서드를 통해 인스턴스를 넘길 필요가 없다. 혹여, 상위 객체에서 포맷을 결정해서 넘겨야하더라도 상위 객체가 해당 인스턴스를 가지고 있지 않다.

## 참고 자료

- [How expensive is DateFormatter \| Sarunw](https://sarunw.com/posts/how-expensive-is-dateformatter/)
- [How to use DateFormatter in Swift \| Sarunw](https://sarunw.com/posts/how-to-use-dateformatter/)

## 연결고리

#iOS #DateFormatter
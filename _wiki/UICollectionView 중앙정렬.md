---
layout    : wiki
title     : UICollectionView 중앙정렬.md
summary   : 
permalink : 2df2a313-5c3e-46bd-a460-63311b3c8d6e
date      : 2025-01-03 08:37:18 +0900
updated   : 2025-01-03 08:37:18 +0900
tag       : 
resource  : 9a/e4e680-0d61-438a-b10d-a2fcb5b9e250
toc       : true
public    : false
parent    : 
latex     : false
---

* TOC
{:toc}

UICollectionView Cell 중앙 정렬
전체 셀의 너비가 화면의 크기보다 작은 경우 중앙 정렬. 그렇지 않은 경우, 왼쪽 정렬

```swift
import UIKit

class ContentSizedCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet { invalidateIntrinsicContentSize() }
    }

    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

class ViewController: UIViewController {
    private let containerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var collectionView: ContentSizedCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10

        let collectionView = ContentSizedCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            // 컨테이너 뷰 제약조건
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50),

            // 컬렉션뷰 제약조건
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            collectionView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            // 컬렉션뷰의 양쪽 여백을 최소 20으로 설정
            collectionView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: 0)
        ])
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = randomColor()
        cell.layer.cornerRadius = 8
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 40)
    }

    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return color
    }
}
```

---
layout: wiki
title: "[Book] 처음 배우는 플라스크 웹 프로그래밍"
permalink: a2ed4fc7-e0f5-7e9d-802f-0ef7e6a021d5
publish: true
date: 2021-09-13
---

# \[Book] 처음 배우는 플라스크 웹 프로그래밍

<p align="center">
<img alt="처음 배우는 플라스크 웹 프로그래밍 표지" src="/assets/flask/flask-book.jpg"> <br />
<a href="https://www.hanbit.co.kr/store/books/look.php?p_code=B9575488572">처음 배우는 플라스크 웹 프로그래밍</a>
</p>

이 책은 저자가 플라스크를 실무에서 사용하면서 가장 이상적인 구조라고 생각하며 만든 프로젝트를 기반으로 진행한다.


## 아쉬운 점

- 책의 일부를 실습했는데, 리눅스와 맥에서 `virtualenv`를 활성화하는 명령어가 잘못되어 있다.
    ```
	. venv/Scripts/activate
    ```

    책에서는 위와 같이 표기 되어 있다. 나는 `Scripts` 폴더가 없었고 다음 명령어로 `activate` 했다.

    ```
    source venv/bin/activate
    ```

- 코드를 표기해놓은 부분 상단에 `파일이름.py`이 적혀있어서 해당 부분은 코드 윗 부분으로 빼거나, 주석으로 작성했으면 좋았을 거 같다.

    ![코드 내 파일이름](filename.jpg)
- 지면의 한계로 인해 입문자를 위해 세세하게 설명해주는 느낌의 책은 아니다. 설명이 부족하다는 뜻은 아니지만, 일부 코드는 스스로 분석하는 능력이 필요할지도 모르겠다. (입문자가 아닌 내 입장에서는) 아쉬운 점은 아닌데 그렇다고 장점도 아니라서 여기에 적었다.

## 좋았던 점

- 저자의 Github에 예제 프로젝트가 올라와 있고, 프로젝트 구조가 만들어져 있다. 저장소에 완성 코드가 제공되지 않아서 무조건 실습을 해야 한다는 점이 좋았다.
  - [gureuso/flask](https://github.com/gureuso/flask)
  - [gureuso/flask-movie](https://github.com/gureuso/flask-movie)
  - [gureuso/flask-blog](https://github.com/gureuso/flask-blog)
  - [gureuso/flask-shop](https://github.com/gureuso/flask-shop)
- 책이 얇다고 플라스크에 대한 내용만 담겨있다고 생각하면 오산이다. AWS RDS, Amazon SQS<sup>simple queue service</sup>, 배포를 위한 AWS 엘라스틱 빈스토크<sup>elastic Beanstalk</sup>, Github Action도 일부 같이 설명하고 있다. 예제 프로젝트를 진행하기 위해 필요한 부분만 다룬다. 테스트 코드 작성에 대해서도 다루고 있고, 심지어 Reactive Programming도 일부 다룬다. 내용이 정말 만만치 않다고 생각한다. 

---

한빛미디어 <나는 리뷰어다\> 활동을 위해서 책을 제공받아 작성된 서평입니다.

## 태그

#서평 #Flask
---
title: "[iOS] App Bundle의 구조와 역할에 대해 설명하시오."
permalink: 35d80db8-e942-f7d2-f087-31cd5bde82ba
publish: true
---

# \[iOS] App Bundle의 구조와 역할에 대해 설명하시오.

## App Bundle의 파일 유형

- Info.plist `필수`  
    응용 프로그램에 대한 구성 정보를 포함하는 구조화된 파일. 시스템은 이 파일에 존재에 의존하여 애플리케이션 및 모든 관련 파일에 대한 관련 정보를 식별함

- Executable `필수`  
    모든 응용 프로그램에는 실행 파일이 있어야 함. 이 파일에는 애플리케이션의 기본 진입점과 애플리케이션 대상에 정적으로 링크된 모든 코드가 포함되어있음

- Resource files  
    애플리케이션의 실행 파일 외부에 있는 데이터 파일. 일반적으로 이미지, 아이콘, 사운드, nib 파일, 문자열 파일, 구성 파일(configuration files), 데이터 파일 등으로 구성됨. 대부분의 리소스 파일은 특정 언어 또는 지역에 대해 현지화하거나 모든 지역에서 공유할 수 있음

- Other support files  
    iOS 애플리케이션 번들에 사용자 정의 프레임워크 또는 플러그인은 포함할 수 없음

App Bundle에 있는 대부분의 리소스는 선택 사항이지만 항상 그렇지는 않음. 예를 들어 iOS 앱에는 일반적으로 앱의 아이콘 및 기본 화면에 대한 추가 이미지 리소스가 필요함. 

## iOS App Bundle의 구조

- MyApp `필수`  
    애플리케이션의 코드를 포함하는 실행 파일

- 응용 프로그램 아이콘 `필수/권장`
- Info.plist `필수`  
    번들 ID, 버전 번호 및 앱 표시 이름과 같은 응용 프로그램의 구성 정보가 포함되어 있음

- Launch images `권장`
- MainWindow.nib `권장`  
    응용 프로그램 시작 시 로드 할 기본 인터페이스 객체가 포함되어 있음. 일반적으로 nib 파일에는 응용 프로그램의 기본 창 객체와 응용 프로그램 delegate 객체의 인스턴스가 포함됨

- Settings.bundle  
    설정 애플리케이션에 추가하려는 애플리케이션 별 환경 설정을 포함하는 특수 유형의 플러그인

- 사용자 지정 리소스 파일  
    지역화되지 않은 리소스는 최상위 디렉토리에 배치되고 지역화된 리소스는 애플리케이션 번들의 언어별 하위 디렉토리에 배치
```
💡 iOS App Bundle은 'Resources' 라는 사용자 지정 폴더를 포함 할 수 없음
```
iOS 애플리케이션은 국제화 되어야하며 지원하는 각 언어에 대한 `language.lproj` 폴더가 있어야 함. 애플리케이션의 사용자 지정 리소스의 현지화된 버전을 제공하는 것 외에도 언어별 프로젝트 디렉토리에 동일한 이름의 파일을 배치하여 시작 이미지를 현지화 할 수도 있음. 현지화된 버전을 제공하더라도 항상 애플리케이션 번들의 최상위 레벨에 이러한 파일의 기본 버전을 포함해야 함. 기본 버전은 특정 지역화를 사용할 수 없는 상황에서 사용됨

---

## 참고 자료

- [Bundle Structures](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/BundleTypes/BundleTypes.html#//apple_ref/doc/uid/10000123i-CH101-SW1)

## 태그

#iOS #iOSInterviewquestions
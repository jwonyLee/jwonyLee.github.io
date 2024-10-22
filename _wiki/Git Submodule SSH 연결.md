---
layout    : wiki
title     : Git Submodule SSH 연결
summary   : 
permalink : e90077fd-a927-4b43-b9d2-0e7b587ad82a
date      : 2024-10-22 11:56:24 +0900
updated   : 2024-10-22 11:56:24 +0900
tag       : 
resource  : 89/d2055c-8772-44b8-82e1-8db3b4bb9ace
toc       : true
public    : true
parent    : 
latex     : false
---

* TOC
{:toc}

프로젝트 저장소에 submodule 이 포함되어 있는 경우, 프로젝트 저장소를 SSH 로 클론을 받았더라도, submodule 의 remote 주소는 HTTP 로 등록되어 있음. 기본값으로 추정.
그래서 submodule 을 업데이트할 때, submodule 이 비공개 저장소라면 업데이트에 실패함. 다음과 같이 submodule 의 remote 주소를 변경해야 함(일반적으로 저장소의 remote 주소를 변경하는 것과 동일함.):

```bash
cd my-submodule
git remote set-url origin git@github.com-{ssh}:{username}/{repository}.git
```

## 참고 자료

- https://stackoverflow.com/questions/6031494/git-submodules-and-ssh-access

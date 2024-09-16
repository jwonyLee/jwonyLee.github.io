---
layout: wiki
title: 한 컴퓨터에 GitHub 계정 여러개 쓰기
summary: 
permalink: 0356f2ee-7e47-af38-047f-c9f13e392d73
date: 2022-12-28
updated: 2024-04-13 20:07:01 +09:00
tag: Git GitHub 
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

## 1. SSH Key 생성

```shell
ssh-keygen -t rsa -C "userA@example.com" -f "id_rsa_userA"
```

```shell
ssh-keygen -t rsa -C "userB@example.com" -f "id_rsa_userB"
```

## 2. ssh-agent에 새로 생성한 SSH Key 추가

백그라운드에 ssh-agent 실행
```shell
eval "$(ssh-agent -s)"
```

userA, userB의 SSH 개인키를 ssh-agent에 추가
```shell
ssh-add ~/.ssh/id_rsa_userA
```

```shell
ssh-add ~/.ssh/id_rsa_userB
```

ssh-agent에 추가되었는지 확인
```shell
ssh-add -l
```

## 3. GitHub 에 공개키 추가하기
```shell
cat < ~/.ssh/id_rsa.pub
```

## 4. SSH Config 파일 생성

```shell
vi ~/.ssh/config
```

```plain
# userA에 대한 SSH 설정
Host github.com-userA
	HostName github.com
	User userA
	IdentityFile ~/.ssh/id_rsa_userA

# userB에 대한 SSH 설정
Host github.com-userB
	HostName github.com
	User userB
	IdentityFile ~/.ssh/id_rsa_userB
```

## 5. SSH 연결 테스트

```shell
ssh -T git@github.com-userA
```

## 6. SSH 로 clone

**SSH 경로를 config 에서 설정한 것으로 해야함**

```shell
git clone git@github.com-userA:userA/userA-test.git
```

예를 들어, jwonylee 로 config 를 만들었고, jwonylee 의 wiki 저장소를 clone 한다면

```shell
git clone git@github.com-jwonylee:jwonylee/wiki.git
```

## 참고 자료

- https://usingu.co.kr/frontend/git/한-컴퓨터에서-github-계정-여러개-사용하기/

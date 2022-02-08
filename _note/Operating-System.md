---
layout: post
title: 운영체제
subtitle: 
tags: []
published: false
created: 2022-01-12 11:03:02+09:00
updated: 2022-01-20 22:08:04+09:00
---

[🏡 목차로 돌아가기](basic-knowledge)

## Contents

- [CPU 스케줄링](#cpu-스케줄링)
- [스케줄링 알고리즘](#스케줄링-알고리즘)
- [FCFS<sup>First Come First Served</sup> 스케줄링](#fcfs-스케줄링)
- [SJF<sup>Shortest Job First</sup> 스케줄링](#sjf-스케줄링)

## CPU 스케줄링

### 스케줄링 알고리즘

#### FCFS 스케줄링
> First Come First Served

- 준비 큐에 도착한 순서대로 CPU를 할당하는 비선점형 방식
- 선입선출 스케줄링이라고도 한다.


#### SJF 스케줄링
> Shortest Job First

- 준비 큐에 있는 프로세스 중에서 실행 시간이 가장 짧은 작업부터 CPU를 할당하는 비선점형 방식
- 최단 작업 우선 스케줄링이라고도 한다.
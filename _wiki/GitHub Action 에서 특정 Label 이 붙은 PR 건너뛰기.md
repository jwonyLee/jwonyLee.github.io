---
layout: wiki
title: GitHub Action 에서 특정 Label 이 붙은 PR 건너뛰기
summary: 
permalink: 0654680d-f102-7159-d06c-99f2e46aa34e
date: 2024-05-14 10:31:50 +09:00
updated: 2024-05-14 10:31:50 +09:00
tag: GitHub-Action
public: true
parent: 
latex: true
comment: true
---

* TOC
{:toc}

## 단일 Label

{% raw %}
```
name: Some Action for single label

on:
  pull_request:
    types: [opened]

jobs:
  someAction:
    if: ${{ !contains(github.event.pull_request.labels.*.name, 'label_name') }}
    runs-on: ubuntu-latest
    // 생략...
```
{% endraw %}

## 다중 Label

{% raw %}
```
name: Some Action for multiple labels

on:
  pull_request:
    types: [opened]

jobs:
  someAction:
    if: >-
      ${{ 
        !contains(github.event.pull_request.labels.*.name, 'label_name') &&
        !contains(github.event.pull_request.labels.*.name, 'label_name2') &&
        !contains(github.event.pull_request.labels.*.name, 'label_name3')
      }}
    runs-on: ubuntu-latest
    // 생략...
```
{% endraw %}

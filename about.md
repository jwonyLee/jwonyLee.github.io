---
layout: page
title:
permalink: /about/
comment: false
latex: true
---
* TOC
{:toc}

<div class="contact">
{% if site.github_username %}
        <a href="https://github.com/{{ site.github_username }}">
            <span class="emoji">💻</span>
            <span>GitHub</span>
        </a>
{% endif %}
{% if site.twitter_username %}
        <a href="https://twitter.com/{{ site.twitter_username }}">
            <span class="emoji">🪶</span>
            <span>Twitter</span>
        </a>
{% endif %}
{% if site.email %}
        <a href="mailto:{{ site.email }}">
            <span class="emoji">📧</span>
            <span>Email</span>
        </a>
{% endif %}
        <a href="{{ "/feed.xml" | prepend: site.baseurl }}">
            <span class="emoji">📢</span>
            <span>RSS</span>
        </a>
</div>

## 소개

- iOS 개발을 하고 있습니다.

## Work Experience

- (주)나인투원 - _2022-03-02 ~ 현재_
    - iOS 개발

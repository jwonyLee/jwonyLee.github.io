---
layout: default
title: Note
permalink: /note/
created: 2022-01-12 11:05:15+09:00
updated: 2022-01-12 11:16:38+09:00
---
<div class="post">
    {% assign sorted = site.note | sort: 'updated' | reverse  %}
    {% for post in sorted %}
    {% assign currentDate = post.updated | date: "%Y" %}
    {% if post.title != page.title %}
    {% if currentDate != myDate %}
    {% unless forloop.first %}
    {% endunless %}
    <h2>{{ currentDate }}</h2>
    {% assign myDate = currentDate %}
    {% endif %}
    <ul>
        <li>
            <span>{{ post.updated | date: "%m-%d" }}</span> · <a href="{{ post.url }}">{{ post.title }}</a>
        </li>
    </ul>
    {% if forloop.last %}
    {% endif %}
    {% endif %}
    {% endfor %}
</div>
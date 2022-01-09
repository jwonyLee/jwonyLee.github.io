---
layout: default
title: Note
permalink: /note/
---
<div class="post">
    {% for post in site.note reversed %}
    {% assign currentDate = post.created | date: "%Y" %}
    {% if post.title != page.title %}
    {% if currentDate != myDate %}
    {% unless forloop.first %}
    {% endunless %}
    <h2>{{ currentDate }}</h2>
    {% assign myDate = currentDate %}
    {% endif %}
    <ul>
        <li>
            <span>{{ post.created | date: "%m-%d" }}</span> · <a href="{{ post.url }}">{{ post.title }}</a>
        </li>
    </ul>
    {% if forloop.last %}
    {% endif %}
    {% endif %}
    {% endfor %}
</div>
---
layout: default
title: "Pages"
permalink: /pages/
---

<div class="post">
    <h2>Pages</h2>
    <ul>
        {% for collection in site.collections %}
        {% unless collection.label == 'posts' %}
            <li><a href="{{ site.baseurl }}/{{ collection.label }}/">{{ collection.label }}</a></li>
        {% endunless %}
        {% endfor %}
    </ul>
</div>
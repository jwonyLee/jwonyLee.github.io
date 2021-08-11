---
layout: default
title: "Pages"
permalink: /pages/
---

<h1>Pages</h1>
<ul>
    {% for collection in site.collections %}
    {% unless collection.label == 'posts' %}
        <li><a href="{{ site.baseurl }}/{{ collection.label }}/">{{ collection.label }}</a></li>
    {% endunless %}
    {% endfor %}
</ul>
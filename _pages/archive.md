---
layout: page
title: Archive
permalink: /archive
---

<ul>
  {% assign recent_notes = site.notes | sort: "date" | reverse %}
  {% for note in recent_notes %}
    <li>
      {{ note.date | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>
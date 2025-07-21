---
layout: page
title: Notes
icon: fas fa-file-alt
order: 4
---
<script>
// This function now directly manipulates the next sibling (the note-grid)
function toggleVisibility(buttonElement) {
  const targetElement = buttonElement.nextElementSibling; // Get the next sibling element (the note-grid)
  const arrow = buttonElement.querySelector('.arrow');

  if (targetElement) {
    if (targetElement.style.display === "none" || targetElement.style.display === "") {
      targetElement.style.display = "flex";
      if (arrow) arrow.textContent = '▼';
    } else {
      targetElement.style.display = "none";
      if (arrow) arrow.textContent = '▶';
    }
  }
}
</script>

<style>
/* Your existing styles remain unchanged */
.folder {
  font-weight: bold;
  margin-top: 1.5rem;
  cursor: pointer;
  font-size: 1.2rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.8rem 1rem;

  border-left: 4px solid #9370DB; /* Purple left border */
  border-radius: 0 8px 8px 0;
  transition: all 0.2s ease;
}
.folder:hover {
  background-color: rgba(147, 112, 219, 0.3);
}
.subfolder {
  margin-left: 1rem;
  cursor: pointer;
  font-size: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 0.8rem;
  background-color: rgba(147, 112, 219, 0.1);
  border-radius: 6px;
  transition: all 0.2s ease;
}
.subfolder:hover {
  background-color: rgba(147, 112, 219, 0.2);
}
.arrow {
  font-size: 0.8em;
  color: #9370DB; /* Purple arrow */
}
.note-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin: 0.8rem 0 1.5rem 1.5rem;
}
.note-block {
  background: var(--card-bg);
  padding: 0.8rem 1rem;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(147, 112, 219, 0.1);
  min-width: 200px;
  flex: 1 0 auto;
  transition: all 0.2s ease;
}
.note-block:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(147, 112, 219, 0.15);
  border-color: rgba(147, 112, 219, 0.4);
}
.note-block h4 {
  margin: 0 0 0.3rem 0;
  font-size: 1rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
    border-left: 4px solid #865dff;
}
.note-block .tags {
  font-size: 0.8rem;
  color: #9370DB; /* Purple tags */
  display: flex;
  flex-wrap: wrap;
  gap: 0.3rem;
}
.note-block a {
  text-decoration: none;
  color: inherit;
}
.empty-folder {
  margin-left: 2rem;
  font-style: italic;
  font-size: 0.9rem;
}
</style>

{% assign sorted_notes = site.notes | sort: "path" %}
{% assign grouped_notes = sorted_notes | group_by_exp: "note", "note.path | split: '/' | slice: 1, 1 | first" %}

<div class="notes-container">
  {% for dir in grouped_notes %}
    <div class="folder" onclick="toggleVisibility(this)">
      <span class="arrow">▶</span>
     <span>{{ dir.name }}</span>
    </div>
    
    <div id="folder-{{ dir.name | slugify }}" style="display:none;" class="note-grid">
      {% assign subgroups = dir.items | group_by_exp: "note", "note.path | split: '/' | slice: 2, 1 | first" %}
      
      {% for subdir in subgroups %}
        {% assign notes = subdir.items %}
        {% assign subdir_name = subdir.name %}
        
        {% if subdir_name contains '.md' %}
          {% for note in subdir.items %}
            <div class="note-block">
              <a href="{{ note.url | relative_url }}">
                <h4>{{ note.title }}</h4>
                {% if note.tags.size > 0 %}
                  <div class="tags">
                    {% for tag in note.tags %}
                      <span>#{{ tag }}</span>
                    {% endfor %}
                  </div>
                {% endif %}
              </a>
            </div>
          {% endfor %}
        {% else %}
          <div class="subfolder" onclick="event.stopPropagation(); toggleVisibility(this)">
            <span class="arrow">▶</span>
            <span>📁 {{ subdir_name }}</span>
          </div>
          
          <div id="sub-{{ dir.name | slugify }}-{{ subdir_name | slugify }}" style="display:none;" class="note-grid">
            {% for note in subdir.items %}
              <div class="note-block">
                <a href="{{ note.url | relative_url }}">
                  <h4>{{ note.title }}</h4>
                  {% if note.tags.size > 0 %}
                    <div class="tags">
                      {% for tag in note.tags %}
                        <span>#{{ tag }}</span>
                      {% endfor %}
                    </div>
                  {% endif %}
                </a>
              </div>
            {% endfor %}
          </div>
        {% endif %}
      {% endfor %}
      
      {% if dir.items.size == 0 %}
        <div class="empty-folder">This folder is empty</div>
      {% endif %}
    </div>
  {% endfor %}
</div>

<script>
// The click handlers are now directly on the folder and subfolder elements
// and call the 'toggleVisibility' function with 'this' to pass the clicked element.
// No need for a separate document.querySelectorAll loop for event listeners
// as the onclick attributes handle it directly.
</script>
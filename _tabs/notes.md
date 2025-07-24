---
layout: page
title: Notes
icon: fas fa-file-alt
order: 4
---

<style>
.folder {
  font-weight: bold;
  margin-top: 1.5rem;
  cursor: pointer;
  font-size: 1.2rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.8rem 1rem;
  border-left: 4px solid #9370DB;
  border-radius: 0 8px 8px 0;
  transition: all 0.2s ease;
  background-color: rgba(147, 112, 219, 0.1);
}

.folder:hover {
  background-color: rgba(147, 112, 219, 0.2);
}

.subfolder {
  margin-left: 1.5rem;
  cursor: pointer;
  font-size: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.6rem 1rem;
  background-color: rgba(147, 112, 219, 0.05);
  border-radius: 6px;
  transition: all 0.2s ease;
}

.subfolder:hover {
  background-color: rgba(147, 112, 219, 0.15);
}

.arrow {
  font-size: 0.8em;
  color: #9370DB;
  transition: transform 0.2s ease;
}

.note-grid {
  display: none;
  flex-wrap: wrap;
  gap: 1rem;
  margin: 0.8rem 0 1.5rem 1.5rem;
}

.note-block {
  background: var(--card-bg);
  padding: 0.8rem 1rem;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  min-width: 200px;
  flex: 1 0 auto;
  transition: all 0.2s ease;
  border: 1px solid rgba(147, 112, 219, 0.1);
}

.note-block:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(147, 112, 219, 0.15);
  border-color: rgba(147, 112, 219, 0.3);
}

.note-block h4 {
  margin: 0 0 0.3rem 0;
  font-size: 1rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  border-left: 3px solid #865dff;
  padding-left: 8px;
}

.note-block .tags {
  font-size: 0.8rem;
  color: #9370DB;
  display: flex;
  flex-wrap: wrap;
  gap: 0.3rem;
}

.note-block a {
  text-decoration: none;
  color: inherit;
  display: block;
}

.empty-folder {
  margin-left: 2rem;
  font-style: italic;
  font-size: 0.9rem;
  color: var(--text-muted);
}

/* Active states */
.folder.active {
  background-color: rgba(147, 112, 219, 0.2);
}

.folder.active .arrow {
  transform: rotate(90deg);
}

.subfolder.active {
  background-color: rgba(147, 112, 219, 0.15);
}

.subfolder.active .arrow {
  transform: rotate(90deg);
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
  // Handle folder clicks
  document.querySelectorAll('.folder').forEach(folder => {
    folder.addEventListener('click', function() {
      const arrow = this.querySelector('.arrow');
      const content = this.nextElementSibling;
      
      this.classList.toggle('active');
      arrow.textContent = this.classList.contains('active') ? '▼' : '▶';
      content.style.display = this.classList.contains('active') ? 'flex' : 'none';
    });
  });

  // Handle subfolder clicks
  document.querySelectorAll('.subfolder').forEach(subfolder => {
    subfolder.addEventListener('click', function(e) {
      e.stopPropagation(); // Prevent parent folder from triggering
      const arrow = this.querySelector('.arrow');
      const content = this.nextElementSibling;
      
      this.classList.toggle('active');
      arrow.textContent = this.classList.contains('active') ? '▼' : '▶';
      content.style.display = this.classList.contains('active') ? 'flex' : 'none';
    });
  });
});
</script>

{% assign sorted_notes = site.notes | sort: "path" %}
{% assign grouped_notes = sorted_notes | group_by_exp: "note", "note.path | split: '/' | slice: 1, 1 | first" %}

<div class="notes-container">
  {% for dir in grouped_notes %}
    {% assign dir_name = dir.name | default: "Uncategorized" %}
    
    <div class="folder">
      <span class="arrow">▶</span>
      <span>{{ dir_name }}</span>
    </div>
    
    <div class="note-grid">
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
          <div class="subfolder">
            <span class="arrow">▶</span>
            <span>📁 {{ subdir_name }}</span>
          </div>
          
          <div class="note-grid">
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
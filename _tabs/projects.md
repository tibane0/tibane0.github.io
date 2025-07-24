---
title: Projects
icon: fas fa-code
order: 3
---

<style>
:root {
  --accent-color: #6c63ff;
  --accent-hover: #5548c8;
  --card-bg: #1e1e2e;
  --border-color: #2a2a3a;
  --tag-bg: #2a2a3a;
  --tag-hover-bg: #3a3a4a;
  --tag-text: #e0e0e0;
  --text-muted: #b0b0b0;
}

.tags {
  margin-top: 1rem;
  margin-bottom: 0.5rem;
}

.tag {
  display: inline-block;
  background: var(--tag-bg);
  color: var(--tag-text);
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 0.75rem;
  margin-right: 6px;
  margin-bottom: 6px;
  text-decoration: none;
  transition: all 0.2s ease;
  font-family: 'Fira Code', monospace;
}

.tag:hover {
  background: var(--tag-hover-bg);
  transform: translateY(-1px);
}

.project-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
  gap: 2rem;
  margin-top: 2.5rem;
}

.project-card {
  background-color: var(--card-bg);
  padding: 1.5rem;
  border: 1px solid var(--border-color);
  border-radius: 14px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  display: flex;
  flex-direction: column;
  height: 100%;
}

.project-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(108, 99, 255, 0.15);
  border-color: var(--accent-color);
}

.project-card h3 {
  margin-top: 0;
  margin-bottom: 0.75rem;
  font-size: 1.3rem;
  font-weight: 600;
}

.project-card h3 a {
  color: inherit;
  text-decoration: none;
  background-image: linear-gradient(var(--accent-color), var(--accent-color));
  background-position: 0% 100%;
  background-repeat: no-repeat;
  background-size: 0% 2px;
  transition: background-size 0.3s ease;
  padding-bottom: 2px;
}

.project-card h3 a:hover {
  background-size: 100% 2px;
}

.project-card p {
  font-size: 0.95rem;
  color: var(--text-muted);
  line-height: 1.5;
  margin-bottom: 1rem;
}

.project-card ul {
  padding-left: 1.25rem;
  font-size: 0.9rem;
  margin-bottom: 1.5rem;
  flex-grow: 1;
}

.project-card ul li {
  margin-bottom: 0.5rem;
  position: relative;
  line-height: 1.5;
}

.project-card ul li::before {
  content: "▹";
  position: absolute;
  left: -1rem;
  color: var(--accent-color);
}

.btn {
  display: inline-flex;
  align-items: center;
  margin-top: auto;
  color: #fff;
  background: var(--accent-color);
  padding: 8px 16px;
  border-radius: 8px;
  text-decoration: none;
  font-size: 0.85rem;
  font-weight: 500;
  transition: all 0.2s ease;
  align-self: flex-start;
  gap: 6px;
}

.btn:hover {
  background: var(--accent-hover);
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.btn::after {
  content: "→";
  transition: transform 0.2s ease;
}

.btn:hover::after {
  transform: translateX(2px);
}

.project-image {
  width: 100%;
  height: 180px;
  object-fit: cover;
  border-radius: 10px;
  margin-bottom: 1.25rem;
  border: 1px solid var(--border-color);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.feature-title {
  font-size: 0.9rem;
  font-weight: 600;
  color: var(--accent-color);
  margin-bottom: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

@media (max-width: 768px) {
  .project-grid {
    grid-template-columns: 1fr;
  }
}
</style>

<div class="project-grid">

<!-- TibaneC2 Project -->
<div class="project-card">
  <img src="/assets/images/tibaneC2.png" alt="TibaneC2 Framework" class="project-image">
  
  <h3><a href="https://github.com/tibane0/TibaneC2" target="_blank">TibaneC2 Framework</a></h3>
  <p>A modular Command and Control framework designed for red team operations and security research, built with operational security and extensibility in mind.</p>

  <div class="feature-title">Key Components</div>
  <ul>
    <li><strong>Core Server:</strong> Multi-threaded C2 server with encrypted communications and session management</li>
    <li><strong>Lightweight Implant:</strong> Configurable agent with sandbox evasion and multiple persistence mechanisms</li>
    <li><strong>Dual Interface:</strong> Web-based GUI for visualization and CLI for rapid operations</li>
    <li><strong>Payload Generator:</strong> Custom implant builder with various obfuscation techniques</li>
    <li><strong>Modular Architecture:</strong> Easy to extend with new post-exploitation modules</li>
  </ul>
  
  <div class="tags">
    <span class="tag">C/C++</span>
    <span class="tag">Python</span>
    <span class="tag">Red Teaming</span>
    <span class="tag">C2 Framework</span>
    <span class="tag">Malware Dev</span>
    <span class="tag">Security Research</span>
  </div>
  <a class="btn" href="https://github.com/tibane0/TibaneC2" target="_blank">View Project</a>
</div>

<!-- Exploit Development Project -->
<div class="project-card">
  <img src="/assets/images/expdev.png" alt="Exploit Development" class="project-image">
  
  <h3><a href="https://github.com/tibane0/exploit-dev" target="_blank">Exploit Development Research</a></h3>
  <p>Collection of binary exploitation techniques, vulnerability research, and proof-of-concept exploits for both CTF challenges and real-world software vulnerabilities.</p>

  <div class="feature-title">Research Focus</div>
  <ul>
    <li><strong>Memory Corruption:</strong> Stack/heap overflows, use-after-free, type confusion</li>
    <li><strong>Mitigation Bypasses:</strong> Techniques for defeating ASLR, DEP, Stack Canaries</li>
    <strong>Kernel Exploitation:</strong> Driver vulnerabilities and privilege escalation vectors</li>
    <li><strong>Modern Protections:</strong> Analysis of Control Flow Guard, CET, and other mitigations</li>
    <li><strong>Tool Development:</strong> Custom fuzzers and exploit automation scripts</li>
  </ul>
  
  <div class="tags">
    <span class="tag">Binary Exploitation</span>
    <span class="tag">Reverse Engineering</span>
    <span class="tag">C/C++</span>
    <span class="tag">Python</span>
    <span class="tag">Pwntools</span>
    <span class="tag">CTF</span>
  </div>
  <a class="btn" href="https://github.com/tibane0/exploit-dev" target="_blank">View Research</a>
</div>

</div>
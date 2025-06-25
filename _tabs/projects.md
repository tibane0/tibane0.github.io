---
title: Projects
icon: fas fa-code
order: 3
---
<style>
.tags {
  margin-top: 0.5rem;
}
.tag {
  display: inline-block;
  background: var(--tag-bg);
  color: var(--tag-text);
  padding: 3px 10px;
  border-radius: 12px;
  font-size: 0.75rem;
  margin-right: 5px;
  margin-top: 5px;
  text-decoration: none;
  transition: background 0.2s;
}
.tag:hover {
  background: var(--tag-hover-bg);
}

.project-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 1.5rem;
  margin-top: 2rem;
}

.project-card {
  background-color: var(--card-bg);
  padding: 1.2rem;
  border: 1px solid #444;
  border-radius: 12px;
  box-shadow: 0 0 8px rgba(255, 255, 255, 0.03);
  transition: 0.3s ease;
}

.project-card:hover {
  transform: scale(1.01);
  border-color: #865dff;
}

.project-card h3 {
  margin-top: 0;
  font-size: 1.2rem;
}

.project-card p {
  font-size: 0.95rem;
}

.project-card ul {
  padding-left: 1rem;
  font-size: 0.9rem;
}

.tags {
  margin-top: 0.5rem;
}

.tags span {
  display: inline-block;
  background: #3a3a3a;
  color: #fff;
  padding: 3px 8px;
  border-radius: 8px;
  font-size: 0.75rem;
  margin-right: 5px;
  margin-top: 5px;
}

.btn {
  display: inline-block;
  margin-top: 1rem;
  color: #fff;
  background: #6c63ff;
  padding: 6px 12px;
  border-radius: 6px;
  text-decoration: none;
  font-size: 0.85rem;
}
.btn:hover {
  background: #5548c8;
}
</style>

<div class="project-grid">

<div class="project-card">
  <h3><a href="https://github.com/tibane0/Basic-C2" target="_blank">C2 Infrastructure</a></h3>
  <p>Building a full-featured Command and Control (C2) infrastructure from scratch, with the core server at its foundation.</p>

  <h5>Key Server Features & Components:</h5>
   <ul>
    <li><strong>C2 Core Server:</strong> Robust beacon handling, task queue management, and secure session tracking.</li>
    <li><strong>Implant:</strong> Stealthy agent with configurable beaconing, dynamic task execution, and sandbox/VM evasion.</li>
    <li><strong>Web Panel:</strong> Operator interface for monitoring, tasking, and viewing agent responses.</li>
    <li><strong>Automation Tools:</strong> Payload generation, server deployment scripts, and stager builders.</li>
    <li><strong>Security:</strong> Encrypted communication, jitter/randomized beaconing, and multi-hop proxy support.</li>
  </ul>
  
  <div class="tags">
    <span>Offensive Tooling</span><span>Command and Control</span><span>Red Team</span><span>C/C++</span><span>PHP</span><span>Python</span><span>Malware Development</span> <span>Security Research</span>
  </div>
  <a class="btn" href="https://github.com/tibane0/Basic-C2" target="_blank">🔗 View Repository</a>
</div>

<!-- Project -->
<div class="project-card">
  <h3><a href="https://github.com/tibane0/exploit-dev" target="_blank">Exploit Development</a></h3>
  <p>Dive into the world of low-level binary exploitation with this repository. It features detailed writeups and custom exploits for challenging CTF puzzles, alongside in-depth analyses and PoCs for real-world CVEs</p>


  <h5>An Evolving Collection:</h5>
  <ul>
    <li><strong>Binary Exploitation:</strong> Ongoing exploration of various vulnerability classes and exploitation techniques.</li>
  </ul>
  <div class="tags">
    <span>Binary-Exploitation</span>
    <span>pwn</span>
    <span>c/c++</span>
  </div>
  <a class="btn" href="https://github.com/tibane0/exploit-dev" target="_blank">🔗 View Repository</a>
</div>


</div>


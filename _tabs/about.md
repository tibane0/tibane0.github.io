---
# the default layout is 'page'
icon: fas fa-info-circle
order: 2
---

<style>
.profile-container {
  display: flex;
  flex-wrap: wrap;
  gap: 2rem;
  margin-top: 2rem;
}

.profile-left {
  flex: 1;
  max-width: 320px;
  background: var(--card-bg);
  padding: 1rem;
  border-radius: 12px;
  text-align: center;
  border: 1px solid #333;
}

.profile-left img {
  width: 100%;
  border-radius: 12px;
  margin-bottom: 1rem;
}

.profile-left h2 {
  margin: 0;
}

.profile-left .roles {
  text-align: left;
  margin-top: 1rem;
  font-family: monospace;
  font-size: 0.9rem;
}

.profile-right {
  flex: 2;
  min-width: 300px;
}

.skills {
  margin-top: 1rem;
}

.skills span {
  display: inline-block;
  background: var(--tag-bg, #3a3a3a);
  color: var(--tag-text, #fff);
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 0.8rem;
  margin: 5px 5px 0 0;
}

.disclaimer {
  background: rgba(255, 255, 255, 0.05);
  border-left: 4px solid #865dff;
  padding: 1rem;
  border-radius: 8px;
  margin-top: 2rem;
  font-size: 0.9rem;
}

.quote {
  text-align: center;
  margin-top: 2rem;
  font-weight: bold;
  font-size: 0.95rem;
}
</style>

<div class="profile-container">

  <div class="profile-left">
    <img src="/assets/images/me.jpeg" alt="Profile Image">
    <h2>Nkateko Tibane</h2>
    <p>20 year old, IT student</p>

    <div>
      <a href="https://github.com/tibane0" target="_blank">GitHub</a> |
      <a href="https://twitter.com/tibane101" target="_blank">Twitter</a> |
      <a href="mailto:nkatekotibane101@gmail.com">Email</a> |
      <a href="www.linkedin.com/in/nkatekotibane" target="_blank">LinkedIn</a>
    </div>

    <div class="roles">
      <p><code>$ whoami</code></p>
      <p>&gt; Exploit Developer</p>
      <p>&gt; Red Teamer</p>
      <p>&gt; Software Developer</p>
    </div>
  </div>

  <div class="profile-right">
    Hello friend

    I'm Nkateko, a 20-year-old cybersecurity enthusiast focused on real-world offensive security.
    <p>
    This blog is my personal learning space where I will explore offensive security and share my progress, insights and discoveries. 
    </p>
    Im currently building a solid foundation in offensive security. 
    <ul>
    <li>Red Teaming</li>
    <li>Exploit Development [binary-exploitation]</li>
    <li>Offensive Tool Development</li>
    <li>Software Development</li>
    </ul>
    Here on this blog, you can expect to find walkthroughs on binary exploitation challanges and real world exploits, walkthroughs of vulnerable machines, deep dives on offensive tools and applying my software development skills to security.
        <div class="skills">
      <h4>Skills</h4>
      <span>C/C++</span>
      <span>Python</span>
      <span>Malware Development</span>
      <span>Reverse Engineering</span>
      <span>Exploit Development</span>
      <span>Red Teaming</span>
      <span>PHP</span>
    </div>

    <div class="disclaimer">
      <strong>Legal Disclaimer:</strong><br>
      Everything you find here — code, blog posts, or techniques — is for educational purposes only.  
      I do not promote or condone the misuse of any tools or scripts for unethical hacking or real-world attacks.
    </div>

    <div class="quote">
      
    </div>
  </div>

</div>



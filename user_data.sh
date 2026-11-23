#!/bin/bash
set -eux

apt-get update -y
apt-get install -y nginx

systemctl enable nginx
systemctl start nginx

cat > /var/www/html/index.html <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CloudDevOps | Infrastructure Solutions</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="logo">Cloud<span>DevOps</span></div>
            <ul>
                <li><a href="#home">Home</a></li>
                <li><a href="#services">Services</a></li>
                <li><a href="#about">About</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <section class="hero" id="home">
            <div class="hero-content">
                <p class="tagline">BUILD. DEPLOY. SCALE.</p>
                <h1>Powering the Future with <span>Cloud Technology</span></h1>
                <p class="description">
                    Reliable infrastructure, automated deployments, and secure
                    cloud solutions to help businesses grow with confidence.
                </p>
                <a href="#services" class="btn">Explore Services</a>
            </div>
        </section>
        <section class="services" id="services">
            <h2>Our Services</h2>
            <p class="section-description">Modern solutions for modern infrastructure.</p>
            <div class="service-grid">
                <div class="service-card">
                    <h3>Cloud Computing</h3>
                    <p>Scalable and reliable infrastructure powered by AWS.</p>
                </div>
                <div class="service-card">
                    <h3>DevOps Automation</h3>
                    <p>Streamlined CI/CD pipelines and automated deployments.</p>
                </div>
                <div class="service-card">
                    <h3>Infrastructure Security</h3>
                    <p>Secure systems with modern networking and encryption.</p>
                </div>
            </div>
        </section>
        <section class="about" id="about">
            <h2>Built for Reliability</h2>
            <p>
                This website is hosted on Amazon EC2, served using Nginx,
                and designed to demonstrate secure HTTPS delivery through
                an Application Load Balancer and AWS Certificate Manager.
            </p>
        </section>
    </main>
    <footer>
        <p>&copy; 2026 CloudDevOps. Built with AWS.</p>
    </footer>
</body>
</html>
HTML

cat > /var/www/html/style.css <<'CSS'
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}
html { scroll-behavior: smooth; }
body {
    font-family: Arial, sans-serif;
    color: #e5e7eb;
    background: #0b1120;
    line-height: 1.6;
}
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 22px 9%;
    background: #111827;
}
.logo { font-size: 25px; font-weight: bold; color: white; }
.logo span, .hero h1 span { color: #38bdf8; }
.navbar ul { display: flex; gap: 30px; list-style: none; }
.navbar a { color: #d1d5db; text-decoration: none; }
.navbar a:hover { color: #38bdf8; }
.hero {
    min-height: 520px;
    display: flex;
    align-items: center;
    padding: 80px 9%;
    background: linear-gradient(120deg, #0b1120, #172554);
}
.hero-content { max-width: 760px; }
.tagline {
    color: #38bdf8;
    font-weight: bold;
    letter-spacing: 3px;
    margin-bottom: 18px;
}
.hero h1 { font-size: clamp(38px, 6vw, 65px); line-height: 1.15; margin-bottom: 22px; }
.description { color: #cbd5e1; font-size: 18px; max-width: 620px; margin-bottom: 32px; }
.btn {
    display: inline-block;
    padding: 13px 25px;
    background: #0284c7;
    color: white;
    border-radius: 6px;
    text-decoration: none;
    font-weight: bold;
}
.btn:hover { background: #0369a1; }
.services, .about { padding: 75px 9%; text-align: center; }
.services h2, .about h2 { color: white; font-size: 34px; margin-bottom: 12px; }
.section-description { color: #94a3b8; margin-bottom: 35px; }
.service-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 22px; }
.service-card { padding: 30px 22px; background: #172033; border: 1px solid #263449; border-radius: 10px; }
.service-card h3 { color: #38bdf8; margin-bottom: 12px; }
.service-card p, .about p { color: #cbd5e1; }
.about { background: #111827; }
.about p { max-width: 750px; margin: 15px auto 0; }
footer { text-align: center; padding: 22px; color: #94a3b8; background: #080d18; }
@media (max-width: 700px) {
    .navbar { padding: 18px 5%; }
    .navbar ul { gap: 12px; font-size: 13px; }
    .hero { padding: 65px 6%; }
    .service-grid { grid-template-columns: 1fr; }
}
CSS

systemctl restart nginx

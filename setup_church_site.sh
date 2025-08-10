#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${PWD}"
REPO_NAME="$(basename "$PROJECT_DIR")"       # e.g., Church_website
ASSETS_CSS="_assets/css"
ASSETS_JS="_assets/js"

echo "==> Scaffolding project in: $PROJECT_DIR"

mkdir -p "$ASSETS_CSS" "$ASSETS_JS" \
         about teachings speaking media prayer support policies

# -------- Write CSS --------
cat > "$ASSETS_CSS/global.css" <<'CSS'
:root{
  --bg:#0b0f14; --text:#e8f3ff; --muted:#b9c7d9;
  --brand:#2aa198; --brand-2:#d0b14a; --border:#1b2430;
  --shadow:0 10px 30px rgba(0,0,0,.35)
}
*{box-sizing:border-box}
html{scroll-behavior:smooth}
body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Inter,Arial,sans-serif;color:var(--text);background:var(--bg)}
a{color:var(--brand);text-decoration:none}
.container{width:min(1100px,92%);margin-inline:auto}
/* Header */
.site-header{position:sticky;top:0;z-index:1000;background:rgba(11,15,20,.8);backdrop-filter:saturate(120%) blur(8px);border-bottom:1px solid var(--border);transition:all .25s ease}
.site-header.shrink{padding-block:.2rem}
.navbar{display:flex;align-items:center;justify-content:space-between;gap:1rem;padding:.9rem 0}
.brand{display:flex;align-items:center;gap:.6rem}
.brand .logo{width:34px;height:34px;border-radius:10px;background:radial-gradient(120% 120% at 30% 20%,var(--brand-2),var(--brand));box-shadow:var(--shadow)}
.brand .name{font-weight:700;letter-spacing:.2px}
.nav-links{display:flex;gap:1rem;align-items:center}
.nav-links a{padding:.5rem .7rem;border-radius:10px}
.nav-links a[aria-current="page"],.nav-links a:hover{background:linear-gradient(180deg,rgba(42,161,152,.18),rgba(42,161,152,.05))}
.menu-btn{display:none}
@media (max-width:860px){
  .menu-btn{display:inline-flex;align-items:center;justify-content:center;width:42px;height:42px;border:1px solid var(--border);border-radius:12px;background:#0b0f14}
  .nav-links{position:fixed;inset:64px 0 auto 0;background:rgba(11,15,20,.98);padding:1rem;border-top:1px solid var(--border);box-shadow:var(--shadow);display:none;flex-direction:column}
  .nav-links.open{display:flex}
}
/* Hero (works with or without image) */
.hero{position:relative;isolation:isolate;padding:clamp(4rem,8vw,8rem) 0;background:
  radial-gradient(120% 100% at 30% 10%, rgba(42,161,152,.25), transparent 60%),
  linear-gradient(180deg, rgba(0,0,0,.4), rgba(0,0,0,.65));
  border-bottom:1px solid var(--border);
}
.hero .bg{position:absolute;inset:0;z-index:-1;background-size:cover;background-position:center;filter:brightness(.55)}
.hero h1{font-size:clamp(2rem,5vw,3.25rem);margin:0 0 .6rem}
.hero p.lead{color:var(--muted);font-size:clamp(1rem,2.5vw,1.2rem);max-width:65ch}
.cta-row{display:flex;gap:.7rem;flex-wrap:wrap;margin-top:1.2rem}
.btn{display:inline-flex;align-items:center;gap:.5rem;padding:.7rem 1rem;border-radius:12px;border:1px solid var(--border);background:#0f141b}
.btn.primary{background:linear-gradient(180deg,rgba(42,161,152,.25),rgba(42,161,152,.05));border-color:#204a46}
.btn.alt{background:linear-gradient(180deg,rgba(208,177,74,.25),rgba(208,177,74,.05));border-color:#4a4320}
/* Sections */
.section{padding:clamp(2.5rem,6vw,4rem) 0;border-top:1px solid var(--border)}
.grid-3{display:grid;grid-template-columns:repeat(3,1fr);gap:1rem}
@media (max-width:980px){.grid-3{grid-template-columns:1fr}}
.card{padding:1rem;border:1px solid var(--border);border-radius:16px;background:linear-gradient(180deg,rgba(255,255,255,.02),rgba(255,255,255,0));box-shadow:var(--shadow)}
.card h3{margin:.2rem 0 .4rem}
.small{font-size:.9rem;color:var(--muted)}
/* Footer */
.site-footer{padding:2rem 0;border-top:1px solid var(--border);background:#0b0f14}
.site-footer .cols{display:grid;grid-template-columns:2fr 1fr 1fr;gap:1rem}
.site-footer p{color:var(--muted)}
@media (max-width:860px){.site-footer .cols{grid-template-columns:1fr}}
CSS

# -------- Write JS --------
cat > "$ASSETS_JS/site.js" <<'JS'
(function(){
  var base = document.querySelector('base');
  if(!base){ base = document.createElement('base'); base.id='site-base'; document.head.prepend(base); }
  var pathFirst = location.pathname.split('/').filter(Boolean)[0] || '';
  var isGithub = location.hostname.endsWith('.github.io');
  var href = (isGithub && pathFirst) ? ('/' + pathFirst + '/') : '/';
  base.setAttribute('href', href);
}());
(function(){
  var btn = document.querySelector('[data-menu]');
  var nav = document.getElementById('nav-links');
  if(btn && nav){ btn.addEventListener('click', function(){ nav.classList.toggle('open'); }); }
}());
(function(){
  var header = document.querySelector('.site-header');
  var last = 0;
  window.addEventListener('scroll', function(){
    var y = window.scrollY || window.pageYOffset;
    if(!header) return;
    if(y > 24 && y > last){ header.classList.add('shrink'); }
    else if(y < 16){ header.classList.remove('shrink'); }
    last = y;
  });
}());
function mailtoSubmit(form){
  var data = new FormData(form);
  var subject = encodeURIComponent('[Contact] ' + (data.get('name')||''));
  var body = encodeURIComponent(Array.from(data.entries()).map(function(p){return p[0]+': '+p[1]}).join('\n'));
  window.location.href = 'mailto:you@example.org?subject='+subject+'&body='+body;
  return false;
}
JS

# -------- Partials --------
read -r -d '' HEADER <<'H'
<header class="site-header">
  <div class="container navbar">
    <a href="/" class="brand">
      <span class="logo" aria-hidden="true"></span>
      <span class="name">Otis Duncan — Christian Portfolio</span>
    </a>
    <button class="menu-btn" data-menu aria-label="Toggle menu">☰</button>
    <nav id="nav-links" class="nav-links">
      <a href="/about/">About</a>
      <a href="/teachings/">Teachings</a>
      <a href="/speaking/">Speaking</a>
      <a href="/media/">Media</a>
      <a href="/prayer/">Prayer & Contact</a>
      <a href="/support/">Support</a>
    </nav>
  </div>
</header>
H

read -r -d '' FOOTER <<'F'
<footer class="site-footer">
  <div class="container cols">
    <div>
      <h3>About this site</h3>
      <p>A simple, fast, accessible portfolio sharing my testimony, teachings, and ministry work. Built with static HTML/CSS and hosted on GitHub Pages.</p>
      <p class="small">“Let your light shine before others…” — Matthew 5:16</p>
    </div>
    <div>
      <h4>Quick Links</h4>
      <p class="small"><a href="/about/">About</a> • <a href="/teachings/">Teachings</a> • <a href="/speaking/">Speaking</a><br>
      <a href="/media/">Media</a> • <a href="/prayer/">Prayer</a> • <a href="/support/">Support</a></p>
    </div>
    <div>
      <h4>Policies</h4>
      <p class="small"><a href="/policies/privacy.html">Privacy</a></p>
      <p class="small">© <span id="y"></span> Otis Duncan</p>
    </div>
  </div>
  <script>document.getElementById('y').textContent = new Date().getFullYear();</script>
</footer>
F

page() {
cat <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$1</title>
  <meta name="description" content="$2" />
  <link rel="stylesheet" href="/_assets/css/global.css" />
  <script defer src="/_assets/js/site.js"></script>
  <base id="site-base" href="/" />
</head>
<body>
  $HEADER
  <section class="hero">
    <div class="bg" id="hero-bg" style=""></div>
    <div class="container">
      <h1>$3</h1>
      <p class="lead">$4</p>
    </div>
  </section>
  $5
  $FOOTER
</body>
</html>
HTML
}

# -------- Write Pages --------
page "Following Jesus. Serving People. | Otis Duncan" \
     "Christian portfolio of Otis Duncan — testimony, teachings, speaking, media, and ministry projects." \
     "Following Jesus. Serving people." \
     "Encouraging faith through teaching, service, and everyday discipleship. Scripture‑grounded, practical, and hopeful." \
     '<section class="section"><div class="container grid-3">
      <div class="card"><h3>Latest Teaching</h3><p class="small">A short devotional or study summary can go here. Link to full post.</p><p><a href="/teachings/">Explore teachings →</a></p></div>
      <div class="card"><h3>Speaking Topics</h3><p class="small">Discipleship in daily life • Hope in hardship • Practical apologetics.</p><p><a href="/speaking/">View topics →</a></p></div>
      <div class="card"><h3>Ministry Projects</h3><p class="small">Service initiatives and community work with simple impact snapshots.</p><p><a href="/media/">See media →</a></p></div>
     </div></section>' > index.html

page "About & Testimony | Otis Duncan" \
     "My story of faith: background, calling, and what I believe." \
     "My story & calling" \
     "A brief testimony of what Christ has done in my life and why I serve." \
     '<section class="section"><div class="container">
        <h2>Testimony</h2>
        <p class="small">(Add your 700–1200 word testimony here, with a two‑paragraph short version up top.)</p>
        <h3>What I believe (summary)</h3>
        <ul><li>Jesus Christ, fully God and fully man, our Savior and Lord.</li>
            <li>Scripture is the authoritative Word of God.</li>
            <li>Salvation by grace through faith.</li>
            <li>The Church as Christ’s body, called to love and mission.</li></ul>
     </div></section>' > about/index.html

page "Teachings & Devotionals | Otis Duncan" \
     "Devotionals and Bible studies with practical application." \
     "Teachings & devotionals" \
     "Short reads rooted in Scripture for everyday life." \
     '<section class="section"><div class="container grid-3">
        <article class="card"><h3>Sample Post Title</h3><p class="small">One‑sentence summary and Scripture reference. <a href="#">Read →</a></p></article>
        <article class="card"><h3>Another Post</h3><p class="small">A brief teaser for the content. <a href="#">Read →</a></p></article>
        <article class="card"><h3>Third Post</h3><p class="small">Encouragement and practical application. <a href="#">Read →</a></p></article>
     </div></section>' > teachings/index.html

page "Speaking & Booking | Otis Duncan" \
     "Signature topics, audiences, and a simple request form for speaking invitations." \
     "Speaking & booking" \
     "Topics tailored for churches, ministries, and community events." \
     '<section class="section"><div class="container">
        <h2>Signature topics</h2>
        <ul><li><strong>Discipleship in Daily Life</strong> — practical rhythms and habits.</li>
            <li><strong>Hope in Hardship</strong> — encouragement from Scripture.</li>
            <li><strong>Everyday Apologetics</strong> — gracious conversations that point to Christ.</li></ul>
        <h2>Booking request</h2>
        <form onsubmit="return mailtoSubmit(this)" class="card">
          <label>Name<br><input required name="name" placeholder="Your name"></label><br>
          <label>Email<br><input required type="email" name="email" placeholder="you@example.org"></label><br>
          <label>Preferred date(s)<br><input name="dates" placeholder="e.g., Oct 10–12 or Sundays"></label><br>
          <label>Location / format<br><input name="location" placeholder="City or online"></label><br>
          <label>Message<br><textarea name="message" rows="5" placeholder="Tell me a bit about the event"></textarea></label><br>
          <button class="btn primary" type="submit">Send request</button>
          <p class="small">(This uses your email client. We can switch to Formspree/EmailJS later.)</p>
        </form>
     </div></section>' > speaking/index.html

page "Media | Otis Duncan" \
     "Sermon videos, podcast appearances, and downloadable notes." \
     "Media" \
     "Sermons, conversations, and resources to share." \
     '<section class="section"><div class="container grid-3">
        <div class="card"><h3>Sermon Title</h3><p class="small">YouTube/Vimeo embed can go here.</p></div>
        <div class="card"><h3>Podcast Name</h3><p class="small">Embed player or external link.</p></div>
        <div class="card"><h3>Study Notes</h3><p class="small"><a href="#">Download PDF</a></p></div>
     </div></section>' > media/index.html

page "Prayer & Contact | Otis Duncan" \
     "Send a private prayer request or contact Otis directly." \
     "Prayer & contact" \
     "I would be honored to pray for you." \
     '<section class="section"><div class="container">
        <form onsubmit="return mailtoSubmit(this)" class="card">
          <label>Name<br><input required name="name" placeholder="Your name"></label><br>
          <label>Email<br><input required type="email" name="email" placeholder="you@example.org"></label><br>
          <label>Prayer request (private)<br><textarea name="request" rows="6" placeholder="Share as much or as little as you like"></textarea></label><br>
          <button class="btn primary" type="submit">Send</button>
          <p class="small">(Private. This opens your email client; we can add a secure form service later.)</p>
        </form>
     </div></section>' > prayer/index.html

page "Support the Work | Otis Duncan" \
     "Ways to help: prayer, volunteering, and financial support through appropriate channels." \
     "Support the work" \
     "Pray, share, serve, and — where appropriate — give through trusted channels." \
     '<section class="section"><div class="container grid-3">
        <div class="card"><h3>Pray</h3><p class="small">Become a prayer partner. <a href="/prayer/">Join →</a></p></div>
        <div class="card"><h3>Volunteer</h3><p class="small">Help with local service initiatives. (Add a sign‑up link later.)</p></div>
        <div class="card"><h3>Give</h3><p class="small">If your church can accept designated gifts, link that here; otherwise, use a trusted giving platform.</p></div>
     </div></section>' > support/index.html

page "Privacy Policy | Otis Duncan" \
     "Privacy policy for the Christian portfolio website." \
     "Privacy policy" \
     "Plain‑language summary of what’s collected and why." \
     '<section class="section"><div class="container">
        <h2>What we collect</h2><p class="small">Only what you voluntarily submit via forms (name, email, and message). No tracking cookies by default.</p>
        <h2>How it’s used</h2><p class="small">To respond to requests, pray, and follow up. We do not sell your data.</p>
        <h2>Your choices</h2><p class="small">Contact us to request removal of your information.</p>
     </div></section>' > policies/privacy.html

# -------- Randomize heroes if ./images exists --------
if [ -d "images" ]; then
  echo "==> images/ found — randomizing hero backgrounds"
  python3 - <<'PY'
import os, random, re, pathlib
root = pathlib.Path(".")
imgs = [p for ext in ("*.jpg","*.jpeg","*.png","*.webp") for p in (root/"images").glob(ext)]
if not imgs:
    print("No image files inside images/ — skipping.")
else:
    for f in root.rglob("*.html"):
        t = f.read_text(encoding="utf-8")
        # Find hero <div class="bg" ... style="">
        def repl(m):
            pick = "/images/" + random.choice(imgs).name
            before, style = m.group(1), m.group(2) or ""
            # inject or replace background-image
            if "background-image" in style:
                style = re.sub(r"background-image\s*:\s*url\([^)]+\);?", f"background-image:url('{pick}')", style)
            else:
                if style and not style.strip().endswith(";"): style += ";"
                style += f"background-image:url('{pick}')"
            return f'<div class="bg"{before} style="{style}">'
        t = re.sub(r'<div class="bg"([^>]*)\sstyle="([^"]*)">', repl, t, flags=re.I)
        t = re.sub(r'<div class="bg"([^>]*)>', lambda m: f'<div class="bg"{m.group(1)} style="background-image:url(\'/images/{random.choice(imgs).name}\')">', t, flags=re.I)
        f.write_text(t, encoding="utf-8")
        print("Updated:", f)
PY
else
  echo "==> No images/ folder — heroes will use the built-in gradient (still looks clean)."
fi

# -------- Local preview --------
echo "==> Starting local server at http://localhost:8080  (Ctrl+C to stop)"
( python3 -m http.server 8080 >/dev/null 2>&1 & )
SERVER_PID=$!
sleep 1
xdg-open "http://localhost:8080" >/dev/null 2>&1 || true

# -------- Offer Git push --------
read -p "Initialize git and push to GitHub now? (y/N): " yn
if [[ "${yn:-N}" =~ ^[Yy]$ ]]; then
  read -p "GitHub username: " GHUSER
  read -p "Repository name [${REPO_NAME}]: " GHREPO
  GHREPO="${GHREPO:-$REPO_NAME}"

  git init >/dev/null 2>&1 || true
  git add .
  git commit -m "Initial commit — ${GHREPO}" || true
  git branch -M main || true

  git remote remove origin >/dev/null 2>&1 || true
  git remote add origin "https://github.com/${GHUSER}/${GHREPO}.git"
  git push -u origin main

  echo ""
  echo "Now enable GitHub Pages:"
  echo "  Repo Settings → Pages → Source: main / (root) → Save"
  echo "Your site will be at: https://${GHUSER}.github.io/${GHREPO}/"
fi

# -------- Cleanup / stop server notice --------
trap "kill $SERVER_PID >/dev/null 2>&1 || true" EXIT
wait $SERVER_PID || true

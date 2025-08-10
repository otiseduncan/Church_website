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

(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important;animation:none !important}";
  document.head.appendChild(st);
  const L=[]; let dans=0, tours=0;
  const t=setInterval(()=>{
    if(++tours>120){ clearInterval(t); fin(); return }
    const pli=document.querySelector("#pli-prof button");
    if(pli){ pli.click(); return }
    if(document.querySelector(".scene")){
      if(++dans>8){ clearInterval(t); setTimeout(fin,300); return }
      document.body.click(); return;
    }
    const d=document.querySelector(".titre-ecran .demarrer");
    if(d){ L.push("titre"); d.click(); return }
    const niv=document.querySelector(".niveaux .niv:not([disabled])");
    if(niv){ L.push("menu"); niv.click(); return }
    const b=Array.from(document.querySelectorAll("#app button"))
      .filter(x=>!x.disabled && /commenc|jouer|lancer|partie|démarr/i.test(x.textContent));
    if(b.length){ L.push("niveau:"+b[0].textContent.trim().slice(0,18)); b[0].click(); return }
  }, 200);
  function fin(){
    const o=document.querySelector(".centre .ordre");
    const i=document.createElement("div");
    i.style.cssText="position:fixed;left:0;bottom:0;z-index:99999;background:#fff;color:#000;font:11px monospace;padding:4px";
    const dec=getComputedStyle(document.getElementById("decor"));
    i.textContent=L.join(">")+" | ordre "+(o?
      "visible="+o.checkVisibility({checkOpacity:true,checkVisibilityCSS:true})
      :"ABSENT")+" | decor="+dec.opacity+"/"+document.body.dataset.decor;
    document.body.appendChild(i);
  }
})();

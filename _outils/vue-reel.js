/* LE PARCOURS REEL : titre -> menu -> epoque -> partie.
   Les sondes precedentes appelaient « nouvellePartie » directement,
   ce qui saute « poserDecor » et laisse le decor a opacite zero. */
(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important;animation:none !important}";
  document.head.appendChild(st);
  const L=[];
  let n=0;
  const t=setInterval(()=>{
    const d=document.querySelector(".titre-ecran .demarrer");
    if(d){ L.push("titre"); d.click(); return }
    const niv=document.querySelector(".niveaux .niv:not([disabled])");
    if(niv){ L.push("menu"); niv.click(); return }
    const pli=document.querySelector("#pli-prof button");
    if(pli){ pli.click(); return }
    if(document.querySelector(".scene")){
      if(++n>8){ clearInterval(t); setTimeout(fin, 300); return }
      document.body.click(); return;
    }
    /* ecran du niveau : le dernier bouton lance la partie */
    const bs=Array.from(document.querySelectorAll("#app button"))
      .filter(b=>!b.disabled && !b.closest(".niveaux"));
    if(bs.length){ L.push("niveau"); bs[bs.length-1].click(); return }
    if(++n>40) clearInterval(t);
  }, 220);
  function fin(){
    const o=document.querySelector(".centre .ordre");
    const info=document.createElement("div");
    info.style.cssText="position:fixed;left:0;bottom:0;z-index:99999;background:#fff;color:#000;font:11px monospace;padding:4px";
    const dec=getComputedStyle(document.getElementById("decor"));
    info.textContent=L.join(">")+" | ordre "+(o?
      (o.checkVisibility?("visible="+o.checkVisibility({checkOpacity:true,checkVisibilityCSS:true})):"?")
      +" "+Math.round(o.getBoundingClientRect().width)+"x"+Math.round(o.getBoundingClientRect().height)
      :"ABSENT")+" | decor opacity="+dec.opacity+" data="+document.body.dataset.decor;
    document.body.appendChild(info);
  }
})();

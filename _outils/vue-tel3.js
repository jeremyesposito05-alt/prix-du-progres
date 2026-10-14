(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important;animation:none !important}";
  document.head.appendChild(st);
  setTimeout(()=>{
    nouvellePartie("campagne","II");
    document.body.classList.remove("surtitre","surmenu");
    let n=0;
    const t=setInterval(()=>{
      document.body.classList.remove("surtitre","surmenu");
      const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
      document.body.click();
      if(++n>12){ clearInterval(t); setTimeout(()=>{
        const o=document.querySelector(".centre .ordre");
        const c=document.querySelector(".scene > .centre");
        o.style.setProperty("background","#FF0000","important");
        c.style.setProperty("outline","5px solid #00FF00","important");
        const info=document.createElement("div");
        info.style.cssText="position:fixed;left:0;bottom:0;z-index:99999;background:#fff;color:#000;font:11px monospace;padding:4px";
        const r=o.getBoundingClientRect(), rc=c.getBoundingClientRect();
        info.textContent="ordre ["+Math.round(r.left)+","+Math.round(r.top)+"] "
          +Math.round(r.width)+"x"+Math.round(r.height)
          +" rects="+o.getClientRects().length
          +" visible="+(o.checkVisibility?o.checkVisibility({checkOpacity:true,checkVisibilityCSS:true}):"?")
          +" | centre ["+Math.round(rc.left)+","+Math.round(rc.top)+"] "
          +Math.round(rc.width)+"x"+Math.round(rc.height);
        document.body.appendChild(info);
      },300) }
    },240);
  }, 300);
})();

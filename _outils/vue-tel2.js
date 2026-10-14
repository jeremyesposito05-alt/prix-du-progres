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
        if(o){ o.style.outline="4px solid red";
          const c=getComputedStyle(o);
          const d=document.createElement("div");
          d.style.cssText="position:fixed;left:0;bottom:0;z-index:9999;background:#fff;color:#000;font:11px monospace;padding:4px;max-width:100%";
          d.textContent="bg="+c.backgroundImage.slice(0,120)+" | couleur="+c.backgroundColor;
          document.body.appendChild(d);
        }
      },300) }
    },240);
  }, 300);
})();

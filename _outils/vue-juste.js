/* ON NE CLIQUE QUE TANT QU IL RESTE A ECRIRE.
   Les sondes precedentes cliquaient un nombre fixe de fois ; au-dela
   de la mise en scene, un clic « pose les dossiers » — ce qui pouvait
   escamoter l ordre du jour dans les captures. */
(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important;animation:none !important}";
  document.head.appendChild(st);
  setTimeout(()=>{
    changerLangue("en");
    setTimeout(()=>{
      nouvellePartie("campagne","I");
      document.body.classList.remove("surtitre","surmenu");
      let garde=0;
      const t=setInterval(()=>{
        document.body.classList.remove("surtitre","surmenu");
        const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
        const s=(typeof E!=="undefined"&&E)?E.scene:null;
        if(s && s.i < s.etapes.length){ document.body.click(); return }
        if(++garde>3){ clearInterval(t);
          const o=document.querySelector(".centre .ordre");
          const d=document.createElement("div");
          d.style.cssText="position:fixed;left:0;bottom:0;z-index:999;background:#fff;color:#000;font:11px monospace;padding:3px";
          d.textContent = o ? ("ordre visible="+o.checkVisibility({checkOpacity:true,checkVisibilityCSS:true})
            +" h="+Math.round(o.getBoundingClientRect().height)) : "ordre absent";
          document.body.appendChild(d);
        }
      },240);
    },300);
  },300);
})();

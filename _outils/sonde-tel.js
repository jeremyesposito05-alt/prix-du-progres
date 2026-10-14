/* LES BULLES SONT-ELLES LISIBLES SUR TELEPHONE ?
   Une bulle cassee se reconnait a sa forme : tres etroite et tres
   haute. On mesure donc le rapport, et on verifie qu'elle ne
   chevauche ni le portrait ni le nom. */
(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important;animation:none !important}";
  document.head.appendChild(st);
  const L=[];
  setTimeout(()=>{
    nouvellePartie("campagne","II");
    document.body.classList.remove("surtitre","surmenu");
    let n=0;
    const t=setInterval(()=>{
      document.body.classList.remove("surtitre","surmenu");
      const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
      document.body.click();
      if(++n>12){ clearInterval(t); setTimeout(()=>{
        let vues=0, mal=[];
        for(const k of ["i","o","m","p"]){
          const b=document.querySelector(".p-"+k+" .dit");
          if(!b || !(b.textContent||"").trim()) continue;
          vues++;
          const r=b.getBoundingClientRect();
          const v=document.querySelector(".p-"+k+" .visage").getBoundingClientRect();
          const chev=Math.max(0,Math.min(r.right,v.right)-Math.max(r.left,v.left))
                   * Math.max(0,Math.min(r.bottom,v.bottom)-Math.max(r.top,v.top));
          L.push(k+" "+Math.round(r.width)+"x"+Math.round(r.height)
            +" rapport="+(r.height/r.width).toFixed(2)
            +(r.height/r.width>2.2?" ECRASEE":"")
            +(chev>4?" CHEVAUCHE le portrait":""));
        }
        const de=document.documentElement;
        L.push("bulles="+vues+" page="+de.scrollWidth+"/"+de.clientWidth
          +(de.scrollWidth>de.clientWidth+1?" DEBORDE":" ok"));
        const d=document.createElement("div"); d.id="sonde";
        d.textContent=L.join(" | ");
        document.body.appendChild(d);
      },500) }
    },240);
  }, 300);
})();

(function(){
  setTimeout(()=>{
    nouvellePartie("campagne","II");
    document.body.classList.remove("surtitre","surmenu");
    let n=0;
    const t=setInterval(()=>{
      document.body.classList.remove("surtitre","surmenu");
      const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
      document.body.click();
      if(++n>12){ clearInterval(t); setTimeout(()=>{
        const L=[];
        let b=null;
        for(const k of ["i","o","m","p"]){
          const e=document.querySelector(".p-"+k+" .dit");
          if(e && (e.textContent||"").trim()){ b=e; L.push("bulle="+k); break }
        }
        if(!b){ L.push("aucune bulle") } else {
          const c=getComputedStyle(b);
          for(const p of ["position","display","width","maxWidth","gridArea",
                          "gridColumnStart","gridColumnEnd","gridRowStart",
                          "left","right","top","bottom","margin"]){
            L.push(p+"="+c[p]);
          }
          const po=b.closest(".poste");
          const pc=getComputedStyle(po);
          L.push("--- poste: display="+pc.display+" cols="+pc.gridTemplateColumns
            +" rows="+pc.gridTemplateRows);
        }
        L.push("fen="+innerWidth);
        const d=document.createElement("div"); d.id="sonde";
        d.textContent=L.join(" | ");
        document.body.appendChild(d);
      },400) }
    },240);
  }, 300);
})();

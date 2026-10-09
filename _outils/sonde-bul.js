/* aucune bulle ne doit sortir de la page, ni a gauche ni a droite,
   et sa queue doit rester sur le medaillon */
(function(){
  const L=[];
  setTimeout(()=>{ nouvellePartie("campagne","II");
                   document.body.classList.remove("surtitre","surmenu"); }, 60);
  let n=0;
  const t=setInterval(()=>{
    document.body.classList.remove("surtitre","surmenu");
    const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
    document.body.click();
    if(++n>12){ clearInterval(t); setTimeout(()=>{
      const W=document.documentElement.clientWidth;
      for(const k of ["i","o","m","p"]){
        const b=document.querySelector(".p-"+k+" .dit");
        if(!b||!(b.textContent||"").trim()){ L.push(k+"=muet"); continue }
        const r=b.getBoundingClientRect();
        const v=document.querySelector(".p-"+k+" .visage").getBoundingClientRect();
        const queue=r.left+26;
        L.push(k+"["+Math.round(r.left)+".."+Math.round(r.right)+"]"
          +(r.right>W+1||r.left<-1?" SORT":"")
          +" queue="+(queue>=v.left-4&&queue<=v.right+4?"sur le visage":"A COTE"));
      }
      const d=document.createElement("div"); d.id="sonde";
      d.textContent="page="+W+" || "+L.join(" | ");
      document.body.appendChild(d);
    },600) }
  },240);
})();

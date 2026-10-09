/* une vue du plateau comme l'eleve la voit : toutes les transitions
   neutralisees, car le temps virtuel de Chrome les gele a leur etat
   de depart — le decor restait invisible et les portraits immobiles. */
(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important}#scene .vue{opacity:1 !important}";
  document.head.appendChild(st);
  setTimeout(()=>nouvellePartie("campagne","I"), 60);
  let n=0;
  const t=setInterval(()=>{
    const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
    document.body.click();
    if(++n>12){ clearInterval(t);
      const q=document.querySelector(".p-o")||document.querySelector(".poste");
      if(q) q.classList.add("parle","dit-maintenant");
    }
  },260);
})();

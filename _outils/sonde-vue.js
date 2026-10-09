/* une vue du plateau, mise en scene terminee, sans la lettre */
(function(){
  setTimeout(()=>nouvellePartie("campagne","I"), 60);
  let n=0;
  const t=setInterval(()=>{
    const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
    document.body.click();
    if(++n>12){ clearInterval(t);
      /* on fige la mise en avant d'un acteur pour la voir */
      const q=document.querySelector(".p-o")||document.querySelector(".poste");
      if(q){ q.style.transition="none";
        q.querySelectorAll("*").forEach(x=>x.style.transition="none");
        q.classList.add("parle","dit-maintenant"); }
    }
  },260);
})();

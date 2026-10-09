/* la vue telle que l eleve la voit : transitions neutralisees (le
   temps virtuel les gele) et « surtitre » retire — la sonde saute le
   menu, donc la classe de l ecran de titre restait, et elle masque le
   decor. */
(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important}";
  document.head.appendChild(st);
  setTimeout(()=>{ nouvellePartie("campagne","II");
                   document.body.classList.remove("surtitre","surmenu"); }, 60);
  let n=0;
  const t=setInterval(()=>{
    document.body.classList.remove("surtitre","surmenu");
    const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
    document.body.click();
    if(++n>12){ clearInterval(t);
      const q=document.querySelector(".p-o")||document.querySelector(".poste");
      if(q) q.classList.add("parle","dit-maintenant");
    }
  },260);
})();

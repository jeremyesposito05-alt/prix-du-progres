/* LA LETTRE, TELLE QU ELLE S OUVRE.
   On fixe la carte 01 pour que la capture soit reproductible, on
   retire « surtitre » (la sonde saute le menu) et on neutralise les
   transitions que le temps virtuel gele. */
(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important;animation:none !important}";
  document.head.appendChild(st);
  setTimeout(()=>{
    nouvellePartie("campagne","II");
    document.body.classList.remove("surtitre","surmenu");
    setTimeout(()=>{
      /* on impose la carte 01 et on rejoue la mise en scene */
      E.carte = CARTES_II.find(c=>c.n==="13") || E.carte;
      E.lettresLues = ["deja lue"];
      rendre();
      document.body.classList.remove("surtitre","surmenu");
      setTimeout(()=>{ if(!document.getElementById("pli-prof")) ouvrirLettre(); }, 500);
    }, 600);
  }, 80);
})();

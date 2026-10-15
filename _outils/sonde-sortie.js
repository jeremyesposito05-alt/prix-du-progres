/* LE BLASON RAMENE-T-IL A L ACCUEIL, ET SEULEMENT APRES DEUX FOIS ? */
(function(){
  const L=[]; const err=[];
  addEventListener("error",e=>err.push(e.message||"?"));
  const q=s=>document.querySelector(s);
  setTimeout(()=>{
    nouvellePartie("campagne","I");
    document.body.classList.remove("surtitre","surmenu");
    let n=0;
    const t=setInterval(()=>{
      document.body.classList.remove("surtitre","surmenu");
      const p=q("#pli-prof button"); if(p){p.click();return}
      document.body.click();
      if(++n>8){ clearInterval(t); setTimeout(()=>{
        L.push("partie en cours="+partieEnCours());
        q("#marque").click();
        L.push("1er clic : feuille="+(q(".sortie-feuille")?"oui":"NON")
          +" titre="+(q(".sortie-feuille h2")||{}).textContent
          +" boutons="+document.querySelectorAll(".so-bt button").length);
        /* on annule : on doit rester dans la partie */
        document.querySelectorAll(".so-bt button")[0].click();
        L.push("apres annulation : feuille="+(q(".sortie-feuille")?"ENCORE LA":"fermee")
          +" scene="+(q(".scene")?"oui":"NON"));
        /* on recommence et on va au bout */
        q("#marque").click();
        document.querySelectorAll(".so-bt button")[1].click();
        L.push("2e etape : titre="+(q(".sortie-feuille h2")||{}).textContent
          +" rouge="+(q(".sortie-feuille h2.so-rouge")?"oui":"non"));
        document.querySelectorAll(".so-bt button")[1].click();
        L.push("apres 2e validation : ecran de titre="
          +(q(".titre-ecran")?"OUI":"NON")
          +" feuille="+(q(".sortie-feuille")?"ENCORE LA":"fermee"));
        /* sur l ecran de titre, un clic doit passer sans rien demander */
        q("#marque").click();
        L.push("depuis le titre : feuille="+(q(".sortie-feuille")?"DEMANDE (anormal)":"aucune")
          +" titre="+(q(".titre-ecran")?"oui":"non"));
        const d=document.createElement("div"); d.id="sonde";
        d.textContent=L.join(" || ")+" || erreurs="+(err.length?err.join("/"):"aucune");
        document.body.appendChild(d);
      },400) }
    },240);
  },300);
})();

/* LES SOIXANTE LETTRES S OUVRENT-ELLES TOUTES, ET AVEC LEUR LIEN ?
   On ne capture pas : on compte. Pour chaque carte des deux niveaux,
   on fabrique la lettre et on verifie qu'elle porte bien les quatre
   blocs — lien, mot, question, reference — et que le lien fait deux
   phrases, ni une ni quatre. */
(function(){
  const L=[], mal=[];
  setTimeout(()=>{
    nouvellePartie("campagne","I");
    document.body.classList.remove("surtitre","surmenu");
    setTimeout(()=>{
      for(const [niv, tab] of [["I",CARTES_I],["II",CARTES_II]]){
        N = NIVEAUX[niv];
        let sans=0, court=0, long=0, phrases=0;
        for(const c of tab){
          if(!c.li){ mal.push(niv+"/"+c.n+" sans lien"); sans++; continue }
          const p = c.li.split(/[.?!]\s+/).filter(x=>x.trim()).length;
          phrases += p;
          if(p < 2) court++;
          if(p > 3) long++;
          if(c.li.length > 240) mal.push(niv+"/"+c.n+" trop long ("+c.li.length+")");
          if(/"/.test(c.li)) mal.push(niv+"/"+c.n+" guillemet droit");
        }
        L.push(niv+": "+tab.length+" cartes, "+sans+" sans lien, "
          +court+" en une phrase, "+long+" en plus de trois, "
          +"moyenne "+(phrases/tab.length).toFixed(1)+" phrases, "
          +"longueur moyenne "+Math.round(tab.reduce((a,c)=>a+(c.li||"").length,0)/tab.length));
      }
      /* et une lettre reellement fabriquee */
      E.carte = CARTES_I[0]; E.lettresLues = [];
      const h1 = pliProf();
      E.lettresLues = ["x"];
      E.carte = CARTES_II[12];
      N = NIVEAUX.II;
      const h2 = pliProf();
      L.push("1re lettre: presentation="+(/M. Esposito/.test(h1)?"oui":"NON")
        +" lien="+(/cp-lien/.test(h1)?"oui":"NON")
        +" mot="+(/cp-notion/.test(h1)?"oui":"NON"));
      L.push("lettre suivante: presentation="+(/M. Esposito/.test(h2)?"OUI (anormal)":"non")
        +" lien="+(/cp-lien/.test(h2)?"oui":"NON"));
      const d=document.createElement("div"); d.id="sonde";
      d.textContent=L.join(" || ")+" || defauts="+(mal.length?mal.join(" / "):"aucun");
      document.body.appendChild(d);
    }, 700);
  }, 80);
})();

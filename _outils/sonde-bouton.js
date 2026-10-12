/* LE BOUTON DE LA LETTRE EST-IL TOUJOURS ATTEIGNABLE ?
   On ouvre la PREMIERE lettre — la plus haute des soixante, celle qui
   porte la presentation — a plusieurs hauteurs d'ecran, et on verifie
   trois choses : elle ne deborde pas, le bouton est dans la fenetre,
   et c'est bien lui qu'on touche au point ou il s'affiche. */
(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important;animation:none !important}";
  document.head.appendChild(st);
  setTimeout(()=>{
    nouvellePartie("campagne","I");
    document.body.classList.remove("surtitre","surmenu");
    setTimeout(()=>{
      E.carte = CARTES_I.find(c=>c.n==="01") || E.carte;
      E.lettresLues = [];
      rendre();
      document.body.classList.remove("surtitre","surmenu");
      setTimeout(()=>{
        if(!document.getElementById("pli-prof")) ouvrirLettre();
        setTimeout(()=>{
          const L=[];
          const pli=document.getElementById("pli-prof");
          const let_=document.querySelector(".lettre-prof");
          const corps=document.querySelector(".cp-corps");
          const b=document.querySelector(".lettre-prof button");
          const H=innerHeight;
          if(!b){ L.push("PAS DE BOUTON") } else {
            const r=b.getBoundingClientRect(), lr=let_.getBoundingClientRect();
            const cx=Math.round(r.left+r.width/2), cy=Math.round(r.top+r.height/2);
            const sous=document.elementFromPoint(cx,cy);
            L.push("fen="+innerWidth+"x"+H
              +" lettre="+Math.round(lr.top)+".."+Math.round(lr.bottom)
              +" (h="+Math.round(lr.height)+", defile="+(corps&&corps.scrollHeight>corps.clientHeight+1?"oui":"non")+", horiz="+(let_.scrollWidth>let_.clientWidth+1?"OUI":"non")+")"
              +" bouton="+Math.round(r.top)+".."+Math.round(r.bottom)
              +" visible="+(r.top>=0&&r.bottom<=H?"OUI":"NON")
              +" cliquable="+(sous===b||b.contains(sous)?"OUI":"NON ("+(sous?sous.className||sous.tagName:"rien")+")"));
          }
          const d=document.createElement("div"); d.id="sonde";
          d.textContent=L.join(" | ");
          document.body.appendChild(d);
        }, 400);
      }, 500);
    }, 600);
  }, 80);
})();

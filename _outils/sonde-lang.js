/* LA BASCULE MARCHE-T-ELLE, ET RESTE-T-IL DU FRANCAIS ?
   On passe en anglais, on parcourt les deux ecrans, et on cherche
   les mots francais les plus courants dans ce qui s'affiche. Un seul
   suffit a signaler une chaine oubliee. */
(function(){
  const FR = /\b(vous|tu|ton|votre|choisir|chaque|décision|groupes?|époque|jamais|joué|préparation|Démarrer|Avant|Comment|progrès|Conçu|écrit|habitants|voitures)\b/i;
  const L=[];
  function scan(nom){
    const el=document.getElementById("app");
    const t=(el?el.innerText:"").replace(/\s+/g," ");
    const m=t.match(new RegExp(FR.source,"gi"));
    const uniq=m?[...new Set(m.map(x=>x.toLowerCase()))]:[];
    L.push(nom+" : boutons="+document.querySelectorAll(".langues button").length
      +" actif="+((document.querySelector(".langues button.on")||{}).textContent||"-")
      +" restes_fr="+(uniq.length?uniq.join(","):"aucun")
      +" long="+t.length);
  }
  setTimeout(()=>{
    changerLangue("en");
    setTimeout(()=>{
      scan("titre EN");
      demarrer();
      setTimeout(()=>{
        scan("tuto EN");
        changerLangue("fr");
        setTimeout(()=>{
          const t=document.getElementById("app").innerText;
          L.push("retour FR : « "+t.slice(0,46).replace(/\s+/g," ")+" »");
          const d=document.createElement("div"); d.id="sonde";
          d.textContent=L.join(" || ");
          document.body.appendChild(d);
        }, 350);
      }, 500);
    }, 350);
  }, 700);
})();

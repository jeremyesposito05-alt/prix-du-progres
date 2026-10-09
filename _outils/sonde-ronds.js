/* LES MEDAILLONS TIENNENT-ILS DANS LA HAUTEUR QUE LE CENTRE IMPOSE ?
   C'est la seule question qui decide du diametre : tant que deux
   rangees de postes sont moins hautes que la colonne du centre,
   agrandir ne coute pas un pixel de page. On releve donc les deux
   hauteurs, et on verifie au passage que celui qui parle avance
   vraiment — mesure prise APRES la transition, pas pendant. */
(function(){
  const h = s => { const e = document.querySelector(s);
                   return e ? Math.round(e.getBoundingClientRect().height) : 0 };
  const w = s => { const e = document.querySelector(s);
                   return e ? Math.round(e.getBoundingClientRect().width) : 0 };
  const err = [];
  addEventListener("error", e => err.push(e.message));
  setTimeout(()=>nouvellePartie("campagne","I"), 60);
  let n = 0;
  const t = setInterval(()=>{
    const p = document.querySelector("#pli-prof button");
    if(p){ p.click(); return }
    document.body.click();
    if(++n > 14){
      clearInterval(t);
      let av = "-";
      try{ avance(document.querySelector(".poste .dit")) }
      catch(e){ av = "ERREUR " + e.message }
      setTimeout(()=>{
        const q = document.querySelector(".poste.dit-maintenant");
        if(q && av === "-") av = q.className.match(/p-\w+/)[0]
                               + " " + getComputedStyle(q).transform;
        const hp = h(".p-i"), hc = h(".scene > .centre");
        const deux = 2*hp + 12;
        const d = document.createElement("div");
        d.id = "sonde";
        d.textContent = "fen=" + innerWidth + "x" + innerHeight
          + " rond=" + w(".p-i .visage") + " centre=" + w(".scene > .centre")
          + " hposte=" + hp + " 2rangees=" + deux + " hcentre=" + hc
          + " marge=" + (hc - deux)
          + " hscene=" + h(".scene") + " page=" + document.documentElement.scrollHeight
          + " avance=" + av
          + " erreurs=" + (err.length ? err.join(" / ") : "aucune");
        document.body.appendChild(d);
      }, 900);
    }
  }, 260);
})();

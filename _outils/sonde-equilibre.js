/* SIMULER DES PARTIES POUR MESURER L EQUILIBRE
   Injecte en fin de fichier par « equilibre.pl ».

   Deux joueurs :
   — AU HASARD : il prend une reponse au sort. C est le plancher ; s il
     survit toujours, le jeu ne demande rien.
   — METHODIQUE : a chaque tour il protege la force la plus basse. C est
     le plafond ; s il meurt souvent, le jeu est injouable.
   Entre les deux se trouve l eleve. */
window.SANS_CHRONO = true;
(function(){
  const PARTIES = 40;
  const res = { hasard:[], methodique:[] };
  let mode = "hasard", n = 0, garde = 0, bloque = 0;
  const coince = [];

  function choix(){
    const c = E.carte;
    const k = ["a","b","c"].filter(x => c[x]);
    if(mode === "hasard") return k[Math.floor(Math.random()*k.length)];
    /* le methodique : il regarde qui est le plus bas et le menage */
    let bas = null;
    for(const f of ["i","o","m","p"]) if(!bas || E.f[f] < E.f[bas]) bas = f;
    let meilleur = k[0], score = -99;
    for(const x of k){
      const e = c[x].e || {};
      const s = (e[bas]||0)*3 + ["i","o","m","p"].reduce((a,f)=>a+(e[f]||0), 0);
      if(s > score){ score = s; meilleur = x; }
    }
    return meilleur;
  }

  function finir(){
    res[mode].push({ f:["i","o","m","p"].map(k=>Math.round(E.f[k])),
                     tour:E.tour, pop:Math.round(E.pop),
                     mort: E.tour < N.tours });
    n++;
    if(n >= PARTIES){
      if(mode === "hasard"){ mode = "methodique"; n = 0; }
      else { clearInterval(t); rapport(); return; }
    }
    nouvellePartie("campagne","I");
  }

  function rapport(){
    const L = [];
    for(const m of ["hasard","methodique"]){
      const p = res[m];
      const morts = p.filter(x=>x.mort).length;
      const moy = k => (p.reduce((a,x)=>a+x.f[k],0)/p.length).toFixed(0);
      const mini = k => Math.min.apply(null, p.map(x=>x.f[k]));
      L.push(m + " : " + (p.length-morts) + "/" + p.length + " arrivent au bout"
        + " · forces moyennes " + [0,1,2,3].map(moy).join("/")
        + " · minimum atteint " + [0,1,2,3].map(mini).join("/") + " · tours " + (p.reduce((a,x)=>a+x.tour,0)/p.length).toFixed(1) + "/" + N.tours);
    }
    const d = document.createElement("div");
    d.id = "sonde"; d.textContent = L.join("  ||  ") + (coince.length ? "  ||  BLOQUE " + coince.length + "x : " + coince[0] : "  ||  jamais bloque");
    document.body.appendChild(d);
  }

  setTimeout(()=>nouvellePartie("campagne","I"), 80);
  var t = setInterval(function(){
    if(typeof E === "undefined" || !E) return;
    if(++garde > 60000){ clearInterval(t); rapport(); return; }
    /* fin de partie : un ecran sans reponse et sans bouton de suite */
    if(E.fini){ finir(); return; }
    const b = document.querySelector(".centre .choix");
    if(b){ document.querySelector(".centre .rep .choix:nth-child(" +
             (["a","b","c"].indexOf(choix())+1) + ")").click(); return; }
    /* N importe quel bouton qui fait avancer : consequence, courrier,
       graine, avertissement. On ne declare la partie finie que sur
       « E.fini » — sinon on mesure ses propres angles morts. */
    const bs = Array.from(document.querySelectorAll("#app button"))
      .filter(x => !x.closest("summary") && !/Changer|niveau|Recommencer/.test(x.textContent));
    if(bs.length){ bs[bs.length-1].click(); bloque = 0; return; }
    if(++bloque > 80){ coince.push(E.tour + ":" + (app.textContent||"").slice(0,60)); bloque = 0; finir(); }
  }, 4);
})();

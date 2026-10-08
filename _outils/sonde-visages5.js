/* COMBIEN DE TEMPS CHAQUE VISAGE RESTERAIT-IL A L ECRAN ?
   Injecte en fin de fichier.

   Un etat de portrait ne vaut la peine d etre dessine que si l eleve
   le voit assez longtemps pour le reconnaitre. On joue des parties, on
   releve la force de chaque acteur a chaque tour, et on compte les
   tours passes dans chaque bande — pour un decoupage en six etats et
   pour un decoupage en quatre. */
window.SANS_CHRONO = true;
(function(){
  const PARTIES = 26;
  /* six etats, bandes egales entre 60 (depart) et 0 (rupture) */
  const SIX = [["content",58],["neutre",48],["contrarie",35],["fache",20],["au bord",0]];
  /* quatre etats, cales sur ce que le jeu dit deja : la pastille de la
     jauge change a 55, 35 et 20 */
  const QUATRE = [["content",55],["neutre",35],["fache",20],["au bord",0]];

  const cpt = { six:{}, quatre:{} };
  for(const [n] of SIX)    cpt.six[n] = 0;
  for(const [n] of QUATRE) cpt.quatre[n] = 0;
  let releves = 0, parties = 0, garde = 0, bloque = 0;

  function bande(v, table){
    for(const [n, seuil] of table) if(v >= seuil) return n;
    return table[table.length-1][0];
  }
  function relever(){
    for(const k of ["i","o","m","p"]){
      cpt.six[bande(E.f[k], SIX)]++;
      cpt.quatre[bande(E.f[k], QUATRE)]++;
      releves++;
    }
  }
  function choix(){
    const c = E.carte, k = ["a","b","c"].filter(x => c[x]);
    /* un eleve ordinaire : il menage un peu, pas toujours */
    if(Math.random() < .5) return k[Math.floor(Math.random()*k.length)];
    let bas = "i";
    for(const f of ["i","o","m","p"]) if(E.f[f] < E.f[bas]) bas = f;
    let best = k[0], sc = -99;
    for(const x of k){ const e = c[x].e || {};
      const s = (e[bas]||0)*3; if(s > sc){ sc = s; best = x; } }
    return best;
  }
  function rapport(){
    const L = [];
    for(const m of ["six","quatre"]){
      L.push(m + " · " + Object.keys(cpt[m]).map(n =>
        n + " " + (100*cpt[m][n]/releves).toFixed(0) + "%").join(" · "));
    }
    L.push("parties=" + parties + " releves=" + releves);
    const d = document.createElement("div");
    d.id = "sonde"; d.textContent = L.join("  ||  ");
    document.body.appendChild(d);
  }

  setTimeout(()=>nouvellePartie("campagne","I"), 80);
  let dernierTour = -1;
  var t = setInterval(function(){
    if(typeof E === "undefined" || !E) return;
    if(++garde > 90000){ clearInterval(t); rapport(); return; }
    if(E.fini){
      if(++parties >= PARTIES){ clearInterval(t); rapport(); return; }
      dernierTour = -1; nouvellePartie("campagne","I"); return;
    }
    const b = document.querySelector(".centre .rep .choix");
    if(b){
      if(E.tour !== dernierTour){ relever(); dernierTour = E.tour; }
      const i = ["a","b","c"].indexOf(choix());
      const tous = document.querySelectorAll(".centre .rep .choix");
      (tous[i] || tous[0]).click(); bloque = 0; return;
    }
    const bs = Array.from(document.querySelectorAll("#app button"))
      .filter(x => !x.closest("summary"));
    if(bs.length){ bs[bs.length-1].click(); bloque = 0; return; }
    if(++bloque > 80){ bloque = 0; parties++; nouvellePartie("campagne","I"); }
  }, 4);
})();

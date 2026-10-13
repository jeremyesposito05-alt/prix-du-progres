/* LES BOUTONS RECOUVRENT-ILS ENCORE QUELQUE CHOSE ?
   On ne regarde pas : on calcule l'intersection des rectangles, a
   plusieurs largeurs, sur les deux ecrans. Zero pixel commun, ou
   c'est un defaut. */
(function(){
  const L=[];
  const chevauche=(a,b)=>{
    const r1=a.getBoundingClientRect(), r2=b.getBoundingClientRect();
    const x=Math.max(0, Math.min(r1.right,r2.right)-Math.max(r1.left,r2.left));
    const y=Math.max(0, Math.min(r1.bottom,r2.bottom)-Math.max(r1.top,r2.top));
    return Math.round(x*y);
  };
  function test(nom){
    const b=document.querySelector(".langues");
    if(!b){ L.push(nom+" : pas de boutons"); return }
    let pire=0, qui="-";
    for(const e of document.querySelectorAll("#app *")){
      if(e===b || b.contains(e) || e.contains(b)) continue;
      if(!e.textContent.trim() && !e.querySelector("img")) continue;
      /* on ne teste que ce qui PORTE du texte, pas les cadres */
      if(e.querySelector("*") && !e.matches("h1,h2,h3,p,span,button,div.surtitre-txt,img")) continue;
      const a=chevauche(b,e);
      if(a>pire){ pire=a; qui=(e.className||e.tagName).toString().slice(0,22) }
    }
    const r=b.getBoundingClientRect();
    L.push(nom+" largeur="+innerWidth
      +" boutons=["+Math.round(r.left)+".."+Math.round(r.right)+"]"
      +" recouvrement="+(pire?pire+" px² avec "+qui:"AUCUN"));
  }
  setTimeout(()=>{
    changerLangue("en");
    setTimeout(()=>{
      test("titre");
      demarrer();
      setTimeout(()=>{
        test("tuto");
        const d=document.createElement("div"); d.id="sonde";
        d.textContent=L.join(" || ");
        document.body.appendChild(d);
      }, 500);
    }, 300);
  }, 700);
})();

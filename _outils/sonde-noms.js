/* AUCUN NOM NE DOIT TENIR SUR DEUX LIGNES.
   On mesure, pour les deux niveaux, la hauteur de chaque nom : une
   ligne, ou deux. Et on verifie qu'il ne deborde pas sa colonne. */
(function(){
  const L=[], err=[];
  addEventListener("error", e=>err.push("ressource"), true);
  function mesurer(niv, suite){
    nouvellePartie("campagne", niv);
    document.body.classList.remove("surtitre","surmenu");
    setTimeout(()=>{
      for(const k of ["i","o","m","p"]){
        const n=document.querySelector(".p-"+k+" .nm");
        if(!n){ L.push(niv+"/"+k+"=absent"); continue }
        const r=n.getBoundingClientRect();
        const cs=getComputedStyle(n);
        const lignes=Math.round(r.height/parseFloat(cs.lineHeight||r.height));
        const par=n.parentElement.getBoundingClientRect();
        L.push(niv+" "+n.textContent.slice(0,14)+" "+Math.round(parseFloat(cs.fontSize))+"px"
          +" l="+Math.round(r.width)+"/"+Math.round(par.width)
          +(r.width>par.width+1?" DEBORDE":"")
          +(r.height>parseFloat(cs.fontSize)*1.5?" DEUX LIGNES":""));
      }
      suite();
    }, 700);
  }
  setTimeout(()=>mesurer("I", ()=>mesurer("II", ()=>{
    const d=document.createElement("div"); d.id="sonde";
    d.textContent="largeur="+innerWidth+" || "+L.join(" | ")
      +" || bulles visibles="+document.querySelectorAll(".poste .dit").length;
    document.body.appendChild(d);
  })), 300);
})();

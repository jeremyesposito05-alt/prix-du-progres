/* un tour complet : aucune erreur, le bandeau est la, le curseur
   s'allume puis s'eteint, et la page ne deborde pas */
(function(){
  const L=[], err=[];
  addEventListener("error", e=>err.push((e.message||"ressource")+""), true);
  const w=s=>{const e=document.querySelector(s);return e?Math.round(e.getBoundingClientRect().width):0};
  setTimeout(()=>nouvellePartie("campagne","I"), 60);
  setTimeout(()=>L.push("curseur pendant la frappe="
    +document.querySelectorAll(".frappe").length), 900);
  let n=0;
  const t=setInterval(()=>{
    const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
    const c=document.querySelectorAll(".tranche .choix");
    if(c.length===3 && n>4){ c[0].click(); }
    else document.body.click();
    if(++n>16){ clearInterval(t); setTimeout(()=>{
      const de=document.documentElement;
      L.push("tranche="+w(".tranche")+" plaques="+document.querySelectorAll(".tranche .choix").length
        +" colonnes="+(document.querySelector(".tranche .rep")
            ? getComputedStyle(document.querySelector(".tranche .rep")).gridTemplateColumns : "-")
        +" curseur restant="+document.querySelectorAll(".frappe").length
        +" carte="+w(".p-i")+" rond="+w(".p-i .visage")
        +" page="+de.scrollHeight+"/"+de.clientHeight
        +" largeur="+de.scrollWidth+"/"+de.clientWidth
        +" tour="+(typeof E!=="undefined"&&E?E.tour:"?"));
      const d=document.createElement("div");d.id="sonde";
      d.textContent=L.join(" || ")+" || erreurs="+(err.length?err.join(" / "):"aucune");
      document.body.appendChild(d);
    },900) }
  },240);
})();

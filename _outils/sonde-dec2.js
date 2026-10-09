(function(){
  const L=[]; const err=[];
  addEventListener("error", e=>err.push(e.message||"?"), true);
  setTimeout(()=>nouvellePartie("campagne","I"), 60);
  const lire=q=>{const v=document.getElementById("decor");
    L.push(q+" decor="+document.body.dataset.decor+" opac="+(v?getComputedStyle(v).opacity:"-")
      +" img="+(v?getComputedStyle(v).backgroundImage.slice(0,80):"absent"));};
  setTimeout(()=>lire("avant clics :"), 2200);
  let n=0;
  const t=setInterval(()=>{
    const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
    document.body.click();
    if(++n>12){ clearInterval(t); setTimeout(()=>{
      lire("apres clics :");
      const d=document.createElement("div");d.id="sonde";
      d.textContent=L.join(" || ")+" || erreurs="+(err.length?err.join("/"):"aucune");
      document.body.appendChild(d);
    },900) }
  },260);
})();

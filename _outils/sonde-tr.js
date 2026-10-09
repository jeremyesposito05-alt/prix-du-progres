(function(){
  setTimeout(()=>nouvellePartie("campagne","I"), 60);
  let n=0;
  const t=setInterval(()=>{
    const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
    document.body.click();
    if(++n>12){ clearInterval(t); setTimeout(()=>{
      const r=s=>{const e=document.querySelector(s);if(!e)return s+"=absent";
        const b=e.getBoundingClientRect();
        return s+"["+Math.round(b.left)+".."+Math.round(b.right)+"]";};
      const cs=s=>{const e=document.querySelector(s);return e?getComputedStyle(e):null};
      const tr=cs(".tranche"), rep=cs(".tranche .rep");
      const d=document.createElement("div"); d.id="sonde";
      d.textContent=[r(".bureau"),r(".plateau.large"),r(".scene"),r(".tranche"),
        r(".tranche .rep"),r(".tranche .choix"),
        "parent="+(document.querySelector(".tranche")||{parentElement:{className:"?"}}).parentElement.className,
        "tranche.display="+(tr?tr.display:"-"),
        "tranche.maxw="+(tr?tr.maxWidth:"-"),
        "rep.cols="+(rep?rep.gridTemplateColumns:"-")].join(" | ");
      document.body.appendChild(d);
    },500) }
  },260);
})();

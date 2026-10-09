/* QUI DEBORDE DE 57 PX ?
   On ne cherche plus les elements qui depassent le bord de la page —
   le balayage precedent n'en a trouve aucun. On cherche les BOITES
   dont le contenu deborde : scrollWidth plus grand que clientWidth.
   C'est la boite qui porte le debordement, meme si l'enfant coupable
   est invisible. */
(function(){
  setTimeout(()=>nouvellePartie("campagne","I"), 60);
  let n=0;
  const t=setInterval(()=>{
    const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
    document.body.click();
    if(++n>10){ clearInterval(t); setTimeout(()=>{
      const L=[];
      const nom=e=>e.tagName.toLowerCase()
        +(e.id?"#"+e.id:"")+(e.className&&e.className.toString?"."+e.className.toString().trim().replace(/\s+/g,"."):"");
      for(const e of document.querySelectorAll("html,body,html *")){
        if(e.scrollWidth > e.clientWidth + 1 && e.clientWidth > 0)
          L.push(nom(e).slice(0,46)+" "+e.clientWidth+"->"+e.scrollWidth);
      }
      /* et les elements les plus a droite, pseudo compris via la boite */
      let pire=null, max=0;
      for(const e of document.querySelectorAll("body *")){
        const r=e.getBoundingClientRect();
        if(r.width && r.right>max){ max=r.right; pire=e }
      }
      const d=document.createElement("div"); d.id="sonde";
      d.textContent="deborde: "+(L.length?L.slice(0,8).join(" | "):"aucune boite")
        +" || le plus a droite = "+(pire?nom(pire).slice(0,46)+" a "+Math.round(max):"-")
        +" || client="+document.documentElement.clientWidth
        +" scroll="+document.documentElement.scrollWidth;
      document.body.appendChild(d);
    },600) }
  },240);
})();

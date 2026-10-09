(function(){
  setTimeout(()=>nouvellePartie("campagne","I"), 60);
  let n=0;
  const t=setInterval(()=>{
    const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
    document.body.click();
    if(++n>10){ clearInterval(t); setTimeout(()=>{
      const de=document.documentElement;
      let large=[];
      for(const e of document.querySelectorAll("body *")){
        const r=e.getBoundingClientRect();
        if(r.right>de.clientWidth+1||r.left<-1)
          large.push(e.className.toString().slice(0,28)+"["+Math.round(r.left)+".."+Math.round(r.right)+"]");
      }
      const d=document.createElement("div"); d.id="sonde";
      d.textContent="client="+de.clientWidth+" scroll="+de.scrollWidth
        +" deborde="+(de.scrollWidth>de.clientWidth?"OUI":"non")
        +" coupables="+(large.length?large.slice(0,6).join(" "):"aucun");
      document.body.appendChild(d);
    },500) }
  },260);
})();

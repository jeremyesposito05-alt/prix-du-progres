(function(){
  setTimeout(()=>{
    nouvellePartie("campagne","II");
    document.body.classList.remove("surtitre","surmenu");
    let n=0;
    const t=setInterval(()=>{
      document.body.classList.remove("surtitre","surmenu");
      const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
      document.body.click();
      if(++n>12){ clearInterval(t); setTimeout(()=>{
        const L=[];
        const o=document.querySelector(".centre .ordre");
        if(!o) L.push("ordre ABSENT du DOM");
        else{
          const r=o.getBoundingClientRect(), c=getComputedStyle(o);
          L.push("ordre ["+Math.round(r.left)+","+Math.round(r.top)+"] "
            +Math.round(r.width)+"x"+Math.round(r.height)
            +" display="+c.display+" order="+c.order+" opacity="+c.opacity
            +" visibility="+c.visibility
            +" texte="+(o.innerText||"").replace(/\s+/g," ").slice(0,40));
        }
        const o2=document.querySelector(".centre .ordre");
        if(o2){ const r2=o2.getBoundingClientRect();
          const el=document.elementFromPoint(Math.round(r2.left+r2.width/2),Math.round(r2.top+30));
          L.push("au-dessus du centre de l ordre : "+(el?(el.className||el.tagName).toString().slice(0,30):"rien"));
          L.push("fond=" + getComputedStyle(o2).backgroundColor + " / " + getComputedStyle(o2).backgroundImage.slice(0,40));
          L.push("zindex=" + getComputedStyle(o2).zIndex + " pos=" + getComputedStyle(o2).position); }
        const sc=document.querySelector(".scene");
        L.push("enfants de la scene : "+Array.from(sc.children)
          .map(e=>(e.className||"?").toString().split(" ")[0]
            +"/"+getComputedStyle(e).order).join(" "));
        const d=document.createElement("div"); d.id="sonde";
        d.textContent=L.join(" || ");
        document.body.appendChild(d);
      },400) }
    },240);
  }, 300);
})();

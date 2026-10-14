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
        const c=getComputedStyle(o);
        L.push("classes="+o.className);
        L.push("bgcolor="+c.backgroundColor);
        L.push("bgimg="+c.backgroundImage.replace(/\s+/g," "));
        L.push("--pap="+c.getPropertyValue("--pap").trim()
             +" --pap2="+c.getPropertyValue("--pap2").trim());
        L.push("filter="+c.filter+" mix="+c.mixBlendMode
             +" clip="+c.clipPath+" mask="+c.maskImage.slice(0,30));
        L.push("transform="+c.transform);
        const par=o.parentElement, pc=getComputedStyle(par);
        L.push("parent="+par.className+" ovf="+pc.overflow+" h="+Math.round(par.getBoundingClientRect().height));
        const r=o.getBoundingClientRect();
        L.push("rect=["+Math.round(r.left)+","+Math.round(r.top)+"] "+Math.round(r.width)+"x"+Math.round(r.height));
        const pile=document.elementsFromPoint(Math.round(r.left+r.width/2), Math.round(r.top+40));
        L.push("pile="+pile.map(e=>(e.id?"#"+e.id:(e.className||e.tagName).toString().split(" ")[0])).join(" > "));
        L.push("scrollY="+Math.round(scrollY)+" innerH="+innerHeight);
        const d=document.createElement("div"); d.id="sonde";
        d.textContent=L.join(" || ");
        document.body.appendChild(d);
      },400) }
    },240);
  }, 300);
})();

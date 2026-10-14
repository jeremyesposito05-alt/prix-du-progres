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
        const dec=document.getElementById("decor");
        const dc=getComputedStyle(dec);
        L.push("decor: pos="+dc.position+" z="+dc.zIndex+" opacity="+dc.opacity);
        let e=document.querySelector(".centre .ordre");
        while(e && e!==document.documentElement){
          const c=getComputedStyle(e);
          const ctx=[];
          if(c.position!=="static" && c.zIndex!=="auto") ctx.push("z="+c.zIndex);
          if(c.transform!=="none") ctx.push("transform");
          if(c.filter!=="none") ctx.push("filter");
          if(c.opacity!=="1") ctx.push("opacity="+c.opacity);
          if(c.isolation!=="auto") ctx.push("isolation");
          if(c.mixBlendMode!=="normal") ctx.push("blend");
          if(c.willChange!=="auto") ctx.push("willChange");
          if(c.contain!=="none") ctx.push("contain="+c.contain);
          if(c.backdropFilter && c.backdropFilter!=="none") ctx.push("backdrop");
          L.push((e.id?"#"+e.id:(e.className||e.tagName).toString().split(" ")[0])
            +" ["+c.position+(ctx.length?" "+ctx.join(","):"")+"]");
          e=e.parentElement;
        }
        const d=document.createElement("div"); d.id="sonde";
        d.textContent=L.join(" || ");
        document.body.appendChild(d);
      },400) }
    },240);
  }, 300);
})();

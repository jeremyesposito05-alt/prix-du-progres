(function(){
  setTimeout(()=>nouvellePartie("campagne","I"), 60);
  setTimeout(()=>{
    const L=[];
    for(const s of ["body",".bureau",".plateau.large","#app"]){
      const e=document.querySelector(s); if(!e){L.push(s+"=absent");continue}
      const c=getComputedStyle(e);
      L.push(s+" img="+c.backgroundImage.slice(0,70)+" size="+c.backgroundSize);
    }
    const v=document.querySelector(".vue,.decor,.fond");
    L.push("element decor="+(v?v.className:"aucun"));
    L.push("age="+getComputedStyle(document.body).getPropertyValue("--age"));
    const d=document.createElement("div");d.id="sonde";d.textContent=L.join(" || ");
    document.body.appendChild(d);
  }, 3000);
})();

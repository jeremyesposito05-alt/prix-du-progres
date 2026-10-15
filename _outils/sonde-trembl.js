/* LE TREMBLEMENT PART-IL QUAND L ACTEUR PARLE ?
   On joue un tour, on choisit, puis on decouvre les bulles une a une
   comme la mise en scene le fait, et on releve l animation calculee. */
(function(){
  const L=[];
  setTimeout(()=>{
    nouvellePartie("campagne","I");
    document.body.classList.remove("surtitre","surmenu");
    let n=0;
    const t=setInterval(()=>{
      document.body.classList.remove("surtitre","surmenu");
      const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
      const ch=document.querySelectorAll(".tranche .choix");
      if(ch.length===3 && n>3){
        ch[0].click(); clearInterval(t);
        setTimeout(()=>{
          L.push("avant la parole :");
          for(const k of ["i","o","m","p"]){
            const po=document.querySelector(".p-"+k);
            L.push("  "+k+" ["+po.className.replace("poste ","").trim()
              +"] anim="+getComputedStyle(po.querySelector(".visage")).animationName);
          }
          for(const b of document.querySelectorAll(".poste .dit")){
            try{ avance(b) }catch(e){}
          }
          L.push("apres la parole :");
          for(const k of ["i","o","m","p"]){
            const po=document.querySelector(".p-"+k);
            const c=getComputedStyle(po.querySelector(".visage"));
            L.push("  "+k+" ["+po.className.replace("poste ","").trim()
              +"] anim="+c.animationName+" dur="+c.animationDuration);
          }
          const d=document.createElement("div"); d.id="sonde";
          d.textContent=L.join(" || ");
          document.body.appendChild(d);
        }, 600);
        return;
      }
      document.body.click();
      if(++n>20) clearInterval(t);
    },240);
  },300);
})();

(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important;animation:none !important}";
  document.head.appendChild(st);
  setTimeout(()=>{
    nouvellePartie("campagne","II");
    document.body.classList.remove("surtitre","surmenu");
    let n=0;
    const t=setInterval(()=>{
      document.body.classList.remove("surtitre","surmenu");
      const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
      document.body.click();
      if(++n>12) clearInterval(t);
    },240);
  }, 300);
})();

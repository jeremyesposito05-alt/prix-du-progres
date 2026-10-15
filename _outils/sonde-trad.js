/* LE MECANISME TIENT-IL, ET QUE COUVRE-T-IL ?
   On bascule en anglais, on force la carte 01, et on releve ce que le
   plateau affiche reellement — titre, expose, replique, les quatre
   noms de forces et les trois choix. Plus la couverture globale. */
(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important;animation:none !important}";
  document.head.appendChild(st);
  const err=[]; addEventListener("error",e=>err.push(e.message||"?"));
  setTimeout(()=>{
    changerLangue("en");
    setTimeout(()=>{
      nouvellePartie("campagne","I");
      document.body.classList.remove("surtitre","surmenu");
      setTimeout(()=>{
        E.carte = N.cartes.find(c=>c.n==="01") || E.carte;
        E.lettresLues = [];
        rendre();
        document.body.classList.remove("surtitre","surmenu");
        let n=0;
        const t=setInterval(()=>{
          const p=document.querySelector("#pli-prof button"); if(p){p.click();return}
          document.body.click();
          if(++n>10){ clearInterval(t); setTimeout(()=>{
            const L=[];
            const q=s=>{const e=document.querySelector(s);return e?(e.innerText||"").replace(/\s+/g," ").trim():"-"};
            L.push("titre: "+q(".situ .t"));
            L.push("qui: "+q(".situ .parle"));
            L.push("expose: "+q(".situ .ex").slice(0,70));
            L.push("forces: "+Array.from(document.querySelectorAll(".poste .nm")).map(e=>e.textContent).join(", "));
            L.push("choix: "+Array.from(document.querySelectorAll(".tranche .choix .q")).map(e=>e.textContent.trim().slice(0,28)).join(" | "));
            const c=couverture("I");
            L.push("couverture niveau I : "+c.fait+"/"+c.tot+" ("+c.pct+"%)");
            L.push("erreurs="+(err.length?err.join("/"):"aucune"));
            const d=document.createElement("div"); d.id="sonde";
            d.textContent=L.join(" || ");
            document.body.appendChild(d);
          },400) }
        },240);
      },600);
    },300);
  },300);
})();

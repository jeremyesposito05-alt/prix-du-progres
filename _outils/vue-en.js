(function(){
  const st=document.createElement("style");
  st.textContent="*{transition:none !important;animation:none !important}";
  document.head.appendChild(st);
  setTimeout(()=>{ changerLangue("en");
    if(window.ECRAN === "tuto") setTimeout(()=>demarrer(), 250);
  }, 600);
})();

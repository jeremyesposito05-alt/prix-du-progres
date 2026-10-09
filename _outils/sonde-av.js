(function(){
  setTimeout(()=>nouvellePartie("campagne","I"), 60);
  setTimeout(()=>{
    const p = document.querySelector(".p-i");
    const L = [];
    if(!p){ L.push("pas de p-i") } else {
      p.style.transition = "none";
      p.querySelectorAll("*").forEach(x=>x.style.transition="none");
      p.classList.add("parle","dit-maintenant");
      L.push("classes=" + p.className);
      setTimeout(()=>{
        L.push("transf=" + getComputedStyle(p).transform);
        L.push("zindex=" + getComputedStyle(p).zIndex);
        const v = p.querySelector(".visage");
        L.push("bordure=" + (v?getComputedStyle(v).borderTopColor:"-"));
        L.push("reduce=" + matchMedia("(prefers-reduced-motion: reduce)").matches);
        const d = document.createElement("div");
        d.id = "sonde"; d.textContent = L.join(" | ");
        document.body.appendChild(d);
      }, 1200);
    }
  }, 2500);
})();

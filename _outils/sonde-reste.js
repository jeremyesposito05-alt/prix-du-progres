(function(){
  setTimeout(()=>{
    const manque = [];
    (function voir(x){
      if(typeof x === "string"){
        if(x.length > 18 && TRAD[x] === undefined) manque.push(x);
        return;
      }
      if(Array.isArray(x)) return x.forEach(voir);
      if(x && typeof x === "object" && x.constructor === Object)
        for(const k in x) voir(x[k]);
    })(NIVEAUX.I);
    const d=document.createElement("div"); d.id="sonde";
    d.textContent = manque.length + " chaines de prose non traduites :: "
      + manque.join(" :: ");
    document.body.appendChild(d);
  }, 400);
})();

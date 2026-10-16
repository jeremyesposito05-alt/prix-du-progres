changerLangue("en");
const o=document.createElement("div");o.id="sonde";
try{o.textContent="memorise="+localStorage.getItem("pdp_lang")}catch(e){o.textContent="stockage refuse"}
document.body.appendChild(o);

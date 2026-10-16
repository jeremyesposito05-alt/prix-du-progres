/* L ANGLAIS RESTAURE DEPUIS LE NAVIGATEUR, COMME UN ELEVE QUI REVIENT.
   On ne touche pas a LANG a la main : on ecrit la preference, puis on
   relit ce que le document en a fait. C est la seule facon de voir le
   defaut du chargement — celui que « changerLangue » masquait. */
const r = [];
r.push("LANG=" + LANG);
r.push("html lang=" + document.documentElement.lang);

const reg = document.querySelectorAll("header .regl i");
r.push("en-tete=" + [...reg].map(e => e.textContent).join(" / "));

const pied = document.querySelector("footer");
r.push("pied=" + (pied ? pied.innerText.replace(/\s+/g, " ").slice(0, 46) : "absent"));

/* Le libelle « Ouvrir » est ecrit par la feuille de style : on demande
   au navigateur ce qu il peint reellement. */
const st = document.createElement("style");
document.head.appendChild(st);
const d = document.createElement("div");
d.className = "carnet";
d.innerHTML = '<span class="pli"></span>';
document.body.appendChild(d);
const av = getComputedStyle(d.querySelector(".pli"), "::before").content;
r.push("bouton du carnet=" + av);
d.remove();

const o = document.createElement("div");
o.id = "sonde";
o.textContent = r.join(" || ");
document.body.appendChild(o);

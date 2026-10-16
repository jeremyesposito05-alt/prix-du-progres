/* LA PREMIERE LETTRE, EN ANGLAIS, TELLE QU ELLE S AFFICHE.
   On bascule la langue, on lance une partie, on ouvre la lettre, et on
   lit le texte rendu — pas le gabarit. Puis on cherche ce qui reste en
   francais, par des mots que l anglais ne contient jamais. */
LANG = "en";
try { localStorage.setItem("pdp-langue", "en") } catch(e) {}
nouvellePartie("campagne", "I");
if (typeof ouvrirLettre === "function") ouvrirLettre();

const r = [];
const pli = document.getElementById("pli-prof");
r.push("lettre ouverte=" + (pli ? "oui" : "NON"));

if (pli) {
  const t = pli.innerText.replace(/\s+/g, " ").trim();
  r.push("longueur=" + t.length);

  /* Des mots qui n existent qu en francais. Si l un apparait, un
     morceau a echappe au dictionnaire. */
  const pieges = ["Bonjour", "professeur", "Je vous glisserai", "lien avec le cours",
                  "À retenir", "À réviser", "J’ai compris", "Que décidez",
                  "votre", "vous", "nous", "cours"];
  const trouves = pieges.filter(m => t.indexOf(m) >= 0);
  r.push("restes francais=" + (trouves.length ? trouves.join(" / ") : "AUCUN"));
  r.push("TEXTE>>> " + t);
}


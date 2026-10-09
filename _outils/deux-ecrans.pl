#!/usr/bin/perl
# UN TOUR, DEUX ECRANS
#
#   perl _outils/deux-ecrans.pl index.html
#
# CE QUI N ALLAIT PAS, ET QUI N ETAIT PAS UN PROBLEME DE MINUTAGE. La
# consequence de la decision precedente, la lettre du tour suivant et
# la nouvelle affaire partageaient la MEME page. Trois consequences,
# toutes constatees a l'ecran :
#
#   — « on lit la lettre mais elle est pour le prochain ordre du jour,
#     or on pense que c'est une consequence de notre decision. »
#     Exact : rien ne disait ou finissait le passe.
#   — « l'ecran monte tout en haut, on ne voit plus les acteurs, il
#     faut descendre et c'est trop tard. » Le bandeau etait en haut,
#     les portraits qui tremblent en bas, et les deux ne tenaient pas
#     ensemble sur un portable.
#   — « la lettre apparait avant la fin, et derriere ca continue. »
#
# CE QU ON FAIT. Deux ecrans au lieu d'un.
#
#   ECRAN A — CE QUI EST ARRIVE : la meme scene, les memes quatre
#   portraits a leur place, qui avancent, reculent et tremblent. Au
#   centre, la consequence et la reponse qu'on a donnee. Les deux voix
#   retournent dans les BULLES — sur cet ecran, l'affaire du moment est
#   la decision qu'on vient de prendre. Un bouton pour continuer.
#
#   ECRAN B — L AFFAIRE DU JOUR : la nouvelle affaire s'ecrit, PUIS la
#   lettre arrive. Elle porte alors sur ce qu'on a sous les yeux.
#
# ON N AJOUTE RIEN, ON SEPARE. Mesure sur les trente cartes de
# Manchester : 678 caracteres sur un seul ecran aujourd'hui, 161 puis
# 517 demain. Et le bandeau disparait — ses cent vingt pixels etaient
# ce qui obligeait a faire defiler.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ---------- 1 · le bandeau disparait ----------

ech("js : la retombee n est plus un bandeau", <<'AV', <<'AP');
  if(!E || !E.consq || !d) return "";
  /* Les deux voix que cette décision a fait parler. Elles sont ici et
     non dans les bulles : autour de l'affaire du jour, elles auraient
     commenté une affaire qui n'est plus celle-là. */
  /* Chaque texte a son propre element : c'est « ecrire » qui les
     remplit, un par un, a la machine. */
  const voix = Object.keys(d.dit || {}).map(k => {
    const v = (d.e || {})[k] || 0;
    return `<span class="rt-v ${v>0?"gagne":"perd"}" data-attente="1">
      <b>${esc(N.forces[k].nom)}</b> <i class="rt-t">${esc(d.dit[k])}</i></span>`;
  }).join("");
  return `<div class="retombee">
    <div class="rt-tete">
      <span class="rt-k">Ce qui est arrivé</span>
      <p class="rt-x">${esc(E.consq)}</p>
    </div>
    ${voix ? `<div class="rt-voix">${voix}</div>` : ""}
  </div>`;
}
AV
  /* LE BANDEAU A ETE REMPLACE PAR UN ECRAN. Il partageait la page avec
     la nouvelle affaire : on ne savait plus ou finissait le passe, et
     ses cent vingt pixels repoussaient les portraits hors de l'ecran
     au moment meme ou ils reagissaient. Ce qui est arrivé a desormais
     sa page — « rendreConsequence » — et les deux voix sont retournees
     dans les bulles, ou elles sont a leur place. */
  return "";
}
AP

ech("js : le plateau ne porte plus le bandeau", <<'AV', <<'AP');
    ${retombee()}
    ${scene(c, `<div class="rep" ${D()}>
AV
    ${scene(c, `<div class="rep" ${D()}>
AP

# ---------- 2 · la scene sait montrer les deux moments ----------

ech("js : la scene prend un mode", <<'AV', <<'AP');
function scene(c, reponses){
  const vus = concernes(c);
  const d = dernierChoix();
  return `<div class="scene" data-phase="${d?"apres":"avant"}">
AV
/* « mode » vaut « consq » sur l'ecran de ce qui est arrive : meme
   scene, memes portraits aux memes places — c'est le centre qui
   change, et les bulles avec lui. */
function scene(c, reponses, mode){
  const vus = concernes(c);
  const d = dernierChoix();
  const cq = mode === "consq";
  return `<div class="scene" data-phase="${cq?"consq":(d?"apres":"avant")}">
AP

ech("js : le centre change de role", <<'AV', <<'AP');
      <div class="situ ordre dossier d-situation">
        <i class="encoche eg" aria-hidden="true"></i>
        <i class="encoche ed" aria-hidden="true"></i>
        <span class="onglet">Affaire du jour</span>
        <div class="t"></div>
        <div class="ex"></div>
        <div class="parle">${illuPersonne(c.qui)}<span>${esc(c.qui)}</span></div>
        <div class="d"></div>
      </div>
      <div class="question">Que décidez-vous ?</div>
      ${reponses}
AV
      <div class="situ ordre dossier ${cq?"d-consq":"d-situation"}">
        <i class="encoche eg" aria-hidden="true"></i>
        <i class="encoche ed" aria-hidden="true"></i>
        <span class="onglet">${cq?"Ce qui est arrivé":"Affaire du jour"}</span>
        <div class="t"></div>
        <div class="ex"></div>
        <div class="parle">${cq?`<span>Votre décision</span>`
          :`${illuPersonne(c.qui)}<span>${esc(c.qui)}</span>`}</div>
        <div class="d"></div>
      </div>
      ${cq?"":`<div class="question">Que décidez-vous ?</div>`}
      ${reponses}
AP

# ---------- 3 · l'acteur dit la reaction sur l'ecran de conséquence ----------

ech("js : sur l ecran de consequence, l acteur reagit", <<'AV', <<'AP');
  const avis = (E.carte && E.carte.av || {})[k];
  return { txt: avis || "",
           sens: (d && v) ? (v>0 ? "gagne" : (v<=-8 ? "perd-fort" : "perd")) : "attend" };
}
AV
  const sens = (d && v) ? (v>0 ? "gagne" : (v<=-8 ? "perd-fort" : "perd")) : "attend";
  /* Sur l'ecran de ce qui est arrive, l'affaire du moment EST la
     decision qu'on vient de prendre : la bulle porte la reaction. */
  if(E.montreConsq) return { txt: (d && d.dit || {})[k] || "", sens };
  const avis = (E.carte && E.carte.av || {})[k];
  return { txt: avis || "", sens };
}
AP

# ---------- 4 · le nouvel ecran ----------

ech("js : l ecran de ce qui est arrive", <<'AV', <<'AP');
function rendre(){
  remonter();
  const c=E.carte;
AV
/* L ECRAN DE CE QUI EST ARRIVE.
   La meme scene que l'affaire : memes portraits, memes places. Rien ne
   defile, rien n'est hors champ — on regarde qui a gagne et qui a
   perdu aussi longtemps qu'on veut. */
function rendreConsequence(){
  remonter();
  const c = E.carte, d = dernierChoix();
  let n = 0; const D = ()=>`style="--d:${(n += .085).toFixed(3)}s"`;
  app.innerHTML = `
  ${alerte()}
  <div class="bureau"><div class="plateau large">
    ${scene(c, `<div class="apres" ${D()}>
      <button class="plein" onclick="suiteApresConsq()">Affaire suivante</button>
    </div>`, "consq")}
    <div class="appoints" ${D()}>${courrier("")}${carnet("")}</div>
  </div></div>`;
  app.classList.remove("presse");
  document.body.style.setProperty("--age",
    Math.min(1, E.tour / (N.tours || 18)).toFixed(3));
  calerBulles();
  requestAnimationFrame(calerBulles);
  ecrire(c.t, E.consq || "", d ? d.q : "");
  try{ SON.majTension(); SON.papier() }catch(e){}
  majVue();
}

function rendre(){
  if(E && E.montreConsq) return rendreConsequence();
  remonter();
  const c=E.carte;
AP

# ---------- 5 · la boucle du tour ----------

ech("js : le tour passe par l ecran de consequence", <<'AV', <<'AP');
  const mort=CLES.find(k=>E.f[k]<=0);
  if(mort) return finir(mort);
  if(E.mode==="campagne"&&E.tour>=N.tours) return finir("verdict");
  const ev=evenementDu();
  if(ev) return declencher(ev);
  const gr=graineMure();
  if(gr) return germer(gr);
  const av=avertissementLecture();
  if(av) return germer(av);
  piocher(); rendre();
}
AV
  const mort=CLES.find(k=>E.f[k]<=0);
  if(mort) return finir(mort);
  /* On montre d'abord ce que la decision a produit. La suite — un
     courrier, une graine, la carte suivante — attend que le joueur
     ait regarde. */
  if(E.consq){ E.montreConsq = true; return rendre(); }
  return suiteApresConsq();
}

/* Le joueur a vu ce qui est arrive : on passe a l'affaire suivante. */
function suiteApresConsq(){
  E.montreConsq = false;
  E.consq = null;
  if(E.mode==="campagne"&&E.tour>=N.tours) return finir("verdict");
  const ev=evenementDu();
  if(ev) return declencher(ev);
  const gr=graineMure();
  if(gr) return germer(gr);
  const av=avertissementLecture();
  if(av) return germer(av);
  piocher(); rendre();
}
AP

# ---------- 6 · la lettre passe apres l'affaire ----------

ech("js : plus d etapes de retombee, la lettre suit l affaire", <<'AV', <<'AP');
  /* LA RETOMBEE PASSE DEVANT. Ce que la decision precedente a produit
     s'ecrit avant tout le reste : la phrase, puis les deux voix. La
     lettre n'arrivera qu'ensuite — elle n'attend plus un delai fixe,
     elle attend que ce soit lu. */
  const etapes = [];
  const rx = app.querySelector(".retombee .rt-x");
  if(rx && rx.textContent){
    etapes.push([[rx, rx.textContent, 11]]);
    const vs = [...app.querySelectorAll(".retombee .rt-v")];
    const lot = [];
    for(const v of vs){
      const el = v.querySelector(".rt-t");
      if(!el || !el.textContent) continue;
      lot.push([el, el.textContent, 9, v]);
      el.textContent = "";
    }
    if(lot.length) etapes.push(lot);
    rx.textContent = "";
  }
  /* C'est ici que la lettre s'ouvrira, une fois la retombee lue. */
  const pause = etapes.length;

  /* Chaque entrée : [où écrire, quoi, vitesse, la bulle à dévoiler]. */
  const ordre = [[t, titre, 15]];
  if(x && E.ecrit.ex) ordre.push([x, E.ecrit.ex, 4]);
  ordre.push([r, replique, 7]);
  etapes.push(ordre);
AV
  /* Chaque entrée : [où écrire, quoi, vitesse, la bulle à dévoiler]. */
  const etapes = [];
  const ordre = [[t, titre, 15]];
  if(x && E.ecrit.ex) ordre.push([x, E.ecrit.ex, 4]);
  if(replique) ordre.push([r, replique, 7]);
  etapes.push(ordre);

  /* LA LETTRE S OUVRE UNE FOIS L AFFAIRE ECRITE, pas avant. Elle porte
     alors sur ce qu'on a sous les yeux : impossible de la prendre pour
     la consequence de la decision precedente, qui a eu son ecran. */
  const pause = etapes.length;
AP

# ---------- 7 · le bouton se devoile comme les plaques ----------

ech("js : le bouton de suite se devoile aussi", <<'AV', <<'AP');
  for(const sel of [".scene .question", ".scene .rep"]){
    const el = app.querySelector(sel);
    if(el) el.dataset.attente = "1";
  }
AV
  for(const sel of [".scene .question", ".scene .rep", ".scene .apres"]){
    const el = app.querySelector(sel);
    if(el) el.dataset.attente = "1";
  }
AP

ech("js : et on le montre a la fin", <<'AV', <<'AP');
  for(const sel of [".scene .question", ".scene .rep"]){
    const el = app.querySelector(sel);
    if(!el) continue;
    delete el.dataset.attente;
    el.classList.add("montre");
  }
AV
  for(const sel of [".scene .question", ".scene .rep", ".scene .apres"]){
    const el = app.querySelector(sel);
    if(!el) continue;
    delete el.dataset.attente;
    el.classList.add("montre");
  }
AP

# ---------- 8 · l'habillage ----------

ech("css : l ecran de consequence et son bouton", <<'AV', <<'AP');
/* ---------- les trois choix : des plaques, pas des bulles ----------
AV
/* ---------- l'ecran de ce qui est arrive --------------------------
   Meme scene, meme centre, mais l'onglet est rouge et le bouton
   remplace les trois plaques : on ne decide pas, on constate. */
.d-consq{--ong:var(--rge)}
.d-consq .onglet{color:var(--rge)}
.d-consq .parle span{color:var(--rge)}
.centre .apres{display:flex; justify-content:center; margin:22px 0 0}
.centre .apres[data-attente]{opacity:0; pointer-events:none}
.centre .apres button{font-size:16px; padding:12px 26px}

/* ---------- la hauteur : les quatre acteurs doivent tenir ---------
   Sur un portable, le plateau depassait l'ecran et la reaction des
   portraits se jouait hors champ. Au-dessous de neuf cents pixels de
   haut, le cadre redevient carre et l'image se cale sur le haut :
   la tete reste, le bas part. */
@media(max-height:900px){
  .poste .visage{aspect-ratio:1/1}
  .poste .visage img{object-position:50% 16%}
}
@media(max-height:760px){
  .poste .visage{aspect-ratio:4/3}
  .poste .nm{font-size:13.5px}
  .scene{gap:10px 16px}
}

/* ---------- les trois choix : des plaques, pas des bulles ----------
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-54s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

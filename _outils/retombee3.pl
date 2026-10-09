#!/usr/bin/perl
# ON VOIT CE QU ON A FAIT AVANT QUE LA LETTRE ARRIVE
#
#   perl _outils/retombee3.pl index.html
#
# CE QUI N ALLAIT PAS. La lettre attendait deux secondes et deux
# dixiemes, fixees dans le CSS. Deux secondes pour lire une phrase de
# consequence ET deux repliques ET voir quatre portraits avancer,
# reculer et trembler : ce n'est pas assez, et surtout c'etait un
# nombre arbitraire qui ne savait rien de ce qu'il y avait a lire.
#
# CE QU ON FAIT. La retombee devient les deux PREMIERES etapes de la
# mise en scene : la phrase de consequence s'ecrit a la machine, puis
# les deux voix. La lettre n'arrive pas apres un delai, elle arrive
# QUAND C EST LU — et un clic abrege, comme partout ailleurs.
#
# L ordre d un tour devient : ce qui est arrive, qui l a dit, la
# lettre, l affaire, les quatre voix, les trois plaques.
#
# CONSEQUENCE TECHNIQUE. La lettre n'est plus posee par « rendre » et
# cachee par un delai : elle est INJECTEE au moment voulu. Une
# animation CSS part au rendu de l'element, pas a son apparition —
# cachee puis devoilee, elle se serait jouee dans le vide.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ---------- 1 · la retombee, ecrite a la machine ----------

ech("js : la retombee se prepare a etre ecrite", <<'AV', <<'AP');
  const voix = Object.keys(d.dit || {}).map(k => {
    const v = (d.e || {})[k] || 0;
    return `<span class="rt-v ${v>0?"gagne":"perd"}">
      <b>${esc(N.forces[k].nom)}</b> ${esc(d.dit[k])}</span>`;
  }).join("");
  return `<div class="retombee">
    <div class="rt-tete">
      <span class="rt-k">Ce qui est arrivé</span>
      <p>${esc(E.consq)}</p>
    </div>
    ${voix ? `<div class="rt-voix">${voix}</div>` : ""}
  </div>`;
AV
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
AP

ech("css : une voix attend son tour", <<'AV', <<'AP');
.retombee .rt-v b{color:var(--enc); font-weight:bold; margin-right:3px}
AV
.retombee .rt-v b{color:var(--enc); font-weight:bold; margin-right:3px}
.retombee .rt-t{font-style:normal}
.retombee .rt-v[data-attente]{opacity:0}
.retombee .rt-v{transition:opacity .25s ease}
AP

# ---------- 2 · les deux etapes en tete de la mise en scene ----------

ech("js : la retombee ouvre la mise en scene", <<'AV', <<'AP');
  /* Chaque entrée : [où écrire, quoi, vitesse, la bulle à dévoiler]. */
  const ordre = [[t, titre, 15]];
AV
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
AP

ech("js : les etapes suivantes s ajoutent a la suite", <<'AV', <<'AP');
  ordre.push([r, replique, 7]);
  const etapes = [ordre];
AV
  ordre.push([r, replique, 7]);
  etapes.push(ordre);
AP

ech("js : la scene retient ou s arreter", <<'AV', <<'AP');
  E.scene = { etapes, i:0 };
AV
  E.scene = { etapes, i:0, pause };
AP

ech("js : plus de depart conditionne a la lettre", <<'AV', <<'AP');
  t.textContent=""; if(x) x.textContent=""; r.textContent="";
  /* Si une lettre est encore a lire, on ne tape rien : sinon l'ordre
     du jour serait deja ecrit et les quatre voix dites quand le joueur
     refermerait la lettre. C'est « lettreLue » qui donnera le depart. */
  if(lettreAlire()) return;
  try{ SON.frappe(true) }catch(e){}
  jouerEtape();
AV
  t.textContent=""; if(x) x.textContent=""; r.textContent="";
  try{ SON.frappe(true) }catch(e){}
  jouerEtape();
AP

ech("js : la lettre s ouvre quand la retombee est lue", <<'AV', <<'AP');
function jouerEtape(){
  const s = E && E.scene;
  if(!s) return;
  if(s.i >= s.etapes.length){ try{ SON.frappe(false) }catch(e){} revelerChoix(); return; }
AV
function jouerEtape(){
  const s = E && E.scene;
  if(!s) return;
  /* Le courrier n'attend plus un delai fixe : il attend que ce qui
     vient d'arriver ait ete ecrit. */
  if(s.i === s.pause && lettreAlire() && !document.getElementById("pli-prof")){
    try{ SON.frappe(false) }catch(e){}
    ouvrirLettre();
    return;
  }
  if(s.i >= s.etapes.length){ try{ SON.frappe(false) }catch(e){} revelerChoix(); return; }
AP

# ---------- 3 · la lettre est injectee, non plus retardee ----------

ech("js : le plateau ne porte plus la lettre", <<'AV', <<'AP');
  ${pliProf()}
AV
AP

ech("js : la fonction qui pose la lettre", <<'AV', <<'AP');
function pliProf(){
  if(!lettreAlire()) return "";
AV
/* La lettre est POSEE au moment voulu, pas rendue d'avance puis
   cachee : une animation CSS part au rendu de l'element, et non a son
   apparition — cachee puis devoilee, elle se serait jouee dans le
   vide. */
function ouvrirLettre(){
  if(document.getElementById("pli-prof")) return;
  const html = pliProf();
  if(!html) return;
  const b = document.createElement("div");
  b.innerHTML = html;
  const el = b.firstElementChild;
  if(el) app.appendChild(el);
}

function pliProf(){
  if(!lettreAlire()) return "";
AP

ech("js : plus de delai fixe sur la lettre", <<'AV', <<'AP');
  /* Le temps de laisser les portraits reagir. Au tout premier tour il
     n'y a rien a regarder : elle vient presque tout de suite. */
  const retard = dernierChoix() ? "2.2s" : ".25s";
AV
  /* Plus de delai : la lettre n'est posee qu'au moment ou la retombee
     a fini de s'ecrire. Il reste un souffle pour que l'enveloppe ne
     saute pas a la figure. */
  const retard = ".2s";
AP

ech("js : refermer la lettre reprend la suite", <<'AV', <<'AP');
  /* la lecture commence maintenant, pas avant */
  if(E.scene && E.scene.i < E.scene.etapes.length){
    try{ SON.frappe(true) }catch(e){}
    jouerEtape();
  }
AV
  /* la suite reprend la ou la retombee s'etait arretee */
  if(E.scene && E.scene.i < E.scene.etapes.length){
    try{ SON.frappe(true) }catch(e){}
    setTimeout(jouerEtape, 280);
  }
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

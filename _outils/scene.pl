#!/usr/bin/perl
# LA SCENE : L ORDRE DU JOUR AU CENTRE, LES QUATRE ACTEURS AUTOUR
#
#   perl _outils/scene.pl index.html
#   perl _outils/scene.pl index-en.html en
#
# CE QUI CHANGE, ET POURQUOI
#
# Jusqu'ici les quatre acteurs etaient un tableau de jauges accroche au
# mur, au-dessus du bureau : des chiffres qui bougeaient. Leur avis
# n'existait qu'en texte, dans une bulle qu'il fallait aller cliquer
# apres avoir decide. Le joueur lisait beaucoup pour apprendre peu.
#
# Ils deviennent quatre personnages places aux quatre coins, autour de
# l'affaire du jour. Ils parlent tout le temps : avant la decision ils
# disent ce qu'ils attendent, apres ils disent ce qu'ils ont encaisse.
# Celui qui gagne AVANCE vers le joueur ; celui qui perd RECULE et
# tremble. On voit le dilemme au lieu de le lire.
#
# TROIS SUPPRESSIONS, qui sont le vrai allegement :
#   — le tableau des forces disparait : les quatre postes le portent, et
#     une seule representation vaut mieux que deux ;
#   — les chiffres ne sont plus affiches nulle part, ni sur les jauges ni
#     sur les boutons. L'eleve decide parce que c'est ce qu'il pense ;
#   — le rapport, le courrier et le carnet quittent la colonne de gauche
#     pour une bande discrete sous les reponses : ils restent
#     accessibles, ils ne disputent plus l'attention a l'affaire.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift or die "usage: scene.pl <jeu.html> [en]\n";
my $lg = shift // "fr";
open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
local $/; my $s = <$h>; close $h;
$s =~ s/\x0D\x0A/\n/g;

my @done;
sub swap {
  my ($nom, $av, $ap, $k) = @_;
  $k ||= 1;
  $av =~ s/\n\z//; $ap =~ s/\n\z//;   # jamais chomp : $/ vaut undef ici
  my $n = ($s =~ s/\Q$av\E/$ap/g);
  $n == $k or die "ARRET - $nom : $n fois au lieu de $k\n";
  push @done, $nom;
}

my $T = $lg eq "en"
  ? { aff=>"Case of the day", qui=>"What do you decide?",
      att=>"What they expect of you", app=>"The files" }
  : { aff=>"Affaire du jour", qui=>"Que d\x{E9}cidez-vous ?",
      att=>"Ce qu\x{2019}ils attendent de vous", app=>"Les dossiers" };

# ================================================================
# 1. LA FONCTION QUI PEINT LES QUATRE POSTES
# ================================================================
my $moteur = <<'JS';

/* ==================================================================
   LA SCENE — quatre acteurs autour de l'affaire du jour
   Chaque poste porte un visage, un nom, une jauge SANS CHIFFRE, et une
   bulle qui parle tout le temps : avant la decision ce qu'il attend,
   apres ce qu'il a encaisse.
   ================================================================== */

/* Qui est concerne par la carte du jour : un acteur qu'au moins une des
   reponses touche. On ne le dit pas au joueur — on fait seulement
   avancer un peu ceux qui ont quelque chose a perdre ou a gagner. */
function concernes(c){
  const s = new Set();
  for(const k of ["a","b","c"]){
    const ch = c && c[k];
    if(!ch || !ch.e) continue;
    for(const f of CLES) if(ch.e[f]) s.add(f);
  }
  return s;
}

/* Ce que l'acteur dit maintenant. Deux cas, jamais plus :
   — on vient de decider : il reagit, et sa raison est celle que porte
     la force (« pourquoi »), deja ecrite carte par carte ;
   — on n'a pas encore decide : il rappelle ce qu'il attend. */
function diraActeur(k){
  const d = dernierChoix();
  const v = d && d.e ? (d.e[k]||0) : 0;
  if(d && v){
    const logique = (N.forces[k].pourquoi || {})[v>0?"plus":"moins"] || "";
    return { txt: logique || (v>0 ? "Vous nous avez entendus." : "Nous n'oublierons pas."),
             sens: v>0 ? "gagne" : (v<=-8 ? "perd-fort" : "perd") };
  }
  return { txt: N.forces[k].veut, sens: "attend" };
}

function poste(k, c, vus){
  const v = E.f[k];
  const etat = v<=10 ? "critique" : v<=20 ? "danger" : v<=35 ? "fragile" : "";
  const mot  = v<=10 ? "au bord de la rupture" : v<=20 ? "ne tiendra pas longtemps"
             : v<=35 ? "fragile" : "";
  const dit  = diraActeur(k);
  const pres = vus.has(k) ? " concerne" : "";
  const col  = v>55?"var(--vert)" : v>35?"var(--accent)" : v>20?"#D08A2A" : "var(--rge)";
  return `<div class="poste p-${k} ${dit.sens}${pres} ${etat}">
    <div class="visage">
      <img src="img/acteurs/${N.id}-${k}.jpg" alt="" loading="lazy"
           onerror="this.remove()">
      <span class="jeton">${icone(k)}</span>
    </div>
    <div class="ident">
      <span class="nm">${esc(N.forces[k].nom)}</span>
      ${mot?`<span class="et">${mot}</span>`:""}
    </div>
    <div class="tige"><i style="width:${Math.max(3,v)}%;background:${col}"></i></div>
    <div class="dit"><span>${esc(dit.txt)}</span></div>
  </div>`;
}

function scene(c){
  const vus = concernes(c);
  const d = dernierChoix();
  return `<div class="scene" data-phase="${d?"apres":"avant"}">
    ${poste("i", c, vus)}
    ${poste("m", c, vus)}
    <div class="centre">
      <div class="ordre dossier d-situation">
        <span class="onglet">__AFF__</span>
        <div class="t"></div>
        <div class="ex"></div>
        <div class="parle">${illuPersonne(c.qui)}<span>${esc(c.qui)}</span></div>
        <div class="d"></div>
      </div>
      <div class="moi" aria-hidden="true"><span></span></div>
    </div>
    ${poste("o", c, vus)}
    ${poste("p", c, vus)}
  </div>`;
}
JS
$moteur =~ s/__AFF__/$T->{aff}/;
swap("la scene et ses quatre postes", "\nfunction rendre(){", "$moteur\nfunction rendre(){");

# ================================================================
# 2. « rendre » adopte la scene
# ================================================================
my $vieux = <<'OLD';
  app.innerHTML=`
  <div class="tableau" ${D()}>
    <span class="plaque">État des forces</span>
    ${barresForces()}
  </div>
  ${alerte()}
  <div class="bureau"><div class="plateau">
    <div class="col col-g">
      ${c.f?`<details class="dossier d-enquete ${guide?"guide":""}" ${D()}>
          <summary><span class="onglet">Rapport d’enquête</span>
            <span class="cq-txt">Le bureau d’enquête a joint une note.${
              invite?`<i class="invite">Le fait historique est dedans.</i>`:""}</span>
            <span class="pli"></span></summary>
          <div class="corps">${illuDoc(c)}${corpsRapport(c)}</div></details>`:""}
      ${courrier(D())}
    </div>
    <div class="col col-c">
      <div class="situ dossier d-situation" ${D()}>
        <span class="onglet">Affaire du jour</span>
        <div class="ct">Une nouvelle affaire vous arrive</div>
        <div class="t"></div>
        <div class="ex"></div>
        <div class="parle">${illuPersonne(c.qui)}<span>${esc(c.qui)}</span></div>
        <div class="d"></div></div>
    </div>
    <div class="col col-d">
      ${carnet(D())}
    </div>
    <div class="question" ${D()}>Que décidez-vous ?</div>
    <div class="rep ${trois.length===2?"deux":""}" ${D()}>
      ${trois.map(k=>`<button class="choix" onclick="choisir('${k}')">
        <span class="q">${esc(c[k].q)}</span><span class="impacts">${impacts(c[k].e)}</span></button>`).join("")}
    </div>
  </div></div>
  `;
OLD

my $neuf = <<'NEW';
  /* Les chiffres ne se montrent plus : l'eleve decide parce que c'est ce
     qu'il pense, pas parce qu'il a lu une flèche. Les dossiers passent
     sous les reponses : ils restent la, ils ne disputent plus
     l'attention a l'affaire du jour. */
  app.innerHTML=`
  ${alerte()}
  <div class="bureau"><div class="plateau large">
    ${scene(c)}
    <div class="question" ${D()}>__QUI__</div>
    <div class="rep ${trois.length===2?"deux":""}" ${D()}>
      ${trois.map(k=>`<button class="choix" onclick="choisir('${k}')">
        <span class="q">${esc(c[k].q)}</span></button>`).join("")}
    </div>
    <div class="appoints" ${D()}>
      ${c.f?`<details class="dossier d-enquete ${guide?"guide":""}">
          <summary><span class="onglet">Rapport d’enquête</span>
            <span class="cq-txt">Le bureau d’enquête a joint une note.${
              invite?`<i class="invite">Le fait historique est dedans.</i>`:""}</span>
            <span class="pli"></span></summary>
          <div class="corps">${illuDoc(c)}${corpsRapport(c)}</div></details>`:""}
      ${courrier("")}
      ${carnet("")}
    </div>
  </div></div>
  `;
NEW
$neuf =~ s/__QUI__/$T->{qui}/;
swap("rendre adopte la scene", $vieux, $neuf);

# ================================================================
# 3. L HABILLAGE
# ================================================================
my $css = <<'CSS';

/* ==================================================================
   LA SCENE — les quatre acteurs autour de l'affaire
   Trois colonnes, deux rangs : l'affaire tient la colonne du milieu sur
   toute la hauteur, les quatre acteurs occupent les coins. Celui qui
   gagne avance vers le centre, celui qui perd recule et tremble.
   ================================================================== */
.plateau.large{max-width:1180px}

.scene{
  display:grid; gap:12px 16px; align-items:stretch;
  grid-template-columns:minmax(0,1fr) minmax(0,1.6fr) minmax(0,1fr);
  grid-template-rows:auto auto;
  margin:0 0 18px;
}
.p-i{grid-area:1/1} .p-m{grid-area:1/3}
.p-o{grid-area:2/1} .p-p{grid-area:2/3}
.centre{grid-area:1/2/3/3; display:flex; flex-direction:column; gap:10px}

/* ---------- un poste d'acteur ---------- */
.poste{
  position:relative; display:flex; flex-direction:column; gap:6px;
  padding:10px 11px 11px; border-radius:3px;
  background:linear-gradient(176deg,var(--pap) 0%,var(--pap2) 100%);
  border:1px solid rgba(107,87,65,.3);
  box-shadow:0 2px 7px rgba(43,33,24,.17);
  transition:transform .42s cubic-bezier(.22,.9,.26,1),
             box-shadow .42s ease, filter .42s ease, opacity .42s ease;
  transform:scale(.975); opacity:.9;
}
/* Concerne par l'affaire : il se penche un peu, sans qu'on le dise. */
.poste.concerne{opacity:1}
.p-i.concerne,.p-o.concerne{transform:scale(1) translateX(5px)}
.p-m.concerne,.p-p.concerne{transform:scale(1) translateX(-5px)}

/* Il a gagne : il AVANCE vers le joueur. */
.poste.gagne{opacity:1; box-shadow:0 7px 010px rgba(43,33,24,.3), 0 0 0 1px rgba(63,106,46,.4)}
.p-i.gagne,.p-o.gagne{transform:scale(1.045) translateX(12px)}
.p-m.gagne,.p-p.gagne{transform:scale(1.045) translateX(-12px)}
.poste.gagne .visage{box-shadow:0 0 0 2px rgba(63,106,46,.55)}

/* Il a perdu : il RECULE, se ternit, et tremble une fois. */
.poste.perd{filter:saturate(.72) brightness(.97); opacity:.86}
.p-i.perd,.p-o.perd{transform:scale(.95) translateX(-7px)}
.p-m.perd,.p-p.perd{transform:scale(.95) translateX(7px)}
.poste.perd .visage{animation:trembler .5s ease-in-out 1}

.poste.perd-fort{filter:saturate(.5) brightness(.94); opacity:.84}
.p-i.perd-fort,.p-o.perd-fort{transform:scale(.93) translateX(-11px)}
.p-m.perd-fort,.p-p.perd-fort{transform:scale(.93) translateX(11px)}
.poste.perd-fort .visage{animation:trembler .42s ease-in-out 3}
.poste.perd-fort::after{
  content:""; position:absolute; inset:-1px; border-radius:3px;
  box-shadow:inset 0 0 0 1px rgba(166,48,36,.5); pointer-events:none;
}
@keyframes trembler{
  0%,100%{transform:translateX(0) rotate(0)}
  18%{transform:translateX(-3px) rotate(-.9deg)}
  38%{transform:translateX(3px) rotate(.9deg)}
  58%{transform:translateX(-2px) rotate(-.6deg)}
  78%{transform:translateX(2px) rotate(.4deg)}
}

/* ---------- le visage ---------- */
.poste .visage{
  position:relative; width:100%; aspect-ratio:1/1; max-height:124px;
  border-radius:2px; overflow:hidden; background:var(--pap2);
  border:1px solid rgba(107,87,65,.28);
  transition:box-shadow .42s ease;
}
.poste .visage img{width:100%;height:100%;object-fit:cover;display:block;
  filter:sepia(.14) contrast(1.03)}
.poste .visage .jeton{
  position:absolute; inset:0; display:flex; align-items:center;
  justify-content:center; opacity:.42;
}
.poste .visage img ~ .jeton{display:none}
.poste .visage svg{width:46%;height:46%}

.poste .ident{display:flex;flex-direction:column;gap:1px;line-height:1.2}
.poste .nm{font-family:var(--serif);font-size:15px;color:var(--enc)}
.poste .et{font-size:10.5px;color:var(--rge);letter-spacing:.03em}
.poste.critique .et{font-weight:bold}

/* la jauge, sans un chiffre */
.poste .tige{height:3px;border-radius:2px;background:rgba(107,87,65,.2);overflow:hidden}
.poste .tige i{display:block;height:100%;transition:width .6s ease}

/* ---------- ce qu'il dit ---------- */
.poste .dit{
  position:relative; margin-top:1px; padding:7px 9px; border-radius:2px;
  background:rgba(255,255,255,.5); border:1px solid rgba(107,87,65,.22);
  font-size:12.5px; line-height:1.4; color:var(--enc);
}
.poste .dit::before{
  content:""; position:absolute; top:-5px; left:12px; width:8px; height:8px;
  background:rgba(255,255,255,.5); border-left:1px solid rgba(107,87,65,.22);
  border-top:1px solid rgba(107,87,65,.22); transform:rotate(45deg);
}
.poste.gagne .dit{border-color:rgba(63,106,46,.4)}
.poste.perd .dit,.poste.perd-fort .dit{border-color:rgba(166,48,36,.35)}

/* ---------- le centre : l'affaire, et le joueur ---------- */
.centre .ordre{flex:1;display:flex;flex-direction:column}
/* Le joueur, personnifie : un sous-main vide au bas du centre, qui dit
   sans un mot que la place est la sienne. */
.centre .moi{
  height:9px; border-radius:0 0 3px 3px;
  background:linear-gradient(180deg,rgba(107,87,65,.3),rgba(107,87,65,.07));
  box-shadow:inset 0 1px 2px rgba(43,33,24,.2);
}
.centre .moi span{display:none}

/* ---------- les dossiers, en bande sous les reponses ---------- */
.appoints{
  display:flex; flex-wrap:wrap; gap:10px; margin-top:20px;
  padding-top:14px; border-top:1px solid rgba(107,87,65,.22);
}
.appoints > *{flex:1 1 220px; min-width:0}
.appoints .dossier{margin:0}

/* ---------- le telephone : une colonne, les acteurs en rang ---------- */
@media(max-width:860px){
  .scene{grid-template-columns:1fr;grid-template-rows:auto}
  .centre{grid-area:auto;order:-1}
  .p-i,.p-m,.p-o,.p-p{grid-area:auto}
  .scene{display:grid}
  .poste{flex-direction:row;align-items:center;gap:9px;transform:none!important}
  .poste .visage{width:58px;height:58px;max-height:58px;flex:0 0 58px;aspect-ratio:auto}
  .poste .ident{flex:0 0 92px}
  .poste .tige{display:none}
  .poste .dit{flex:1;margin:0}
  .poste .dit::before{top:12px;left:-5px;border:none;
    border-left:1px solid rgba(107,87,65,.22);border-bottom:1px solid rgba(107,87,65,.22)}
}
@media(prefers-reduced-motion:reduce){
  .poste,.poste .visage{transition:none;animation:none!important;transform:none!important}
}
CSS
my $ancre = "\n/* l'ordre du jour";
index($s, $ancre) >= 0 or die "ARRET : ancrage CSS introuvable\n";
$s =~ s/\Q$ancre\E/$css$ancre/;
push @done, "habillage de la scene";

open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";
print $o $s; close $o;
print "  $_\n" for @done;
printf "  %s : %d octets\n", $f, -s $f;

#!/usr/bin/perl
# LE MODELE DE LA PHOTO : CARTES D ACTEUR, CHOIX EN BANDEAU, ZOOM
#
#   perl _outils/tranche.pl index.html
#
# CE QUI CHANGE DANS LA STRUCTURE. Les trois choix sortent de la
# colonne du centre. Ils formaient une pile coincee entre les deux
# bulles du bas, et « calerBulles » passait son temps a leur reserver
# des marges ; ils deviennent un bandeau de trois plaques sous toute
# la scene. La colonne du centre ne porte plus que l'ordre du jour.
#
# Trois consequences, toutes bonnes : la pile de trois plaques
# (environ 200 px) devient une rangee (environ 95 px) ; l'ordre du
# jour recupere sa largeur entiere, sans encoches a reserver ; et la
# question « Que decidez-vous ? » devient une vraie bascule en travers
# de l'ecran, au lieu d'un titre coince dans une colonne.
#
# LES ACTEURS DEVIENNENT DES CARTES. Medaillon rond a gauche, nom et
# jauge a droite, sur une plaque sombre a filet d'or — les memes
# materiaux que les plaques de choix, de sorte que le plateau tient
# d'une seule matiere. La bulle se pose AU-DESSUS de la carte, la
# queue sur le medaillon : elle ne mord plus sur l'ordre du jour, donc
# les deux encoches qui lui reservaient la place n'ont plus lieu
# d'etre.
#
# LE ZOOM. Celui qui parle avance, et SON PORTRAIT se rapproche dans
# le medaillon. C'est un effet gratuit — une transformation sur
# l'image deja chargee — et c'est lui qui fait le gros plan.
#
# LA MACHINE A ECRIRE. Un curseur clignote au bout de la ligne en
# cours de frappe, et disparait des qu'elle est posee.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ================================================================= 1
# La structure : les choix sortent du centre.
ech("les choix sortent de la colonne du centre", <<'AV', <<'AP');
      ${cq?"":`<div class="question">Que décidez-vous ?</div>`}
      ${reponses}
      <div class="moi" aria-hidden="true"><span></span></div>
    </div>
    ${poste("o", c, vus)}
    ${poste("p", c, vus)}
  </div>`;
AV
      <div class="moi" aria-hidden="true"><span></span></div>
    </div>
    ${poste("o", c, vus)}
    ${poste("p", c, vus)}
  </div>
  <div class="tranche centre">
    ${cq?"":`<div class="question">Que décidez-vous ?</div>`}
    ${reponses}
  </div>`;
AP

# ================================================================= 2
# Les encoches n ont plus de raison d etre.
ech("plus rien a reserver dans l ordre du jour", <<'AV', <<'AP');
  /* Les trois reponses se serrent entre les deux bulles du bas. */
  if(rep){
    const ce = sc.querySelector(".centre").getBoundingClientRect();
    const bg = sc.querySelector(".p-o .dit"), bd = sc.querySelector(".p-p .dit");
    const g = bg ? Math.max(0, bg.getBoundingClientRect().right - ce.left + 14) : 0;
    const d = bd ? Math.max(0, ce.right - bd.getBoundingClientRect().left + 14) : 0;
    /* on ne laisse jamais moins de 260 px pour lire une reponse */
    const place = ce.width - g - d;
    const k = place < 260 ? Math.max(0, (ce.width - 260) / (g + d || 1)) : 1;
    rep.style.marginLeft  = Math.round(g * k) + "px";
    rep.style.marginRight = Math.round(d * k) + "px";
  }

  const r = ord.getBoundingClientRect();
AV
  /* LES BULLES NE MORDENT PLUS SUR L'ORDRE DU JOUR. Elles se posent
     au-dessus de la carte de leur acteur, dans la colonne laterale :
     il n'y a plus rien a reserver au texte, et les trois choix ne
     sont plus coinces entre elles puisqu'ils sont passes en bandeau
     sous la scene. La fonction se contente donc d'effacer ce que les
     versions precedentes avaient pose. */
  for(const e of sc.querySelectorAll(".encoche")) e.style.cssText = "";
  if(rep){ rep.style.marginLeft = rep.style.marginRight = "" }
  return;

  /* eslint-disable no-unreachable */
  const r = ord.getBoundingClientRect();
AP

# ================================================================= 3
# La grille : trois colonnes plus equilibrees, plateau plus large.
ech("le plateau et les colonnes au modele de la photo", <<'AV', <<'AP');
.plateau.large{max-width:1340px;margin:0 auto;grid-template-columns:minmax(0,1fr)}
AV
.plateau.large{max-width:1400px;margin:0 auto;grid-template-columns:minmax(0,1fr)}
AP

ech("les colonnes laterales portent des cartes, pas des medaillons", <<'AV', <<'AP');
  /* 1 / 1,6 / 1 sur 1340 px : la colonne du centre garde les 587 px
     qu'elle avait, au pixel pres — c'est elle qui decide du nombre de
     lignes, donc de la hauteur de la page. Tout le reste va aux
     medaillons. */
  grid-template-columns:minmax(0,1fr) minmax(0,1.6fr) minmax(0,1fr);
  grid-template-rows:auto auto;
  margin:0 0 4px;
  /* 282 px : le plus grand diametre tel que deux rangees tiennent
     encore dans la hauteur que la colonne du centre impose de toute
     facon. Mesure, pas choisi. */
  --rond:282px;
AV
  /* La colonne laterale ne porte plus un medaillon nu mais une carte
     — medaillon, nom et jauge cote a cote. Elle est donc plus large
     et bien moins haute : deux rangees de cartes font moins que deux
     rangees de medaillons, et l'ordre du jour garde sa largeur. */
  grid-template-columns:minmax(0,1fr) minmax(0,1.45fr) minmax(0,1fr);
  grid-template-rows:auto auto;
  margin:0 0 4px;
  --rond:150px;
AP

# ================================================================= 4
# Le poste devient une carte horizontale.
ech("le poste devient une carte horizontale", <<'AV', <<'AP');
.poste{
  /* z-index : sans lui, les deux postes du haut sont peints avant le
     centre — leurs bulles disparaissaient sous la feuille. */
  position:relative; z-index:3;
  display:flex; flex-direction:column; gap:5px;
  /* Plus de cadre de papier : le medaillon porte son propre bord, et
     les onze pixels de marge passent dans le diametre. */
  padding:0;
  width:min(100%,var(--rond));
  transition:transform .42s cubic-bezier(.22,.9,.26,1),
             filter .42s ease, opacity .42s ease;
  transform:scale(.975); opacity:.88;
}
/* chacun se range du cote de l'ordre du jour */
.p-i,.p-o{justify-self:end}
.p-m,.p-p{justify-self:start}
AV
.poste{
  /* z-index : sans lui, les deux postes du haut sont peints avant le
     centre — leurs bulles disparaissaient sous la feuille. */
  position:relative; z-index:3;
  /* Une carte : medaillon a gauche, nom et jauge a droite. Memes
     materiaux que les plaques de choix — plaque sombre, filet d'or —
     pour que le plateau tienne d'une seule matiere. */
  display:flex; flex-direction:row; align-items:center; gap:16px;
  padding:14px 20px 14px 14px; border-radius:6px; width:100%;
  background:linear-gradient(176deg,rgba(34,25,16,.93) 0%,rgba(17,12,7,.96) 100%);
  border:1px solid rgba(214,176,106,.22);
  box-shadow:0 6px 18px rgba(0,0,0,.42);
  transition:transform .42s cubic-bezier(.22,.9,.26,1),
             filter .42s ease, opacity .42s ease,
             border-color .42s ease, box-shadow .42s ease;
  transform:scale(.985); opacity:.9;
}
body[data-niveau="II"] .poste{
  background:linear-gradient(176deg,rgba(21,28,38,.93) 0%,rgba(11,15,22,.96) 100%);
  border-color:rgba(150,185,220,.22)}
AP

# ================================================================= 5
# Le medaillon dans la carte.
ech("le medaillon prend sa place dans la carte", <<'AV', <<'AP');
.poste .visage{
  position:relative; width:100%; aspect-ratio:1;
  border-radius:50%; overflow:hidden; background:var(--pap2);
  border:3px solid rgba(107,87,65,.4);
  box-shadow:0 6px 16px rgba(43,33,24,.3);
  transition:box-shadow .42s ease, border-color .42s ease;
}
AV
.poste .visage{
  position:relative; width:var(--rond); flex:0 0 var(--rond); aspect-ratio:1;
  border-radius:50%; overflow:hidden; background:var(--pap2);
  border:3px solid rgba(214,176,106,.3);
  box-shadow:0 5px 14px rgba(0,0,0,.45);
  transition:box-shadow .42s ease, border-color .42s ease;
}
body[data-niveau="II"] .poste .visage{border-color:rgba(150,185,220,.3)}
AP

ech("l image peut se rapprocher", <<'AV', <<'AP');
  filter:sepia(calc(.14 + var(--age,0) * .3))
AV
  transform-origin:50% 24%;
  filter:sepia(calc(.14 + var(--age,0) * .3))
AP

ech("la transition de l image accueille le zoom", <<'AV', <<'AP');
  transition:filter 1.2s ease}
AV
  transition:filter 1.2s ease, transform .55s cubic-bezier(.22,.9,.26,1)}
AP

# ================================================================= 6
# Le nom sort du medaillon et se pose a cote.
ech("le nom se pose a cote du medaillon", <<'AV', <<'AP');
/* Un cartouche, pas un voile : sur un atelier clair, un degrade ne
   tient pas. Le gain de place reste — il mord toujours sur le rond. */
.poste .ident{display:flex;flex-direction:column;gap:0;line-height:1.16;
  text-align:center;align-items:center;
  position:relative; z-index:2; margin-top:-36px; pointer-events:none;
  width:84%; margin-left:auto; margin-right:auto;
  padding:4px 10px 5px; border-radius:4px;
  background:linear-gradient(176deg,rgba(32,23,15,.93) 0%,rgba(18,12,7,.95) 100%);
  border:1px solid rgba(216,179,112,.34);
  box-shadow:0 4px 12px rgba(0,0,0,.5)}
body[data-niveau="II"] .poste .ident{
  background:linear-gradient(176deg,rgba(20,26,36,.93) 0%,rgba(12,16,23,.95) 100%);
  border-color:rgba(150,185,220,.32)}
AV
/* Le cartouche n'a plus lieu d'etre : la carte EST le fond sombre.
   Le nom se pose simplement a droite du medaillon. */
.poste .ident{display:flex;flex-direction:column;gap:1px;line-height:1.16;
  flex:1 1 auto; min-width:0; text-align:left; align-items:flex-start;
  pointer-events:none}
AP

ech("le nom prend la taille d un titre de carte", <<'AV', <<'AP');
.poste .nm{font-family:var(--serif);font-size:16.5px;color:#F2E7D2;
  letter-spacing:.01em; white-space:nowrap}
AV
.poste .nm{font-family:var(--serif);font-size:23px;color:#F2E7D2;
  letter-spacing:.01em; line-height:1.1}
AP

ech("la jauge prend la largeur du nom", <<'AV', <<'AP');
/* Elle passe DANS le cartouche : plus rien ne depasse du rond, et la
   rangee ne coute que les quelques pixels du bas de la plaque. */
.poste .tige{height:4px;border-radius:2px;width:84%;
  margin:-4px auto 0; position:relative; z-index:3;
  background:rgba(0,0,0,.5);overflow:hidden;
  box-shadow:0 0 0 1px rgba(0,0,0,.4)}
AV
.poste .tige{height:7px;border-radius:4px;width:100%;max-width:190px;
  margin:7px 0 0; background:rgba(0,0,0,.55);overflow:hidden;
  box-shadow:inset 0 1px 2px rgba(0,0,0,.6)}
AP

# ================================================================= 7
# La bulle passe au-dessus de la carte.
ech("la bulle se pose au-dessus de la carte", <<'AV', <<'AP');
.poste .dit{
  transition:opacity .25s ease;
  position:absolute; top:24%; z-index:6; width:200px;
  padding:9px 13px 10px; border-radius:15px;
  background:#FFFCF2; border:1.5px solid rgba(74,56,38,.6);
  box-shadow:0 7px 18px rgba(0,0,0,.42);
  font-size:13px; line-height:1.38; color:var(--enc);
}
.p-i .dit,.p-o .dit{left:calc(100% - 58px)}
.p-m .dit,.p-p .dit{right:calc(100% - 58px)}
/* la queue : deux triangles, le bord puis le papier */
.poste .dit::before,.poste .dit::after{
  content:""; position:absolute; width:0; height:0; border:10px solid transparent;
}
.poste .dit::before{top:13px}
.poste .dit::after{top:14px; border-width:9px}
.p-i .dit::before,.p-o .dit::before{left:-20px; border-right-color:rgba(74,56,38,.6)}
.p-i .dit::after,.p-o .dit::after{left:-17px; border-right-color:#FFFCF2}
.p-m .dit::before,.p-p .dit::before{right:-20px; border-left-color:rgba(74,56,38,.6)}
.p-m .dit::after,.p-p .dit::after{right:-17px; border-left-color:#FFFCF2}
AV
/* Elle se pose AU-DESSUS de la carte, la queue plantee sur le
   medaillon : elle ne passe plus sur l'ordre du jour, et on voit d'un
   coup d'oeil de quelle bouche elle sort. */
.poste .dit{
  transition:opacity .25s ease;
  position:absolute; bottom:calc(100% - 26px); top:auto; z-index:6;
  width:max-content; max-width:min(300px, 94%);
  padding:11px 15px 12px; border-radius:16px;
  background:#FFFCF2; border:1.5px solid rgba(74,56,38,.6);
  box-shadow:0 9px 22px rgba(0,0,0,.5);
  font-size:14.5px; line-height:1.36; color:var(--enc);
}
.p-i .dit,.p-o .dit{left:38px}
.p-m .dit,.p-p .dit{left:38px; right:auto}
/* la queue : deux triangles, le bord puis le papier, pointes vers le bas */
.poste .dit::before,.poste .dit::after{
  content:""; position:absolute; width:0; height:0; border:11px solid transparent;
}
.poste .dit::before{top:100%; left:26px; border-top-color:rgba(74,56,38,.6)}
.poste .dit::after{top:calc(100% - 3px); left:27px; border-width:10px;
  border-top-color:#FFFCF2}
AP

ech("les couleurs de queue suivent le bas de la bulle", <<'AV', <<'AP');
.poste.gagne .dit{border-color:rgba(63,106,46,.65)}
.p-i.gagne .dit::before,.p-o.gagne .dit::before{border-right-color:rgba(63,106,46,.65)}
.p-m.gagne .dit::before,.p-p.gagne .dit::before{border-left-color:rgba(63,106,46,.65)}
.poste.perd .dit,.poste.perd-fort .dit{border-color:rgba(166,48,36,.6)}
.p-i.perd .dit::before,.p-o.perd .dit::before,
.p-i.perd-fort .dit::before,.p-o.perd-fort .dit::before{border-right-color:rgba(166,48,36,.6)}
.p-m.perd .dit::before,.p-p.perd .dit::before,
.p-m.perd-fort .dit::before,.p-p.perd-fort .dit::before{border-left-color:rgba(166,48,36,.6)}
AV
.poste.gagne .dit{border-color:rgba(63,106,46,.65)}
.poste.gagne .dit::before{border-top-color:rgba(63,106,46,.65)}
.poste.perd .dit,.poste.perd-fort .dit{border-color:rgba(166,48,36,.6)}
.poste.perd .dit::before,.poste.perd-fort .dit::before{border-top-color:rgba(166,48,36,.6)}
AP

# ================================================================= 8
# Le zoom sur celui qui parle.
ech("celui qui parle est pris en gros plan", <<'AV', <<'AP');
.poste.parle{opacity:1}
.poste.dit-maintenant{z-index:7; opacity:1}
.poste.dit-maintenant .visage{border-color:rgba(216,179,112,.75);
  box-shadow:0 10px 26px rgba(43,33,24,.45), 0 0 0 4px rgba(216,179,112,.2)}
.p-i.dit-maintenant,.p-o.dit-maintenant{transform:scale(1.075) translateX(10px)}
.p-m.dit-maintenant,.p-p.dit-maintenant{transform:scale(1.075) translateX(-10px)}
AV
.poste.parle{opacity:1}
.poste.dit-maintenant{z-index:7; opacity:1;
  border-color:rgba(216,179,112,.6);
  box-shadow:0 14px 34px rgba(0,0,0,.55)}
.poste.dit-maintenant .visage{border-color:rgba(216,179,112,.85);
  box-shadow:0 8px 22px rgba(0,0,0,.5), 0 0 0 5px rgba(216,179,112,.18)}
/* LE GROS PLAN. Le portrait se rapproche dans son medaillon pendant
   qu'il parle : rien a charger, une transformation sur l'image qui
   est deja la. */
.poste.dit-maintenant .visage img{transform:scale(1.17)}
.p-i.dit-maintenant,.p-o.dit-maintenant{transform:scale(1.045) translateX(8px)}
.p-m.dit-maintenant,.p-p.dit-maintenant{transform:scale(1.045) translateX(-8px)}
AP

# ================================================================= 9
# Le bandeau des choix.
ech("les trois choix deviennent un bandeau", <<'AV', <<'AP');
.centre .question{margin:22px 0 10px;grid-column:auto}
/* Les marges gauche et droite sont posees par « calerBulles » : ce
   sont les deux bulles du bas qui disent de combien il faut se
   serrer. */
.centre .rep{grid-template-columns:minmax(0,1fr);gap:10px;margin:0;
  counter-reset:choix; transition:margin .3s ease}
AV
/* ---------- LE BANDEAU DES CHOIX ----------
   Sorti de la colonne du centre, il prend toute la largeur : trois
   plaques cote a cote au lieu d'une pile. Une rangee coute environ
   95 px de hauteur la ou la pile en coutait 200, et la question
   devient une vraie bascule en travers de l'ecran. */
.tranche{max-width:1400px; margin:16px auto 0}
.tranche .question{display:flex; align-items:center; gap:20px;
  margin:0 0 14px; grid-column:auto; white-space:nowrap}
.tranche .question::before,.tranche .question::after{
  content:""; flex:1 1 auto; height:1px; min-width:30px;
  background:linear-gradient(90deg,transparent,rgba(214,176,106,.55),transparent)}
.tranche .rep{display:grid; grid-template-columns:repeat(3,minmax(0,1fr));
  gap:14px; margin:0; counter-reset:choix}
@media(max-width:1000px){
  .tranche .rep{grid-template-columns:minmax(0,1fr)}
  .tranche .question{white-space:normal}
}
.centre .question{margin:22px 0 10px;grid-column:auto}
.centre .rep{grid-template-columns:minmax(0,1fr);gap:10px;margin:0;
  counter-reset:choix; transition:margin .3s ease}
AP

ech("une plaque de bandeau se lit de haut en bas", <<'AV', <<'AP');
.centre .choix{
  /* La regle generale des choix est en colonne : le jeton se posait
     au-dessus du texte au lieu d etre a sa gauche. */
  display:flex !important; flex-direction:row !important;
  align-items:center; gap:15px; text-align:left;
AV
/* Dans le bandeau, la plaque est plus haute que large : le jeton
   passe au-dessus du texte, et les trois se lisent d'un coup. */
.tranche .choix{
  align-items:flex-start !important;
  padding:16px 18px 18px !important;
  min-height:92px;
}
.tranche .choix .q{font-size:17px !important; line-height:1.34}
.centre .choix{
  /* La regle generale des choix est en colonne : le jeton se posait
     au-dessus du texte au lieu d etre a sa gauche. */
  display:flex !important; flex-direction:row !important;
  align-items:center; gap:15px; text-align:left;
AP

# ================================================================ 10
# Le curseur de la machine a ecrire.
ech("css : un curseur clignote au bout de la ligne en cours", <<'AV', <<'AP');
/* ---------- l'ecran de ce qui est arrive --------------------------
AV
/* ---------- LE CURSEUR DE LA MACHINE A ECRIRE ----------
   Il clignote au bout de la ligne qu'on est en train de frapper, et
   disparait des qu'elle est posee. C'est ce qui manquait au bruit de
   frappe : le son disait qu'on tapait, rien ne le MONTRAIT. */
.frappe::after{
  content:""; display:inline-block; vertical-align:-.14em;
  width:.46em; height:1.02em; margin-left:2px;
  background:currentColor; opacity:.8;
  animation:curseur .68s step-end infinite;
}
@keyframes curseur{50%{opacity:0}}
@media(prefers-reduced-motion:reduce){.frappe::after{animation:none;opacity:.5}}

/* ---------- l'ecran de ce qui est arrive --------------------------
AP

ech("js : la ligne en cours porte le curseur", <<'AV', <<'AP');
function taper(el, txt, ms, fin){
  let i=0;
  const id=setInterval(()=>{
    el.textContent = txt.slice(0, ++i);
    if(i>=txt.length){ clearInterval(id); if(fin) fin(); }
  }, ms);
  return id;
}
AV
function taper(el, txt, ms, fin){
  let i=0;
  /* une seule ligne porte le curseur a la fois */
  for(const e of app.querySelectorAll(".frappe")) e.classList.remove("frappe");
  el.classList.add("frappe");
  const id=setInterval(()=>{
    el.textContent = txt.slice(0, ++i);
    if(i>=txt.length){ clearInterval(id); el.classList.remove("frappe");
                       if(fin) fin(); }
  }, ms);
  return id;
}
AP

ech("js : poser une etape eteint le curseur", <<'AV', <<'AP');
function poserEtape(etape){
  for(const [el, txt, , b] of etape){
    el.textContent = txt;
AV
function poserEtape(etape){
  for(const e of app.querySelectorAll(".frappe")) e.classList.remove("frappe");
  for(const [el, txt, , b] of etape){
    el.textContent = txt;
AP

ech("js : arreter les machines eteint le curseur", <<'AV', <<'AP');
function stopperMachines(){
  if(E && E.machines) E.machines.forEach(clearInterval);
AV
function stopperMachines(){
  try{ for(const e of app.querySelectorAll(".frappe")) e.classList.remove("frappe") }
  catch(e){}
  if(E && E.machines) E.machines.forEach(clearInterval);
AP

# ================================================================ 11
# Le telephone.
ech("au telephone la carte garde sa forme, sans bulle au-dessus", <<'AV', <<'AP');
  .centre .question{order:1;margin:6px 0 2px}
  .centre .rep{order:2}
AV
  .tranche .question{order:1;margin:6px 0 2px;white-space:normal}
  .tranche .rep{order:2}
AP

ech("au telephone la pastille et la bulle reprennent leur place", <<'AV', <<'AP');
  .poste{width:auto}
  .poste .visage{width:62px;flex:0 0 62px;aspect-ratio:1;border-width:2px}
  .poste .ident{text-align:left;align-items:flex-start;
    margin-top:0;background:none;padding:0}
AV
  .poste{width:auto;padding:9px 11px}
  .poste .visage{width:62px;flex:0 0 62px;aspect-ratio:1;border-width:2px}
  .poste .ident{flex:0 0 96px}
  .poste .nm{font-size:15px}
  .poste .dit{position:relative;bottom:auto;max-width:none;width:auto}
  .poste .dit::before{top:16px;left:-19px;border-width:9px;
    border-top-color:transparent !important;
    border-right-color:rgba(74,56,38,.6) !important}
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-56s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

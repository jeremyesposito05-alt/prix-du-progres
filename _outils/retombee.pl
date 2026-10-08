#!/usr/bin/perl
# DEUX TROUS QUE LES NOUVELLES REPLIQUES ONT REVELES
#
#   perl _outils/retombee.pl index.html
#
# 1. LA CONSEQUENCE N'ETAIT AFFICHEE NULLE PART. Chaque reponse porte
#    une phrase qui dit ce qui arrive et qui le paie — quatre-vingt-dix
#    phrases ecrites avec les cartes. Elle etait montree par
#    « bulleForce », qui appartient a l'ancien panneau des forces : le
#    nouveau plateau ne l'appelle plus. Le joueur decidait donc sans
#    jamais apprendre ce que sa decision avait produit.
#    Elle revient en bandeau au-dessus de l'affaire du jour, nettement
#    separee : ce qui vient d'arriver n'est pas ce qui arrive.
#
# 2. LES ECRANS DE COURRIER MONTRAIENT ENCORE LES CHIFFRES. Le plateau
#    n'en montre plus aucun depuis la refonte, mais « barresForces »
#    affiche la valeur de chaque force sur 100, et le courrier s'en
#    sert. Les fleches et les mots — « gagne », « perd » — restent :
#    ce sont des resultats, pas des anticipations. Le chiffre, lui,
#    ramenait le jeu a un probleme d'optimisation.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ---------- 1 · la retombee ----------

ech("css : le bandeau de ce qui vient d arriver", <<'AV', <<'AP');
/* ==================================================================
   LE PLI DU PROFESSEUR
AV
/* ---------- ce que la decision precedente a produit ---------------
   Une bande etroite au-dessus de l'affaire du jour. Elle doit se lire
   comme un echo, pas comme une consigne : d'ou le filet rouge a
   gauche, le corps plus petit que l'expose, et la mention en capitales
   qui dit que c'est du passe. */
.retombee{
  display:flex; align-items:baseline; gap:14px; flex-wrap:wrap;
  margin:0 0 14px; padding:10px 15px; border-radius:2px;
  background:rgba(255,252,242,.86);
  border:1px solid rgba(107,87,65,.3); border-left:3px solid var(--rge);
  box-shadow:0 4px 12px rgba(43,33,24,.22);
  animation:retombe .45s ease-out;
}
@keyframes retombe{from{opacity:0;transform:translateY(-6px)}to{opacity:1;transform:none}}
.retombee .rt-k{
  flex:0 0 auto; font-size:10.5px; letter-spacing:.14em; text-transform:uppercase;
  color:var(--rge); font-weight:bold;
}
.retombee p{margin:0; flex:1 1 300px; font-size:14.5px; line-height:1.45; color:var(--enc)}
@media(max-width:600px){ .retombee{gap:5px} .retombee p{font-size:13.5px} }
@media(prefers-reduced-motion:reduce){ .retombee{animation:none} }

/* ==================================================================
   LE PLI DU PROFESSEUR
AP

ech("js : la retombee se rend avec le plateau", <<'AV', <<'AP');
function rendre(){
  remonter();
AV
/* CE QUE LA DECISION PRECEDENTE A PRODUIT.
   Il n'y a pas d'ecran de consequence dans ce jeu : on passe de la
   decision a l'affaire suivante. La phrase qui dit ce qui est arrive
   doit donc se lire ICI, sur le plateau suivant — sinon elle n'est
   jamais lue. */
function retombee(){
  if(!E || !E.consq || !dernierChoix()) return "";
  return `<div class="retombee">
    <span class="rt-k">Ce qui est arrivé</span>
    <p>${esc(E.consq)}</p>
  </div>`;
}

function rendre(){
  remonter();
AP

ech("js : le bandeau au-dessus de l affaire", <<'AV', <<'AP');
  <div class="bureau"><div class="plateau large">
    ${scene(c, `<div class="rep" ${D()}>
AV
  <div class="bureau"><div class="plateau large">
    ${retombee()}
    ${scene(c, `<div class="rep" ${D()}>
AP

# ---------- 2 · les chiffres des forces ----------

ech("js : les forces ne montrent leur chiffre qu a la fin", <<'AV', <<'AP');
function barresForces(){
  oublierSecousse();
AV
/* « chiffres » n'est vrai qu'a l'ecran de fin. Pendant la partie, le
   joueur decide parce que c'est ce qu'il pense, pas parce qu'il a lu
   un nombre — les fleches et les mots suffisent a dire ce qui vient
   de bouger. */
function barresForces(chiffres){
  oublierSecousse();
AP

ech("js : le nom sans sa valeur", <<'AV', <<'AP');
      <div class="nom">${N.forces[k].nom} <b>${Math.round(v)}</b></div>
AV
      <div class="nom">${N.forces[k].nom}${chiffres?` <b>${Math.round(v)}</b>`:""}</div>
AP

ech("js : seul l ecran de fin les demande", <<'AV', <<'AP');
    <span class="plaque">État des forces à la fin</span>
    ${barresForces()}
AV
    <span class="plaque">État des forces à la fin</span>
    ${barresForces(true)}
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-50s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

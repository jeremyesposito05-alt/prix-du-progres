#!/usr/bin/perl
# LA LETTRE NE PEUT PLUS DEPASSER L ECRAN
#
#   perl _outils/lettre-haute.pl index.html
#
# LE BLOCAGE. La lettre n avait aucune limite de hauteur. Centree dans
# un voile en position fixe, une lettre plus haute que la fenetre
# deborde des DEUX cotes : le haut sort au-dessus, le bas en dessous,
# et rien ne permet d atteindre le bouton. Comme le voile bloque les
# clics — a juste titre, sans quoi on deciderait derriere elle — la
# partie s arrete la.
#
# C est la premiere lettre qui l a revele : elle a recu avant-hier
# deux paragraphes de presentation, et elle est devenue la plus haute
# des soixante.
#
# TROIS VERROUS, DU PLUS SUR AU PLUS DOUX.
#   1. La lettre ne depasse jamais la fenetre : au-dela, elle defile.
#   2. Le bouton est colle en bas de la feuille. Il reste visible
#      pendant qu on fait defiler le texte : on ne peut pas le perdre.
#   3. La touche d echappement la ferme. Sur un ordinateur, c est la
#      sortie de secours ; sur tablette, les deux premiers suffisent.
#
# Et le voile se laisse parcourir, pour le cas ou un navigateur
# ancien ignorerait la hauteur maximale : rien de ce qui est affiche
# ne doit pouvoir devenir inatteignable.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("le voile se laisse parcourir", <<'AV', <<'AP');
.pli-prof{
  position:fixed; inset:0; z-index:60; display:flex;
  align-items:center; justify-content:center; padding:24px;
AV
.pli-prof{
  position:fixed; inset:0; z-index:60; display:flex;
  /* « center » seul fait deborder une lettre trop haute des DEUX
     cotes, haut compris, donc inatteignable. Les marges automatiques
     centrent tant qu'il y a la place et cedent quand il n'y en a
     plus. */
  align-items:flex-start; justify-content:center; padding:20px;
  overflow-y:auto; overscroll-behavior:contain;
AP

ech("la lettre ne depasse jamais la fenetre", <<'AV', <<'AP');
.lettre-prof{
  max-width:560px; width:100%;
AV
.lettre-prof{
  max-width:560px; width:100%;
  /* Elle ne peut plus etre plus haute que l'ecran : au-dela, c'est
     son texte qui defile, pas la page. */
  margin:auto; max-height:calc(100vh - 40px); overflow-y:auto;
  overscroll-behavior:contain;
AP

ech("le bouton reste colle en bas de la feuille", <<'AV', <<'AP');
.lettre-prof button{display:block;margin:0 auto}
AV
/* Colle en bas de la feuille : il reste visible pendant qu'on fait
   defiler le texte. L'ombre large lui fait un fond opaque de la
   couleur du papier, sinon les lignes passeraient derriere lui. */
.lettre-prof button{display:block; margin:10px auto 0;
  position:sticky; bottom:0; z-index:3;
  box-shadow:0 -10px 16px 12px var(--pap2)}
AP

ech("sur un ecran bas, la lettre se resserre", <<'AV', <<'AP');
@media(prefers-reduced-motion:reduce){
  .pli-prof .enveloppe{display:none}
}
AV
@media(prefers-reduced-motion:reduce){
  .pli-prof .enveloppe{display:none}
}
/* Un ecran bas : on rend a la lettre les pixels que les marges et
   les interlignes lui prenaient, avant de la faire defiler. */
@media(max-height:760px){
  .pli-prof{padding:10px}
  .lettre-prof{max-height:calc(100vh - 20px); padding:20px 24px 16px}
  .courrier-prof .cp-titre{margin-bottom:10px}
  .cp-ouverture{margin-bottom:11px; padding-bottom:9px}
  .cp-ouverture p{margin-bottom:6px}
  .cp-lien{margin-bottom:11px}
}
AP

ech("js : la touche d echappement ferme la lettre", <<'AV', <<'AP');
function ouvrirLettre(){
  if(document.getElementById("pli-prof")) return;
AV
/* SORTIE DE SECOURS. Rien de ce qui s'affiche ne doit pouvoir rendre
   la partie injouable. Si la lettre debordait malgre tout, la touche
   d'echappement la referme comme le bouton. */
addEventListener("keydown", e => {
  if(e.key === "Escape" && document.getElementById("pli-prof")) lettreLue();
});

function ouvrirLettre(){
  if(document.getElementById("pli-prof")) return;
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-48s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

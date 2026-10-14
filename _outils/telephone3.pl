#!/usr/bin/perl
# REPARATION + LA VRAIE CAUSE
#
#   perl _outils/telephone3.pl index.html
#
# DEUX CHOSES EN UNE.
#
# 1. REPARER. Un « perl -pe » ecrit a la hate a supprime le selecteur
#    « .scene{... » du bloc telephone : la ligne se terminait
#    exactement par le motif cherche. Le bloc commencait donc par une
#    declaration orpheline, ce qui invalide la media query entiere.
#    Rappel a moi-meme : les transformations de ce fichier passent par
#    un script, jamais par une ligne de commande.
#
# 2. CORRIGER. Mesure des styles calcules :
#
#       poste: display=grid cols=62px 0px
#
#    La deuxieme colonne de la carte valait ZERO. Ce n'etait donc pas
#    la bulle qui etait mal placee, c'est la carte entiere qui n'avait
#    pas de largeur. La scene porte « align-items:start », pose pour
#    sa grille de bureau ; en colonne flexible, « start » fait
#    retrecir chaque enfant a la largeur de son contenu. Les cartes
#    cessaient de prendre la largeur de l'ecran, et « minmax(0,1fr) »
#    n'avait plus rien a partager.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my $av = "\@media(max-width:860px){\n"
       . "    padding-top:0; --rond:62px}\n";

my $ap = "\@media(max-width:860px){\n"
       . "  /* « align-items:stretch » : la scene garde le « start » de sa\n"
       . "     grille de bureau, et en colonne cela fait retrecir chaque carte\n"
       . "     a la largeur de son contenu — la colonne du texte tombe alors a\n"
       . "     ZERO pixel et la bulle se replie en un mot par ligne. C'etait la\n"
       . "     vraie cause, trouvee en relevant les styles calcules de la\n"
       . "     carte : « cols=62px 0px ». */\n"
       . "  .scene{display:flex; flex-direction:column; gap:11px;\n"
       . "    align-items:stretch; padding-top:0; --rond:62px}\n";

my $n = () = ($s =~ /\Q$av\E/g);
$n == 1 or die "ARRET : ancre trouvee $n fois. Rien n'a ete ecrit.\n";
$s =~ s/\Q$av\E/$ap/;

# Controle : le bloc telephone doit etre syntaxiquement clos.
my $de = index($s, "\@media(max-width:860px){");
my ($prof, $i) = (0, $de);
while($i < length $s){
  my $c = substr($s, $i, 1);
  $prof++ if $c eq "{";
  if($c eq "}"){ $prof--; last if $prof == 0 }
  $i++;
}
$prof == 0 or die "ARRET : accolades desequilibrees dans le bloc telephone\n";
my $bloc = substr($s, $de, $i - $de);
$bloc =~ /\{\s*\n\s*[a-z-]+:/ and die "ARRET : declaration orpheline restante\n";

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "  ok  selecteur restaure et largeur corrigee (bloc de %d octets, accolades equilibrees)\n",
  length($bloc);

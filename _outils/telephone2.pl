#!/usr/bin/perl
# LA VRAIE CAUSE : LA CARTE N AVAIT PAS DE LARGEUR
#
#   perl _outils/telephone2.pl index.html
#
# Mesure des styles calcules, plutot qu une hypothese de plus :
#
#   poste: display=grid cols=62px 0px
#
# La deuxieme colonne de la carte valait ZERO. Ce n est donc pas la
# bulle qui etait mal placee — c est la carte entiere qui n avait pas
# de largeur, et tout ce qui vient apres le portrait se repliait dans
# rien.
#
# POURQUOI. La scene porte « align-items:start », pose pour sa grille
# de bureau. En telephone elle passe en colonne flexible, et « start »
# y signifie : chaque enfant se retrecit a la largeur de son contenu.
# Les cartes cessent donc de prendre la largeur de l ecran, et
# « minmax(0,1fr) » n a plus rien a partager.
#
# Une ligne suffit — mais il fallait la mesure pour la trouver, et
# deux hypotheses fausses sont tombees avant.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my $av = "  .scene{display:flex; flex-direction:column; gap:11px;\n"
       . "    padding-top:0; --rond:62px}\n";

my $ap = "  /* « align-items:stretch » : la scene garde le « start » de sa\n"
       . "     grille de bureau, et en colonne cela fait retrecir chaque carte\n"
       . "     a son contenu — la colonne du texte tombe alors a ZERO pixel et\n"
       . "     la bulle se replie en un mot par ligne. C'etait la vraie cause,\n"
       . "     trouvee en relevant les styles calcules : « cols=62px 0px ». */\n"
       . "  .scene{display:flex; flex-direction:column; gap:11px;\n"
       . "    align-items:stretch; padding-top:0; --rond:62px}\n";

my $n = () = ($s =~ /\Q$av\E/g);
$n == 1 or die "ARRET : ancre trouvee $n fois. Rien n'a ete ecrit.\n";
$s =~ s/\Q$av\E/$ap/;

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
print "  ok  les cartes reprennent la largeur de l'ecran\n";

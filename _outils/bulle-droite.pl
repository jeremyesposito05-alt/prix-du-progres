#!/usr/bin/perl
# LES BULLES DE DROITE S OUVRENT VERS L INTERIEUR
#
# Elles etaient calees a 38 px du bord GAUCHE de leur carte, comme
# celles de gauche. Pour la colonne de droite, cela les envoie vers le
# bord de la page : a 920 px, la bulle des clients finissait a 953 px
# pour une page de 920, et se faisait couper.
#
# Elles se calent desormais sur le bord DROIT de la carte et
# s'etendent vers l'ordre du jour. La queue reste a 26 px de leur bord
# gauche, c'est-a-dire sur le medaillon, puisque la bulle est plus
# large que la distance qui l'en separe.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $av = ".p-i .dit,.p-o .dit{left:38px}\n.p-m .dit,.p-p .dit{left:38px; right:auto}\n";
my $ap = ".p-i .dit,.p-o .dit{left:38px; right:auto}\n"
       . "/* colonne de droite : calee sur le bord droit de la carte, elle\n"
       . "   s'ouvre vers l'ordre du jour au lieu du bord de la page. */\n"
       . ".p-m .dit,.p-p .dit{right:0; left:auto}\n";
my $n = () = ($s =~ /\Q$av\E/g);
$n == 1 or die "ARRET : ancre trouvee $n fois\n";
$s =~ s/\Q$av\E/$ap/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
print "  ok  les bulles de droite s'ouvrent vers l'interieur\n";

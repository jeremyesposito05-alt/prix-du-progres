#!/usr/bin/perl
# ON ARRETE DE CONTOURNER « display:contents »
#
# Constat decisif : l ordre du jour mesure 461 x 247 px, se declare
# visible, contient son texte, repond a elementFromPoint — et un
# contour rouge pose dessus ne se voit NULLE PART. Il n est pas
# peint. C est le symptome de « display:contents » sur son parent,
# pose pour que les quatre cartes et l ordre du jour deviennent
# freres dans la colonne.
#
# Deux corrections ont deja echoue en essayant de le garder (z-index,
# puis plan propre). La troisieme le supprime : « .centre » redevient
# un bloc ordinaire, et c est LUI qui prend l ordre -2. Le resultat
# est le meme — ordre du jour en tete, puis les quatre cartes — sans
# la classe de problemes qu entraine un parent sans boite.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";

my $av = "  .scene > .centre{display:contents; margin-top:0}\n"
       . "  /* « display:contents » sur « .centre » supprime sa boite, donc le\n"
       . "     z-index qui tenait l'ordre du jour au-dessus du decor fixe. Il\n"
       . "     reprend son propre plan. */\n"
       . "  .centre .ordre{order:-2; position:relative; z-index:2}\n";

my $ap = "  /* Pas de « display:contents » ici : un parent sans boite ne peint\n"
       . "     plus ses enfants de maniere fiable — l'ordre du jour avait sa\n"
       . "     place, son texte et sa visibilite, et n'apparaissait pas a\n"
       . "     l'ecran. « .centre » reste un bloc, et c'est lui qui passe en\n"
       . "     tete de la colonne. */\n"
       . "  .scene > .centre{display:block; margin-top:0; order:-2;\n"
       . "    position:relative; z-index:2}\n";

my $n = () = ($s =~ /\Q$av\E/g);
$n == 1 or die "ARRET : ancre trouvee $n fois\n";
$s =~ s/\Q$av\E/$ap/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
print "  ok  le centre redevient un bloc\n";

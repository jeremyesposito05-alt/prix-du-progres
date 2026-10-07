#!/usr/bin/perl
# MELANGER LES REPONSES, PAS SEULEMENT LES QUESTIONS
#
#   perl _outils/melanger-reponses.pl index.html
#   perl _outils/melanger-reponses.pl index-en.html
#
# LE BUG. Les trente questions du jeu ont ete ecrites avec la bonne
# reponse en premier : « b:0 » trente fois sur trente. « melanger »
# existait deja, mais il ne brassait que le CHOIX des questions, jamais
# les reponses a l'interieur de chacune. Un eleve qui remarque la regle
# repond juste huit fois sur huit sans rien savoir du cours — et c'est
# justement la partie notee.
#
# LE CORRECTIF. « questionsDeLaPartie » rend desormais une COPIE de
# chaque question, dont les reponses sont tirees au sort et dont « b »
# suit sa reponse a sa nouvelle place. Une copie, parce que « N.quiz »
# est partage entre les parties : melanger l'original le melangerait une
# seconde fois a la partie suivante, et la reponse juste finirait par ne
# plus correspondre.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift or die "usage: melanger-reponses.pl <jeu.html>\n";
open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
local $/; my $s = <$h>; close $h;
$s =~ s/\x0D\x0A/\n/g;

my $vieux = "  melanger(lot);\n  return lot.slice(0, 8);\n}";

my $neuf = <<'JS';
  melanger(lot);

  /* LES REPONSES ELLES-MEMES. Les questions ont ete ecrites avec la
     bonne reponse en premier — b:0 partout. Sans ce melange, un eleve
     qui l'a remarque repond juste huit fois sur huit sans rien savoir.
     On rend une COPIE de chaque question : « N.quiz » est partage entre
     les parties, et melanger l'original le melangerait a nouveau a la
     partie suivante, jusqu'a ce que « b » ne designe plus rien. */
  return lot.slice(0, 8).map(q => {
    const juste = q.r[q.b];
    const r = q.r.slice();
    melanger(r);
    return Object.assign({}, q, { r, b: r.indexOf(juste) });
  });
}
JS
$neuf =~ s/\n\z//;

my $n = ($s =~ s/\Q$vieux\E/$neuf/g);
$n == 1 or die "ARRET - $f : l'ancrage a ete trouve $n fois au lieu de 1\n";

open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";
print $o $s; close $o;
printf "  %s corrige (%d octets)\n", $f, -s $f;

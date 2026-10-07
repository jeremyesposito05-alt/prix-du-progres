#!/usr/bin/perl
# EGALISER LA LONGUEUR DES REPONSES DU QUESTIONNAIRE
#
#   perl _outils/prompt-quiz.pl index.html _a-installer/quiz
#
# LE BIAIS, MESURE. La bonne reponse est la plus longue des trois dans
# 28 questions sur 30 — 93 % — et depasse les autres de 18,7 caracteres
# en moyenne. Melanger l'ordre, fait le 7 octobre, ne corrige donc rien :
# il suffit de prendre la plus developpee.
#
# La cause est naturelle a l'ecriture : on soigne la bonne reponse, qui
# doit etre exacte et complete, et on expedie les deux autres. Le
# resultat est un questionnaire qui se devine.
#
# CE QU ON DEMANDE. Non pas de raccourcir la bonne reponse — elle doit
# rester juste — mais de REECRIRE LES DEUX LEURRES pour qu'ils tiennent
# la meme longueur, et qu'ils restent plausibles : un leurre qu'on ecarte
# sans reflechir ne sert a rien non plus.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $src = shift or die "usage: prompt-quiz.pl <jeu.html> <dossier>\n";
my $dos = shift or die "usage: prompt-quiz.pl <jeu.html> <dossier>\n";
open(my $h, "<:encoding(UTF-8)", $src) or die "$src: $!";
local $/; my $s = <$h>; close $h;

my @q;
while($s =~ /q:"([^"]{10,})",\s*r:\s*\[([^\]]*)\],\s*b:\s*(\d+)/g){
  my ($txt, $bloc, $b) = ($1, $2, $3+0);
  my @r = $bloc =~ /"([^"]*)"/g;
  next unless @r >= 2;
  push @q, { q=>$txt, r=>\@r, b=>$b };
}
@q or die "ARRET : aucune question trouvee\n";

mkdir $dos unless -d $dos;
my $PAR = 10;
my $nbf = int((@q + $PAR - 1) / $PAR);

for my $i (0 .. $nbf-1){
  my $de = $i*$PAR;
  my $a  = $de + $PAR - 1; $a = $#q if $a > $#q;
  my $f = sprintf "%s/quiz-%02d.md", $dos, $i+1;
  open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";

  printf $o <<'TETE', $i+1, $nbf, $a-$de+1;
# Égaliser les leurres du questionnaire — partie %d sur %d (%d questions)

## Le problème, mesuré

Dans ce jeu d'histoire pour des élèves de 15 ans, chaque question a **trois réponses**
dont une seule est juste. Mesure faite sur les 30 questions : **la bonne réponse est la
plus longue dans 28 cas sur 30**, et dépasse les autres de **18,7 caractères** en moyenne.

Un élève qui connaît l'astuce — *prendre la réponse la plus développée* — réussit donc
presque tout sans rien savoir du cours. L'ordre des réponses est déjà tiré au sort : cela
ne suffit pas, puisque la longueur se voit quel que soit l'ordre.

## Ce que je te demande

Pour chaque question : **ne touche pas à la bonne réponse**, elle doit rester exacte.
**Réécris les deux leurres** pour qu'ils atteignent la même longueur.

## Six règles

1. **La bonne réponse est recopiée telle quelle.** Elle est marquée `JUSTE`.
2. **Les deux leurres doivent faire la même longueur que la bonne réponse, à dix
   caractères près.** Je vérifie ensuite par programme : au-delà, je redemande.
3. **Un leurre doit rester plausible.** Un élève qui n'a pas appris doit pouvoir y croire ;
   un élève qui a appris doit pouvoir l'écarter. Un leurre absurde ne sert à rien : il
   ramène la question à deux réponses.
4. **Un leurre est faux pour une raison précise** — il confond deux notions voisines, il
   déplace une date, il inverse une cause et sa conséquence. Pas simplement « le
   contraire ».
5. **Même vocabulaire, même ton que la bonne réponse.** Si elle dit « la machine qui
   démêle le coton », le leurre ne dit pas « la carde ». Aucun mot de métier sans son
   explication dans la phrase.
6. **N'emploie jamais le guillemet droit** `"` : il casserait le jeu.

## Comment répondre

Recopie le fichier entier en remplissant les lignes `>>`. Ne touche pas aux numéros entre
crochets ni à l'ordre.

---

TETE

  for my $n ($de .. $a){
    my $e = $q[$n];
    my $juste = $e->{r}[ $e->{b} ];
    my $lj = length $juste;
    printf $o "## Question %02d\n\n**%s**\n\n", $n+1, $e->{q};
    printf $o "JUSTE (%d caractères, à recopier) : %s\n\n", $lj, $juste;
    print  $o "Les deux leurres actuels, trop courts :\n";
    my $c = 0;
    for my $i (0 .. $#{$e->{r}}){
      next if $i == $e->{b};
      $c++;
      printf $o "- (%d car.) %s\n", length($e->{r}[$i]), $e->{r}[$i];
    }
    printf $o "\n**À réécrire — visez %d à %d caractères chacun :**\n\n",
      $lj-10 < 1 ? 1 : $lj-10, $lj+10;
    printf $o "[[Q%02d-JUSTE]]\n>> %s\n\n", $n+1, $juste;
    printf $o "[[Q%02d-LEURRE1]]\n>> \n\n", $n+1;
    printf $o "[[Q%02d-LEURRE2]]\n>> \n\n", $n+1;
    print  $o "---\n\n";
  }
  close $o;
}

printf "  %d questions, %d fichier(s) de %d dans %s\n", scalar(@q), $nbf, $PAR, $dos;

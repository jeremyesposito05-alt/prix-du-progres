#!/usr/bin/perl
# FINIR D EQUILIBRER LES LONGUEURS DU QUESTIONNAIRE
#
#   perl _outils/prompt-quiz2.pl index.html _a-installer/quiz/quiz-04.md
#
# POURQUOI UNE SECONDE PASSE. La premiere a supprime le defaut mesure —
# la bonne reponse etait la plus longue 28 fois sur 30, elle ne l'est
# plus que 4 fois. Mais en allongeant les leurres, on a bascule de
# l'autre cote : la bonne reponse est maintenant la PLUS COURTE une
# fois sur deux. Un eleve qui prendrait systematiquement la plus courte
# aurait 53 % au lieu des 33 % du hasard.
#
# Le questionnaire est devinable des qu'une regle de longueur, quelle
# qu'elle soit, designe la bonne reponse. Le but n'est donc pas
# « des leurres longs » mais « aucune regle » : un tiers de bonnes
# reponses les plus longues, un tiers au milieu, un tiers les plus
# courtes.
#
# Ce script choisit les questions a retoucher — celles ou la bonne
# reponse est la plus courte ET ou elle est assez longue pour qu'on
# puisse raccourcir les leurres sans les rendre telegraphiques — et
# ecrit la demande avec des fourchettes calculees.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $src = shift || "index.html";
my $out = shift || "_a-installer/quiz/quiz-04.md";

open(my $h, "<:raw", $src) or die "$src: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);

# ---------- relecture des trente questions ----------
my (@Q, $n);
while($s =~ /\r?\n q:"((?:[^"]|\\")*)",\r?\n r:\[(.*?)\],\r?\n b:(\d+)/gs){
  my ($quest, $bloc, $bonne) = ($1, $2, $3);
  my @t = $bloc =~ /"([^"]*)"/g;
  next unless @t == 3;
  $n++;
  my @l = map { length } @t;
  my $plus = grep { $_ > $l[$bonne] } @l;
  push @Q, { n=>$n, q=>$quest, r=>\@t, b=>$bonne, l=>\@l, rang=>$plus };
}
@Q == 30 or die "ARRET : $n questions relues, 30 attendues\n";

my %c; $c{$_->{rang}}++ for @Q;
printf "  depart : %d la plus longue · %d au milieu · %d la plus courte\n",
  ($c{0}||0), ($c{1}||0), ($c{2}||0);

# ---------- combien de questions faire basculer ----------
# On vise dix par case. Les candidates sont celles ou la bonne reponse
# est la plus courte ; on prend d'abord les plus longues en valeur
# absolue, parce que raccourcir un leurre de douze caracteres sur une
# reponse de quatre-vingts ne lui enleve rien, alors que sur une
# reponse de quinze cela n'a aucun sens.
my $vise = int(@Q / 3);
my $bouger = $vise - ($c{0}||0);
$bouger = 0 if $bouger < 0;

my @cand = sort { $b->{l}[$b->{b}] <=> $a->{l}[$a->{b}] }
           grep { $_->{rang} == 2 && $_->{l}[$_->{b}] >= 40 } @Q;
@cand >= $bouger or die "ARRET : $bouger a bouger, seulement "
  . scalar(@cand) . " question(s) assez longues\n";
my @choisies = sort { $a->{n} <=> $b->{n} } @cand[0 .. $bouger-1];

printf "  %d question(s) a retoucher pour arriver a %d/%d/%d\n",
  scalar(@choisies), $vise, $vise, @Q - 2*$vise;

# ---------- la demande ----------
open(my $o, ">:encoding(UTF-8)", $out) or die "$out: $!";
printf $o <<'TETE', scalar(@choisies);
# Raccourcir quelques leurres du questionnaire — dernière passe (%d questions)

## Ce qui s'est passé

Dans ce jeu d'histoire pour des élèves de 15 ans, chaque question a **trois réponses**
dont une seule est juste. La bonne réponse était la **plus longue** des trois dans 28 cas
sur 30 : un élève qui prenait la réponse la plus développée avait presque tout juste sans
rien savoir du cours.

Tu as allongé les leurres, et ce défaut-là a disparu. Mais le pendule est allé trop loin :
la bonne réponse est maintenant la **plus courte** une fois sur deux. C'est le même défaut
à l'envers — il suffit de prendre la réponse la plus brève.

## Ce que je te demande

Pour les questions ci-dessous seulement : **raccourcir les deux leurres** pour qu'ils
passent **en dessous** de la bonne réponse. Je donne une fourchette calculée pour chacun.

**Ne touche à rien d'autre.** Ni à la bonne réponse, ni aux autres questions.

## Cinq règles

1. **La bonne réponse est recopiée telle quelle.** Elle est marquée `JUSTE`.
2. **Chaque leurre doit tomber dans la fourchette indiquée.** Je vérifie par programme.
3. **Raccourcir, ce n'est pas tronquer.** Le leurre doit rester une phrase entière, lisible,
   et toujours plausible : un élève qui n'a pas appris doit pouvoir y croire.
4. **Un leurre reste faux pour une raison précise** — il confond deux notions voisines, il
   déplace une date, il inverse une cause et sa conséquence. Jamais « le contraire ».
5. **N'emploie jamais le guillemet droit** `"` : il casserait le jeu.

## Comment répondre

Recopie le fichier entier en remplissant les lignes `>>`. Ne touche pas aux numéros entre
crochets ni à l'ordre.

---

TETE

for my $q (@choisies){
  my $lj  = $q->{l}[$q->{b}];
  my $bas = $lj - 14; $bas = 6 if $bas < 6;
  my $ht  = $lj - 4;
  printf $o "## Question %02d\n\n**%s**\n\n", $q->{n}, $q->{q};
  printf $o "JUSTE (%d caractères, à recopier) : %s\n\n", $lj, $q->{r}[$q->{b}];
  print  $o "Les deux leurres actuels, trop longs :\n";
  for my $i (0..2){
    next if $i == $q->{b};
    printf $o "- (%d car.) %s\n", $q->{l}[$i], $q->{r}[$i];
  }
  printf $o "\n**À réécrire — visez %d à %d caractères chacun :**\n\n", $bas, $ht;
  printf $o "[[Q%02d-JUSTE]]\n>> \n\n", $q->{n};
  printf $o "[[Q%02d-LEURRE1]]\n>> \n\n", $q->{n};
  printf $o "[[Q%02d-LEURRE2]]\n>> \n\n", $q->{n};
  print  $o "---\n\n";
}
close $o;
printf "  ecrit : %s\n", $out;

#!/usr/bin/perl
# EGALISER LES LEURRES DU QUESTIONNAIRE
#
#   perl _outils/quiz-injecter.pl index.html fichier1.md fichier2.md ...
#
# LE DEFAUT CORRIGE. Mesure du 7 octobre : la bonne reponse est la plus
# longue 28 fois sur 30, et de 18,7 caracteres en moyenne. Melanger
# l'ordre ne change rien — la longueur se voit quel que soit le rang.
# Un eleve qui prend la reponse la plus developpee avait donc 28 points
# sur 30 sans rien savoir.
#
# CE QUE CE SCRIPT REFUSE D'ECRIRE :
#   — une bonne reponse modifiee (elle doit etre recopiee telle quelle) ;
#   — un leurre absent d'index.html, ou present deux fois ;
#   — un guillemet droit, qui casserait la chaine JavaScript ;
#   — un leurre qui s'ecarte de plus de dix caracteres de la bonne ;
#   — deux leurres identiques, ou un leurre egal a la bonne reponse.
# Tout est verifie AVANT la premiere ecriture : au moindre ecart, rien
# n'est touche.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $cible = shift or die "usage: quiz-injecter.pl <index.html> <*.md>\n";
my @md = @ARGV or die "usage: quiz-injecter.pl <index.html> <*.md>\n";

open(my $h, "<:raw", $cible) or die "$cible: $!";
my $jeu = do { local $/; <$h> }; close $h;
utf8::decode($jeu);

# ---------- lecture des fichiers rendus ----------
my @Q;
for my $f (@md){
  open(my $m, "<:encoding(UTF-8)", $f) or die "$f: $!";
  my $t = do { local $/; <$m> }; close $m;
  my @bouts = split /^## Question /m, $t;
  shift @bouts;                                  # l'en-tete
  for my $b (@bouts){
    my ($n) = $b =~ /^(\d+)/ or die "ARRET - $f : numero de question illisible\n";
    my ($ref) = $b =~ /^JUSTE \(\d+ caract\x{E8}res, \x{E0} recopier\) : (.+?)$/m
      or die "ARRET - $f, question $n : ligne JUSTE de reference introuvable\n";
    my @vieux = $b =~ /^- \(\d+ car\.\) (.+?)$/mg;
    @vieux == 2 or die "ARRET - $f, question $n : "
      . scalar(@vieux) . " ancien(s) leurre(s), 2 attendus\n";
    my %rep;
    while($b =~ /^\[\[Q\d+-(JUSTE|LEURRE1|LEURRE2)\]\]\s*\n>>\s*(.+?)\s*$/mg){
      $rep{$1} = $2;
    }
    for my $k (qw(JUSTE LEURRE1 LEURRE2)){
      exists $rep{$k} or die "ARRET - $f, question $n : $k non rempli\n";
    }
    push @Q, { n=>$n, fichier=>$f, ref=>$ref, vieux=>\@vieux,
               juste=>$rep{JUSTE}, neufs=>[ $rep{LEURRE1}, $rep{LEURRE2} ] };
  }
}
printf "  %d questions lues dans %d fichier(s)\n", scalar(@Q), scalar(@md);

# ---------- verifications, toutes avant la premiere ecriture ----------
my @mal;
my $AVANT_PLUS_LONGUE = 0;
for my $q (@Q){
  my $ou = sprintf "question %s", $q->{n};

  # 1 · la bonne reponse n'a pas bouge
  push @mal, "$ou : la bonne reponse a ete reecrite\n"
           . "        attendu : $q->{ref}\n        rendu   : $q->{juste}"
    if $q->{juste} ne $q->{ref};

  # 2 · elle est bien dans le jeu, une seule fois
  my $nj = () = ($jeu =~ /\Q"$q->{ref}"\E/g);
  push @mal, "$ou : la bonne reponse apparait $nj fois dans le jeu (1 attendue)"
    if $nj != 1;

  # 3 · chaque ancien leurre est la, une seule fois
  for my $v (@{$q->{vieux}}){
    my $nv = () = ($jeu =~ /\Q"$v"\E/g);
    push @mal, "$ou : l'ancien leurre apparait $nv fois (1 attendue)\n        « $v »"
      if $nv != 1;
  }

  # 4 · les nouveaux leurres tiennent les regles
  my $lj = length $q->{ref};
  $AVANT_PLUS_LONGUE++ if $lj > length($q->{vieux}[0]) && $lj > length($q->{vieux}[1]);
  for my $i (0,1){
    my $t = $q->{neufs}[$i];
    my $nom = "$ou, leurre " . ($i+1);
    push @mal, "$nom : guillemet droit — il casserait le jeu"      if $t =~ /"/;
    push @mal, "$nom : vide"                                        if $t !~ /\S/;
    my $e = abs(length($t) - $lj);
    push @mal, sprintf("%s : %d caracteres contre %d — ecart de %d, dix au plus\n        %s",
                       $nom, length($t), $lj, $e, $t)               if $e > 10;
    push @mal, "$nom : identique a la bonne reponse"                if $t eq $q->{ref};
  }
  push @mal, "$ou : les deux leurres sont identiques"
    if $q->{neufs}[0] eq $q->{neufs}[1];
}

if(@mal){
  print "\n  REFUS — rien n'a ete ecrit :\n";
  print "    · $_\n" for @mal;
  die sprintf "\n  %d probleme(s) sur %d questions.\n", scalar(@mal), scalar(@Q);
}

# ---------- ecriture ----------
for my $q (@Q){
  for my $i (0,1){
    my ($v, $n) = ($q->{vieux}[$i], $q->{neufs}[$i]);
    $jeu =~ s/\Q"$v"\E/"$n"/;
  }
}
utf8::encode($jeu);
open(my $o, ">:raw", $cible) or die "$cible: $!";
print $o $jeu; close $o;

# ---------- ce que cela change, mesure ----------
my $apres = 0; my ($somme_av, $somme_ap) = (0, 0);
for my $q (@Q){
  my $lj = length $q->{ref};
  my @av = map { length } @{$q->{vieux}};
  my @ap = map { length } @{$q->{neufs}};
  $apres++ if $lj > $ap[0] && $lj > $ap[1];
  $somme_av += $lj - ($av[0] > $av[1] ? $av[0] : $av[1]);
  $somme_ap += $lj - ($ap[0] > $ap[1] ? $ap[0] : $ap[1]);
}
printf "\n  ecrit · %d questions, %d leurres remplaces\n", scalar(@Q), 2*scalar(@Q);
printf "  la bonne reponse est la plus longue : %d/%d  ->  %d/%d\n",
  $AVANT_PLUS_LONGUE, scalar(@Q), $apres, scalar(@Q);
printf "  avance moyenne de la bonne reponse  : %+.1f  ->  %+.1f caracteres\n",
  $somme_av/scalar(@Q), $somme_ap/scalar(@Q);

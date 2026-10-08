#!/usr/bin/perl
# LIRE ET CONTROLER LES TRENTE CARTES RENDUES
#
#   perl _outils/cartes-lire.pl _a-installer/refonte/situations.tsv fichier*.md
#
# Deux choses a la fois.
#
# 1. CONTROLER. Les neuf regles de la demande sont verifiables : pas de
#    guillemet droit, un seul gras et seulement dans la lettre, le mot
#    du cours bien present, deux phrases pour la situation, dix mots
#    pour une reponse. Ce qui casserait le jeu est bloquant ; ce qui ne
#    fait que s'ecarter d'une consigne est signale.
#
# 2. LIRE LE GAGNANT ET LE PERDANT. La demande imposait que chaque
#    consequence dise « ce qui arrive, en disant le gagnant et le
#    perdant ». Si c'est tenu, les effets sur les quatre forces se
#    deduisent du texte au lieu d'etre inventes — et le jeu ne peut
#    plus contredire sa propre prose. Ce script mesure si c'est tenu.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $tsv = shift or die "usage: cartes-lire.pl <situations.tsv> <*.md>\n";
my @md  = @ARGV or die "usage: cartes-lire.pl <situations.tsv> <*.md>\n";

# ---------- le cours : quel mot chaque situation doit porter ----------
my %mot;
open(my $t, "<:encoding(UTF-8)", $tsv) or die "$tsv: $!";
while(my $l = <$t>){
  next if $l =~ /^#/; chomp $l; next unless length $l;
  my @f = split /\t/, $l; next unless @f >= 7;
  $mot{$f[0]} = $f[3];
}
close $t;

# ---------- lecture ----------
my (%C, @ordre);
for my $f (@md){
  open(my $m, "<:encoding(UTF-8)", $f) or die "$f: $!";
  my $s = do { local $/; <$m> }; close $m;
  while($s =~ /^\[\[(\d+)-([A-Z]+)\]\]\s*\n>>\s*(.*?)\s*$/mg){
    my ($n, $cle, $txt) = ($1, $2, $3);
    push @ordre, $n unless exists $C{$n};
    $C{$n}{$cle} = $txt;
  }
}
my @CLES = qw(LETTRE TITRE SITUATION QUI REPLIQUE
              REPONSEA CONSEQUENCEA REPONSEB CONSEQUENCEB REPONSEC CONSEQUENCEC);
printf "  %d situations lues dans %d fichier(s)\n\n", scalar(@ordre), scalar(@md);

# ---------- les quatre groupes, tels qu'ils se nomment dans le texte ----------
my %GRP = (
  i => qr/industriel|fabricant|filateur|patron/i,
  o => qr/ouvri|fileus|tisserand|travailleur|enfant/i,
  m => qr/marchand|n\x{E9}gociant|commer\x{E7}ant/i,
  p => qr/parlement|londres|\x{C9}tat|autorit\x{E9}|inspecteur/i,
);
my @BASCULE = (qr/\bmais\b/i, qr/\ben revanche\b/i, qr/\btandis que\b/i,
               qr/\bau prix d/i, qr/\bcependant\b/i, qr/\bpourtant\b/i);

sub camps {
  my ($txt) = @_;
  my ($av, $ap) = ($txt, "");
  for my $b (@BASCULE){
    if($txt =~ /$b/){ ($av, $ap) = ($`, $'); last }
  }
  my (@g, @pe);
  for my $k (sort keys %GRP){
    push @g,  $k if $av =~ $GRP{$k};
    push @pe, $k if $ap =~ $GRP{$k} && !grep { $_ eq $k } @g;
  }
  return (\@g, \@pe, $ap ne "");
}

# ---------- controles ----------
my (@bloquant, @signale, $lisibles, $total);
for my $n (@ordre){
  my $c = $C{$n};
  for my $k (@CLES){
    push @bloquant, "situation $n : $k manquant" unless defined $c->{$k} && $c->{$k} =~ /\S/;
  }
  next unless keys %$c == 11;

  for my $k (@CLES){
    push @bloquant, "situation $n, $k : guillemet droit" if $c->{$k} =~ /"/;
    my $g = () = ($c->{$k} =~ /\*\*/g);
    push @bloquant, "situation $n, $k : $g asterisques doubles, nombre impair"
      if $g % 2;
    push @signale, "situation $n, $k : du gras hors de la lettre"
      if $g && $k ne "LETTRE";
  }
  my $gl = () = ($c->{LETTRE} =~ /\*\*/g);
  push @signale, "situation $n : la lettre porte " . ($gl/2) . " gras, un seul attendu"
    if $gl != 2;
  if(defined $mot{$n} && $c->{LETTRE} !~ /\*\*\Q$mot{$n}\E\*\*/i){
    push @signale, "situation $n : le mot du cours « $mot{$n} » n'est pas le mot en gras";
  }

  my $mt = () = ($c->{TITRE} =~ /\S+/g);
  push @signale, "situation $n : titre de $mt mots, huit au plus" if $mt > 8;
  my $ph = () = ($c->{SITUATION} =~ /[.!?](?:\s|$)/g);
  push @signale, "situation $n : situation en $ph phrases, deux au plus" if $ph > 2;
  my $ml = () = ($c->{LETTRE} =~ /\S+/g);
  push @signale, "situation $n : lettre de $ml mots, quatre-vingts au plus" if $ml > 80;
  push @signale, "situation $n : « qui » sans fonction (pas de virgule)"
    if $c->{QUI} !~ /,/;
  for my $k (qw(A B C)){
    my $mr = () = ($c->{"REPONSE$k"} =~ /\S+/g);
    push @signale, "situation $n, reponse $k : $mr mots, dix au plus" if $mr > 10;
  }

  # --- le gagnant et le perdant ---
  for my $k (qw(A B C)){
    $total++;
    my ($g, $pe, $bascule) = camps($c->{"CONSEQUENCE$k"});
    if(@$g && @$pe){ $lisibles++ }
    else {
      push @signale, sprintf("situation %s, consequence %s : gagnant/perdant illisible%s\n"
             . "        %s", $n, $k, $bascule ? "" : " (pas de « mais »)",
             $c->{"CONSEQUENCE$k"});
    }
  }
}

# ---------- rapport ----------
if(@bloquant){
  print "  BLOQUANT — le jeu ne le supporterait pas :\n";
  print "    · $_\n" for @bloquant;
  print "\n";
}
if(@signale){
  printf "  A REGARDER — %d ecart(s) aux consignes :\n", scalar(@signale);
  print "    · $_\n" for @signale;
  print "\n";
}
printf "  gagnant et perdant lisibles dans %d consequences sur %d (%.0f %%)\n",
  $lisibles, $total, 100*$lisibles/$total;
print  "\n  Aucun blocage : les cartes peuvent entrer dans le jeu.\n" unless @bloquant;
exit(@bloquant ? 1 : 0);

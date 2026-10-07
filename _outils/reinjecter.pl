#!/usr/bin/perl
# REMETTRE LES TRADUCTIONS À LEUR PLACE
#
#   perl reinjecter.pl <jeu.html> <dossier> <sortie.html>
#
# L'extraction a relevé, pour chaque chaîne, sa position exacte. Il n'y
# a donc rien à reconnaître ici : on coupe et on recolle aux octets
# près, en partant de la fin pour que les positions déjà relevées ne
# bougent pas.
#
# Rien n'est écrit tant que tout n'est pas vérifié :
#   — à chaque position doit se trouver exactement le texte français
#     relevé lors de l'extraction, sinon le jeu a changé depuis et la
#     traduction ne lui correspond plus ;
#   — une traduction contenant un guillemet droit casserait le code ;
#   — une traduction vide laisse simplement le français en place.
use strict; use warnings; use utf8;

my ($src, $dos, $out) = @ARGV;
$src && $dos && $out or die "usage: reinjecter.pl <jeu.html> <dossier> <sortie.html>\n";

# ---- ce que l'extraction avait relevé -------------------------------------
my @lot;
open(my $m, "<:encoding(UTF-8)", "$dos/source.tsv") or die "$dos/source.tsv: $!";
while(<$m>){
  next if /^#/; chomp; next unless length;
  my ($n, $deb, $len, $champ, $fr) = split /\t/, $_, 5;
  next unless defined $fr;
  push @lot, { n=>$n+0, deb=>$deb+0, len=>$len+0, champ=>$champ, fr=>$fr };
}
close $m;
@lot or die "ARRET : source.tsv est vide\n";

# ---- les traductions -------------------------------------------------------
my (%en, $lignes);
for my $f (sort glob("$dos/*.md")){
  open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
  my $n;
  while(my $l = <$h>){
    chomp $l;
    if($l =~ /^\s*\[\[(\d+)\]\]\s*$/){ $n = $1+0; next }
    if(defined $n && $l =~ /^\s*EN\s*>>\s*(.*)$/){
      my $t = $1; $t =~ s/\s+$//;
      $en{$n} = $t if length $t;
      $lignes++; undef $n;
    }
  }
  close $h;
}
$lignes or die "ARRET : aucune ligne « EN >> » dans $dos\n";

# ---- vérifier avant de toucher à quoi que ce soit --------------------------
open(my $h, "<:encoding(UTF-8)", $src) or die "$src: $!";
local $/; my $s = <$h>; close $h;
$s =~ s/\x0D\x0A/\n/g;

my @ecarts;
for my $e (@lot){
  my $v = substr($s, $e->{deb}, $e->{len});
  push @ecarts, "n°$e->{n} ($e->{champ}) : le texte a changé à cette place"
    if !defined $v || $v ne $e->{fr};
  push @ecarts, "n°$e->{n} : la traduction contient un guillemet droit"
    if defined $en{$e->{n}} && $en{$e->{n}} =~ /"/;
}
for my $n (sort { $a <=> $b } keys %en){
  push @ecarts, "n°$n : traduit mais inconnu de source.tsv"
    unless grep { $_->{n} == $n } @lot;
}
if(@ecarts){
  print "  ARRET - rien n'a été écrit. ", scalar(@ecarts), " écart(s) :\n";
  my $max = $#ecarts > 14 ? 14 : $#ecarts;
  print "    $_\n" for @ecarts[0..$max];
  print "    …\n" if @ecarts > 15;
  exit 1;
}

# ---- couper et recoller, de la fin vers le début ---------------------------
my ($faits, $vides) = (0, 0);
for my $e (sort { $b->{deb} <=> $a->{deb} } @lot){
  if(defined $en{$e->{n}} && length $en{$e->{n}}){
    # Deux chaînes du jeu se terminent par une espace, parce qu'un bout
    # de phrase les suit. On la perdrait en nettoyant la ligne « EN >> » :
    # on rend donc à la traduction les espaces de bord de l'original.
    my ($g) = $e->{fr} =~ /^(\s*)/;
    my ($d) = $e->{fr} =~ /(\s*)$/;
    substr($s, $e->{deb}, $e->{len}) = $g . $en{$e->{n}} . $d;
    $faits++;
  } else { $vides++ }
}

open(my $o, ">:encoding(UTF-8)", $out) or die "$out: $!";
print $o $s; close $o;
binmode(STDOUT, ":encoding(UTF-8)");
printf "  %d chaînes traduites, %d laissées en français\n", $faits, $vides;
printf "  écrit dans %s (%d octets)\n", $out, -s $out;

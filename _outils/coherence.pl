#!/usr/bin/perl
# LE MEME MOT PARTOUT
#
#   perl _outils/coherence.pl _a-installer/traduction
#
# « verifier.pl » voit si les etoiles du gras sont la. Il ne voit pas ce
# qu'il y a entre. Or si « main-d'oeuvre » devient « workforce » au
# premier fichier et « labour force » au septieme, le surlignage du cours
# perd sa coherence la ou precisement il doit l'avoir : sur les notions
# que les eleves doivent retenir. Chaque fichier etant traduit dans sa
# propre conversation, rien ne garantit l'accord — sauf ce controle.
#
# On releve aussi deux travers d'une traduction faite au fil du texte :
#   — le siecle en chiffres romains, « XIXe century », qui ne se dit pas
#     en anglais ;
#   — les mots du jeu qui reviennent sans etre en gras : filature,
#     contremaitre, metier.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $dos = shift or die "usage: coherence.pl <dossier>\n";
my (%notion, %romain, %recurrent);

# les mots qui reviennent partout sans etre des notions du cours
my %veille = (
  "filature"     => undef, "filatures"  => undef,
  "contremaître" => undef, "métier"     => undef, "métiers" => undef,
);

for my $f (sort glob("$dos/[0-9]*.md")){
  my $court = $f; $court =~ s{.*/}{};
  open my $h, "<:encoding(UTF-8)", $f or die "$f: $!";
  my ($fr, $num);
  while(my $l = <$h>){
    chomp $l;
    if($l =~ /^\s*\[\[(\d+)\]\]/){ $num = $1; next }
    if($l =~ /^FR >> (.*)/){ $fr = $1; next }
    next unless $l =~ /^EN >> (.+)/ && defined $fr;
    my $en = $1;                     # a mettre de cote : $1 va etre ecrase

    # les notions du cours, appariees dans l'ordre d'apparition
    my @a = $fr =~ /\*\*(.+?)\*\*/g;
    my @b = $en =~ /\*\*(.+?)\*\*/g;
    for my $i (0 .. $#a){
      next unless defined $b[$i];
      my $cle = lc $a[$i];
      my $val = $b[$i]; $val = lcfirst $val if $val !~ /^[A-Z]{2}/;
      push @{ $notion{$cle}{$val} }, "$court n°$num";
    }

    # le siecle en chiffres romains n'a pas cours en anglais
    push @{ $romain{"$court n°$num"} }, $1
      if $en =~ /\b([IVXL]{2,}(?:ᵉ|e|th)?)\s+(?:century|siècle)/;

    undef $fr;
  }
  close $h;
}

my $souci = 0;

print "LES NOTIONS DU COURS\n";
for my $n (sort keys %notion){
  my @v = sort keys %{$notion{$n}};
  if(@v == 1){ printf "  %-28s -> %s\n", $n, $v[0] }
  else {
    $souci++;
    printf "  %-28s -> DEUX RENDUS :\n", $n;
    printf "       « %s »  (%s)\n", $_, join(", ", @{$notion{$n}{$_}}[0 .. ($#{$notion{$n}{$_}} > 2 ? 2 : $#{$notion{$n}{$_}})]) for @v;
  }
}
printf "  %d notion(s) relevée(s)\n", scalar(keys %notion);

if(%romain){
  print "\nLE SIECLE EN CHIFFRES ROMAINS — ne se dit pas en anglais\n";
  for my $o (sort keys %romain){ $souci++;
    printf "  %-16s %s\n", $o, join(", ", @{$romain{$o}}) }
}

printf "\n  ---- %s\n", $souci ? "$souci point(s) à reprendre" : "tout s accorde";
exit($souci ? 1 : 0);

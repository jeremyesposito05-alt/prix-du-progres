#!/usr/bin/perl
# AUCUNE DATE NE DOIT SE PERDRE
#
#   perl _outils/chiffres.pl _a-installer/traduction
#
# Dans un jeu d histoire, un chiffre change est la pire faute : elle ne
# se voit pas, et elle enseigne du faux. On verifie donc que chaque
# nombre du francais se retrouve dans l anglais.
#
# On ne regarde que ce sens. L anglais ecrit parfois en chiffres ce que
# le francais ecrivait en mots — « dix-huit morts » devient volontiers
# « 18 dead » — et cela n a rien de fautif.
# Un chiffre present dans le francais et absent de l anglais : une date
# perdue, un nombre change. Dans un jeu d histoire, c est la pire faute.
# On ne regarde que ce sens : l anglais ecrit parfois en chiffres ce que
# le francais ecrivait en mots, et cela n a rien de fautif.
my $D = shift || "_a-installer/traduction";
my $souci = 0;
for my $f (sort glob("$D/[0-9]*.md")){
  my $court = $f; $court =~ s{.*/}{};
  open my $h, "<:encoding(UTF-8)", $f or die "$f: $!";
  my ($fr, $num);
  while(my $l = <$h>){
    chomp $l;
    if($l =~ /^\s*\[\[(\d+)\]\]/){ $num = $1; next }
    if($l =~ /^FR >> (.*)/){ $fr = $1; next }
    next unless $l =~ /^EN >> (.+)/ && defined $fr;
    my $en = $1;
    # on normalise l espace des milliers : « 25 000 » et « 25000 »
    my ($a, $b) = ($fr, $en);
    s/(\d)[\s\x{202F}\x{00A0}](\d)/$1$2/g for $a, $b;
    my %dans; $dans{$_}++ for $b =~ /(\d+)/g;
    for my $c ($a =~ /(\d+)/g){
      next if $dans{$c} && $dans{$c}--;
      printf "  %-8s n°%s : %s absent de l anglais\n", $court, $num, $c;
      printf "      FR  %s\n      EN  %s\n", substr($a,0,96), substr($b,0,96);
      $souci++;
    }
    undef $fr;
  }
  close $h;
}
printf "\n  ---- %s\n", $souci ? "$souci chiffre(s) a verifier" : "tous les chiffres survivent";

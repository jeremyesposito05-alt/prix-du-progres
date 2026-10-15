#!/usr/bin/perl
# CE QU IL Y A A TRADUIRE DANS LE NIVEAU I, PAR CATEGORIE
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
open(my $h,"<:raw","index.html"); my $s=do{local $/;<$h>}; close $h; utf8::decode($s);

sub bloc { my ($n)=@_; my $d=index($s,$n); return "" if $d<0;
           my $f=index($s,"\n];\n",$d); return substr($s,$d,$f-$d) }

my %cat;
sub compte { my ($nom,$txt,@cles)=@_;
  for my $c (@cles){
    while($txt =~ /\n\s*\Q$c\E:"([^"]{2,})"/g){
      $cat{$nom}{n}++; $cat{$nom}{c} += length($1);
    }
  }
}

my $cartes = bloc("const CARTES_I = [");
compte("cartes · titres",      $cartes, "t");
compte("cartes · exposes",     $cartes, "ex");
compte("cartes · qui parle",   $cartes, "qui");
compte("cartes · repliques",   $cartes, "d");
compte("lettres du prof",      $cartes, "l");
compte("liens avec le cours",  $cartes, "li");
# reponses et consequences
while($cartes =~ /\n [abc]:\{q:"([^"]*)", e:\{[^}]*\},\n    c:"([^"]*)"/g){
  $cat{"reponses"}{n}++;       $cat{"reponses"}{c} += length($1);
  $cat{"consequences"}{n}++;   $cat{"consequences"}{c} += length($2);
}
# avis et dit
while($cartes =~ /(?:\bav|\bdit):\{([^}]*)\}/g){
  my $b=$1; while($b =~ /\w:"([^"]+)"/g){
    $cat{"paroles d acteurs"}{n}++; $cat{"paroles d acteurs"}{c} += length($1) }
}
my $quiz = bloc("const QUIZ_I = [");
compte("quiz · questions", $quiz, "q");
while($quiz =~ /\n\s*r:\[([^\]]*)\]/g){
  my $b=$1; while($b =~ /"([^"]+)"/g){
    $cat{"quiz · reponses"}{n}++; $cat{"quiz · reponses"}{c} += length($1) }
}
my $ev = bloc("const EV_I = [");
compte("evenements", $ev, "t","x","src");

my ($N,$C)=(0,0);
printf "%-24s %5s %8s\n", "categorie", "n", "car.";
for my $k (sort { $cat{$b}{c} <=> $cat{$a}{c} } keys %cat){
  printf "%-24s %5d %8d\n", $k, $cat{$k}{n}, $cat{$k}{c};
  $N += $cat{$k}{n}; $C += $cat{$k}{c};
}
printf "%-24s %5d %8d  (~%d mots)\n", "TOTAL", $N, $C, int($C/6.1);

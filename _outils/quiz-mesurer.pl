#!/usr/bin/perl
# OU SE TROUVE LA BONNE REPONSE QUAND ON CLASSE PAR LONGUEUR
#
#   perl _outils/quiz-mesurer.pl index.html
#
# Un questionnaire est devinable si la longueur trahit la bonne reponse.
# Le premier biais mesure allait dans un sens — la bonne etait la plus
# longue. Il faut verifier qu'on ne l'a pas simplement retourne : une
# bonne reponse toujours la PLUS COURTE se devine tout aussi bien.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);

my (%rang, $n, $somme);
# Le fichier de travail passe en CRLF des qu'un « git checkout » le
# retouche (core.autocrlf), alors que le depot le garde en LF : le
# motif doit accepter les deux, sinon il ne trouve rien et on croit a
# tort que le questionnaire a disparu.
while($s =~ /\r?\n r:\[(.*?)\],\r?\n b:(\d+)/gs){
  my ($bloc, $bonne) = ($1, $2);
  my @t = $bloc =~ /"([^"]*)"/g;
  next unless @t == 3;
  $n++;
  my @l = map { length } @t;
  my $lb = $l[$bonne];
  my $plus = grep { $_ > $lb } @l;
  $rang{$plus}++;
  my ($max) = sort { $b <=> $a } @l;
  $somme += $lb - $max;
}
die "ARRET : aucune question relue\n" unless $n;

printf "  %d questions relues\n\n", $n;
printf "  la bonne reponse est la plus longue : %2d  (%.0f %%)\n",
  ($rang{0}||0), 100*($rang{0}||0)/$n;
printf "  elle est au milieu                  : %2d  (%.0f %%)\n",
  ($rang{1}||0), 100*($rang{1}||0)/$n;
printf "  elle est la plus courte             : %2d  (%.0f %%)\n",
  ($rang{2}||0), 100*($rang{2}||0)/$n;
printf "\n  le hasard donnerait environ %.0f %% dans chaque case.\n", 100/3;
printf "  ecart moyen a la plus longue : %+.1f caracteres\n", $somme/$n;

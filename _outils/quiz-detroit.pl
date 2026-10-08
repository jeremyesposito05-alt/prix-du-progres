#!/usr/bin/perl
# LE QUESTIONNAIRE DE DETROIT RETROUVE SES CARTES
#
#   perl _outils/quiz-detroit.pl index.html
#
# Le jeu ne pose que des questions portant sur ce que le joueur a vu :
# il compare le titre de la carte. Les trente nouvelles cartes de
# Detroit ont de nouveaux titres — sans ce rattachement, chaque
# question tomberait dans le repli et le questionnaire redeviendrait
# aleatoire.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

# ancien titre => nouveau. Le choix tient a ce que la question demande,
# pas a l'ordre : « l'integration verticale » se rattache aux hauts
# fourneaux qu'on fait construire, et le « departement sociologique »
# aux cinq dollars, qui l'ont fait naitre.
my @liens = (
 ["Un ing\x{E9}nieur propose de faire venir la voiture \x{E0} l\x{2019}ouvrier.",
  "La voiture avance vers l\x{2019}ouvrier"],
 ["Personne ne reste plus de quelques jours.",
  "Une usine que les ouvriers quittent"],
 ["Qui m\x{E9}rite les cinq dollars ?",
  "Cinq dollars par jour"],
 ["Le client demande une autre couleur.",
  "Le noir ou davantage de couleurs"],
 ["Une usine qui fabriquerait tout.",
  "L\x{2019}acier, trop cher"],
 ["L\x{2019}ouvri\x{E8}re de la ligne 4 demande \x{E0} parler.",
  "Un seul geste par poste"],
 ["General Motors change de mod\x{E8}le chaque ann\x{E9}e.",
  "La concurrence change de voiture"],
 ["Faut-il vendre \x{E0} cr\x{E9}dit ?",
  "Une voiture pay\x{E9}e en plusieurs fois"],
 ["Cinq jours de travail au lieu de six.",
  "La semaine de cinq jours"],
 ["Le chronom\x{E8}tre descend \x{E0} l\x{2019}atelier.",
  "La vitesse du tapis roulant"],
 ["Les pi\x{E8}ces ne s\x{2019}embo\x{EE}tent pas.",
  "Des pi\x{E8}ces qui ne s\x{2019}ajustent pas"],
 ["Faut-il arr\x{EA}ter la voiture qui vous a faits ?",
  "La fin d\x{2019}un mod\x{E8}le c\x{E9}l\x{E8}bre"],
);

my @T;
for my $l (@liens){
  push @T, [ "quiz : \x{AB} " . substr($l->[0], 0, 36) . " \x{BB}",
             "{c:\"$l->[0]\",", "{c:\"$l->[1]\"," ];
}

# Le nouveau titre doit exister parmi les cartes, sinon le lien est
# mort sans qu'on s'en apercoive.
my $de = index($s, "const CARTES_II = [");
my $fin = index($s, "\n];\n", $de);
my $bloc = substr($s, $de, $fin - $de);
my @absents = grep { index($bloc, "t:\"$_->[1]\"") < 0 } @liens;
if(@absents){
  print "  REFUS — ces titres n'existent pas dans CARTES_II :\n";
  print "    \x{B7} $_->[1]\n" for @absents;
  die "\n  Rien n'a ete ecrit.\n";
}

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-46s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d liens refaits\n", scalar(@T);

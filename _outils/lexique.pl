#!/usr/bin/perl
# IMPOSER LE LEXIQUE AUX FICHIERS QUI RESTENT
#
#   perl _outils/lexique.pl _a-installer/traduction 02 11
#
# Le premier fichier traduit a fixe le vocabulaire des notions du cours.
# Si le suivant rend « main-d'oeuvre » par « labour force » la ou le
# premier disait « workforce », le surlignage du cours perd sa coherence
# — et « verifier.pl » n'y verra rien, puisque les etoiles sont bien la.
# On ajoute donc le lexique a la consigne, une fois pour toutes.
use strict; use warnings; use utf8;

my ($dos, $de, $a) = @ARGV;
$dos && $de && $a or die "usage: lexique.pl <dossier> <du> <au>\n";

my $bloc = <<'TXT';
**Le vocabulaire des notions est déjà fixé.** Un premier lot a été traduit avant
celui-ci : emploie exactement ces mots, pour que le surlignage du cours reste
cohérent d'un bout à l'autre du jeu.

| français | anglais |
|---|---|
| capitaux | capital |
| exode rural | rural exodus |
| fabricants | manufacturers |
| industriels | industrialists |
| main-d'œuvre | workforce |
| marchés | markets |
| négociants | merchants |
| organisation du travail | organisation of work |
| ouvriers | workers |
| progrès | progress |
| ressource | resource |
| transports | transport |
| urbanisation | urbanisation |
| État | State |
| filature | mill |
| contremaître | foreman |

Orthographe **britannique** partout : *labour*, *organisation*, *urbanisation*,
*neighbour*, *recognise*.

TXT

my $faits = 0;
for my $n ($de .. $a){
  my $f = sprintf "%s/%02d.md", $dos, $n;
  -f $f or die "ARRET : $f n'existe pas\n";
  open my $h, "<:encoding(UTF-8)", $f or die "$f: $!"; local $/;
  my $s = <$h>; close $h;

  if($s =~ /Le vocabulaire des notions est déjà fixé/){ next }   # deja fait

  # On se glisse juste avant le trait qui ferme la consigne, pour ne pas
  # toucher aux six regles ni a une seule entree.
  my $ancre = "\n---\n\n[[";
  my $i = index($s, $ancre);
  $i >= 0 or die "ARRET : $f, la fin de la consigne est introuvable\n";
  substr($s, $i + 1, 0) = $bloc;

  open my $o, ">:encoding(UTF-8)", $f or die "$f: $!";
  print $o $s; close $o;
  $faits++;
}
binmode(STDOUT, ":encoding(UTF-8)");
printf "  lexique ajoute a %d fichier(s)\n", $faits;

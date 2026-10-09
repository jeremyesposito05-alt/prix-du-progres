#!/usr/bin/perl
# UNE COPIE D ESSAI AVEC UNE SONDE DEDANS
#
#   perl _outils/essai.pl index.html _outils/sonde-ronds.js _essai.html
#
# La sonde se glisse juste avant le dernier </script> : elle voit donc
# tout ce que le jeu a declare, et le jeu n est pas touche.
use strict; use warnings; use utf8;

my ($src, $js, $out) = @ARGV;
$src && $js && $out or die "usage: essai.pl <source> <sonde.js> <sortie>\n";

open(my $h, "<:raw", $src) or die "$src: $!";
my $s = do { local $/; <$h> }; close $h;
open(my $j, "<:raw", $js) or die "$js: $!";
my $sonde = do { local $/; <$j> }; close $j;

my $i = rindex($s, "</script>");
$i >= 0 or die "ARRET : pas de </script> dans $src\n";
substr($s, $i, 0) = "\n/* ---- sonde ---- */\n" . $sonde . "\n";

open(my $o, ">:raw", $out) or die "$out: $!";
print $o $s; close $o;
printf "  %s ecrit (%d Ko)\n", $out, length($s)/1024;

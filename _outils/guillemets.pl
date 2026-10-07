#!/usr/bin/perl
# LES CHEVRONS DEVIENNENT DES GUILLEMETS ANGLAIS
#
#   perl _outils/guillemets.pl _a-installer/traduction
#
# La consigne de traduction interdisait le guillemet droit, qui casserait
# le code. ChatGPT a donc repris les chevrons du francais, ce qui ne
# cassait rien mais depaysait : un lecteur anglophone n'ecrit pas
# « like this ». On passe aux guillemets courbes anglais, qui sont aussi
# surs que les chevrons — ce ne sont pas des guillemets droits.
#
# On ne touche qu'aux lignes EN. Le francais du jeu garde ses chevrons,
# et les lignes FR restent intactes : la reinjection les verifie.
#
# Les apostrophes simples courbes sont laissees telles quelles : elles
# portent les termes cites — « the ‘Ford whisper’ » — et se nichent
# correctement a l'interieur des guillemets doubles.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $dos = shift or die "usage: guillemets.pl <dossier>\n";
my $OUV = "\x{201C}";   # “
my $FER = "\x{201D}";   # ”

my ($av_o, $av_f, $ap_o, $ap_f, $droits, $faits) = (0,0,0,0,0,0);
my @fichiers = sort glob("$dos/[0-9]*.md");
@fichiers or die "ARRET : aucun fichier dans $dos\n";

for my $f (@fichiers){
  open my $h, "<:encoding(UTF-8)", $f or die "$f: $!";
  my @l = <$h>; close $h;
  my $touche = 0;
  for my $l (@l){
    next unless $l =~ /^EN >> /;
    $av_o += () = $l =~ /«/g;
    $av_f += () = $l =~ /»/g;
    my $avant = $l;
    $l =~ s/« /$OUV/g;        # le cas courant : l espace fine du francais
    $l =~ s/ »/$FER/g;
    $l =~ s/«/$OUV/g;         # et le cas sans espace
    $l =~ s/»/$FER/g;
    if($l ne $avant){ $touche++; $faits++ }
    $ap_o += () = $l =~ /\Q$OUV\E/g;
    $ap_f += () = $l =~ /\Q$FER\E/g;
    $droits += () = $l =~ /"/g;
  }
  next unless $touche;
  open my $o, ">:encoding(UTF-8)", $f or die "$f: $!";
  print $o @l; close $o;
}

# Rien ne doit avoir ete perdu ni invente.
$av_o == $av_f or die "ARRET : $av_o chevrons ouvrants pour $av_f fermants\n";
$ap_o == $av_o or die "ARRET : $ap_o guillemets ouvrants pour $av_o chevrons\n";
$ap_f == $av_f or die "ARRET : $ap_f guillemets fermants pour $av_f chevrons\n";
$droits == 0   or die "ARRET : $droits guillemet(s) droit(s) apparus\n";

printf "  %d paires de chevrons devenues des guillemets anglais\n", $ap_o;
printf "  %d lignes touchees, aucun guillemet droit\n", $faits;

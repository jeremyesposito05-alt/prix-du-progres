#!/usr/bin/perl
# CE QUI RESTE EN FRANCAIS DANS LA LETTRE DU PROFESSEUR
#
#   perl _outils/audit-lettre.pl index.html
#
# La lettre se compose de morceaux venus de trois endroits :
#   - des libelles ecrits en dur dans la fonction d affichage,
#   - le champ « li » de la carte (le lien avec le cours),
#   - le champ « l » de la carte (reference, mot, definition, question).
# Seuls les deux derniers passent par le dictionnaire. On verifie.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);

my ($trad) = $s =~ /const TRAD = \{(.*?)\/\* --- fin du dictionnaire --- \*\//s;
die "dictionnaire introuvable\n" unless $trad;

sub traduit { my $t = shift; return index($trad, '"' . $t . '"') >= 0 }

for my $niv ("I", "II") {
  my ($cartes) = $s =~ /const CARTES_$niv = \[(.*?)\n\];/s;
  unless($cartes){ print "  CARTES_$niv introuvable\n"; next }

  for my $champ ("li", "l") {
    my @v;
    while($cartes =~ /\n\s*\Q$champ\E:"([^"]*)"/g){ push @v, $1 }
    my (@hors);
    for my $t (@v){ push @hors, $t unless traduit($t) }
    printf "  niveau %-2s  champ %-3s : %2d valeurs, %2d hors dictionnaire\n",
           $niv, $champ, scalar(@v), scalar(@hors);
    for my $t (@hors[0 .. ($#hors > 2 ? 2 : $#hors)]){
      next unless defined $t;
      print "        hors : ", substr($t, 0, 78), "...\n";
    }
  }
}

print "\n  --- les libelles ecrits en dur dans la fonction d affichage ---\n";
my ($fn) = $s =~ /(const intro = premiere.*?function decoupeLettre)/s;
if($fn){
  # tout texte francais hors ${...} et hors balises
  my $t = $fn;
  $t =~ s/\$\{[^}]*\}/ /g;
  my @phr = ($t =~ /([A-ZÀ-Þ][^<>`"\n]{14,}?[.?:])/g);
  my %vu;
  for my $p (@phr){
    $p =~ s/\s+/ /g; $p =~ s/^\s+|\s+$//g;
    next if $vu{$p}++;
    next if $p =~ /^(La|Le|Les|Il|Elle|Un|Une|On|Decoupee|Nommer|Mesure)\b.*\*/;
    printf "    %s  %s\n", (traduit($p) ? "traduit" : "EN DUR "), substr($p, 0, 86);
  }
}

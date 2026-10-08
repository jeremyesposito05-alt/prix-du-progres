#!/usr/bin/perl
# LES EVENEMENTS DE DETROIT, RAMENES A L ECHELLE DES NOUVELLES CARTES
#
#   perl _outils/evenements-detroit.pl index.html <facteur>
#
# CE QUI A ETE MESURE. Avec les trente nouvelles cartes, Detroit
# devenait injouable : zero partie sur seize menee au bout en jouant au
# hasard, et le joueur methodique finissait a 17/14/60/31. En
# neutralisant les evenements dans la simulation, les memes cartes
# donnent 13 sur 16 au hasard et 50/43/69/58. Les evenements sont donc
# toute la cause, et non les cartes.
#
# POURQUOI. « EV_II » a ete calibre contre les ANCIENNES cartes de
# Detroit, dont les effets etaient plus amples. Les nouvelles appliquent
# +9 / -8, derives des consequences. Mesure : les evenements de Detroit
# pesent -9,1 par evenement contre -5,8 a Manchester, niveau qui, lui,
# reste jouable.
#
# CE QU'ON NE FAIT PAS. On ne touche ni aux textes des evenements, ni
# aux faits qu'ils rapportent : le krach de 1929 arrive toujours, la
# marche de Dearborn aussi. Seule l'amplitude de leur effet change.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f   = shift || "index.html";
my $fac = shift; defined $fac or die "usage: evenements-detroit.pl <index.html> <facteur>\n";
$fac > 0 && $fac <= 1 or die "ARRET : facteur attendu entre 0 et 1\n";

open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my $de = index($s, "const EV_II = [");
$de >= 0 or die "ARRET : EV_II introuvable\n";
my $fin = index($s, "\n];\n", $de);
$fin > $de or die "ARRET : fin de EV_II introuvable\n";
my $bloc = substr($s, $de, $fin - $de);

# L'etat avant
sub solde {
  my ($b) = @_;
  my (%t, $n);
  my $c = $b;
  while($c =~ /\be:\{([^}]*)\}/g){
    my $e = $1; $n++;
    while($e =~ /(\w+):(-?\d+)/g){ $t{$1} += $2 }
  }
  return (\%t, $n);
}
my ($av, $nb) = solde($bloc);
printf "  avant : %d evenements · i %+d · o %+d · m %+d · p %+d\n",
  $nb, ($av->{i}||0), ($av->{o}||0), ($av->{m}||0), ($av->{p}||0);

# On met a l'echelle, en gardant le signe et au moins 1 : un evenement
# qui ne ferait plus rien du tout ne serait plus un evenement.
my $touches = 0;
# Une substitution dans la partie droite d'une autre substitution se
# lit mal : on passe par une fonction nommee.
sub echelle {
  my ($e) = @_;
  my @out;
  while($e =~ /(\w+):(-?\d+)/g){
    my ($k, $v) = ($1, $2);
    my $n = int(abs($v) * $fac + .5); $n = 1 if $n < 1;
    $touches++;
    push @out, "$k:" . ($v < 0 ? -$n : $n);
  }
  return join(",", @out);
}
# Les accolades litterales dans la partie droite d'une substitution
# delimitee par des accolades les desequilibrent, et Perl ne lit plus
# la fin du remplacement. On les passe par des variables.
# … et le delimiteur lui-meme ne doit pas etre une accolade, sinon
# Perl compte celles du motif. On prend « ! », absent des deux cotes.
my $OUV = chr(123); my $FER = chr(125);
$bloc =~ s!\be:\{([^}]*)\}! "e:" . $OUV . echelle($1) . $FER !ge;

my ($ap) = solde($bloc);
printf "  apres : %d valeurs mises a l'echelle (x%.2f) · i %+d · o %+d · m %+d · p %+d\n",
  $touches, $fac, ($ap->{i}||0), ($ap->{o}||0), ($ap->{m}||0), ($ap->{p}||0);

substr($s, $de, $fin - $de) = $bloc;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
print "  ecrit\n";

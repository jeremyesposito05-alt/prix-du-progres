#!/usr/bin/perl
# LA LETTRE REDEVIENT MODALE, ET NE S OUVRE PAS SUR LE PASSE
#
#   perl _outils/lettre-modale.pl index.html
#
# DEUX DEFAUTS TROUVES EN VERIFIANT LES DEUX ECRANS.
#
# 1. Le voile de la lettre n interceptait plus les clics. C etait
#    voulu du temps ou un delai la tenait cachee : invisible, elle
#    n avait pas a bloquer. Mais depuis elle n est plus cachee, elle
#    est posee au moment voulu — et le voile transparent laissait
#    DECIDER derriere elle. La lettre, jamais refermee, se rouvrait au
#    tour suivant, accrochee au mauvais moment.
#
# 2. Rien n interdisait une lettre sur l ecran de ce qui est arrive.
#    Elle porte sur une affaire a venir : elle n a rien a y faire.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("css : le voile bloque de nouveau les clics", <<'AV', <<'AP');
  /* tant qu'elle n'est pas la, le voile n'intercepte rien */
  pointer-events:none;
}
.pli-prof .lettre-prof{pointer-events:auto}
AV
  /* Le voile bloque de nouveau les clics. Il ne le faisait plus depuis
     qu'un délai la tenait cachée — invisible, elle n'avait pas à
     bloquer. Mais elle n'est plus cachée : elle est posée au moment
     voulu, et le voile transparent laissait DÉCIDER derrière elle. */
  pointer-events:auto;
}
AP

ech("js : jamais de lettre sur l ecran de consequence", <<'AV', <<'AP');
  if(s.i === s.pause && lettreAlire() && !document.getElementById("pli-prof")){
AV
  /* Jamais de lettre sur l'écran de ce qui est arrivé : elle porte sur
     une affaire à venir, pas sur une décision passée. */
  if(s.i === s.pause && !E.montreConsq && lettreAlire()
     && !document.getElementById("pli-prof")){
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-50s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

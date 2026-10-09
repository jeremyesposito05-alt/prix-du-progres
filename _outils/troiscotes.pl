#!/usr/bin/perl
# LES TROIS CHOIX RESTENT COTE A COTE
#
#   perl _outils/troiscotes.pl index.html
#
# La bascule etait posee a 1040 px : en dessous, les trois plaques
# repassaient en pile. Sur une fenetre d'environ 900 px — celle d'un
# portable, ou d'un navigateur zoome, ce qui revient au meme en pixels
# CSS — on retombait donc sur la colonne qu'on venait de quitter.
#
# Elle descend a 820 px, juste au-dessus de la bascule telephone
# (860 px) qui empile de toute facon tout le plateau. Entre les deux,
# trois colonnes de 270 px : assez pour deux ou trois lignes de
# reponse, et c'est tout ce qu'il faut.
#
# Au passage, les plaques se resserrent quand la place manque : corps
# plus petit, marges plus courtes, hauteur minimale rabaissee. Une
# plaque d'une seule ligne n'a pas besoin de quatre-vingt-quatorze
# pixels.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("la bascule descend de 1040 a 820 px", <<'AV', <<'AP');
@media(max-width:1040px){
  .tranche.centre .rep{grid-template-columns:minmax(0,1fr)}
  .tranche.centre .question{white-space:normal}
}
AV
/* Les trois restent cote a cote jusqu'a 820 px — en dessous, la
   bascule telephone (860 px) a de toute facon mis tout le plateau en
   colonne. Entre 820 et 1100, elles se resserrent au lieu de se
   casser. */
@media(max-width:1100px){
  .tranche.centre .rep{gap:11px}
  .tranche.centre .choix{padding:12px 13px 13px !important; min-height:78px; gap:11px}
  .tranche.centre .choix .q{font-size:15.5px !important; line-height:1.3}
  .tranche.centre .choix::before{width:24px;height:24px;font-size:14px}
  .tranche.centre .question{gap:12px}
}
@media(max-width:820px){
  .tranche.centre .rep{grid-template-columns:minmax(0,1fr)}
  .tranche.centre .question{white-space:normal}
}
AP

ech("une plaque d une ligne ne prend plus toute la hauteur", <<'AV', <<'AP');
.tranche.centre .choix{
  align-items:flex-start !important;
  padding:16px 18px 18px !important;
  min-height:94px;
}
AV
.tranche.centre .choix{
  align-items:flex-start !important;
  padding:15px 17px 16px !important;
  min-height:84px;
}
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

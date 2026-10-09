#!/usr/bin/perl
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $av = "\@media(max-width:1100px){\n  .tranche.centre .rep{gap:11px}\n";
my $ap = <<'FIN';
/* LA CARTE SUIT LA LARGEUR DISPONIBLE. Sur une fenetre de 920 px la
   colonne laterale ne fait plus que 253 px : medaillon, marges et nom
   n'y tenaient pas, et « Marchands » se faisait couper. Le medaillon
   et le nom descendent par paliers, mesures sur la colonne reelle. */
@media(max-width:1150px){
  .scene{--rond:124px}
  .poste{padding:11px 13px 11px 11px; column-gap:13px}
  .poste .nm{font-size:19px}
  .poste .tige{max-width:160px; height:6px}
}
@media(max-width:1000px){
  .scene{--rond:104px; padding-top:88px}
  .scene > .centre{margin-top:-72px}
  .poste{padding:9px 11px 9px 9px; column-gap:11px}
  .poste .nm{font-size:17px}
  .poste .tige{max-width:130px; margin-top:6px}
  .poste .dit{font-size:13.5px; padding:9px 12px 10px; max-width:min(260px,96%)}
}
/* un nom trop long passe a la ligne plutot que de deborder */
.poste .nm{overflow-wrap:anywhere}

@media(max-width:1100px){
  .tranche.centre .rep{gap:11px}
FIN
my $n = () = ($s =~ /\Q$av\E/g);
$n == 1 or die "ARRET : ancre trouvee $n fois\n";
$s =~ s/\Q$av\E/$ap/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
print "  ok  la carte suit la largeur disponible\n";

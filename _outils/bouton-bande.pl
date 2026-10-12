#!/usr/bin/perl
# LE BOUTON COLLE REPOSE SUR UN BANDEAU, PAS SUR UNE OMBRE
#
# L'ombre large ne couvrait que ses abords : le texte de la question
# passait de part et d'autre et se lisait coupe. Un pseudo-element
# large comme la feuille fait un vrai fond de papier sous lui.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $av = <<'AV';
/* Colle en bas de la feuille : il reste visible pendant qu'on fait
   defiler le texte. L'ombre large lui fait un fond opaque de la
   couleur du papier, sinon les lignes passeraient derriere lui. */
.lettre-prof button{display:block; margin:10px auto 0;
  position:sticky; bottom:0; z-index:3;
  box-shadow:0 -10px 16px 12px var(--pap2)}
AV
my $ap = <<'AP';
/* Colle en bas de la feuille : il reste visible pendant qu'on fait
   defiler le texte. Sous lui, un bandeau large comme la feuille —
   une ombre ne couvrait que ses abords, et le texte passait de part
   et d'autre. */
.lettre-prof button{display:block; margin:14px auto 0;
  position:sticky; bottom:0; z-index:3}
.lettre-prof button::before{
  content:""; position:absolute; z-index:-1;
  left:-340px; right:-340px; top:-16px; bottom:-30px;
  background:var(--pap2);
}
AP
my $n = () = ($s =~ /\Q$av\E/g);
$n == 1 or die "ARRET : ancre trouvee $n fois\n";
$s =~ s/\Q$av\E/$ap/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
print "  ok  le bouton repose sur un bandeau\n";

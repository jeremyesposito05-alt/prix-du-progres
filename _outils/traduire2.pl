#!/usr/bin/perl
# LE DECOUPAGE DE LA LETTRE, SANS DECALER LES GROUPES
#
# En ajoutant la variante anglaise « The term **word** means … », j ai
# cree un GROUPE DE CAPTURE de plus. Les groupes suivants — la
# definition et la question — ont donc glisse d un rang, et le code
# qui lit m[4] et m[5] a leve « Cannot read properties of undefined ».
#
# Les deux langues partagent desormais le meme groupe : « (?:Le terme|
# The term) **mot** (?:designe|means) ». Un seul groupe, deux langues,
# aucun decalage.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $av = q{    /^(?:Consultez|Révisez|See|Review)\s+(.+?)\.\s*(?:(?:Retenez|Remember)\s+\*\*(.+?)\*\*\s*:\s*|(?:Le terme\s+\*\*(.+?)\*\*\s+désigne|The term\s+\*\*(.+?)\*\*\s+means)\s+)(.+?)\.\s+([A-ZÀ-Þ].*)$/);};
my $ap = q{    /^(?:Consultez|Révisez|See|Review)\s+(.+?)\.\s*(?:(?:Retenez|Remember)\s+\*\*(.+?)\*\*\s*:\s*|(?:Le terme|The term)\s+\*\*(.+?)\*\*\s+(?:désigne|means)\s+)(.+?)\.\s+([A-ZÀ-Þ].*)$/);};
my $n = () = ($s =~ /\Q$av\E/g);
$n == 1 or die "ARRET : ancre trouvee $n fois\n";
$s =~ s/\Q$av\E/$ap/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
print "  ok  un seul groupe pour les deux langues\n";

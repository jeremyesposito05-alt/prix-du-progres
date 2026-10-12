#!/usr/bin/perl
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my ($f, $niv) = (shift||"index.html", shift||"I");
open(my $h, "<:raw", $f) or die "$f: $!"; my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
my $de = index($s, "const CARTES_$niv = [");
my $fin = index($s, "\n];\n", $de);
my @c = split /\n\n(?=\{)/, substr($s, $de, $fin-$de);
for my $c (@c){
  my ($n) = $c =~ /n:"(\d+)"/ or next;
  my ($t) = $c =~ /t:"([^"]*)"/;
  my ($x) = $c =~ /\n ex:"([^"]*)"/;
  my ($l) = $c =~ /\n l:"([^"]*)"/;
  my ($mot,$def) = ($l//"") =~ /\*\*(.+?)\*\*\s*:\s*(.+?)\.\s+[A-ZÀ-Þ]/;
  ($mot,$def) = (($l//"") =~ /Le terme \*\*(.+?)\*\* désigne (.+?)\.\s+[A-ZÀ-Þ]/) unless $mot;
  my ($ref) = ($l//"") =~ /^(?:Consultez|Révisez)\s+(.+?)\.\s/;
  my ($q)   = ($l//"") =~ /\.\s+([A-ZÀ-Þ][^"]*)$/;
  printf "[%s] %s\n  REF %s\n  MOT %s = %s\n  EX  %s\n  Q   %s\n\n",
    $n, ($t//"?"), ($ref//"-"), ($mot//"-"), ($def//"-"),
    (substr($x//"-",0,150)), ($q//"-");
}

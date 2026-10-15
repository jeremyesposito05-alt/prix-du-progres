#!/usr/bin/perl
# CE QUI N EST PAS ENCORE TRADUIT DANS LE NIVEAU I
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
open(my $h,"<:raw","index.html"); my $s=do{local $/;<$h>}; close $h; utf8::decode($s);
my $d=index($s,"const TRAD = {");
my $f=index($s,"/* --- fin du dictionnaire --- */",$d);
my %t;
my $b=substr($s,$d,$f-$d);
while($b =~ /^"([^"]+)":/mg){ $t{$1}=1 }
printf "  dictionnaire : %d entrees\n\n", scalar(keys %t);

sub bloc { my ($n)=@_; my $i=index($s,$n); return "" if $i<0;
           my $j=index($s,"\n];\n",$i); return substr($s,$i,$j-$i) }
my %vu;
sub montre {
  my ($nom,$txt,@cles)=@_;
  my @m;
  for my $c (@cles){
    while($txt =~ /\b\Q$c\E:"([^"]{3,})"/g){
      next if $t{$1} or $vu{$1}++; push @m, $1;
    }
  }
  return unless @m;
  print "===== $nom (", scalar(@m), ")\n";
  print "  $_\n" for @m;
  print "\n";
}
montre("quiz · questions", bloc("const QUIZ_I = ["), "q");
my $q = bloc("const QUIZ_I = [");
my @r; while($q =~ /\n\s*r:\[([^\]]*)\]/g){ my $x=$1;
  while($x =~ /"([^"]+)"/g){ next if $t{$1} or $vu{$1}++; push @r,$1 } }
if(@r){ print "===== quiz · reponses (", scalar(@r), ")\n"; print "  $_\n" for @r; print "\n" }
montre("evenements", bloc("const EV_I = ["), "t","x","src");
my $niv = substr($s, index($s,"  I:{id:\"I\""), 1400);
montre("niveau", $niv, "lieu","sous","ord","unite","unite2","t","x");

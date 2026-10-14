#!/usr/bin/perl
# L ORDRE DU JOUR REPASSE DEVANT LE DECOR
#
# Mesure : il est bien la, 461 x 247 px, visible et plein de texte —
# mais a l ecran on voit le decor a sa place. Explication : « .centre »
# passe en « display:contents » sur telephone, ce qui supprime sa
# boite — et avec elle le « z-index:1 » qui tenait l ordre du jour
# au-dessus du decor. Or « #decor » est en position fixe avec
# « z-index:0 », donc au-dessus de tout contenu non positionne.
#
# L ordre du jour reprend donc son propre plan, au lieu de dependre
# d un parent qui n a plus de boite.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $av = "  .centre .ordre{order:-2}\n";
my $ap = "  /* « display:contents » sur « .centre » supprime sa boite, donc le\n"
       . "     z-index qui tenait l'ordre du jour au-dessus du decor fixe. Il\n"
       . "     reprend son propre plan. */\n"
       . "  .centre .ordre{order:-2; position:relative; z-index:2}\n";
my $n = () = ($s =~ /\Q$av\E/g);
$n == 1 or die "ARRET : ancre trouvee $n fois\n";
$s =~ s/\Q$av\E/$ap/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
print "  ok  l'ordre du jour repasse devant\n";

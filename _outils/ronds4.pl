#!/usr/bin/perl
# LE NOM REDEVIENT LISIBLE SUR LE MEDAILLON
#
#   perl _outils/ronds4.pl index.html
#
# Pose sur le bas du rond, le nom gagnait trente-quatre pixels de
# diametre mais se perdait dans l'image : un degrade sombre et une
# ombre portee ne suffisent pas quand le fond est un atelier clair.
# On lui donne un cartouche franc — une plaque sombre a filet d'or,
# comme celles des trois choix. Le gain de place est conserve, la
# lisibilite revient.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("le nom prend un cartouche au lieu d un degrade", <<'AV', <<'AP');
.poste .ident{display:flex;flex-direction:column;gap:0;line-height:1.18;
  text-align:center;align-items:center;
  position:relative; z-index:2; margin-top:-34px; pointer-events:none;
  padding:2px 6px 1px; border-radius:11px;
  background:radial-gradient(ellipse at 50% 55%,
    rgba(14,9,5,.62) 0%, rgba(14,9,5,.42) 55%, transparent 78%)}
AV
/* Un cartouche, pas un voile : sur un atelier clair, un degrade ne
   tient pas. Le gain de place reste — il mord toujours sur le rond. */
.poste .ident{display:flex;flex-direction:column;gap:0;line-height:1.16;
  text-align:center;align-items:center;
  position:relative; z-index:2; margin-top:-36px; pointer-events:none;
  width:84%; margin-left:auto; margin-right:auto;
  padding:4px 10px 5px; border-radius:4px;
  background:linear-gradient(176deg,rgba(32,23,15,.93) 0%,rgba(18,12,7,.95) 100%);
  border:1px solid rgba(216,179,112,.34);
  box-shadow:0 4px 12px rgba(0,0,0,.5)}
body[data-niveau="II"] .poste .ident{
  background:linear-gradient(176deg,rgba(20,26,36,.93) 0%,rgba(12,16,23,.95) 100%);
  border-color:rgba(150,185,220,.32)}
AP

ech("le nom et l etiquette se posent sur le cartouche", <<'AV', <<'AP');
.poste .nm{font-family:var(--serif);font-size:16px;color:#EFE3CC;
  text-shadow:0 1px 6px rgba(0,0,0,.8)}
body[data-niveau="II"] .poste .nm{color:#E4ECF5}
.poste .et{font-size:10.5px;color:#D8B370;letter-spacing:.04em;
  text-shadow:0 1px 5px rgba(0,0,0,.8)}
AV
.poste .nm{font-family:var(--serif);font-size:16.5px;color:#F2E7D2;
  letter-spacing:.01em; white-space:nowrap}
body[data-niveau="II"] .poste .nm{color:#E6EEF7}
.poste .et{font-size:10px;color:#D8B370;letter-spacing:.06em;
  text-transform:uppercase; white-space:nowrap}
body[data-niveau="II"] .poste .et{color:#9EC2E0}
AP

ech("la jauge se glisse dans le cartouche", <<'AV', <<'AP');
.poste .tige{height:4px;border-radius:2px;width:58%;margin:3px auto 0;
  background:rgba(20,14,8,.5);overflow:hidden;
  box-shadow:0 0 0 1px rgba(0,0,0,.3)}
AV
/* Elle passe DANS le cartouche : plus rien ne depasse du rond, et la
   rangee ne coute que les quelques pixels du bas de la plaque. */
.poste .tige{height:4px;border-radius:2px;width:84%;
  margin:-4px auto 0; position:relative; z-index:3;
  background:rgba(0,0,0,.5);overflow:hidden;
  box-shadow:0 0 0 1px rgba(0,0,0,.4)}
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

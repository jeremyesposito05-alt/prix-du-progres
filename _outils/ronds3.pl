#!/usr/bin/perl
# LE DIAMETRE NE DEPEND PAS DE LA HAUTEUR DE L ECRAN
#
#   perl _outils/ronds3.pl index.html
#
# CE QUE LA MESURE A MONTRE. On croyait que la hauteur de la fenetre
# commandait la taille des portraits : c'est faux. La hauteur de la
# scene est celle de la colonne du centre — ordre du jour, question,
# trois plaques — et elle vaut de 582 a 622 px selon la longueur de
# l'affaire du jour, quelle que soit la fenetre. Deux rangees de
# medaillons tiennent dedans tant que le diametre reste sous
# (582 - 12) / 2, soit 285 px. En dessous de ce chiffre, agrandir ne
# coute RIEN : la page ne s'allonge pas d'un pixel.
#
# Les quatre paliers par hauteur d'ecran retrecissaient donc les
# visages pour rien, et jusqu'a 222 px — moins que les 248 px d'avant
# la refonte. Ils sautent. Un seul diametre, 282 px, partout : c'est
# le plus grand qui ne coute pas une ligne de defilement.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("un seul diametre, le plus grand qui soit gratuit", <<'AV', <<'AP');
  --rond:330px;
AV
  /* 282 px : le plus grand diametre tel que deux rangees tiennent
     encore dans la hauteur que la colonne du centre impose de toute
     facon. Mesure, pas choisi. */
  --rond:282px;
AP

ech("les paliers par hauteur d ecran sautent", <<'AV', <<'AP');
/* Les paliers sont mesures, pas choisis : a chacun d'eux, deux
   rangees de medaillons tiennent encore dans la hauteur que la
   colonne du centre impose de toute facon. */
@media(max-height:940px){ .scene{--rond:300px} }
@media(max-height:860px){ .scene{--rond:276px} }
@media(max-height:790px){ .scene{--rond:252px; gap:10px} }
@media(max-height:720px){ .scene{--rond:228px}
  .poste .nm{font-size:14.5px} .poste .et{display:none} }
AV
/* Plus de palier par hauteur d'ecran : la mesure a montre que ce
   n'est pas la fenetre qui commande la hauteur de la scene, mais la
   colonne du centre — et elle ne change pas avec la fenetre. Les
   paliers retrecissaient les visages sans rien gagner. Seul reste un
   ecran vraiment bas, ou la bande de nom se resserre. */
@media(max-height:700px){
  .poste .nm{font-size:14.5px} .poste .et{display:none}
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

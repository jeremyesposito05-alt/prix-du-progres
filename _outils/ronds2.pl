#!/usr/bin/perl
# LE MEDAILLON PREND TOUTE LA PLACE QU IL Y A
#
#   perl _outils/ronds2.pl index.html
#
# CE QUE LA MESURE A DIT. On a releve, a plusieurs hauteurs d'ecran,
# la largeur de chaque boite : fenetre 1418, bureau 1403, plateau
# 1240, colonne laterale 262, medaillon 262. Colonne et medaillon
# egaux : c'etait mon plafond qui limitait, pas la place. Il restait
# cinquante pixels de bureau inutilises de chaque cote.
#
# ET LA VRAIE CONTRAINTE. La hauteur de la scene ne vient pas des
# portraits mais de la colonne du centre — ordre du jour, question,
# trois plaques : 604 px. Tant que deux rangees de medaillons tiennent
# dans ces 604 px, agrandir ne coute RIEN. Au-dela, la page s'allonge
# et il faut redescendre pour voir reagir les acteurs — le defaut
# qu'on vient de corriger.
#
# D OU LES TROIS CHANGEMENTS.
#   1. Le plateau passe a 1340 : les colonnes laterales gagnent les
#      cinquante pixels que le bureau laissait perdre, et la colonne
#      du centre garde sa largeur — sinon le texte prend une ligne de
#      plus et la page s'allonge par l'autre bout.
#   2. Le nom se pose SUR le bas du medaillon au lieu d'en dessous :
#      trente-quatre pixels par rangee rendus au diametre.
#   3. Le diametre suit la hauteur de l'ecran, mais vers le haut :
#      330 sur un grand ecran, 232 sur un portable bas. Jamais en
#      rognant l'image — le rond reste un rond.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("le plateau prend la largeur que le bureau offrait", <<'AV', <<'AP');
.plateau.large{max-width:1240px;margin:0 auto;grid-template-columns:minmax(0,1fr)}
AV
.plateau.large{max-width:1340px;margin:0 auto;grid-template-columns:minmax(0,1fr)}
AP

ech("les colonnes laterales prennent ces cent pixels", <<'AV', <<'AP');
  grid-template-columns:minmax(0,1.08fr) minmax(0,1.95fr) minmax(0,1.08fr);
  grid-template-rows:auto auto;
  margin:0 0 4px;
  --rond:300px;
AV
  /* 1 / 1,6 / 1 sur 1340 px : la colonne du centre garde les 587 px
     qu'elle avait, au pixel pres — c'est elle qui decide du nombre de
     lignes, donc de la hauteur de la page. Tout le reste va aux
     medaillons. */
  grid-template-columns:minmax(0,1fr) minmax(0,1.6fr) minmax(0,1fr);
  grid-template-rows:auto auto;
  margin:0 0 4px;
  --rond:330px;
AP

ech("le nom se pose sur le bas du medaillon", <<'AV', <<'AP');
.poste .ident{display:flex;flex-direction:column;gap:0;line-height:1.18;
  text-align:center;align-items:center}
AV
/* Il mord sur le bas du rond : trente-quatre pixels par rangee rendus
   au diametre, et le nom reste lisible — il porte son ombre. */
.poste .ident{display:flex;flex-direction:column;gap:0;line-height:1.18;
  text-align:center;align-items:center;
  position:relative; z-index:2; margin-top:-34px; pointer-events:none;
  padding:2px 6px 1px; border-radius:11px;
  background:radial-gradient(ellipse at 50% 55%,
    rgba(14,9,5,.62) 0%, rgba(14,9,5,.42) 55%, transparent 78%)}
AP

ech("la jauge se serre sous le nom pose", <<'AV', <<'AP');
.poste .tige{height:4px;border-radius:2px;width:62%;margin:1px auto 0;
  background:rgba(20,14,8,.45);overflow:hidden;
  box-shadow:0 0 0 1px rgba(0,0,0,.25)}
AV
.poste .tige{height:4px;border-radius:2px;width:58%;margin:3px auto 0;
  background:rgba(20,14,8,.5);overflow:hidden;
  box-shadow:0 0 0 1px rgba(0,0,0,.3)}
AP

ech("le diametre suit la hauteur, et jamais en rognant", <<'AV', <<'AP');
@media(max-height:900px){ .scene{--rond:262px} }
@media(max-height:800px){ .scene{--rond:232px; gap:9px 10px}
  .poste .nm{font-size:14.5px} }
@media(max-height:720px){ .scene{--rond:204px}
  .poste .et{display:none} }
AV
/* Les paliers sont mesures, pas choisis : a chacun d'eux, deux
   rangees de medaillons tiennent encore dans la hauteur que la
   colonne du centre impose de toute facon. */
@media(max-height:940px){ .scene{--rond:300px} }
@media(max-height:860px){ .scene{--rond:276px} }
@media(max-height:790px){ .scene{--rond:252px; gap:10px} }
@media(max-height:720px){ .scene{--rond:228px}
  .poste .nm{font-size:14.5px} .poste .et{display:none} }
AP

ech("au telephone le nom redescend sous la pastille", <<'AV', <<'AP');
  .poste .ident{text-align:left;align-items:flex-start}
AV
  .poste .ident{text-align:left;align-items:flex-start;
    margin-top:0;background:none;padding:0}
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-54s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

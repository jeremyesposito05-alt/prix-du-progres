#!/usr/bin/perl
# QUATRE DEFAUTS DE LA NOUVELLE MISE EN PAGE
#
#   perl _outils/tranche2.pl index.html
#
# 1. LA JAUGE TRAVERSAIT LE NOM. La carte est passee en « flex-direction:
#    row » : la jauge, qui est la soeur du bloc du nom et non sa fille,
#    est devenue le TROISIEME element de la rangee et s'est posee a
#    cote du nom au lieu d'en dessous. La carte devient une grille a
#    deux colonnes : medaillon a gauche sur deux rangees, nom en haut
#    a droite, jauge sous le nom.
#
# 2. LE BANDEAU NE FAISAIT QUE 401 PX. « margin:16px auto 0 » sur un
#    element de grille : des marges automatiques dans l'axe en ligne
#    annulent l'etirement, et la boite se reduit a son contenu. Mesure
#    a l'appui — .scene faisait 1400 px, .tranche 401. Les marges
#    automatiques sautent.
#
# 3. LES TROIS CHOIX RESTAIENT EMPILES. « .centre .rep » et
#    « .tranche .rep » ont la meme specificite, et l'ancienne regle
#    etait ecrite apres. Le bandeau prend « .tranche.centre .rep ».
#
# 4. LES BULLES DU HAUT SORTAIENT DU PLATEAU. Elles se posent
#    au-dessus de la carte, et la rangee du haut touchait le bandeau
#    du titre. La scene prend de l'air au-dessus — elle peut se le
#    permettre : elle a perdu plus de deux cents pixels en passant aux
#    cartes.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ----------------------------------------------------------------- 1
ech("la carte devient une grille : la jauge passe sous le nom", <<'AV', <<'AP');
  /* Une carte : medaillon a gauche, nom et jauge a droite. Memes
     materiaux que les plaques de choix — plaque sombre, filet d'or —
     pour que le plateau tienne d'une seule matiere. */
  display:flex; flex-direction:row; align-items:center; gap:16px;
  padding:14px 20px 14px 14px; border-radius:6px; width:100%;
AV
  /* Une carte : medaillon a gauche, nom et jauge a droite. Memes
     materiaux que les plaques de choix — plaque sombre, filet d'or —
     pour que le plateau tienne d'une seule matiere.
     Une GRILLE et non une rangee : la jauge est la soeur du bloc du
     nom, pas sa fille — en rangee elle se posait a COTE du nom. */
  display:grid; grid-template-columns:var(--rond) minmax(0,1fr);
  grid-template-rows:auto auto; align-items:center;
  column-gap:18px; row-gap:0;
  padding:14px 20px 14px 14px; border-radius:6px; width:100%;
AP

ech("chacun sa case dans la carte", <<'AV', <<'AP');
.poste .ident{display:flex;flex-direction:column;gap:1px;line-height:1.16;
  flex:1 1 auto; min-width:0; text-align:left; align-items:flex-start;
  pointer-events:none}
AV
.poste .visage{grid-area:1/1/3/2}
.poste .ident{grid-area:1/2/2/3; align-self:end;
  display:flex;flex-direction:column;gap:1px;line-height:1.16;
  min-width:0; text-align:left; align-items:flex-start;
  pointer-events:none}
AP

ech("la jauge occupe la case du dessous", <<'AV', <<'AP');
.poste .tige{height:7px;border-radius:4px;width:100%;max-width:190px;
  margin:7px 0 0; background:rgba(0,0,0,.55);overflow:hidden;
  box-shadow:inset 0 1px 2px rgba(0,0,0,.6)}
AV
.poste .tige{grid-area:2/2/3/3; align-self:start;
  height:7px;border-radius:4px;width:100%;max-width:200px;
  margin:9px 0 0; background:rgba(0,0,0,.55);overflow:hidden;
  box-shadow:inset 0 1px 2px rgba(0,0,0,.6)}
AP

# ----------------------------------------------------------------- 2 et 3
ech("le bandeau s etire, et ses trois plaques avec lui", <<'AV', <<'AP');
.tranche{max-width:1400px; margin:16px auto 0}
.tranche .question{display:flex; align-items:center; gap:20px;
  margin:0 0 14px; grid-column:auto; white-space:nowrap}
.tranche .question::before,.tranche .question::after{
  content:""; flex:1 1 auto; height:1px; min-width:30px;
  background:linear-gradient(90deg,transparent,rgba(214,176,106,.55),transparent)}
.tranche .rep{display:grid; grid-template-columns:repeat(3,minmax(0,1fr));
  gap:14px; margin:0; counter-reset:choix}
@media(max-width:1000px){
  .tranche .rep{grid-template-columns:minmax(0,1fr)}
  .tranche .question{white-space:normal}
}
AV
/* Pas de marge automatique : dans une grille, des marges auto dans
   l'axe en ligne annulent l'etirement et la boite se reduit a son
   contenu — mesure, 401 px au lieu de 1400. */
.tranche{margin:18px 0 0}
.tranche.centre .question{display:flex; align-items:center; gap:20px;
  margin:0 0 15px; grid-column:auto; white-space:nowrap}
.tranche.centre .question::before,.tranche.centre .question::after{
  content:""; flex:1 1 auto; height:1px; min-width:30px;
  background:linear-gradient(90deg,transparent,rgba(214,176,106,.55),transparent)}
/* « .centre .rep » a la meme specificite et etait ecrite apres : il
   faut la classe du bandeau EN PLUS pour l'emporter. */
.tranche.centre .rep{display:grid;
  grid-template-columns:repeat(3,minmax(0,1fr));
  gap:16px; margin:0; counter-reset:choix}
@media(max-width:1040px){
  .tranche.centre .rep{grid-template-columns:minmax(0,1fr)}
  .tranche.centre .question{white-space:normal}
}
AP

ech("la plaque du bandeau prend sa classe", <<'AV', <<'AP');
.tranche .choix{
  align-items:flex-start !important;
  padding:16px 18px 18px !important;
  min-height:92px;
}
.tranche .choix .q{font-size:17px !important; line-height:1.34}
AV
.tranche.centre .choix{
  align-items:flex-start !important;
  padding:16px 18px 18px !important;
  min-height:94px;
}
.tranche.centre .choix .q{font-size:17px !important; line-height:1.34}
.tranche.centre .apres{margin:0}
AP

# ----------------------------------------------------------------- 4
ech("la scene prend de l air pour les bulles du haut", <<'AV', <<'AP');
  grid-template-columns:minmax(0,1fr) minmax(0,1.45fr) minmax(0,1fr);
  grid-template-rows:auto auto;
  margin:0 0 4px;
  --rond:150px;
AV
  grid-template-columns:minmax(0,1fr) minmax(0,1.45fr) minmax(0,1fr);
  grid-template-rows:auto auto;
  /* Les bulles se posent AU-DESSUS des cartes : sans cet air, celles
     de la rangee du haut passaient sous le bandeau du titre. La scene
     peut se le permettre, elle a perdu plus de deux cents pixels en
     passant aux cartes. */
  margin:0 0 4px; padding-top:62px;
  --rond:150px;
AP

ech("l ordre du jour ne descend pas avec la scene", <<'AV', <<'AP');
.scene > .centre{grid-area:1/2/3/3; display:flex; flex-direction:column;
  gap:10px; position:relative; z-index:1}
AV
.scene > .centre{grid-area:1/2/3/3; display:flex; flex-direction:column;
  gap:10px; position:relative; z-index:1;
  /* il remonte dans l'air pris pour les bulles : rien ne se pose
     au-dessus de lui */
  margin-top:-50px}
AP

ech("la rangee du bas laisse voir la carte du haut", <<'AV', <<'AP');
  display:grid; gap:12px 10px; align-items:start;
AV
  display:grid; gap:26px 12px; align-items:start;
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-56s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

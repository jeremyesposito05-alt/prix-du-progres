#!/usr/bin/perl
# LA CARTE D ACTEUR SUR TELEPHONE
#
#   perl _outils/telephone.pl index.html
#
# LE BUG. Sur telephone, les bulles de dialogue s affichaient en une
# colonne d un mot par ligne, par-dessus la carte.
#
# LA CAUSE, ET ELLE EST DE MOI. Le 12 octobre, la carte d acteur est
# passee de « rangee flexible » a « grille a deux colonnes » pour que
# la jauge cesse de traverser le nom. La regle telephone, elle, n a pas
# suivi : elle continuait de parler de « flex-direction », de « flex:1 »
# et de « flex:0 0 96px », qui ne veulent plus rien dire sur une
# grille. La bulle n ayant plus de case assignee, le navigateur l a
# placee tout seul dans la premiere case libre — etroite — d ou la
# colonne d un mot.
#
# Le bloc avait aussi accumule les doublons de trois corrections
# successives : « .poste .ident » deux fois, « .poste .dit » trois
# fois, et deux definitions contradictoires de sa queue. Il est
# reecrit en entier plutot que rapiece une quatrieme fois.
#
# CE QU ON FAIT. La carte reste une grille, mais a TROIS rangees : le
# portrait et le nom en haut, la jauge dessous, et la bulle en travers
# des deux colonnes, en bas. Sa queue pointe vers le haut, vers le
# portrait. C est la disposition naturelle sur un ecran etroit : on lit
# qui parle, puis ce qu il dit.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my $av = <<'AV';
@media(max-width:860px){
  .scene{display:flex; flex-direction:column; gap:11px}
  .scene > .centre{display:contents}
  .centre .ordre{order:-2}
  .poste{order:0}
  .tranche .question{order:1;margin:6px 0 2px;white-space:normal}
  .tranche .rep{order:2}
  .centre .moi{display:none}
  .centre .ordre .encoche{display:none}
  .poste{flex-direction:row;align-items:center;gap:10px;transform:none!important}
  .poste{width:auto;padding:9px 11px}
  .poste .visage{width:62px;flex:0 0 62px;aspect-ratio:1;border-width:2px}
  .poste .ident{flex:0 0 96px}
  .poste .nm{font-size:15px}
  .poste .dit{position:relative;bottom:auto;max-width:none;width:auto}
  .poste .dit::before{top:16px;left:-19px;border-width:9px;
    border-top-color:transparent !important;
    border-right-color:rgba(74,56,38,.6) !important}
  .poste .ident{flex:0 0 96px}
  .poste .tige{display:none}
  .poste .dit{position:relative;flex:1;width:auto;border-radius:12px;
    padding:8px 11px;box-shadow:none}
  .poste .dit::after{display:none}
  .poste .dit::before{top:16px;left:-19px;right:auto;border-width:9px;
    border-right-color:rgba(74,56,38,.6) !important;
    border-left-color:transparent !important}
}
AV

my $ap = <<'AP';
/* ---------- LE TELEPHONE ----------
   Le plateau devient une colonne : ordre du jour, les quatre cartes,
   la question, les trois choix. Et la carte d'acteur garde sa grille,
   mais a TROIS rangees — portrait et nom en haut, jauge dessous,
   bulle en travers des deux colonnes, en bas.

   Sans case assignee, la bulle etait placee d'office par le
   navigateur dans la premiere case libre, large d'un mot : c'est le
   defaut observe le 14 octobre. Sur un ecran etroit, lire d'abord qui
   parle puis ce qu'il dit est de toute facon la bonne lecture. */
@media(max-width:860px){
  .scene{display:flex; flex-direction:column; gap:11px;
    padding-top:0; --rond:62px}
  .scene > .centre{display:contents; margin-top:0}
  .centre .ordre{order:-2}
  .poste{order:0}
  .tranche .question{order:1;margin:6px 0 2px;white-space:normal}
  .tranche .rep{order:2}
  .centre .moi{display:none}
  .centre .ordre .encoche{display:none}

  .poste{width:auto; padding:9px 11px; transform:none!important;
    grid-template-columns:var(--rond) minmax(0,1fr);
    grid-template-rows:auto auto auto; column-gap:10px}
  .poste .visage{border-width:2px}
  .poste .ident{grid-area:1/2/2/3}
  .poste .nm{font-size:15px}
  .poste .et{display:block}
  .poste .tige{grid-area:2/2/3/3; max-width:none; height:5px; margin-top:5px}

  .poste .dit{grid-area:3/1/4/3;
    position:relative; top:auto; bottom:auto; left:auto; right:auto;
    width:auto; max-width:none; margin:11px 0 0;
    border-radius:13px; padding:9px 12px;
    box-shadow:0 3px 10px rgba(0,0,0,.28); font-size:14px}
  /* la queue pointe vers le HAUT, vers le portrait qui est au-dessus */
  .poste .dit::before{top:-20px; bottom:auto; left:22px; right:auto;
    border-width:10px;
    border-top-color:transparent !important;
    border-bottom-color:rgba(74,56,38,.6) !important}
  .poste .dit::after{top:-17px; bottom:auto; left:23px; right:auto;
    border-width:9px; display:block;
    border-top-color:transparent !important;
    border-bottom-color:#FFFCF2 !important}
  .poste.gagne .dit::before{border-bottom-color:rgba(63,106,46,.65) !important}
  .poste.perd .dit::before,.poste.perd-fort .dit::before{
    border-bottom-color:rgba(166,48,36,.6) !important}
}
AP

my $n = () = ($s =~ /\Q$av\E/g);
$n == 1 or die "ARRET : le bloc telephone a ete trouve $n fois. Rien n'a ete ecrit.\n";
$s =~ s/\Q$av\E/$ap/;

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
print "  ok  le bloc telephone est reecrit\n";

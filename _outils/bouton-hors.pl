#!/usr/bin/perl
# LE BOUTON SORT DE LA ZONE QUI DEFILE
#
# Deux tentatives ratees avant celle-ci, et elles se ressemblent :
# l'ombre large ne couvrait que les abords du bouton, le texte passait
# de part et d'autre ; le bandeau en pseudo-element passait DEVANT le
# bouton — dans un contexte d'empilement, un enfant en z-index negatif
# se peint au-dessus du fond de son parent — et ses 340 px de debord
# ouvraient une barre de defilement horizontale.
#
# Les deux cherchaient a CACHER le texte derriere le bouton. La bonne
# reponse est qu'il n'y ait rien derriere lui : la feuille devient une
# colonne, le texte defile dans la partie haute, le bouton reste en
# bas, hors de la zone qui defile. Plus de collage, plus de fond
# postiche, plus rien a masquer.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";

my @T; sub ech { push @T, [ @_ ] }

ech("la feuille devient une colonne, le texte defile dedans", <<'AV', <<'AP');
  /* Elle ne peut plus etre plus haute que l'ecran : au-dela, c'est
     son texte qui defile, pas la page. */
  margin:auto; max-height:calc(100vh - 40px); overflow-y:auto;
  overscroll-behavior:contain;
AV
  /* Elle ne peut plus etre plus haute que l'ecran. Et c'est son TEXTE
     qui defile, pas elle : le bouton vit hors de la zone qui defile,
     donc rien ne peut passer derriere lui. */
  margin:auto; max-height:calc(100vh - 40px);
  display:flex; flex-direction:column; overflow:hidden;
AP

ech("la zone qui defile, et le bouton qui n en fait pas partie", <<'AV', <<'AP');
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
AV
/* « min-height:0 » : sans lui, un enfant de colonne flexible refuse
   de devenir plus court que son contenu, et le defilement ne part
   jamais. */
.lettre-prof .cp-corps{overflow-y:auto; overscroll-behavior:contain;
  min-height:0; flex:1 1 auto;
  /* un filet de papier en haut et en bas dit qu'il reste du texte */
  mask-image:linear-gradient(180deg,transparent 0,#000 10px,
             #000 calc(100% - 10px),transparent 100%);
  -webkit-mask-image:linear-gradient(180deg,transparent 0,#000 10px,
             #000 calc(100% - 10px),transparent 100%)}
.lettre-prof button{display:block; margin:16px auto 0; flex:0 0 auto}
AP

ech("js : le corps de la lettre est enveloppe", <<'AV', <<'AP');
    <article class="lettre-prof courrier-prof">
      <div class="cp-tete">
AV
    <article class="lettre-prof courrier-prof">
      <div class="cp-corps">
      <div class="cp-tete">
AP

ech("js : et referme avant le bouton", <<'AV', <<'AP');
      ${corps}
      <button class="plein" onclick="lettreLue()">J’ai compris · place au choix</button>
AV
      ${corps}
      </div>
      <button class="plein" onclick="lettreLue()">J’ai compris · place au choix</button>
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-48s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

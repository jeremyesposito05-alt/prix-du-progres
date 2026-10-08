#!/usr/bin/perl
# LA RONDE : LA PHRASE AU-DESSUS, LES QUATRE CARRES SEULS
#
#   perl _outils/ronde2.pl index.html
#
# La phrase occupait la colonne du milieu, entre les quatre fiches.
# Posee sur la photographie du decor, sans papier dessous, elle se
# lisait mal — et elle ecrasait les fiches sur les cotes, qui n'avaient
# plus que le tiers de la largeur pour un paragraphe entier.
#
# Elle monte au-dessus de la ronde. Les quatre fiches prennent alors
# chacune la moitie de la largeur : le texte du role respire, et les
# quatre carres se lisent d'un coup comme un ensemble.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("js : la phrase sort du centre", <<'AV', <<'AP');
  <div class="ronde">
    ${["i","m"].map(fichActeur).join("")}
    <div class="ronde-c">
      <p class="rc-t">Les quatre groupes qui vous jugent</p>
      <p class="rc-x">Chaque décision en contente un et en fâche un autre.
      Si l’un d’eux vous abandonne tout à fait, la partie s’arrête.</p>
    </div>
    ${["o","p"].map(fichActeur).join("")}
  </div>
AV
  <div class="ronde-tete">
    <p class="rc-t">Les quatre groupes qui vous jugent</p>
    <p class="rc-x">Chaque décision en contente un et en fâche un autre.
    Si l’un d’eux vous abandonne tout à fait, la partie s’arrête.</p>
  </div>
  <div class="ronde">
    ${["i","m","o","p"].map(fichActeur).join("")}
  </div>
AP

ech("css : deux colonnes, et le titre au-dessus", <<'AV', <<'AP');
.ronde{
  display:grid; gap:14px 16px; align-items:stretch; margin:22px 0 6px;
  grid-template-columns:minmax(0,1fr) minmax(0,.72fr) minmax(0,1fr);
}
.r-i{grid-area:1/1} .r-m{grid-area:1/3}
.r-o{grid-area:2/1} .r-p{grid-area:2/3}
.ronde-c{grid-area:1/2/3/3; display:flex; flex-direction:column;
  align-items:center; justify-content:center; text-align:center; padding:8px 4px}
AV
/* Les quatre fiches, moitie-moitie. La phrase qui les presente est
   passee au-dessus : au milieu, elle ne leur laissait qu'un tiers de
   la largeur chacune pour un paragraphe entier. */
.ronde{
  display:grid; gap:14px 16px; align-items:stretch; margin:14px 0 6px;
  grid-template-columns:repeat(2, minmax(0,1fr));
}
.ronde-tete{
  margin:24px auto 0; max-width:62ch; text-align:center;
  display:flex; flex-direction:column; align-items:center;
}
AP

ech("css : le titre et sa phrase, lisibles sur la photographie", <<'AV', <<'AP');
.ronde-c .rc-t{
  margin:0 0 8px; font-family:var(--serif); font-size:clamp(17px,2vw,21px);
  color:var(--pap); text-shadow:0 2px 14px rgba(0,0,0,.85); line-height:1.2;
}
.ronde-c .rc-x{
  margin:0; font-size:13.5px; line-height:1.55; color:#CDBCA2;
  text-shadow:0 2px 10px rgba(0,0,0,.9); max-width:30ch;
}
@media(max-width:900px){
  .ronde{display:flex; flex-direction:column}
  .ronde-c{order:-1; padding:0 0 4px}
  .fich{grid-template-columns:76px minmax(0,1fr)}
}
AV
.ronde-tete .rc-t{
  margin:0 0 7px; font-family:var(--serif); font-size:clamp(19px,2.4vw,25px);
  color:var(--pap); text-shadow:0 2px 16px rgba(0,0,0,.9); line-height:1.2;
}
.ronde-tete .rc-x{
  margin:0; font-size:14px; line-height:1.55; color:#CDBCA2;
  text-shadow:0 2px 10px rgba(0,0,0,.92); max-width:56ch;
}
@media(max-width:900px){
  .ronde{grid-template-columns:minmax(0,1fr)}
  .fich{grid-template-columns:76px minmax(0,1fr)}
}
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-46s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

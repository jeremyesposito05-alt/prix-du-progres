#!/usr/bin/perl
# TROIS DEFAUTS MESURES SUR LE RENDU
#
#   perl _outils/plateau2b.pl index.html
#
# 1. Les bulles passaient DERRIERE l'ordre du jour. Un poste a bien
#    « position:relative » et un « transform », mais son z-index reste
#    « auto » : l'ordre de peinture suit l'ordre du document, et les
#    deux postes du haut sont ecrits avant le centre.
# 2. Les bulles du bas mordaient sur les trois reponses. On leur
#    reserve leur place par une marge, comme on l'a fait pour le texte.
# 3. Le carnet s'ouvrait toujours : la partie naissait avec
#    « carnetOuvert:true ».
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);

my @T;
sub ech { push @T, [ @_ ] }

ech("css : les postes passent devant le centre", <<'AV', <<'AP');
.poste{
  position:relative; display:flex; flex-direction:column; gap:6px;
AV
.poste{
  /* z-index : sans lui, les deux postes du haut sont peints avant le
     centre — leurs bulles disparaissaient sous la feuille. */
  position:relative; z-index:3;
  display:flex; flex-direction:column; gap:6px;
AP

ech("css : les reponses ne portent plus de marge fixe", <<'AV', <<'AP');
.centre .rep{grid-template-columns:minmax(0,1fr);gap:9px;margin:0}
AV
/* Les marges gauche et droite sont posees par « calerBulles » : ce
   sont les deux bulles du bas qui disent de combien il faut se
   serrer. */
.centre .rep{grid-template-columns:minmax(0,1fr);gap:9px;margin:0;
  transition:margin .3s ease}
AP

ech("js : on reserve aussi la place des deux bulles du bas", <<'AV', <<'AP');
function calerBulles(){
  const sc = app.querySelector(".scene"); if(!sc) return;
  const ord = sc.querySelector(".ordre"); if(!ord) return;
  const r = ord.getBoundingClientRect();
  if(!r.width) return;
  const cs = getComputedStyle(ord);
AV
function calerBulles(){
  const sc = app.querySelector(".scene"); if(!sc) return;
  const ord = sc.querySelector(".ordre"); if(!ord) return;

  /* Au telephone la scene est une colonne : les bulles ne debordent
     sur rien, et toute mesure posee ici serait a defaire. */
  const rep = sc.querySelector(".rep");
  if(innerWidth <= 860){
    for(const e of sc.querySelectorAll(".encoche")) e.style.cssText = "";
    if(rep){ rep.style.marginLeft = rep.style.marginRight = "" }
    return;
  }

  /* Les trois reponses se serrent entre les deux bulles du bas. */
  if(rep){
    const ce = sc.querySelector(".centre").getBoundingClientRect();
    const bg = sc.querySelector(".p-o .dit"), bd = sc.querySelector(".p-p .dit");
    const g = bg ? Math.max(0, bg.getBoundingClientRect().right - ce.left + 14) : 0;
    const d = bd ? Math.max(0, ce.right - bd.getBoundingClientRect().left + 14) : 0;
    /* on ne laisse jamais moins de 260 px pour lire une reponse */
    const place = ce.width - g - d;
    const k = place < 260 ? Math.max(0, (ce.width - 260) / (g + d || 1)) : 1;
    rep.style.marginLeft  = Math.round(g * k) + "px";
    rep.style.marginRight = Math.round(d * k) + "px";
  }

  const r = ord.getBoundingClientRect();
  if(!r.width) return;
  const cs = getComputedStyle(ord);
AP

# Celui-ci est au milieu d'une ligne : pas de heredoc, qui ajouterait
# un saut de ligne a la fin de ce qu'on cherche.
ech("js : la partie naissait carnet ouvert",
    "carnet:[],carnetOuvert:true,crLus:0",
    "carnet:[],carnetOuvert:false,crLus:0");

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-52s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

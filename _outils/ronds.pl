#!/usr/bin/perl
# LES QUATRE VISAGES EN MEDAILLON, SERRES AUTOUR DE L ORDRE DU JOUR
#
#   perl _outils/ronds.pl index.html
#
# POURQUOI LES PORTRAITS ETAIENT DEVENUS PETITS. Pour faire tenir le
# plateau sur un portable, le cadre passait en carre sous 900 px de
# haut, puis en 4/3 sous 760. Le visage ne retrecissait pas en
# largeur : il se faisait couper. Le plateau tenait, les visages
# avaient disparu.
#
# CE QU ON FAIT A LA PLACE. Un medaillon rond. Il coute sa largeur en
# hauteur, la et pas plus — un cadre en 4/5 en coutait un quart de
# plus. Le cadre de papier autour du portrait saute : son fond, son
# filet et ses onze pixels de marge ne servaient qu a encadrer une
# image qui porte deja son propre bord. Tout ce qui est recupere
# passe dans le diametre.
#
# ET LES QUATRE SE SERRENT. Les colonnes laterales s elargissent, les
# gouttieres se reduisent, et chaque poste se cale du cote de l ordre
# du jour. Le conseil se tient autour de la table au lieu de border
# l ecran.
#
# ENFIN CELUI QUI PARLE AVANCE. La mise en scene decouvre les bulles
# une a une : le poste dont la bulle s ecrit prend « dit-maintenant »
# et s avance, les autres restent en arriere. Quand tout est dit,
# personne n est plus « maintenant » : le regard est libre pour les
# trois choix.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ---------------------------------------------------------------- 1
ech("la grille : colonnes laterales plus larges, gouttieres serrees", <<'AV', <<'AP');
.plateau.large{max-width:1180px;margin:0 auto;grid-template-columns:minmax(0,1fr)}

.scene{
  display:grid; gap:14px 18px; align-items:stretch;
  grid-template-columns:minmax(0,.95fr) minmax(0,2fr) minmax(0,.95fr);
  grid-template-rows:auto auto;
  margin:0 0 4px;
}
AV
.plateau.large{max-width:1240px;margin:0 auto;grid-template-columns:minmax(0,1fr)}

/* Les colonnes des acteurs gagnent ce que les gouttieres perdent :
   le medaillon est plus large, et les quatre se tiennent plus pres
   de l'ordre du jour. */
.scene{
  display:grid; gap:12px 10px; align-items:start;
  grid-template-columns:minmax(0,1.08fr) minmax(0,1.95fr) minmax(0,1.08fr);
  grid-template-rows:auto auto;
  margin:0 0 4px;
  --rond:300px;
}
AP

# ---------------------------------------------------------------- 2
ech("le poste perd son cadre de papier et se cale vers le centre", <<'AV', <<'AP');
.poste{
  /* z-index : sans lui, les deux postes du haut sont peints avant le
     centre — leurs bulles disparaissaient sous la feuille. */
  position:relative; z-index:3;
  display:flex; flex-direction:column; gap:6px;
  padding:10px 11px 11px; border-radius:3px;
  background:linear-gradient(176deg,var(--pap) 0%,var(--pap2) 100%);
  border:1px solid rgba(107,87,65,.3);
  box-shadow:0 2px 7px rgba(43,33,24,.17);
  transition:transform .42s cubic-bezier(.22,.9,.26,1),
             box-shadow .42s ease, filter .42s ease, opacity .42s ease;
  transform:scale(.975); opacity:.9;
}
AV
.poste{
  /* z-index : sans lui, les deux postes du haut sont peints avant le
     centre — leurs bulles disparaissaient sous la feuille. */
  position:relative; z-index:3;
  display:flex; flex-direction:column; gap:5px;
  /* Plus de cadre de papier : le medaillon porte son propre bord, et
     les onze pixels de marge passent dans le diametre. */
  padding:0;
  width:min(100%,var(--rond));
  transition:transform .42s cubic-bezier(.22,.9,.26,1),
             filter .42s ease, opacity .42s ease;
  transform:scale(.975); opacity:.88;
}
/* chacun se range du cote de l'ordre du jour */
.p-i,.p-o{justify-self:end}
.p-m,.p-p{justify-self:start}
AP

# ---------------------------------------------------------------- 3
ech("les ombres du poste passent sur le medaillon", <<'AV', <<'AP');
.poste.gagne{opacity:1; box-shadow:0 7px 010px rgba(43,33,24,.3), 0 0 0 1px rgba(63,106,46,.4)}
AV
.poste.gagne{opacity:1}
AP

ech("le filet rouge du perdant suit le rond", <<'AV', <<'AP');
.poste.perd-fort::after{
  content:""; position:absolute; inset:-1px; border-radius:3px;
  box-shadow:inset 0 0 0 1px rgba(166,48,36,.5); pointer-events:none;
}
AV
.poste.perd-fort .visage{box-shadow:0 0 0 2px rgba(166,48,36,.5)}
AP

# ---------------------------------------------------------------- 4
ech("le cadre devient un medaillon rond", <<'AV', <<'AP');
.poste .visage{
  position:relative; width:100%; aspect-ratio:4/5;
  border-radius:2px; overflow:hidden; background:var(--pap2);
  border:1px solid rgba(107,87,65,.28);
  transition:box-shadow .42s ease;
}
AV
.poste .visage{
  position:relative; width:100%; aspect-ratio:1;
  border-radius:50%; overflow:hidden; background:var(--pap2);
  border:3px solid rgba(107,87,65,.4);
  box-shadow:0 6px 16px rgba(43,33,24,.3);
  transition:box-shadow .42s ease, border-color .42s ease;
}
.poste.gagne .visage{border-color:rgba(63,106,46,.6)}
AP

ech("l image se cale sur la tete dans le rond", <<'AV', <<'AP');
.poste .visage img{width:100%;height:100%;object-fit:cover;display:block;
AV
.poste .visage img{width:100%;height:100%;object-fit:cover;display:block;
  object-position:50% 14%;
AP

ech("le vignettage epouse le rond", <<'AV', <<'AP');
  background:radial-gradient(ellipse at 50% 40%,
    transparent 42%, rgba(28,19,11,.62) 100%);
AV
  background:radial-gradient(circle at 50% 42%,
    transparent 40%, rgba(28,19,11,.66) 100%);
AP

# ---------------------------------------------------------------- 5
ech("le nom se centre sous le medaillon", <<'AV', <<'AP');
.poste .ident{display:flex;flex-direction:column;gap:1px;line-height:1.2}
.poste .nm{font-family:var(--serif);font-size:15px;color:var(--enc)}
.poste .et{font-size:10.5px;color:var(--rge);letter-spacing:.03em}
AV
.poste .ident{display:flex;flex-direction:column;gap:0;line-height:1.18;
  text-align:center;align-items:center}
.poste .nm{font-family:var(--serif);font-size:16px;color:#EFE3CC;
  text-shadow:0 1px 6px rgba(0,0,0,.8)}
body[data-niveau="II"] .poste .nm{color:#E4ECF5}
.poste .et{font-size:10.5px;color:#D8B370;letter-spacing:.04em;
  text-shadow:0 1px 5px rgba(0,0,0,.8)}
AP

ech("la jauge se pose sous le nom", <<'AV', <<'AP');
.poste .tige{height:3px;border-radius:2px;background:rgba(107,87,65,.2);overflow:hidden}
AV
.poste .tige{height:4px;border-radius:2px;width:62%;margin:1px auto 0;
  background:rgba(20,14,8,.45);overflow:hidden;
  box-shadow:0 0 0 1px rgba(0,0,0,.25)}
AP

# ---------------------------------------------------------------- 6
ech("celui qui parle avance, les autres patientent", <<'AV', <<'AP');
/* Concerne par l'affaire : il se penche un peu, sans qu'on le dise. */
.poste.concerne{opacity:1}
.p-i.concerne,.p-o.concerne{transform:scale(1) translateX(5px)}
.p-m.concerne,.p-p.concerne{transform:scale(1) translateX(-5px)}
AV
/* Concerne par l'affaire : il se penche un peu, sans qu'on le dise. */
.poste.concerne{opacity:1}
.p-i.concerne,.p-o.concerne{transform:scale(1) translateX(5px)}
.p-m.concerne,.p-p.concerne{transform:scale(1) translateX(-5px)}

/* IL A LA PAROLE. La mise en scene ecrit les bulles une a une : celui
   dont la bulle s'ecrit s'avance d'un pas et passe devant les autres.
   Quand tout est dit, plus personne n'est « maintenant » et le regard
   est libre pour les trois choix. */
.poste.parle{opacity:1}
.poste.dit-maintenant{z-index:7; opacity:1}
.poste.dit-maintenant .visage{border-color:rgba(216,179,112,.75);
  box-shadow:0 10px 26px rgba(43,33,24,.45), 0 0 0 4px rgba(216,179,112,.2)}
.p-i.dit-maintenant,.p-o.dit-maintenant{transform:scale(1.075) translateX(10px)}
.p-m.dit-maintenant,.p-p.dit-maintenant{transform:scale(1.075) translateX(-10px)}
AP

# ---------------------------------------------------------------- 7
ech("la queue de la bulle part de la joue, pas du coin du cadre", <<'AV', <<'AP');
.p-i .dit,.p-o .dit{left:calc(100% - 90px)}
.p-m .dit,.p-p .dit{right:calc(100% - 90px)}
AV
.p-i .dit,.p-o .dit{left:calc(100% - 58px)}
.p-m .dit,.p-p .dit{right:calc(100% - 58px)}
AP

# ---------------------------------------------------------------- 8
ech("la hauteur joue sur le diametre, plus sur le cadrage", <<'AV', <<'AP');
@media(max-height:900px){
  .poste .visage{aspect-ratio:1/1}
  .poste .visage img{object-position:50% 16%}
}
@media(max-height:760px){
  .poste .visage{aspect-ratio:4/3}
  .poste .nm{font-size:13.5px}
  .scene{gap:10px 16px}
}
AV
/* Un ecran bas ne coupe plus la tete : il reduit le diametre. Le
   visage reste entier, du premier au dernier pixel. */
@media(max-height:900px){ .scene{--rond:262px} }
@media(max-height:800px){ .scene{--rond:232px; gap:9px 10px}
  .poste .nm{font-size:14.5px} }
@media(max-height:720px){ .scene{--rond:204px}
  .poste .et{display:none} }
AP

# ---------------------------------------------------------------- 9
ech("au telephone la pastille reste ronde", <<'AV', <<'AP');
  .poste .visage{width:62px;flex:0 0 62px;aspect-ratio:4/5}
AV
  .poste{width:auto}
  .poste .visage{width:62px;flex:0 0 62px;aspect-ratio:1;border-width:2px}
  .poste .ident{text-align:left;align-items:flex-start}
AP

# --------------------------------------------------------------- 10
ech("js : la parole se voit sur le poste", <<'AV', <<'AP');
/* Poser une étape, c'est écrire d'un coup tout ce qu'elle devait
   écrire — et montrer la bulle, s'il y en a une. */
function poserEtape(etape){
  for(const [el, txt, , b] of etape){
    el.textContent = txt;
    if(b) delete b.dataset.attente;
  }
}
AV
/* QUI PARLE AVANCE. Le poste dont la bulle vient d'etre decouverte
   prend « dit-maintenant » ; celui d'avant le rend mais garde
   « parle », donc sa bulle et sa pleine presence. */
function avance(b){
  if(!b) return;
  const p = b.closest(".poste"); if(!p) return;
  for(const q of app.querySelectorAll(".poste.dit-maintenant"))
    if(q !== p) q.classList.remove("dit-maintenant");
  p.classList.add("parle", "dit-maintenant");
}
/* Plus personne n'a la parole : le regard va aux trois choix. */
function finParole(){
  for(const q of app.querySelectorAll(".poste.dit-maintenant"))
    q.classList.remove("dit-maintenant");
}

/* Poser une étape, c'est écrire d'un coup tout ce qu'elle devait
   écrire — et montrer la bulle, s'il y en a une. */
function poserEtape(etape){
  for(const [el, txt, , b] of etape){
    el.textContent = txt;
    if(b){ delete b.dataset.attente; avance(b) }
  }
}
AP

ech("js : la bulle en cours de frappe met son poste en avant", <<'AV', <<'AP');
    const [el, txt, ms, b] = etape[j];
    if(b) delete b.dataset.attente;
AV
    const [el, txt, ms, b] = etape[j];
    if(b){ delete b.dataset.attente; avance(b) }
AP

ech("js : les choix reprennent le regard", <<'AV', <<'AP');
function revelerChoix(){
  for(const sel of [".scene .question", ".scene .rep", ".scene .apres"]){
AV
function revelerChoix(){
  finParole();
  for(const sel of [".scene .question", ".scene .rep", ".scene .apres"]){
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

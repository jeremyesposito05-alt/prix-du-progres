#!/usr/bin/perl
# LES TROIS CHOIX NE DOIVENT PAS RESSEMBLER A DES BULLES
#
#   perl _outils/choix.pl index.html
#
# LE DEFAUT. Les trois reponses etaient du papier clair, aux coins
# arrondis, posees a la hauteur exacte des deux bulles du bas. Meme
# matiere, meme forme, meme place : l'oeil ne distinguait pas ce qu'on
# lui disait de ce qu'on lui demandait de faire.
#
# TROIS SEPARATIONS, pas une.
#
# 1. LE TEMPS. Les choix forment la derniere etape de la mise en
#    scene : ils n'apparaissent qu'une fois les quatre groupes ayant
#    parle, et ils montent l'un apres l'autre. Quand ils arrivent, les
#    bulles sont lues.
# 2. LA MATIERE. Une bulle est du papier clair ; un choix devient une
#    plaque sombre a filet d'or, texte creme. Rien d'autre dans le jeu
#    n'a cette allure — la confusion devient impossible, meme du coin
#    de l'oeil.
# 3. LA FORME. Les bulles sont arrondies a quinze pixels et portent
#    une queue ; les plaques ont des coins nets et un jeton numerote.
#    Un eleve peut dire « je prends la deux ».
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ---------- 1 · le temps ----------

ech("js : les choix attendent la fin de la mise en scene", <<'AV', <<'AP');
  E.scene = { etapes, i:0 };
AV
  E.scene = { etapes, i:0 };

  /* Les trois choix sont la derniere etape : ils n'apparaissent
     qu'une fois les quatre groupes ayant parle. C'est la premiere des
     trois separations d'avec les bulles — celle du temps. */
  for(const sel of [".scene .question", ".scene .rep"]){
    const el = app.querySelector(sel);
    if(el) el.dataset.attente = "1";
  }
AP

ech("js : on les devoile quand tout est dit", <<'AV', <<'AP');
  if(s.i >= s.etapes.length){ try{ SON.frappe(false) }catch(e){} return; }
AV
  if(s.i >= s.etapes.length){ try{ SON.frappe(false) }catch(e){} revelerChoix(); return; }
AP

ech("js : la fonction qui les devoile", <<'AV', <<'AP');
/* Poser une étape, c'est écrire d'un coup tout ce qu'elle devait
   écrire — et montrer la bulle, s'il y en a une. */
AV
/* Les trois plaques montent l'une après l'autre. « montre » déclenche
   l'animation : la poser en même temps qu'on retire l'attente, sinon
   l'animation se jouerait pendant que le bloc est encore invisible. */
function revelerChoix(){
  for(const sel of [".scene .question", ".scene .rep"]){
    const el = app.querySelector(sel);
    if(!el) continue;
    delete el.dataset.attente;
    el.classList.add("montre");
  }
}

/* Poser une étape, c'est écrire d'un coup tout ce qu'elle devait
   écrire — et montrer la bulle, s'il y en a une. */
AP

ech("js : le chemin instantane les devoile aussi", <<'AV', <<'AP');
    for(const etape of etapes) poserEtape(etape);
    E.scene.i = etapes.length;
    return;
AV
    for(const etape of etapes) poserEtape(etape);
    E.scene.i = etapes.length;
    revelerChoix();
    return;
AP

# ---------- 2 et 3 · la matiere et la forme ----------

ech("css : les choix deviennent des plaques", <<'AV', <<'AP');
/* Les trois reponses, au milieu du plateau, en bulles. Elles etaient
   sous la scene : il fallait quitter des yeux l'affaire pour les lire. */
.centre .question{margin:12px 0 8px;grid-column:auto}
/* Les marges gauche et droite sont posees par « calerBulles » : ce
   sont les deux bulles du bas qui disent de combien il faut se
   serrer. */
.centre .rep{grid-template-columns:minmax(0,1fr);gap:9px;margin:0;
  transition:margin .3s ease}
.centre .choix{
  border-radius:16px !important; padding:12px 17px !important;
  transform:none !important; text-align:left;
  border:1.5px solid rgba(74,56,38,.5) !important;
}
.centre .choix .q{font-size:16px;line-height:1.32}
.centre .choix:hover{transform:translateY(-2px) !important;
  border-color:var(--rge) !important}
AV
/* ---------- les trois choix : des plaques, pas des bulles ----------
   Une bulle est du papier clair, arrondi, avec une queue : c'est ce
   qu'on vous DIT. Un choix est une plaque sombre a filet d'or, aux
   coins nets, avec un jeton numerote : c'est ce que vous FAITES. */
.centre .question{margin:22px 0 10px;grid-column:auto}
/* Les marges gauche et droite sont posees par « calerBulles » : ce
   sont les deux bulles du bas qui disent de combien il faut se
   serrer. */
.centre .rep{grid-template-columns:minmax(0,1fr);gap:10px;margin:0;
  counter-reset:choix; transition:margin .3s ease}

.centre .question[data-attente],.centre .rep[data-attente]{
  opacity:0; pointer-events:none;
}
.centre .question,.centre .rep{transition:opacity .3s ease, margin .3s ease}

.centre .choix{
  display:flex !important; align-items:center; gap:14px; text-align:left;
  counter-increment:choix;
  background:linear-gradient(176deg,#3C2D1F 0%,#241A12 100%) !important;
  color:#F2E6CE !important;
  border:1px solid rgba(214,176,106,.4) !important;
  border-left:3px solid var(--lai) !important;
  border-radius:3px !important;
  padding:13px 18px !important;
  transform:none !important;
  box-shadow:0 7px 18px rgba(0,0,0,.45);
}
/* le jeton : on peut dire « je prends la deux » */
.centre .choix::before{
  content:counter(choix);
  flex:0 0 auto; width:27px; height:27px; border-radius:50%;
  display:flex; align-items:center; justify-content:center;
  font-family:var(--serif); font-size:15.5px; color:#2B2118;
  background:radial-gradient(circle at 34% 30%, #F0D79A, var(--lai) 70%, #9A7430);
  box-shadow:0 2px 5px rgba(0,0,0,.45), inset 0 1px 0 rgba(255,255,255,.35);
}
.centre .choix .q{color:#F6ECD8 !important;font-size:16.5px;line-height:1.3}
.centre .choix:hover{
  transform:translateY(-2px) !important;
  border-color:var(--lai) !important;
  box-shadow:0 11px 26px rgba(0,0,0,.55), 0 0 0 1px rgba(214,176,106,.28);
}

/* elles montent l'une apres l'autre, une fois tout le monde entendu */
@keyframes choix-monte{
  from{opacity:0; transform:translateY(16px)}
  to{opacity:1; transform:none}
}
.centre .rep.montre .choix{animation:choix-monte .42s cubic-bezier(.2,.9,.3,1) backwards}
.centre .rep.montre .choix:nth-child(2){animation-delay:.1s}
.centre .rep.montre .choix:nth-child(3){animation-delay:.2s}
@media(prefers-reduced-motion:reduce){
  .centre .rep.montre .choix{animation:none}
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

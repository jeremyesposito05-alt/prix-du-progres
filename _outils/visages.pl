#!/usr/bin/perl
# LES VISAGES CHANGENT AVEC LE SCORE
#
#   perl _outils/visages.pl index.html
#
# Le poste d'un acteur portait un portrait unique. Il en porte
# desormais deux : content tant que la force tient, fache quand elle
# descend. Le mouvement, le tremblement et la bulle disent deja ce
# qui vient de se passer ; le visage, lui, dit l'etat durable — ce
# qu'un eleve lit d'un coup d'oeil sans compter quoi que ce soit.
#
# LE SEUIL. Les quatre forces partent a 60. En dessous de 45, l'acteur
# est fache : c'est la meme borne que la pastille orange de la jauge,
# donc les deux signaux disent la meme chose au meme moment.
#
# LE REPLI, qui compte autant que le reste. Aucune de ces images
# n'existe encore. Chaque portrait essaie, dans l'ordre : le visage
# expressif en JPEG, le meme en PNG — ChatGPT rend du PNG —, puis le
# portrait neutre d'aujourd'hui. S'il ne trouve rien, il s'efface et
# le pictogramme grave reprend la main. Le jeu ne casse a aucune
# etape, et il s'enrichit a mesure que les fichiers arrivent.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);

my @T;
sub ech { push @T, [ @_ ] }

ech("js : le poste choisit son visage", <<'AV', <<'AP');
  const col  = v>55?"var(--vert)" : v>35?"var(--accent)" : v>20?"#D08A2A" : "var(--rge)";
  return `<div class="poste p-${k} ${dit.sens}${pres} ${etat}">
    <div class="visage">
      <img src="img/acteurs/${N.id}-${k}-portrait.jpg" alt="" loading="lazy"
           onerror="this.remove()">
      <span class="jeton">${icone(k)}</span>
    </div>
AV
  const col  = v>55?"var(--vert)" : v>35?"var(--accent)" : v>20?"#D08A2A" : "var(--rge)";
  /* Le visage dit l'etat durable, pas la derniere decision : celle-la
     est deja dite par le mouvement, le tremblement et la bulle. */
  const vis  = v < 45 ? "fache" : "content";
  const base = `img/acteurs/${N.id}-${k}-`;
  return `<div class="poste p-${k} ${dit.sens}${pres} ${etat}">
    <div class="visage">
      <img src="${base}${vis}.jpg" alt="" loading="lazy"
           data-repli="${base}${vis}.png|${base}portrait.jpg"
           onerror="secours(this)">
      <span class="jeton">${icone(k)}</span>
    </div>
AP

ech("js : le repli en cascade", <<'AV', <<'AP');
function poste(k, c, vus){
AV
/* UNE IMAGE QUI MANQUE NE DOIT RIEN CASSER.
   « data-repli » porte les adresses de rechange, separees par une
   barre. A chaque echec on essaie la suivante ; quand la liste est
   vide, l'image s'efface et ce qui est dessous — le pictogramme grave
   — reprend la main de lui-meme. */
function secours(img){
  const l = (img.dataset.repli || "").split("|").filter(Boolean);
  if(!l.length){ img.remove(); return; }
  img.dataset.repli = l.slice(1).join("|");
  img.src = l[0];
}

function poste(k, c, vus){
AP

ech("js : la vue de fond suit l avancement", <<'AV', <<'AP');
function chercherVue(ecran){
  poserDecor(ecran);
  if(!SC.el) return;
  SC.el.classList.remove("aimg");
  const src="img/vue-"+N.id+".jpg", im=new Image();
  im.onload=()=>{ SC.el.querySelector(".vue").style.backgroundImage=`url("${src}")`;
                  SC.el.classList.add("aimg"); };
  im.src=src;
}
AV
/* Ou en est la partie : le debut, la pleine croissance, ou ce que la
   ville est devenue. Trois tiers, pas davantage — au-dela, le fond
   changerait trop souvent pour qu'on le remarque. */
function phaseVue(){
  if(typeof E === "undefined" || !E || !N.tours) return "debut";
  const p = E.tour / N.tours;
  return p < .34 ? "debut" : p < .67 ? "milieu" : "fin";
}

function chercherVue(ecran){
  poserDecor(ecran);
  if(!SC.el) return;
  const ph = N.id + "/" + phaseVue();
  if(SC.phase === ph) return;                 /* deja en place */
  SC.phase = ph;
  /* On essaie dans l'ordre et on s'arrete au premier qui charge. Le
     « aimg » n'est retire qu'en cas d'echec complet : l'enlever tout
     de suite faisait clignoter le fond a chaque changement de tiers. */
  const liste = [ "img/" + N.id + "-vue-" + phaseVue() + ".jpg",
                  "img/" + N.id + "-vue-" + phaseVue() + ".png",
                  "img/vue-" + N.id + ".jpg" ];
  (function essayer(i){
    if(i >= liste.length){ SC.el.classList.remove("aimg"); SC.phase = null; return; }
    const im = new Image();
    im.onload  = ()=>{ SC.el.querySelector(".vue").style.backgroundImage =
                         `url("${liste[i]}")`;
                       SC.el.classList.add("aimg"); };
    im.onerror = ()=>essayer(i+1);
    im.src = liste[i];
  })(0);
}
AP

ech("js : on reverifie la vue a chaque tour", <<'AV', <<'AP');
function majVue(){
  if(!SC.el||!E) return;
AV
function majVue(){
  if(!SC.el||!E) return;
  /* Le tiers a pu changer depuis la derniere decision. */
  if(SC.phase !== N.id + "/" + phaseVue()) chercherVue();
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

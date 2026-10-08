#!/usr/bin/perl
# L AFFAIRE, PUIS LES QUATRE BULLES, L UNE APRES L AUTRE
#
#   perl _outils/mise-en-scene.pl index.html
#
# CE QU'ON FAIT. L'affaire du jour s'ecrivait deja a la machine. Les
# quatre bulles, elles, etaient posees d'un coup : le joueur avait
# cinq textes sous les yeux avant d'avoir lu le premier. Elles
# s'ecrivent maintenant l'une apres l'autre, dans l'ordre ou l'oeil
# les rencontre — en haut a gauche, en haut a droite, en bas a gauche,
# en bas a droite.
#
# LE CLIC. Il termine l'ETAPE en cours et lance la suivante : le
# premier pose tout l'ordre du jour, le deuxieme la premiere bulle, et
# ainsi de suite. Celui qui lit vite n'attend pas ; celui qui lit
# lentement n'est pas bouscule. Quand il n'y a plus rien a ecrire, le
# clic reprend son role d'avant : il pose les dossiers.
#
# DEUX PIEGES.
#
# 1. L'ORDRE DE LA MESURE. « calerBulles » mesure la place que chaque
#    bulle prend sur l'ordre du jour pour que le texte la contourne.
#    Il tournait APRES « ecrire » — qui vide desormais les bulles. Il
#    aurait mesure du vide, le texte n'aurait rien contourne, et les
#    bulles lui seraient passees dessus en arrivant. La mesure passe
#    donc avant, pendant que les bulles portent encore leur texte.
#
# 2. LES MESURES D'APRES. Deux autres appels suivent — au prochain
#    rendu d'image, puis au chargement complet. Ceux-la tomberaient
#    sur des bulles vides. On leur apprend a ne rien changer quand une
#    bulle n'a pas encore son texte.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("js : on mesure avant d effacer les bulles", <<'AV', <<'AP');
  ecrire(c.t, c.ex, c.d);
  /* Les images des portraits arrivent apres : on cale une fois tout de
     suite pour que le premier mot tombe au bon endroit, une fois la
     mise en page faite, et une fois le chargement termine. */
  calerBulles();
  requestAnimationFrame(calerBulles);
  addEventListener("load", calerBulles, { once:true });
AV
  /* LA MESURE PASSE AVANT L'ECRITURE. « ecrire » vide les bulles pour
     les faire paraitre une a une ; mesure apres lui, « calerBulles »
     mesurerait du vide et le texte de l'ordre du jour ne contournerait
     plus rien. */
  calerBulles();
  requestAnimationFrame(calerBulles);
  addEventListener("load", calerBulles, { once:true });
  ecrire(c.t, c.ex, c.d);
AP

ech("js : une bulle vide ne se mesure pas", <<'AV', <<'AP');
    if(!b){ e.style.width = e.style.height = "0px"; continue; }
AV
    if(!b){ e.style.width = e.style.height = "0px"; continue; }
    /* Pendant la mise en scene, une bulle qui n'a pas encore ete
       ecrite est vide donc minuscule : la mesurer retrecirait
       l'encoche, et la bulle finirait par passer sur le texte. On
       garde celle d'avant. */
    if(!(b.textContent || "").trim()) continue;
AP

ech("js : la mise en scene remplace l ecriture d un bloc", <<'AV', <<'AP');
/* Le titre s'inscrit, puis la réplique. On garde le texte de côté pour
   pouvoir le poser d'un coup si le joueur clique. */
function ecrire(titre, expose, replique){
  stopperMachines();
  E.ecrit = {t:titre, ex:expose||"", d:replique};
  const t=app.querySelector(".situ .t"),
        x=app.querySelector(".situ .ex"),
        r=app.querySelector(".situ .d");
  if(!t||!r) return;
  if(window.SANS_CHRONO || app.classList.contains("presse")){
    t.textContent=titre; if(x) x.textContent=E.ecrit.ex; r.textContent=replique; return;
  }
  t.textContent=""; if(x) x.textContent=""; r.textContent="";
  /* Toute l'affaire s'écrit : le titre, puis l'exposé, puis la réplique.
     L'exposé défile vite — il fait près de quatre cents caractères — et
     un clic n'importe où pose l'ensemble d'un coup. */
  try{ SON.frappe(true) }catch(e){}
  const fini = ()=>{ try{ SON.frappe(false) }catch(e){} };
  E.machines=[ taper(t, titre, 15, ()=>{
    try{ SON.chariot() }catch(e){}          /* le titre est posé */
    if(!x || !E.ecrit.ex){ E.machines.push(taper(r, replique, 7, fini)); return; }
    E.machines.push(taper(x, E.ecrit.ex, 4, ()=>{
      E.machines.push(taper(r, replique, 7, fini));
    }));
  }) ];
}
AV
/* LA MISE EN SCENE.
   Une ETAPE est une liste de textes a écrire l'un après l'autre :
   l'ordre du jour en forme une — titre, exposé, réplique —, puis
   chaque bulle la sienne. Un clic termine l'étape en cours et lance
   la suivante. */
function ecrire(titre, expose, replique){
  stopperMachines();
  E.ecrit = {t:titre, ex:expose||"", d:replique};
  const t=app.querySelector(".situ .t"),
        x=app.querySelector(".situ .ex"),
        r=app.querySelector(".situ .d");
  if(!t||!r) return;

  /* Chaque entrée : [où écrire, quoi, vitesse, la bulle à dévoiler]. */
  const ordre = [[t, titre, 15]];
  if(x && E.ecrit.ex) ordre.push([x, E.ecrit.ex, 4]);
  ordre.push([r, replique, 7]);
  const etapes = [ordre];

  /* L'ordre des bulles est celui du regard, pas celui des données. */
  for(const k of ["i","m","o","p"]){
    const b  = app.querySelector(".p-"+k+" .dit");
    const sp = b && b.querySelector("span");
    const txt = sp ? sp.textContent : "";
    if(!txt) continue;
    sp.textContent = "";
    b.dataset.attente = "1";
    etapes.push([[sp, txt, 9, b]]);
  }
  E.scene = { etapes, i:0 };

  let dro = false;
  try{ dro = matchMedia("(prefers-reduced-motion: reduce)").matches }catch(e){}
  if(window.SANS_CHRONO || app.classList.contains("presse") || dro){
    for(const etape of etapes) poserEtape(etape);
    E.scene.i = etapes.length;
    return;
  }
  t.textContent=""; if(x) x.textContent=""; r.textContent="";
  try{ SON.frappe(true) }catch(e){}
  jouerEtape();
}

/* Poser une étape, c'est écrire d'un coup tout ce qu'elle devait
   écrire — et montrer la bulle, s'il y en a une. */
function poserEtape(etape){
  for(const [el, txt, , b] of etape){
    el.textContent = txt;
    if(b) delete b.dataset.attente;
  }
}

function jouerEtape(){
  const s = E && E.scene;
  if(!s) return;
  if(s.i >= s.etapes.length){ try{ SON.frappe(false) }catch(e){} return; }
  const etape = s.etapes[s.i];
  const lancer = j=>{
    const [el, txt, ms, b] = etape[j];
    if(b) delete b.dataset.attente;
    el.textContent = "";
    E.machines.push(taper(el, txt, ms, ()=>{
      /* le chariot revient quand le titre est posé */
      if(j === 0 && etape.length > 1){ try{ SON.chariot() }catch(e){} }
      if(j + 1 < etape.length){ lancer(j + 1); return; }
      s.i++; jouerEtape();
    }));
  };
  lancer(0);
}
AP

ech("js : le clic termine l etape en cours", <<'AV', <<'AP');
/* Un clic n'importe où pose le texte en entier. */
function finirEcriture(){
  stopperMachines();
  if(!E || !E.ecrit) return;
  const t=app.querySelector(".situ .t"),
        x=app.querySelector(".situ .ex"),
        r=app.querySelector(".situ .d");
  if(t) t.textContent=E.ecrit.t;
  if(x) x.textContent=E.ecrit.ex||"";
  if(r) r.textContent=E.ecrit.d;
}
AV
/* Un clic pose l'étape en cours et lance la suivante. Rend « true »
   tant qu'il restait quelque chose à écrire : au-delà, le clic reprend
   son rôle d'avant et pose les dossiers. */
function finirEcriture(){
  const s = E && E.scene;
  if(!s || s.i >= s.etapes.length) return false;
  stopperMachines();
  poserEtape(s.etapes[s.i]);
  s.i++;
  jouerEtape();
  return true;
}
AP

ech("js : le gestionnaire de clic", <<'AV', <<'AP');
/* Un clic n'importe où sur la table pose le reste des dossiers d'un coup. */
document.addEventListener("click",e=>{
  if(e.target.closest("button, summary, a")) return;
  app.classList.add("presse");
  finirEcriture();
});
AV
/* Un clic termine d'abord l'étape en cours de la mise en scène. Quand
   il n'y a plus rien à écrire, il reprend son rôle d'avant : poser le
   reste des dossiers d'un coup. */
document.addEventListener("click",e=>{
  if(e.target.closest("button, summary, a")) return;
  if(finirEcriture()) return;
  app.classList.add("presse");
});
AP

ech("css : une bulle attend son tour", <<'AV', <<'AP');
.poste .dit{
  position:absolute; top:24%; z-index:6; width:200px;
AV
/* Tant que la mise en scene ne l'a pas atteinte, la bulle est la —
   elle occupe sa place, qui a ete mesuree — mais on ne la voit pas. */
.poste .dit[data-attente]{opacity:0}
.poste .dit{
  transition:opacity .25s ease;
  position:absolute; top:24%; z-index:6; width:200px;
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

#!/usr/bin/perl
# LE RYTHME D UN TOUR
#
#   perl _outils/rythme.pl index.html
#
# TROIS DEFAUTS QUI N EN FONT QU UN : trois choses se jouaient en meme
# temps, donc aucune ne se voyait.
#
# 1. LA LETTRE COUVRAIT LES TREMBLEMENTS. Celui qui vient de perdre
#    recule et tremble — mais la lettre du tour suivant s'ouvrait par
#    dessus au meme instant. Elle attend maintenant que la reaction
#    soit passee.
#
# 2. LES TREMBLEMENTS ETAIENT TROP COURTS. Une demi-seconde, une seule
#    fois. Trois secousses pour celui qui perd, six pour celui qui
#    perd gros — on a le temps de voir qui on a touche.
#
# 3. L AFFAIRE S ECRIVAIT DERRIERE LA LETTRE. La mise en scene
#    demarrait au rendu : le temps qu'on referme la lettre, l'ordre du
#    jour etait deja tape et les bulles dites. Elle attend desormais
#    que la lettre soit refermee — la lecture commence quand le joueur
#    est pret a lire.
#
# L ORDRE D UN TOUR DEVIENT : ce qui vient d'arriver, les portraits qui
# reagissent, la lettre qui arrive, puis l'affaire, les quatre voix et
# les trois plaques.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ---------- 2 · des tremblements qu'on voit ----------

ech("css : celui qui perd tremble trois fois", <<'AV', <<'AP');
.poste.perd .visage{animation:trembler .5s ease-in-out 1}
AV
/* Trois secousses, apres un court temps mort : la premiere partait
   avant que l'oeil ait trouve le portrait. */
.poste.perd .visage{animation:trembler .5s ease-in-out .2s 3}
AP

ech("css : celui qui perd gros tremble six fois", <<'AV', <<'AP');
.poste.perd-fort .visage{animation:trembler .42s ease-in-out 3}
AV
.poste.perd-fort .visage{animation:trembler .44s ease-in-out .2s 6}
AP

ech("css : une secousse un peu plus ample", <<'AV', <<'AP');
@keyframes trembler{
  0%,100%{transform:translateX(0) rotate(0)}
  18%{transform:translateX(-3px) rotate(-.9deg)}
  38%{transform:translateX(3px) rotate(.9deg)}
  58%{transform:translateX(-2px) rotate(-.6deg)}
  78%{transform:translateX(2px) rotate(.4deg)}
}
AV
@keyframes trembler{
  0%,100%{transform:translateX(0) rotate(0)}
  16%{transform:translateX(-4px) rotate(-1.2deg)}
  36%{transform:translateX(4px) rotate(1.2deg)}
  56%{transform:translateX(-3px) rotate(-.8deg)}
  76%{transform:translateX(2px) rotate(.5deg)}
}
AP

# ---------- 1 · la lettre attend ----------

ech("js : la lettre sait combien de temps attendre", <<'AV', <<'AP');
  return `<div class="pli-prof" id="pli-prof">
AV
  /* Le temps de laisser les portraits reagir. Au tout premier tour il
     n'y a rien a regarder : elle vient presque tout de suite. */
  const retard = dernierChoix() ? "2.2s" : ".25s";
  return `<div class="pli-prof" id="pli-prof" style="--retard:${retard}">
AP

ech("css : le voile attend lui aussi", <<'AV', <<'AP');
  background:rgba(14,10,7,.74);
  animation:pli-entre .3s ease-out;
}
AV
  background:rgba(14,10,7,.74);
  animation:pli-entre .3s ease-out var(--retard,0s) both;
  /* tant qu'elle n'est pas la, le voile n'intercepte rien */
  pointer-events:none;
}
.pli-prof .lettre-prof{pointer-events:auto}
AP

ech("css : l enveloppe attend", <<'AV', <<'AP');
  animation:env-monte .95s cubic-bezier(.2,.85,.3,1) forwards;
AV
  animation:env-monte .95s cubic-bezier(.2,.85,.3,1) var(--retard,0s) forwards;
AP

ech("css : le rabat attend", <<'AV', <<'AP');
  animation:env-ouvre .5s ease-in .42s both;
AV
  animation:env-ouvre .5s ease-in calc(var(--retard,0s) + .42s) both;
AP

ech("css : le cachet attend", <<'AV', <<'AP');
  animation:cire-brise .3s ease-in .4s both;
AV
  animation:cire-brise .3s ease-in calc(var(--retard,0s) + .4s) both;
AP

ech("css : la feuille attend", <<'AV', <<'AP');
  animation:pli-deplie .62s cubic-bezier(.22,.9,.26,1) .62s both;
AV
  animation:pli-deplie .62s cubic-bezier(.22,.9,.26,1) calc(var(--retard,0s) + .62s) both;
AP

# ---------- 3 · l'affaire attend la lettre ----------

ech("js : la mise en scene ne demarre pas derriere la lettre", <<'AV', <<'AP');
  t.textContent=""; if(x) x.textContent=""; r.textContent="";
  try{ SON.frappe(true) }catch(e){}
  jouerEtape();
}
AV
  t.textContent=""; if(x) x.textContent=""; r.textContent="";
  /* Si une lettre est encore a lire, on ne tape rien : sinon l'ordre
     du jour serait deja ecrit et les quatre voix dites quand le joueur
     refermerait la lettre. C'est « lettreLue » qui donnera le depart. */
  if(lettreAlire()) return;
  try{ SON.frappe(true) }catch(e){}
  jouerEtape();
}
AP

ech("js : refermer la lettre donne le depart", <<'AV', <<'AP');
  const el = document.getElementById("pli-prof");
  if(el){ el.classList.add("parti"); setTimeout(()=>el.remove(), 260); }
  try{ SON.papier() }catch(e){}
}
AV
  const el = document.getElementById("pli-prof");
  if(el){ el.classList.add("parti"); setTimeout(()=>el.remove(), 260); }
  try{ SON.papier() }catch(e){}
  /* la lecture commence maintenant, pas avant */
  if(E.scene && E.scene.i < E.scene.etapes.length){
    try{ SON.frappe(true) }catch(e){}
    jouerEtape();
  }
}
AP

ech("js : un clic ne saute rien tant que la lettre est la", <<'AV', <<'AP');
document.addEventListener("click",e=>{
  if(e.target.closest("button, summary, a")) return;
  if(finirEcriture()) return;
AV
document.addEventListener("click",e=>{
  if(e.target.closest("button, summary, a")) return;
  /* la lettre est ouverte : rien a sauter derriere elle */
  if(document.getElementById("pli-prof")) return;
  if(finirEcriture()) return;
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

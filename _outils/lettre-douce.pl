#!/usr/bin/perl
# LA LETTRE SE POSE, AU LIEU D ARRIVER EN SPECTACLE
#
#   perl _outils/lettre-douce.pl index.html
#
# DEUX DEFAUTS DISTINCTS, ET DEUX REMEDES DIFFERENTS.
#
# 1. L ATTENTE. Une enveloppe montait du bas (0,95 s), son rabat
#    s ouvrait (0,5 s), le cachet de cire se brisait, et la feuille se
#    depliait seulement ensuite (0,62 s). Pres d une seconde et demie
#    avant de pouvoir lire la premiere ligne — et cela a chaque carte,
#    dix-huit fois par partie. Un effet qu on voit une fois avec
#    plaisir devient une attente a la troisieme.
#    L enveloppe et le cachet sont retires, markup et styles compris.
#    La feuille se pose seule, en un tiers de seconde.
#
# 2. L ECRAN COUPE. Le voile etait sombre (50 %) ET floute. Le flou
#    est ce qui coupe vraiment : il ne masque pas le plateau, il le
#    rend illisible, donc absent. Or ce sont les quatre acteurs qui
#    donnent son sens a la decision. Le voile s eclaircit a 24 % et
#    perd son flou : on lit la lettre, et on voit toujours qui attend
#    autour.
#
# CE QU ON NE TOUCHE PAS. La feuille ne s anime toujours QUE par
# transformation, jamais par opacite — une animation bloquee a
# l opacite zero emporterait le bouton avec elle, et la partie
# s arreterait la. Regle posee apres l incident des plaques de choix,
# elle vaut toujours.
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
ech("le voile s eclaircit et perd son flou", <<'AV', <<'AP');
  /* assez sombre pour qu'on lise, assez clair pour qu'on voie que les
     quatre portraits sont toujours autour */
  background:rgba(14,10,7,.5);
  backdrop-filter:blur(2.5px);
  -webkit-backdrop-filter:blur(2.5px);
  /* « backwards » et non « both » : le voile est transparent AVANT son
     tour, jamais apres. */
  animation:pli-entre .3s ease-out var(--retard,0s) backwards;
AV
  /* Le flou est ce qui coupait vraiment l'ecran : il ne masquait pas
     le plateau, il le rendait illisible, donc absent. Or ce sont les
     quatre acteurs qui donnent son sens a la decision. Un voile clair
     suffit a dire « lisez ceci d'abord ». */
  background:rgba(14,10,7,.24);
  /* « backwards » et non « both » : le voile est transparent AVANT son
     tour, jamais apres. */
  animation:pli-entre .2s ease-out backwards;
AP

# ----------------------------------------------------------------- 2
ech("l enveloppe et le cachet disparaissent des styles", <<'AV', <<'AP');
/* ---------- l'enveloppe arrive, le cachet se brise ----------------
   Elle monte du bas, se pose, et son rabat s'ouvre pendant que la
   feuille se deplie par-dessus. Un peu plus d'une seconde en tout :
   assez pour qu'on voie ce qui se passe, trop court pour attendre. */
.pli-prof .enveloppe{
  position:absolute; width:300px; height:196px; border-radius:3px;
  background:linear-gradient(162deg,#E7D7B4,#CDB68C);
  border:1px solid #A98E5E;
  box-shadow:0 18px 40px rgba(0,0,0,.55);
  animation:env-monte .95s cubic-bezier(.2,.85,.3,1) var(--retard,0s) forwards;
}
@keyframes env-monte{
  0%{opacity:0; transform:translateY(90px) rotate(-5deg) scale(.86)}
  55%{opacity:1; transform:translateY(0) rotate(0) scale(1)}
  100%{opacity:0; transform:translateY(-10px) scale(1.04)}
}
.pli-prof .env-rabat{
  position:absolute; inset:0 0 auto 0; height:58%;
  background:linear-gradient(170deg,#DCC79F,#C4AC80);
  clip-path:polygon(0 0,100% 0,50% 100%);
  transform-origin:top center;
  animation:env-ouvre .5s ease-in calc(var(--retard,0s) + .42s) both;
}
@keyframes env-ouvre{ to{ transform:rotateX(-168deg) } }
.pli-prof .env-cire{
  position:absolute; left:50%; top:48%; width:38px; height:38px;
  margin:-19px 0 0 -19px; border-radius:50%;
  background:radial-gradient(circle at 36% 32%,#C4503A,#7E2413 70%,#5A190C);
  box-shadow:0 2px 6px rgba(0,0,0,.5);
  animation:cire-brise .3s ease-in calc(var(--retard,0s) + .4s) both;
}
@keyframes cire-brise{
  0%{opacity:1; transform:scale(1)}
  60%{opacity:1; transform:scale(1.18) rotate(7deg)}
  100%{opacity:0; transform:scale(.6) rotate(-14deg)}
}
@media(prefers-reduced-motion:reduce){
  .pli-prof .enveloppe{display:none}
}
AV
/* L'ENVELOPPE A ETE RETIREE le 13 octobre 2026. Elle montait du bas,
   son rabat s'ouvrait, le cachet de cire se brisait, et la feuille se
   depliait seulement ensuite : pres d'une seconde et demie avant la
   premiere ligne, dix-huit fois par partie. Un effet qu'on voit une
   fois avec plaisir devient une attente a la troisieme. */
AP

# ----------------------------------------------------------------- 3
ech("la feuille se pose au lieu de se deplier", <<'AV', <<'AP');
  animation:pli-deplie .62s cubic-bezier(.22,.9,.26,1) calc(var(--retard,0s) + .62s) both;
  transform-origin:top center;
}
/* La feuille sort de l'enveloppe et se deplie — sans toucher a son
   opacite : une lettre bloquee invisible emporterait son bouton avec
   elle, et la partie s'arreterait la. */
@keyframes pli-deplie{
  0%{transform:rotate(-.35deg) translateY(34px) scaleY(.46)}
  100%{transform:rotate(-.35deg) translateY(0) scaleY(1)}
}
AV
  animation:pli-pose .3s cubic-bezier(.22,.9,.26,1) both;
  transform-origin:top center;
}
/* Elle se pose, simplement — et toujours SANS toucher a son opacite :
   une lettre bloquee invisible emporterait son bouton avec elle, et
   la partie s'arreterait la. Le « scaleY » de l'ancienne version
   ecrasait le texte pendant qu'il arrivait, ce qui etait desagreable
   a lire autant qu'a regarder. */
@keyframes pli-pose{
  0%{transform:rotate(-.35deg) translateY(-20px)}
  100%{transform:rotate(-.35deg) translateY(0)}
}
AP

# ----------------------------------------------------------------- 4
ech("js : plus d enveloppe a poser, plus de retard a attendre", <<'AV', <<'AP');
  /* Plus de delai : la lettre n'est posee qu'au moment ou la retombee
     a fini de s'ecrire. Il reste un souffle pour que l'enveloppe ne
     saute pas a la figure. */
  const retard = ".2s";
  const d = decoupeLettre(E.carte.l);
AV
  const d = decoupeLettre(E.carte.l);
AP

ech("js : le pli n a plus d enveloppe", <<'AV', <<'AP');
  return `<div class="pli-prof" id="pli-prof" style="--retard:${retard}">
    <div class="enveloppe" aria-hidden="true">
      <span class="env-rabat"></span><span class="env-cire"></span>
    </div>
    <article class="lettre-prof courrier-prof">
AV
  return `<div class="pli-prof" id="pli-prof">
    <article class="lettre-prof courrier-prof">
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

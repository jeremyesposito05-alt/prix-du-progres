#!/usr/bin/perl
# LE TREMBLEMENT SE VOIT, ET IL ARRIVE AU BON MOMENT
#
# Mesure : l animation se declenche bien — « trembler, 0,44 s, six
# fois » sur le perdant. Elle n etait donc pas cassee, elle etait
# devenue invisible : plus ou moins quatre pixels sur un medaillon de
# 150 px dans une carte sombre, pendant que l oeil est sur le texte en
# train de s ecrire au centre.
#
# DEUX CORRECTIONS.
#   L amplitude passe de 4 a 8 pixels et la rotation de 1,2 a 2,2
#   degres, et le medaillon lance en meme temps un halo rouge qui se
#   dissipe : on le voit du coin de l oeil, sans avoir a regarder.
#
#   Surtout, le tremblement ne part plus au rendu de l ecran mais
#   quand l acteur PREND LA PAROLE. La mise en scene decouvre les
#   bulles une a une ; celle du perdant arrive avec sa secousse. On
#   regarde exactement la ou il se passe quelque chose.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";

my @T; sub ech { push @T, [ @_ ] }

ech("le tremblement attend que l acteur parle", <<'AV', <<'AP');
.poste.perd .visage{animation:trembler .5s ease-in-out .2s 3}
AV
/* « .secoue » est pose par « avance() » au moment ou la bulle de cet
   acteur commence a s'ecrire : la secousse arrive quand on le
   regarde, et non au rendu de l'ecran, ou l'oeil est encore au
   centre. */
.poste.perd.secoue .visage{animation:trembler .46s ease-in-out 3,
  halo-perd 1.5s ease-out both}
AP

ech("et le perdant lourd tremble plus longtemps", <<'AV', <<'AP');
.poste.perd-fort .visage{animation:trembler .44s ease-in-out .2s 6}
AV
.poste.perd-fort.secoue .visage{animation:trembler .44s ease-in-out 6,
  halo-fort 2s ease-out both}
AP

ech("l amplitude devient visible, et le halo l accompagne", <<'AV', <<'AP');
@keyframes trembler{
  0%,100%{transform:translateX(0) rotate(0)}
  16%{transform:translateX(-4px) rotate(-1.2deg)}
  36%{transform:translateX(4px) rotate(1.2deg)}
  56%{transform:translateX(-3px) rotate(-.8deg)}
  76%{transform:translateX(2px) rotate(.5deg)}
}
AV
/* Huit pixels et 2,2 degres : sur un medaillon rond pose dans une
   carte sombre, quatre pixels ne se voyaient plus. */
@keyframes trembler{
  0%,100%{transform:translateX(0) rotate(0)}
  16%{transform:translateX(-8px) rotate(-2.2deg)}
  36%{transform:translateX(8px) rotate(2.2deg)}
  56%{transform:translateX(-5px) rotate(-1.4deg)}
  76%{transform:translateX(3px) rotate(.8deg)}
}
/* Le halo se voit du coin de l'oeil : on n'a pas besoin de regarder
   l'acteur pour savoir qu'il vient d'encaisser. */
@keyframes halo-perd{
  0%  {box-shadow:0 5px 14px rgba(0,0,0,.45), 0 0 0 0 rgba(166,48,36,.55)}
  35% {box-shadow:0 5px 14px rgba(0,0,0,.45), 0 0 0 10px rgba(166,48,36,.32)}
  100%{box-shadow:0 5px 14px rgba(0,0,0,.45), 0 0 0 16px rgba(166,48,36,0)}
}
@keyframes halo-fort{
  0%  {box-shadow:0 5px 14px rgba(0,0,0,.45), 0 0 0 0 rgba(166,48,36,.8)}
  25% {box-shadow:0 5px 14px rgba(0,0,0,.45), 0 0 0 14px rgba(166,48,36,.45)}
  100%{box-shadow:0 5px 14px rgba(0,0,0,.45), 0 0 0 22px rgba(166,48,36,0)}
}
AP

ech("js : la prise de parole declenche la secousse", <<'AV', <<'AP');
  p.classList.add("parle", "dit-maintenant");
AV
  p.classList.add("parle", "dit-maintenant");
  /* S'il vient de perdre, c'est maintenant qu'il encaisse — pas au
     rendu de l'ecran, quand l'oeil est encore au centre. */
  if(p.classList.contains("perd") || p.classList.contains("perd-fort"))
    p.classList.add("secoue");
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-44s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

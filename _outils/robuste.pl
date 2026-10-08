#!/usr/bin/perl
# RIEN D ESSENTIEL NE DOIT DEPENDRE D UNE ANIMATION QUI SE TERMINE
#
#   perl _outils/robuste.pl index.html
#
# CE QUI A ETE CONSTATE. Dans le rendu de controle, les trois plaques
# de choix restaient a opacite zero : leur animation d'apparition etait
# encore « running » neuf secondes apres son depart. Que la cause soit
# le mode sans interface ou autre chose, la lecon est la meme et elle
# ne se discute pas : si l'animation ne se termine pas, le joueur n'a
# plus de boutons et la partie est finie.
#
# CE QU'ON CHANGE. Une animation ne decide plus de ce qu'on voit, elle
# ne decide plus que de la maniere dont ca arrive.
#   — « choix-monte » ne touche plus a l'opacite, seulement a la
#     position : bloquee a son premier etat, une plaque est visible,
#     simplement decalee de seize pixels.
#   — Les deux blocs du choix n'ont plus de transition d'opacite :
#     l'attribut tombe, ils sont la. Au pire c'est sec, jamais absent.
#   — La lettre se depliait avec « both » : bloquee, elle restait
#     invisible, et avec elle son bouton. Son animation ne touche plus
#     a l'opacite non plus.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("css : les plaques montent sans disparaitre", <<'AV', <<'AP');
@keyframes choix-monte{
  from{opacity:0; transform:translateY(16px)}
  to{opacity:1; transform:none}
}
AV
/* Pas d'opacite ici : si l'animation ne se jouait pas, la plaque
   resterait invisible et le joueur n'aurait plus de quoi decider. */
@keyframes choix-monte{
  from{transform:translateY(16px)}
  to{transform:none}
}
AP

ech("css : le choix parait d un coup, sans transition", <<'AV', <<'AP');
.centre .question,.centre .rep{transition:opacity .3s ease, margin .3s ease}
AV
.centre .question,.centre .rep{transition:margin .3s ease}
AP

ech("css : la feuille se deplie sans jouer sur l opacite", <<'AV', <<'AP');
/* la feuille sort de l'enveloppe et se deplie */
@keyframes pli-deplie{
  0%{opacity:0; transform:rotate(-.35deg) translateY(34px) scaleY(.46)}
  60%{opacity:1}
  100%{opacity:1; transform:rotate(-.35deg) translateY(0) scaleY(1)}
}
AV
/* La feuille sort de l'enveloppe et se deplie — sans toucher a son
   opacite : une lettre bloquee invisible emporterait son bouton avec
   elle, et la partie s'arreterait la. */
@keyframes pli-deplie{
  0%{transform:rotate(-.35deg) translateY(34px) scaleY(.46)}
  100%{transform:rotate(-.35deg) translateY(0) scaleY(1)}
}
AP

ech("css : le voile parait sans fondu bloquant", <<'AV', <<'AP');
  animation:pli-entre .3s ease-out var(--retard,0s) both;
AV
  /* « backwards » et non « both » : le voile est transparent AVANT son
     tour, jamais apres. */
  animation:pli-entre .3s ease-out var(--retard,0s) backwards;
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

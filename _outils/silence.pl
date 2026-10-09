#!/usr/bin/perl
# QUI N A RIEN A DIRE SUR CETTE AFFAIRE SE TAIT
#
#   perl _outils/silence.pl index.html
#
# CE QU ON VOYAIT. Les deux acteurs que la carte concerne disent leur
# avis sur CETTE affaire. Les deux autres affichaient leur phrase
# generale — « des canaux, des rails, des debouches », « l'ordre
# public et la salubrite » — la meme a chaque tour, dix-huit fois,
# sans rapport avec ce qui est sur le bureau. C'est du remplissage,
# et c'est exactement ce que la classe reprochait au jeu : trop
# d'elements a lire pour rien.
#
# CE QU ON FAIT. Pas de bulle du tout. Le portrait reste, la jauge
# reste, le mot d'alerte reste — ce qui manque, c'est une phrase qui
# ne disait rien. Et le silence devient un signal : les deux qui
# parlent sont ceux dont le sort depend de ce choix.
#
# Ce que cela entraine, et qui marche deja : la mise en scene saute
# les bulles vides, les encoches qui reservent la place du texte
# retombent a zero, et les marges des trois plaques aussi.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("js : plus de phrase generale pour boucher un trou", <<'AV', <<'AP');
     Pour Detroit, qui n'a pas encore ses dialogues, « veut » sert de
     filet : le groupe rappelle ce qu'il attend. */
  const avis = (E.carte && E.carte.av || {})[k];
  return { txt: avis || N.forces[k].veut,
           sens: (d && v) ? (v>0 ? "gagne" : (v<=-8 ? "perd-fort" : "perd")) : "attend" };
}
AV
     QUI N'A RIEN A DIRE SE TAIT. Les deux acteurs que la carte
     concerne ont un avis ecrit pour elle ; les deux autres n'en ont
     pas, et affichaient alors leur phrase generale — la meme a chaque
     tour, sans rapport avec l'affaire. On rend une chaine vide : le
     poste ne dessine aucune bulle. Le silence dit qui est concerne. */
  const avis = (E.carte && E.carte.av || {})[k];
  return { txt: avis || "",
           sens: (d && v) ? (v>0 ? "gagne" : (v<=-8 ? "perd-fort" : "perd")) : "attend" };
}
AP

ech("js : le poste ne dessine la bulle que s il y a quelque chose", <<'AV', <<'AP');
    <div class="dit"><span>${esc(dit.txt)}</span></div>
AV
    ${dit.txt ? `<div class="dit"><span>${esc(dit.txt)}</span></div>` : ""}
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

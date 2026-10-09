#!/usr/bin/perl
# LE BUREAU CHANGE AVEC LA VILLE
#
#   perl _outils/decor-phases.pl index.html
#
# CE QUE J AI TROUVE EN CHERCHANT OU BRANCHER LES SIX VUES D AMBIANCE.
# Elles n avaient aucun endroit ou s afficher. « chercherVue » les
# posait dans le « .vue » de la fenetre DESSINEE, qui est masquee des
# que le decor photographique existe — et il existe. Six images
# generees pour rien.
#
# OU ELLES VONT VRAIMENT. Le decor est une photographie de bureau dont
# la baie vitree donne sur la ville : la vue est DANS l image. Les
# trois etats d une ville se jouent donc la, en trois photographies de
# la meme piece, et le jeu en change au premier et au deuxieme tiers
# de la partie.
#
# Cela regle du meme coup « bureau-II.jpg », absent depuis le debut :
# Detroit n avait pas de decor et retombait sur celui de Manchester.
#
# Le repli reste en cascade — phase, puis decor unique du niveau, puis
# celui de Manchester : tant qu une image manque, rien ne casse.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("js : le decor suit l avancement de la partie", <<'AV', <<'AP');
  /* L'écran de choix et le tutoriel se passent aujourd'hui, à Beau
     Soleil : on n'entre dans le siècle qu'en ouvrant une époque. */
  const voulu = (ecran === "menu")
    ? ["img/decor/menu.jpg", "img/decor/bureau-I.jpg"]
    : ["img/decor/bureau-" + ((typeof N!=="undefined" && N) ? N.id : "I") + ".jpg"];
AV
  /* L'écran de choix et le tutoriel se passent aujourd'hui, à Beau
     Soleil : on n'entre dans le siècle qu'en ouvrant une époque. */
  const id = (typeof N!=="undefined" && N) ? N.id : "I";
  /* La pièce est la même, la ville qu'on voit par la baie ne l'est
     pas : trois états, au premier et au deuxième tiers de la partie.
     Repli en cascade — la phase, puis le décor unique du niveau, puis
     celui de Manchester : tant qu'une image manque, rien ne casse. */
  const voulu = (ecran === "menu")
    ? ["img/decor/menu.jpg", "img/decor/bureau-I.jpg"]
    : ["img/decor/bureau-" + id + "-" + phaseVue() + ".jpg",
       "img/decor/bureau-" + id + "-" + phaseVue() + ".png",
       "img/decor/bureau-" + id + ".jpg",
       "img/decor/bureau-I.jpg"];
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

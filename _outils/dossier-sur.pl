#!/usr/bin/perl
# UN DOSSIER QUI N ATTEND PAS SON ANIMATION POUR EXISTER
#
# « .dossier{opacity:0; animation:poser … forwards} » : si l animation
# ne part pas, la carte reste invisible — avec sa taille, son texte et
# sa place, mais invisible. C est exactement le defaut qui avait
# emporte les plaques de choix en octobre, et pour lequel j ai pose la
# regle : une animation change COMMENT une chose arrive, jamais SI
# elle est visible.
#
# Le mouvement reduit etait deja couvert par une regle dediee ; le
# reste ne l etait pas. « both » applique l etat de depart pendant le
# delai — on garde donc l arrivee en fondu — et l opacite de base
# passe a 1 : si l animation ne se joue pas du tout, la carte est la.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my @T; sub ech { push @T, [ @_ ] }

ech("le dossier existe meme sans son animation",
  q~  opacity:0;animation:poser .42s cubic-bezier(.2,.8,.3,1) forwards;animation-delay:var(--d,0s)}~,
  q~  /* opacite 1 et « both » : l'etat de depart s'applique pendant le
     delai, donc l'arrivee reste en fondu — mais si l'animation ne se
     joue pas du tout, la carte est visible. Une animation change
     COMMENT une chose arrive, jamais SI elle est visible. */
  opacity:1;animation:poser .42s cubic-bezier(.2,.8,.3,1) both;animation-delay:var(--d,0s)}~);

ech("le tableau des forces aussi",
  q~.forces{opacity:0;animation:poser .4s ease-out forwards}~,
  q~.forces{opacity:1;animation:poser .4s ease-out both}~);

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-40s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

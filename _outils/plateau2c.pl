#!/usr/bin/perl
# DEUX COLLISIONS
#
#   perl _outils/plateau2c.pl index.html
#
# 1. « .centre » existait deja dans le jeu comme « centrer le texte » :
#    la scene lui a mis un « display:flex », et les trois boutons de
#    l'ecran de niveau se sont empiles sur toute la largeur. On accroche
#    les regles de la scene a « .scene ».
# 2. « .but-jeu » avait deja sa regle, ecrite avec le tutoriel : un fond
#    dore a 13 %, pose sur la photographie, texte encre sur or. C'est
#    l'illisibilite signalee. On la remplace, et on lui donne sa forme
#    Beau Soleil sur l'ecran de choix — la charte s'applique la.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);

my @T;
sub ech { push @T, [ @_ ] }

ech("css : le centre de la scene ne vaut que dans la scene", <<'AV', <<'AP');
/* Les bulles debordent des postes sur l'ordre du jour : elles ne
   peuvent le faire que si les postes passent DEVANT le centre. */
.centre{grid-area:1/2/3/3; display:flex; flex-direction:column; gap:10px;
  position:relative; z-index:1}
AV
/* « .centre » sert ailleurs dans le jeu a centrer un texte : sans le
   prefixe, ce « display:flex » empilait les boutons de l'ecran de
   niveau sur toute la largeur.
   Les bulles debordent des postes sur l'ordre du jour : elles ne
   peuvent le faire que si les postes passent DEVANT le centre. */
.scene > .centre{grid-area:1/2/3/3; display:flex; flex-direction:column;
  gap:10px; position:relative; z-index:1}
AP

ech("css : idem au telephone", <<'AV', <<'AP');
  .centre{display:contents}
AV
  .scene > .centre{display:contents}
AP

ech("css : l ancienne regle du but s en va", <<'AV', <<'AP');
/* Le but du jeu, dit avant tout le reste : les eleves lisaient cinq
   points sans trouver l'objectif, parce qu'il n'etait ecrit nulle part. */
.but-jeu{
  margin:0 0 20px; padding:12px 16px; text-align:center;
  font-family:var(--serif); font-size:16.5px; line-height:1.45;
  color:var(--enc); background:rgba(243,190,49,.13);
  border-top:1px solid rgba(243,190,49,.5);
  border-bottom:1px solid rgba(243,190,49,.5);
}
.but-jeu strong{color:var(--enc)}
@media(max-width:600px){ .but-jeu{font-size:15px;padding:10px 12px} }
AV
/* Le but du jeu a sa feuille, plus haut dans la page : un fond dore a
   13 % pose sur une photographie d'usine ne se lisait pas. */
@media(max-width:600px){ .but-jeu{font-size:15px;padding:12px 14px} }
AP

ech("css : le but, en version Beau Soleil sur l ecran de choix", <<'AV', <<'AP');
body.surmenu[data-decor-ecran="menu"] .etape:hover{
  box-shadow:0 10px 26px rgba(26,32,71,.14);
}
AV
body.surmenu[data-decor-ecran="menu"] .etape:hover{
  box-shadow:0 10px 26px rgba(26,32,71,.14);
}
/* Le but suit les fiches : meme papier, meme ombre, l'accent en or. */
body.surmenu[data-decor-ecran="menu"] .but-jeu{
  background:rgba(255,255,255,.94);
  border:1px solid var(--bs-filet); border-left:4px solid var(--bs-gold);
  border-radius:6px; color:var(--bs-gris);
  box-shadow:0 6px 18px rgba(26,32,71,.1), 0 1px 3px rgba(26,32,71,.08);
}
body.surmenu[data-decor-ecran="menu"] .but-jeu strong{color:var(--bs-navy)}
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-52s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

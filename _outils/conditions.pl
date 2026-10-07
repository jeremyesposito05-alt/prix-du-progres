#!/usr/bin/perl
# SEPARER LA CLE DE SON LIBELLE
#
#   perl _outils/conditions.pl index.html     fr
#   perl _outils/conditions.pl index-en.html  en
#
# LE PROBLEME. Les sept conditions — « Ressources », « Capitaux »… —
# servent a la fois d'etiquette affichee et de cle interne : vingt-neuf
# cartes les accordent par « g: », sept les exigent par « req: », et la
# comparaison se fait sur le mot exact. Traduire le mot casse le jeu ;
# ne pas le traduire laisse sept mots francais dans la version anglaise,
# a l'ecran de fin et dans le document rendu.
#
# LE CHOIX. On ne touche pas aux cles. On ajoute une table de libelles,
# et les cinq endroits qui AFFICHENT une condition passent par elle. La
# version francaise recoit une table vide : le libelle retombe sur la
# cle, et rien ne change pour elle — c'est ce qui rend l'operation sure.
#
# Les cinq endroits, trouves un par un :
#   — la liste des conditions a l'ecran de fin ;
#   — la phrase « Il vous manquait : … » ;
#   — la liste du carnet de bord ;
#   — la trace copiee en texte ;
#   — le document Word.
# Les autres emplois de CONDITIONS ne font que compter, et comptent
# aussi bien des cles que des libelles.
use strict; use warnings; use utf8;

my $f = shift or die "usage: conditions.pl <jeu.html> <fr|en>\n";
my $langue = shift // "";
$langue =~ /^(?:fr|en)$/ or die "usage: conditions.pl <jeu.html> <fr|en>\n";

open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
local $/; my $s = <$h>; close $h;
$s =~ s/\x0D\x0A/\n/g;

# Les caracteres non ASCII, nommes. Une chaine entre guillemets simples
# n'interprete pas « \x{2019} », et une chaine entre guillemets doubles
# interpreterait les « ${...} » du code cherche : on concatene.
my $AP = "\x{2019}";   # l apostrophe courbe
my $OE = "\x{0153}";   # le e dans l o
my $EA = "\x{00E9}";   # e accent aigu
my $TD = "\x{2014}";   # le tiret cadratin

my @done;
sub swap {
  my ($nom, $av, $ap) = @_;
  $av =~ s/\n\z//; $ap =~ s/\n\z//;   # jamais chomp : $/ vaut undef ici
  my $n = ($s =~ s/\Q$av\E/$ap/g);
  $n == 1 or die "ARRET - $nom : $n fois au lieu de 1\n";
  push @done, $nom;
}

# ---- la table des libelles -------------------------------------------
my $table = $langue eq "en" ? <<'EN' : <<'FR';

/* Le libelle affiche d'une condition. La cle, elle, ne change jamais :
   les cartes l'accordent et l'exigent par le mot exact. */
const COND_NOM = {
  "Ressources"         : "Resources",
  "Savoirs techniques" : "Technical knowledge",
  "Capitaux"           : "Capital",
  "Main-d’œuvre" : "Workforce",
  "Marchés"       : "Markets",
  "Transports"         : "Transport",
  "Organisation"       : "Organisation of work",
};
const condNom = k => COND_NOM[k] || k;
const condListe = a => a.map(condNom).join(", ");
EN

/* Le libelle affiche d'une condition. En francais il est identique a la
   cle : la table reste vide, et condNom retombe sur la cle. C'est la
   version anglaise qui la remplit. */
const COND_NOM = {};
const condNom = k => COND_NOM[k] || k;
const condListe = a => a.map(condNom).join(", ");
FR

my $DECL = 'const CONDITIONS = ["Ressources","Savoirs techniques","Capitaux","Main-d'
  . $AP . $OE . 'uvre","March' . $EA . 's","Transports","Organisation"];';

swap("la table des libelles", $DECL, $DECL . $table);

# ---- les cinq endroits qui affichent --------------------------------
swap("la liste de l ecran de fin",
  '`<span class="${E.acquis.includes(x)?"ok":""}">${x}</span>`',
  '`<span class="${E.acquis.includes(x)?"ok":""}">${condNom(x)}</span>`');

swap("la phrase « Il vous manquait »",
  '${manque.join(", ").toLowerCase()}',
  '${condListe(manque).toLowerCase()}');

swap("la liste du carnet de bord",
  '`<li class="${E.acquis.includes(x)?"ok":""}">${x}</li>`',
  '`<li class="${E.acquis.includes(x)?"ok":""}">${condNom(x)}</li>`');

swap("la trace copiee en texte",
  '+(E.acquis.length?"  ("+E.acquis.join(", ")+")":""));',
  '+(E.acquis.length?"  ("+condListe(E.acquis)+")":""));');

swap("le document Word",
  'E.acquis.length?" ' . $TD . ' "+e(E.acquis.join(", ")):""',
  'E.acquis.length?" ' . $TD . ' "+e(condListe(E.acquis)):""');

open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";
print $o $s; close $o;
binmode(STDOUT, ":encoding(UTF-8)");
print "  $_\n" for @done;
printf "  %s : %d octets\n", $f, -s $f;

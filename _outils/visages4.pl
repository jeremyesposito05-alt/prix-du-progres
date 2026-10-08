#!/usr/bin/perl
# QUATRE VISAGES, CALES SUR CE QUE LE JEU DIT DEJA EN TOUTES LETTRES
#
#   perl _outils/visages4.pl index.html
#
# Le poste n'avait que deux visages, content et fache, a la bascule 45.
# Il en a quatre, et leurs bornes sont celles que le jeu emploie deja
# pour choisir le mot sous le nom de l'acteur :
#
#     > 55   content    la jauge est verte
#   35..55   neutre     aucun mot — c'est le portrait d'aujourd'hui
#   20..35   fache      « fragile »
#     <= 20  au-bord    « ne tiendra pas longtemps »
#
# Le visage et le mot disent alors la meme chose au meme instant. Un
# portrait dont la borne ne tombe nulle part ajoute un signal de plus a
# lire, au lieu d'en remplacer un.
#
# POURQUOI PAS SIX. Mesure sur trente parties, 2096 relevés : avec six
# etats a bandes egales, « en colere » occupe 3 % du temps d'ecran et
# « desespere » 1 %. C'est seize images pour deux etats qu'un eleve
# verra deux fois par partie, et qui, a 62 px sur un telephone, ne se
# distinguent que par un sourcil. Et « parti » ne peut pas exister : la
# partie s'arrete a l'instant ou une force touche zero — ce visage-la
# n'aurait aucune image a l'ecran. Sa place est l'ecran de fin.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my $av = <<'AV';
  /* Le visage dit l'etat durable, pas la derniere decision : celle-la
     est deja dite par le mouvement, le tremblement et la bulle. */
  const vis  = v < 45 ? "fache" : "content";
  const base = `img/acteurs/${N.id}-${k}-`;
AV
my $ap = <<'AP';
  /* Le visage dit l'etat durable, pas la derniere decision : celle-la
     est deja dite par le mouvement, le tremblement et la bulle. Les
     quatre bornes sont celles du mot affiche sous le nom : le visage
     et le mot changent ensemble. « neutre » est le portrait d'origine,
     qui existe deja — il n'y a donc que trois images a faire. */
  const vis  = v>55 ? "content" : v>35 ? "portrait" : v>20 ? "fache" : "au-bord";
  const base = `img/acteurs/${N.id}-${k}-`;
AP

my $n = () = ($s =~ /\Q$av\E/g);
$n == 1 or die "ARRET : $n occurrence(s), 1 attendue. Rien n'a ete ecrit.\n";
$s =~ s/\Q$av\E/$ap/;

# Le repli : l'etat voulu en JPEG, le meme en PNG, puis le portrait
# neutre. Quand « vis » vaut deja « portrait », la cascade se replie
# sur lui-meme sans dommage — l'image aura charge du premier coup.
print "  ok  quatre visages, bornes 55 / 35 / 20\n";

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;

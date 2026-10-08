#!/usr/bin/perl
# OU DEPOSER LES IMAGES, ET DANS QUEL ORDRE LES FAIRE
#
#   perl _outils/prompts-mode-emploi.pl _a-installer/images/PROMPTS-ILLUSTRATIONS.md
#
# Deux manques du document, verifies contre le code :
#
# 1. LE DOSSIER. Les visages vont dans « img/acteurs/ », les vues dans
#    « img/ » — pas au meme endroit. Le document disait de tout deposer
#    dans « _a-installer/images/ » en attendant que je les range, ce qui
#    ajoutait un aller-retour inutile : depose au bon endroit, une
#    image s'allume toute seule au prochain rechargement.
#
# 2. L'ORDRE. Le document numerote A1, A2, D1 : trois prompts du MEME
#    personnage, separes par vingt pages. Or un generateur d'images ne
#    garde un visage d'une image a l'autre que dans une meme
#    conversation. Les faire dans cet ordre-la, c'est obtenir trois
#    personnes differentes pour un seul acteur.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "_a-installer/images/PROMPTS-ILLUSTRATIONS.md";
open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;

my $bloc = <<'FIN';
## Comment s'y prendre — lisez ceci d'abord

### Un acteur à la fois, dans une seule conversation

Le document numérote `A1`, `A2`, `D1` — mais ce sont **les trois états du même
personnage**, et ils sont séparés de vingt pages. Un générateur d'images ne garde un
visage d'une image à l'autre que **dans une même conversation**. Faites-les donc par
paquets de trois, à la suite :

| Le personnage | Ses trois prompts | Ses trois fichiers |
|---|---|---|
| Manchester · l'industriel | A1 · A2 · D1 | `I-i-content` · `I-i-fache` · `I-i-au-bord` |
| Manchester · l'ouvrière | A3 · A4 · D2 | `I-o-content` · `I-o-fache` · `I-o-au-bord` |
| Manchester · le négociant | A5 · A6 · D3 | `I-m-content` · `I-m-fache` · `I-m-au-bord` |
| Manchester · le Parlement | A7 · A8 · D4 | `I-p-content` · `I-p-fache` · `I-p-au-bord` |
| Detroit · l'actionnaire | B1 · B2 · D5 | `II-i-content` · `II-i-fache` · `II-i-au-bord` |
| Detroit · l'ouvrier | B3 · B4 · D6 | `II-o-content` · `II-o-fache` · `II-o-au-bord` |
| Detroit · le client | B5 · B6 · D7 | `II-m-content` · `II-m-fache` · `II-m-au-bord` |
| Detroit · l'opinion | B7 · B8 · D8 | `II-p-content` · `II-p-fache` · `II-p-au-bord` |

Les six vues d'ambiance (section C) n'ont pas ce problème : chacune est indépendante.

### Où déposer les fichiers

Deux dossiers, et ils ne sont pas les mêmes :

| Ce que c'est | Où ça va | Exemple |
|---|---|---|
| Les 24 visages | `img\acteurs\` | `img\acteurs\I-i-au-bord.png` |
| Les 6 vues | `img\` | `img\I-vue-fin.png` |

**Déposez-les directement là.** Le jeu essaie chaque image, et se replie sur le portrait
neutre tant qu'elle n'existe pas : vous pouvez les générer dans n'importe quel ordre, et
chacune s'allume au rechargement suivant. Rien à attendre, rien à me demander.

Le `.png` convient — le jeu cherche le `.jpg` puis le `.png`. Si vous pouvez exporter en
JPEG autour de 560 px de large pour les visages et 1400 px pour les vues, la page se
chargera plus vite sur les téléphones de la classe, mais ce n'est pas bloquant.

### Ce à quoi vous reconnaîtrez que ça marche

Lancez une partie : au départ les quatre forces sont à 60, donc vous devez voir les
visages **contents**. Faites deux ou trois décisions qui fâchent le même groupe, et son
portrait doit changer sous vos yeux, en même temps que le mot sous son nom.

---

FIN

my $ancre = "## Avant de commencer : deux choses qui comptent plus que les prompts";
my $n = () = ($s =~ /\Q$ancre\E/g);
$n == 1 or die "ARRET : ancre trouvee $n fois. Rien n'a ete ecrit.\n";
$s =~ s/\Q$ancre\E/$bloc . $ancre/e;

# Le paragraphe final disait de tout deposer au meme endroit et
# d'attendre que je branche : le branchement est fait.
my $av = "D\x{E9}posez tout dans `_a-installer\\images\\` et dites-le-moi. Je m\x{2019}occupe de :";
if($s =~ /\Q$av\E/){
  my $ap = "D\x{E9}posez-les directement dans `img\\acteurs\\` et `img\\` "
         . "(voir plus haut). Le branchement est d\x{E9}j\x{E0} fait :";
  $s =~ s/\Q$av\E/$ap/;
  print "  ok  le paragraphe final renvoie aux bons dossiers\n";
}

open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";
print $o $s; close $o;
print "  ok  mode d'emploi ajoute en tete\n";

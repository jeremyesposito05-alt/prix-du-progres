#!/usr/bin/perl
# LES SIX VUES DEVIENNENT SIX DECORS
#
#   perl _outils/prompts-decor.pl _a-installer/images/PROMPTS-ILLUSTRATIONS.md
#
# La section des vues d'ambiance demandait six paysages de ville, a
# deposer dans « img/ ». Or le jeu ne les aurait jamais montres : le
# « .vue » ou elles allaient appartient a la fenetre DESSINEE, masquee
# des que le decor photographique existe — et il existe.
#
# Le decor est une photographie de bureau dont la baie vitree donne
# sur la ville : la vue est DANS l image. Les trois etats d une ville
# se jouent donc la, en trois photographies de la meme piece. La
# section est reecrite en consequence : meme nombre d'images, autre
# cadrage, autre dossier, et des noms que le jeu cherche vraiment.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "_a-installer/images/PROMPTS-ILLUSTRATIONS.md";
open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;

my $de = index($s, "# I. Les vues d");
$de >= 0 or die "ARRET : section des vues introuvable. Rien n'a ete ecrit.\n";
my $avant = substr($s, 0, $de);

my $neuf = <<'FIN';
# I. Le bureau, et la ville par la fenêtre

> **Ce que c'est, et où ça va.** Le fond du jeu est une **photographie de bureau** dont la
> baie vitrée donne sur la ville : la vue est *dans* l'image, elle n'est pas une couche
> séparée. Il n'y a donc pas de « vues d'ambiance » à part — il y a **trois états du même
> bureau**, et le jeu en change au premier et au deuxième tiers de la partie.
>
> | Ce que c'est | Dossier | Noms |
> |---|---|---|
> | Les 3 bureaux de Manchester | `img\decor\` | `bureau-I-debut` · `bureau-I-milieu` · `bureau-I-fin` |
> | Les 3 bureaux de Detroit | `img\decor\` | `bureau-II-debut` · `bureau-II-milieu` · `bureau-II-fin` |
>
> **Format paysage très large** — environ 1800 × 1000 px. Le bas de l'image est couvert par
> les cartes du jeu : tout ce qui compte doit se trouver dans le **tiers supérieur**, et le
> bas doit rester sombre et vide.
>
> **Les trois d'un même niveau se font dans une seule conversation**, comme les visages :
> c'est la même pièce aux trois moments, seule la ville change.
>
> Detroit n'avait aucun décor et retombait sur celui de Manchester — un bureau victorien
> pour une usine de 1920. Ces trois images-là corrigent aussi cela.

## I1 — `bureau-I-debut.jpg` · Manchester, 1780

```
Intérieur d'un bureau anglais de la fin du XVIIIe siècle, vu de face : lambris de bois
sombre sur toute la largeur, grande baie vitrée à meneaux occupant le tiers supérieur de
l'image, rideau de velours rouge à gauche, globe terrestre et pile de livres reliés sur
l'appui de fenêtre, tapis persan et parquet sombre en bas. Par la fenêtre : une petite
ville de brique au bord d'une rivière, un clocher, trois ou quatre cheminées de manufacture
seulement, des champs et des arbres jusqu'à l'horizon, ciel clair de fin de journée.
Aucun personnage. Format paysage très large, le bas de l'image sombre et vide.
Style : peinture numérique réaliste, lumière chaude de fin d'après-midi, teintes sépia.
```

## I2 — `bureau-I-milieu.jpg` · Manchester, vers 1815

```
Même bureau, même lambris, même baie vitrée à meneaux, même rideau rouge, même globe sur
l'appui de fenêtre. Par la fenêtre : la même ville trente ans plus tard, une vingtaine de
cheminées de filature fumantes, des entrepôts de brique le long d'un canal, des péniches
chargées, un pont de pierre, les champs repoussés au loin, ciel qui se charge de fumée.
Aucun personnage. Format paysage très large, le bas de l'image sombre et vide.
Style : peinture numérique réaliste, lumière chaude de fin d'après-midi, teintes sépia.
```

## I3 — `bureau-I-fin.jpg` · Manchester, 1851

```
Même bureau, même lambris, même baie vitrée à meneaux, même rideau rouge, même globe sur
l'appui de fenêtre, mais la pièce est plus sombre et les vitres sont encrassées. Par la
fenêtre : une forêt de cheminées jusqu'à l'horizon, la fumée qui mange le ciel, des rangées
serrées de toits ouvriers, la rivière noire, plus un seul champ visible, soleil rouge voilé.
Aucun personnage. Format paysage très large, le bas de l'image sombre et vide.
Style : peinture numérique réaliste, lumière rasante et sale, teintes sépia assombries.
```

## I4 — `bureau-II-debut.jpg` · Detroit, 1908

```
Intérieur d'un bureau de direction américain du début du XXe siècle, vu de face : boiseries
claires et mur peint sur toute la largeur, grande fenêtre à cadre d'acier occupant le tiers
supérieur de l'image, store à lamelles relevé, lampe de bureau en laiton et classeur à
rideau sur le côté, parquet ciré en bas. Par la fenêtre : un atelier de brique à un étage,
une cour de terre battue, quelques automobiles noires garées, des arbres et des maisons de
bois au fond, ciel clair du matin. Aucun personnage. Format paysage très large, le bas de
l'image sombre et vide. Style : peinture numérique réaliste d'après photographie des années
1910, teintes froides et sobres.
```

## I5 — `bureau-II-milieu.jpg` · Detroit, vers 1925

```
Même bureau, mêmes boiseries claires, même fenêtre à cadre d'acier, même lampe de laiton.
Par la fenêtre : une usine immense de béton et de verre sur plusieurs étages, des halls à
verrières, des cheminées, un faisceau de voies ferrées avec des wagons de marchandises, un
parc d'automobiles noires alignées à perte de vue, ciel chargé de fumée. Aucun personnage.
Format paysage très large, le bas de l'image sombre et vide. Style : peinture numérique
réaliste d'après photographie des années 1920, teintes froides et sobres.
```

## I6 — `bureau-II-fin.jpg` · Detroit, 1932

```
Même bureau, mêmes boiseries claires, même fenêtre à cadre d'acier, mais la pièce est
éteinte et les vitres sont sales. Par la fenêtre : la même usine à l'arrêt, les cheminées
froides, les halls vides, le parc d'automobiles désert, une longue file d'hommes en manteau
devant le portail sous un ciel gris de neige fondue. Aucun personnage dans la pièce. Format
paysage très large, le bas de l'image sombre et vide. Style : peinture numérique réaliste
d'après photographie des années 1930, teintes froides et désaturées.
```
FIN

open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";
print $o $avant . $neuf; close $o;
print "  ok  la section des vues devient la section des decors\n";
print "  ok  six noms que le jeu cherche vraiment, dans img/decor/\n";

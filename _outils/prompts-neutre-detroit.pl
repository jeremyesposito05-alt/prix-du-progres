#!/usr/bin/perl
# LES QUATRE VISAGES POSES DE DETROIT
#
#   perl _outils/prompts-neutre-detroit.pl _a-installer/images/PROMPTS-ILLUSTRATIONS.md
#
# La section J ne portait que Manchester, et renvoyait Detroit a une
# adaptation « meme personnage, meme posture ». C'etait leger : les
# personnages de Detroit ont ete generes depuis, et on sait maintenant
# a quoi ils ressemblent — le costume, le decor, jusqu'au globe de
# laiton sur le bureau de l'actionnaire. Les quatre prompts sont donc
# ecrits d'apres les images existantes, et non d'apres l'idee qu'on
# s'en faisait.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "_a-installer/images/PROMPTS-ILLUSTRATIONS.md";
open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;

my $bloc = <<'FIN';
## J5 — `II-i-neutre.png` · l'actionnaire, posé

```
Même actionnaire américain, la soixantaine, cheveux gris argentés, costume trois-pièces
sombre, cravate bordeaux, pochette blanche. Il attend votre décision : assis derrière son
grand bureau, le buste droit face à l'objectif, le visage neutre, ni sourire ni sourcils
froncés, les deux mains posées à plat sur le registre ouvert, le globe de laiton à sa
gauche. Derrière lui, la même fenêtre à cadre d'acier sur l'usine et ses cheminées, ciel
de fin de journée. Style : photographie noir et blanc américaine des années 1920,
légèrement virée sépia, contraste doux, grain argentique. Pas de texte.
```

## J6 — `II-o-neutre.png` · l'ouvrier, posé

```
Même ouvrier américain, la trentaine, casquette plate grise, chemise claire tachée de
cambouis, salopette de travail, bras nus. Il attend : debout, le buste droit face à
l'objectif, le visage neutre et sans expression marquée, les bras le long du corps, une
clé dans la main baissée. Derrière lui, flous, le hall de montage, les machines et les
roues d'automobiles. Style : photographie noir et blanc américaine des années 1920,
légèrement virée sépia, contraste doux, grain argentique. Pas de texte.
```

## J7 — `II-m-neutre.png` · les clients, posés

```
Mêmes clients américains, le couple : elle, la trentaine, chapeau cloche et manteau
rouille à col de fourrure ; lui, la trentaine, lunettes rondes et costume trois-pièces
brun à chevrons. Ils attendent : tous deux tournés vers l'objectif, le visage neutre, ni
sourire ni moue, lui la main posée à plat sur l'aile de l'automobile noire, elle à côté
de lui, les mains jointes. Derrière eux, floues, les grandes verrières du hall
d'exposition. Style : photographie noir et blanc américaine des années 1920, légèrement
virée sépia, contraste doux, grain argentique. Pas de texte.
```

## J8 — `II-p-neutre.png` · la journaliste, posée

```
Même journaliste américaine, la trentaine, chapeau cloche brun, tailleur de tweed,
chemisier blanc, sacoche en bandoulière. Elle attend : debout, le buste droit face à
l'objectif, le visage neutre et attentif, le carnet fermé tenu à deux mains devant elle,
le crayon rangé. Derrière elle, floue, la rue de la ville et ses réverbères au crépuscule.
Style : photographie noir et blanc américaine des années 1920, légèrement virée sépia,
contraste doux, grain argentique. Pas de texte.
```

FIN

# On remplace le renvoi vague par les quatre prompts reels.
my $av = "> Les quatre m\x{EA}mes prompts valent pour Detroit \x{2014} m\x{EA}me personnage, m\x{EA}me posture \x{2014} en\n"
       . "> terminant par : *Style : photographie noir et blanc am\x{E9}ricaine des ann\x{E9}es 1920,\n"
       . "> l\x{E9}g\x{E8}rement vir\x{E9}e s\x{E9}pia, contraste doux, grain argentique. Pas de texte.*\n";
my $n = () = ($s =~ /\Q$av\E/g);
$n == 1 or die "ARRET : renvoi trouve $n fois. Rien n'a ete ecrit.\n";
$s =~ s/\Q$av\E/$bloc/;

open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";
print $o $s; close $o;
print "  ok  quatre prompts de Detroit, ecrits d'apres les images existantes\n";

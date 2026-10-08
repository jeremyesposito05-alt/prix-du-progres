#!/usr/bin/perl
# LE CINQUIEME VISAGE : CELUI QUI ATTEND
#
#   perl _outils/prompts-neutre.pl _a-installer/images/PROMPTS-ILLUSTRATIONS.md
#
# Les quatre visages generes le 8 octobre sont content, contrarie,
# fache et au bord. Le jeu en distingue cinq : entre 48 et 58, l'acteur
# n'est ni content ni contrarie, il est pose. Faute de cette image,
# c'est le visage content qui sert — mesure : l'acteur sourirait 72 %
# du temps au lieu de 46 %.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "_a-installer/images/PROMPTS-ILLUSTRATIONS.md";
open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;

my $bloc = <<'FIN';
---

# J. Le cinquième état : le visage posé

> **Pourquoi il manque.** Les quatre visages générés sont *content*, *contrarié*, *fâché*
> et *au bord*. Le jeu en distingue cinq : entre 48 et 58, l'acteur n'est ni content ni
> contrarié, il est **posé**. Faute de cette image, c'est le visage content qui sert —
> l'acteur sourit alors 72 % du temps au lieu de 46 %.
>
> **Un seul prompt par acteur.** À faire dans la même conversation que les quatre autres si
> elle est encore ouverte ; sinon, recommencez par le prompt `content` pour retrouver le
> personnage, puis enchaînez celui-ci.
>
> Le fichier s'appelle `<niveau>-<acteur>-neutre.png` et remplacera l'actuel
> `<niveau>-<acteur>-portrait.jpg` dans `img\acteurs\`.

## J1 — `I-i-neutre.png` · l'industriel, posé

```
Même industriel anglais du XIXe siècle, mêmes favoris, même redingote sombre. Il attend
votre décision : le buste droit face à l'objectif, le visage neutre, ni sourire ni sourcils
froncés, les deux mains posées à plat sur le registre ouvert. Derrière lui, floue, la même
filature. Style : gravure anglaise du XIXe siècle colorisée, teintes sépia chaudes, lumière
latérale douce, grain photographique d'époque. Pas de texte.
```

## J2 — `I-o-neutre.png` · l'ouvrière, posée

```
Même ouvrière de filature anglaise du XIXe siècle, même fichu, même tablier. Elle attend :
le buste droit face à l'objectif, le visage neutre et sans expression marquée, les mains
jointes devant le tablier. Derrière elle, floue, la même salle de filature. Style : gravure
anglaise du XIXe siècle colorisée, teintes sépia chaudes, lumière latérale douce, grain
photographique d'époque. Pas de texte.
```

## J3 — `I-m-neutre.png` · le négociant, posé

```
Même négociant anglais du XIXe siècle, même haut-de-forme, même manteau. Il attend : le
buste droit face à l'objectif, le visage neutre, le carnet de commandes posé fermé devant
lui sur la table. Derrière lui, flous, le même quai et le même canal. Style : gravure
anglaise du XIXe siècle colorisée, teintes sépia chaudes, lumière latérale douce, grain
photographique d'époque. Pas de texte.
```

## J4 — `I-p-neutre.png` · l'envoyé du Parlement, posé

```
Même haut fonctionnaire britannique du XIXe siècle, mêmes cheveux blancs, même redingote
noire, même col haut. Il attend : le buste droit face à l'objectif, le visage neutre et
impassible, les mains posées sur la liasse de documents. Derrière lui, floue, la même salle
de commission. Style : gravure anglaise du XIXe siècle colorisée, teintes sépia chaudes,
lumière latérale douce, grain photographique d'époque. Pas de texte.
```

> Les quatre mêmes prompts valent pour Detroit — même personnage, même posture — en
> terminant par : *Style : photographie noir et blanc américaine des années 1920,
> légèrement virée sépia, contraste doux, grain argentique. Pas de texte.*

FIN

my $ancre;
for my $a ("---\n\n# I. Les vues d\x{2019}ambiance", "---\n\n# I. Les vues d'ambiance"){
  $ancre = $a if $s =~ /\Q$a\E/;
}
$ancre or die "ARRET : section des vues introuvable. Rien n'a ete ecrit.\n";
my $n = () = ($s =~ /\Q$ancre\E/g);
$n == 1 or die "ARRET : ancre trouvee $n fois. Rien n'a ete ecrit.\n";
$s =~ s/\Q$ancre\E/$bloc . $ancre/e;

if($s =~ s/\*\*32 visages \+ 6 vues\.\*\*/**36 visages + 6 vues.**/){
  print "  ok  le total passe de 32 a 36 visages\n";
} else {
  print "  (total en tete inchange — a verifier)\n";
}

open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";
print $o $s; close $o;
print "  ok  section J ajoutee : 4 prompts du visage pose\n";

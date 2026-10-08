#!/usr/bin/perl
# LE HUITIEME ETAT : CELUI QUI S EN VA
#
#   perl _outils/prompts-au-bord.pl _a-installer/images/PROMPTS-ILLUSTRATIONS.md
#
# Le document demandait deux visages par acteur, content et fache. Le
# jeu en distingue desormais quatre, et le quatrieme n'est pas « plus
# fache » : c'est celui qui ne vous regarde plus. L'idee tient en une
# phrase, et c'est elle qui rend l'etat reconnaissable a 62 px sur un
# telephone : dans « fache », la colere vous est adressee ; dans
# « au bord », le personnage a deja le corps tourne vers la sortie.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "_a-installer/images/PROMPTS-ILLUSTRATIONS.md";
open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;

my $bloc = <<'FIN';
---

# D. Les visages — celui qui s'en va

> **Ce qui distingue cet état du précédent.** Dans « fâché », la colère vous est
> adressée : le personnage vous regarde. Dans « au bord », il ne vous regarde plus —
> il a déjà le corps tourné vers la sortie, et ses affaires à la main. C'est cette
> différence-là qui se voit à soixante pixels sur un téléphone, pas un sourcil de plus.
>
> Le jeu affiche ce visage quand la force passe sous vingt, au moment même où il écrit
> « ne tiendra pas longtemps » sous le nom. Le visage et la phrase disent la même chose.

## D1 — `I-i-au-bord.png` · l'industriel qui plie bagage

```
Même industriel anglais du XIXe siècle, mêmes favoris, même redingote sombre. Il
part : le chapeau haut de forme déjà sur la tête, un registre fermé sous le bras, le
corps tourné de trois quarts vers la sortie, le regard loin derrière l'objectif.
Derrière lui, floue, sa filature de coton aux grilles closes et aux cheminées
froides. Style : gravure anglaise du XIXe siècle colorisée, teintes sépia chaudes,
lumière latérale douce, grain photographique d'époque. Pas de texte.
```

## D2 — `I-o-au-bord.png` · l'ouvrière qui ne reviendra pas

```
Même ouvrière de filature anglaise du XIXe siècle, même fichu, même tablier. Elle
s'en va : un châle serré sur les épaules, un baluchon de toile contre la hanche, le
visage de profil perdu, aucun regard vers l'objectif. Derrière elle, floue, la salle
de filature aux métiers arrêtés et aux bobines immobiles. Style : gravure anglaise
du XIXe siècle colorisée, teintes sépia chaudes, lumière latérale douce, grain
photographique d'époque. Pas de texte.
```

## D3 — `I-m-au-bord.png` · le négociant qui retire ses comptes

```
Même négociant anglais du XIXe siècle, même chapeau, même manteau de voyage. Il
retire ses affaires de la ville : deux registres ficelés sous le bras, une malle à
ses pieds, le corps déjà de dos, la tête tournée une dernière fois sans regarder
l'objectif. Derrière lui, flou, un quai où l'on charge ses caisses sur un bateau qui
part ailleurs. Style : gravure anglaise du XIXe siècle colorisée, teintes sépia
chaudes, lumière latérale douce, grain photographique d'époque. Pas de texte.
```

## D4 — `I-p-au-bord.png` · l'envoyé du Parlement qui a fini d'écrire

```
Même envoyé du Parlement britannique du XIXe siècle, même habit noir, même col haut.
Il ne discute plus : un rapport cacheté de cire rouge tenu à deux mains, le menton
baissé, le regard déjà tourné vers Londres, le corps de trois quarts. Derrière lui,
flou, le palais de Westminster sous un ciel chargé. Style : gravure anglaise du
XIXe siècle colorisée, teintes sépia chaudes, lumière latérale douce, grain
photographique d'époque. Pas de texte.
```

## D5 — `II-i-au-bord.png` · l'actionnaire qui vend ses parts

```
Même actionnaire américain des années 1920, même costume trois-pièces clair. Il
sort : le chapeau en main, une serviette de cuir refermée, le corps tourné vers la
porte, le regard par-dessus l'épaule mais pas vers l'objectif. Derrière lui, flou,
le bureau de direction déserté, les fauteuils vides. Style : photographie noir et
blanc américaine des années 1920, légèrement virée sépia, contraste doux, grain
argentique. Pas de texte.
```

## D6 — `II-o-au-bord.png` · l'ouvrier qui rend son tablier

```
Même ouvrier américain des années 1920, même salopette, même casquette. Il quitte
l'usine : le tablier roulé sous le bras, la casquette à la main, le visage fermé
tourné vers la sortie, aucun regard vers l'objectif. Derrière lui, floue, la chaîne
de montage à l'arrêt et une file d'hommes au portail. Style : photographie noir et
blanc américaine des années 1920, légèrement virée sépia, contraste doux, grain
argentique. Pas de texte.
```

## D7 — `II-m-au-bord.png` · le client qui a acheté ailleurs

```
Même client américain des années 1920, même chapeau mou, même manteau. Il est déjà
parti : la main sur la portière d'une automobile claire d'une autre marque, le corps
entièrement de profil, le regard sur sa voiture et non sur l'objectif. Derrière lui,
floue, la rue commerçante et une vitrine de concessionnaire concurrent. Style :
photographie noir et blanc américaine des années 1920, légèrement virée sépia,
contraste doux, grain argentique. Pas de texte.
```

## D8 — `II-p-au-bord.png` · la journaliste qui a bouclé son enquête

```
Même journaliste américaine des années 1920, même tailleur sombre, mêmes cheveux
courts. L'article est écrit : un dossier épais fermé contre elle, le carnet rangé,
le corps tourné vers la rédaction, le regard droit devant mais pas vers l'objectif.
Derrière elle, flou, un atelier de presse et ses rotatives. Style : photographie
noir et blanc américaine des années 1920, légèrement virée sépia, contraste doux,
grain argentique. Pas de texte.
```

FIN

my $ancre = "---\n\n# C. Les vues d'ambiance";
my $n = () = ($s =~ /\Q$ancre\E/g);
$n == 1 or die "ARRET : ancre trouvee $n fois, 1 attendue. Rien n'a ete ecrit.\n";
$s =~ s/\Q$ancre\E/$bloc . "---\n\n# C. Les vues d'ambiance"/e;

# Le decompte en tete du document doit suivre.
my $av_t = "| **Visages f\x{E2}ch\x{E9}s** | 8 | idem |";
my $ap_t = "| **Visages f\x{E2}ch\x{E9}s** | 8 | idem |\n"
         . "| **Visages \x{AB} au bord \x{BB}** | 8 | idem \x{2014} celui qui s\x{2019}en va, section D |";
my $m = () = ($s =~ /\Q$av_t\E/g);
$m == 1 or die "ARRET : ligne du tableau trouvee $m fois. Rien n'a ete ecrit.\n";
$s =~ s/\Q$av_t\E/$ap_t/;
$s =~ s/\| \*\*22 images\*\* \|/| **30 images** |/
  or die "ARRET : total des images introuvable\n";

open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";
print $o $s; close $o;
print "  ok  section D ajoutee : 8 prompts \x{AB} au bord \x{BB}\n";
print "  ok  le decompte passe de 22 a 30 images\n";

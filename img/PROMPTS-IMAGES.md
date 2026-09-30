# Les photographies de fond

Le jeu les cherche ici, et **fonctionne très bien sans elles** — sans image, il peint
lui-même une ville en SVG dont les cheminées sortent de terre à mesure qu'elle grandit.

```
Jeu\img\vue-I.jpg      (Manchester, 1780-1851)
Jeu\img\vue-II.jpg     (Detroit, 1908-1932)
Jeu\img\vue-III.jpg    (plus tard, pour la révolution numérique)
```

Format : **1920 × 1080**, JPEG.

## Ce que c'est exactement

**Ce qu'on voit par la fenêtre**, pas le bureau. Le bureau, les papiers, la vitre sale et
les montants sont déjà dessinés par le jeu ; l'image ne fournit que le paysage derrière.

Elle est donc vue **de l'intérieur vers l'extérieur**, à hauteur d'homme, et une grande
partie du centre sera recouverte par les documents. Trois règles :

1. **Pas de premier plan.** Ni rebord, ni châssis, ni objet : le jeu les ajoute par-dessus.
2. **L'intérêt est sur les côtés et en haut.** Le centre bas disparaîtra sous les cartes.
3. **Aucun texte lisible**, aucune enseigne, aucun personnage au premier plan.

---

## vue-I.jpg — Manchester

> Vue panoramique d'une ville industrielle anglaise du XIXe siècle par un jour de brouillard,
> vue depuis une fenêtre en étage. Une forêt de hautes cheminées de brique crachant des fumées
> épaisses, des toits d'ardoise serrés, des entrepôts de brique noircie, un canal étroit au
> loin. Ciel bas, gris et jaunâtre, lumière diffuse de fin d'après-midi. Palette de suie, de
> brique brune et de gris. Aucun premier plan, aucun cadre de fenêtre, aucun texte.
> Rendu photographique atmosphérique, format paysage 16:9.

## vue-II.jpg — Detroit

> Vue panoramique d'un complexe industriel automobile américain des années 1920, vue depuis
> une verrière en étage. De vastes halles à toit en dents de scie, des cheminées d'usine, des
> réservoirs d'acier, des voies ferrées et des wagons de marchandises, une grue au loin.
> Ciel gris métallique, lumière froide de matin d'hiver. Palette d'acier, de béton et de
> rouille. Aucun premier plan, aucun cadre de fenêtre, aucun texte.
> Rendu photographique atmosphérique, format paysage 16:9.

---

## Vérifier qu'une image convient

Posez-la dans `img\`, ouvrez le jeu, jouez trois ou quatre tours. Deux choses à regarder :

- **Le texte des cartes reste-t-il aussi lisible qu'avant ?** Si non, l'image est trop claire
  ou trop chargée : regénérez-la plus sombre et plus vide.
- **La ville s'encrasse-t-elle encore ?** Avec une image, la vitre sale continue de s'assombrir
  au fil de la partie, mais les cheminées peintes disparaissent. C'est voulu — si vous préférez
  garder la ville qui pousse, n'installez pas d'image du tout.

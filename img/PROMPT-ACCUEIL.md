# L'illustration de l'écran d'accueil

Le jeu la cherche ici, et **fonctionne très bien sans elle** — sans image, le panneau reste
en dégradé bleu marine, ce qui est déjà conforme à la charte.

```
img/accueil.jpg      1920 × 1080, JPEG
```

## Ce qu'elle doit être

Un **fond**, pas une affiche. Le titre « Le prix du progrès », le blason, l'accroche et le
bouton se posent par-dessus, dans un panneau bleu marine à 90 % d'opacité. L'image ne se
verra donc qu'en transparence, comme une texture derrière le texte.

Trois règles :

1. **Le centre reste sombre et vide.** Tout le tiers central sera recouvert par le titre et
   le bouton. L'intérêt doit se trouver sur les bords et dans les angles.
2. **Aucun texte, aucun logo, aucun visage.**
3. **Pas de blanc franc, pas de zone très claire** : le texte est blanc et or, il disparaîtrait.

## Le prompt

> Composition horizontale en triptyque très sombre, évoquant trois âges de l'industrie de
> gauche à droite : à gauche des cheminées de brique et des toits d'ardoise dans un brouillard
> épais ; au centre, dégagé et presque noir, une simple silhouette de structures métalliques ;
> à droite des lignes de lumière froide et des formes géométriques abstraites évoquant des
> circuits et des données. Palette strictement limitée au bleu marine profond, au bleu acier
> et au gris ardoise, avec de rares filets d'or chaud comme seules touches lumineuses.
> Aucune source de lumière vive, aucune zone claire, aucun texte, aucun personnage.
> Atmosphère grave et feutrée, rendu pictural très contrasté, format paysage 16:9.

## Pourquoi ces couleurs

Elles sont celles de la charte du collège, et elles seules :

| | |
|---|---|
| Dark Navy | `#1A2047` — le fond du panneau |
| Mid Blue | `#14387F` — le dégradé central |
| Bright Blue | `#0087CC` — les lueurs froides, à droite |
| Gold | `#F3BE31` — les filets, le bouton, **en accent seulement** |
| Dark Grey | `#2E3945` — les gris ardoise |

L'or ne doit jamais couvrir de surface : des filets, des reflets, rien de plus. C'est la règle
de la charte, et c'est aussi ce qui fera ressortir le bouton « Démarrer ».

## Vérifier qu'elle convient

Posez-la dans `img\`, ouvrez le jeu. Le titre blanc doit rester parfaitement lisible et le
bouton or doit sauter aux yeux. Si l'image attire l'œil avant le titre, c'est qu'elle est trop
claire ou trop chargée : regénérez-la plus sombre, en insistant sur « centre vide et presque
noir ».

# Le prix du progrès

Jeu de décision historique pour l'unité 1 de G10, *Quand l'innovation change la société*.
Collège Alpin Beau Soleil.

**Jouer :** https://jeremyesposito05-alt.github.io/prix-du-progres/

Un seul fichier, aucune dépendance, aucun compte : le jeu tourne dans n'importe quel
navigateur, y compris sur téléphone, et fonctionne hors ligne une fois la page chargée.

## Ce que l'élève y fait

Il décide. Quatre forces le jugent — selon le niveau : industriels, ouvriers, marchands et
Parlement, ou actionnaires, ouvriers, clients et opinion. **Si l'une d'elles tombe à zéro,
la partie s'arrête.** Chaque décision en contente une et en fâche une autre : c'est le sujet
même du cours.

| Niveau | Lieu et période | Le joueur est |
|---|---|---|
| I | Manchester, 1780-1851 | le maître de la ville |
| II | Detroit, 1908-1932 | le directeur de l'usine |
| III | La révolution numérique | *en préparation* |

Deux modes : **campagne** (18 décisions jusqu'à la date de bilan, puis un verdict) et
**survie** (sans fin, le score se compte en habitants ou en voitures produites).

## Ce qui est vrai et ce qui ne l'est pas

Le jeu le dit à l'élève, et c'est un point de méthode :

- Les **personnages** qui viennent parler sont des **figures composites**. Ils n'ont pas porté
  ces noms, mais chacun dit ce que disaient les gens de sa condition.
- Les **événements** sont **authentiques et datés**, et chacun cite sa source à l'écran :
  Peterloo le 16 août 1819, la grève des bouchons d'août 1842, l'incendie de la Triangle
  Shirtwaist du 25 mars 1911, l'arrêt *Dodge v. Ford* de 1919, le Jeudi noir.
- Les **témoignages du verdict** sont de vrais textes : Johanna Schopenhauer et Friedrich
  Engels au niveau I, Henry Ford et Antonio Gramsci au niveau II.
- Chaque carte porte un encart **« Pour comprendre »** : deux phrases de fait, pour que la
  situation se comprenne sans connaissance préalable.

## Les images de fond

Facultatives. Sans elles, le jeu peint lui-même une ville dont les cheminées sortent de terre
à mesure qu'elle grandit, et dont la vitre s'encrasse quand les ouvriers s'épuisent.
Voir `img/PROMPTS-IMAGES.md` pour en ajouter.

## Modifier le jeu

Tout est dans `index.html` : structure, feuilles de style, données et moteur. Les cartes sont
dans les tableaux `CARTES_I` et `CARTES_II`, les événements dans `EV_I` et `EV_II`, et chaque
niveau est décrit dans la table `NIVEAUX`.

`_sauvegardes/` conserve une copie datée avant chaque publication.

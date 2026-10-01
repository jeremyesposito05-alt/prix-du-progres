# Les images du jeu

Trois dossiers, **tous facultatifs**. Une image absente se retire d'elle-même :
aucune icône cassée, la mise en page se referme. Vous pouvez donc en déposer une
seule et voir le résultat tout de suite.

```
img/acteurs/   les quatre forces, sur l'écran de présentation du niveau   52 × 52 px
img/gens/      celui qui plaide, en pastille ronde à côté de son nom      38 × 38 px
img/docs/      la pièce jointe au rapport d'enquête                       largeur ~480 px
```

Format JPEG. Les deux premiers sont recadrés en carré par le jeu : cadrez sur le
visage. Le troisième s'affiche comme une photographie agrafée au dossier, posée de
travers, avec sa légende — c'est **lui qui doit donner envie d'ouvrir le rapport**.

## La légende d'une pièce jointe

Elle s'écrit dans le jeu, pas dans le fichier. Donnez-la-moi avec l'image et je
l'ajoute : il suffit d'un champ `doc:` sur la carte concernée.

## Les noms de fichiers attendus

Ils sont dérivés automatiquement du texte du jeu. Si je renomme une affaire,
il faudra renommer son image — je vous préviendrai.

```
=== Manchester ===
  img/acteurs/I-i.jpg   <- Industriels
  img/acteurs/I-o.jpg   <- Ouvriers
  img/acteurs/I-m.jpg   <- Marchands
  img/acteurs/I-p.jpg   <- Parlement

  img/gens/josiah-halliwell.jpg   <- Josiah Halliwell
  img/gens/thomas-ainsworth.jpg   <- Thomas Ainsworth
  img/gens/abel-crompton.jpg   <- Abel Crompton
  img/gens/amos-pilkington.jpg   <- Amos Pilkington
  img/gens/charles-beresford.jpg   <- Charles Beresford
  img/gens/docteur-william-rait.jpg   <- docteur William Rait
  img/gens/ezra-duckworth.jpg   <- Ezra Duckworth
  img/gens/reverend-ellis-hargreaves.jpg   <- révérend Ellis Hargreaves
  img/gens/mary-kearsley.jpg   <- Mary Kearsley
  img/gens/agnes-thorne.jpg   <- Agnes Thorne
  img/gens/secretaire-du-conseil-de-ville.jpg   <- secrétaire du conseil de ville

  img/docs/le-charbon-manque-a-la-filature.jpg   <- Le charbon manque à la filature.
  img/docs/un-mecanicien-vous-montre-un-plan.jpg   <- Un mécanicien vous montre un plan.
  img/docs/quarante-familles-attendent-a-la-grille.jpg   <- Quarante familles attendent à la grille.
  img/docs/un-batisseur-propose-soixante-cottages.jpg   <- Un bâtisseur propose soixante cottages.
  img/docs/deux-heures-de-plus-par-jour.jpg   <- Deux heures de plus par jour.
  img/docs/le-parlement-a-vote-le-factory-act.jpg   <- Le Parlement a voté le Factory Act.
  img/docs/l-eau-croupit-devant-les-portes.jpg   <- L’eau croupit devant les portes.
  img/docs/liverpool-propose-une-voie-ferree.jpg   <- Liverpool propose une voie ferrée.
  img/docs/des-acheteurs-attendent-a-hambourg.jpg   <- Des acheteurs attendent à Hambourg.
  img/docs/un-medecin-demande-une-salle-et-deux-lits.jpg   <- Un médecin demande une salle et deux lits.
  img/docs/on-loue-desormais-les-sous-sols.jpg   <- On loue désormais les sous-sols.
  img/docs/une-fileuse-demande-a-vous-parler.jpg   <- Une fileuse demande à vous parler.
  img/docs/un-contremaitre-veut-chronometrer-les-gestes.jpg   <- Un contremaître veut chronométrer les gestes.
  img/docs/trois-morts-dans-la-meme-ruelle.jpg   <- Trois morts dans la même ruelle.
  img/docs/le-dernier-terrain-libre-du-centre.jpg   <- Le dernier terrain libre du centre.
  img/docs/le-pain-a-double-depuis-le-printemps.jpg   <- Le pain a doublé depuis le printemps.
  img/docs/une-petition-contre-les-droits-sur-le-grain.jpg   <- Une pétition contre les droits sur le grain.
  img/docs/le-monde-entier-defile-au-crystal-palace.jpg   <- Le monde entier défile au Crystal Palace.
  img/docs/une-filature-a-brule-cette-nuit.jpg   <- Une filature a brûlé cette nuit.
  img/docs/un-predicateur-decrit-ce-qu-il-voit.jpg   <- Un prédicateur décrit ce qu’il voit.

=== Detroit ===
  img/acteurs/II-i.jpg   <- Actionnaires
  img/acteurs/II-o.jpg   <- Ouvriers
  img/acteurs/II-m.jpg   <- Clients
  img/acteurs/II-p.jpg   <- Opinion

  img/gens/walter-kessler.jpg   <- Walter Kessler
  img/gens/frank-doyle.jpg   <- Frank Doyle
  img/gens/docteur-emmett-crowe.jpg   <- docteur Emmett Crowe
  img/gens/elias-bright.jpg   <- Elias Bright
  img/gens/anna-kowalczyk.jpg   <- Anna Kowalczyk
  img/gens/harriet-vance.jpg   <- Harriet Vance
  img/gens/sam-rusin.jpg   <- Sam Rusin

  img/docs/un-ingenieur-propose-de-faire-venir-la-voiture-a-l-ouvrier.jpg   <- Un ingénieur propose de faire venir la voiture à l’ouvrier.
  img/docs/personne-ne-reste-plus-de-quelques-jours.jpg   <- Personne ne reste plus de quelques jours.
  img/docs/qui-merite-les-cinq-dollars.jpg   <- Qui mérite les cinq dollars ?
  img/docs/le-client-demande-une-autre-couleur.jpg   <- Le client demande une autre couleur.
  img/docs/une-usine-qui-fabriquerait-tout.jpg   <- Une usine qui fabriquerait tout.
  img/docs/l-ouvriere-de-la-ligne-4-demande-a-parler.jpg   <- L’ouvrière de la ligne 4 demande à parler.
  img/docs/general-motors-change-de-modele-chaque-annee.jpg   <- General Motors change de modèle chaque année.
  img/docs/faut-il-vendre-a-credit.jpg   <- Faut-il vendre à crédit ?
  img/docs/cinq-jours-de-travail-au-lieu-de-six.jpg   <- Cinq jours de travail au lieu de six.
  img/docs/un-organisateur-distribue-des-tracts-a-la-grille.jpg   <- Un organisateur distribue des tracts à la grille.
  img/docs/le-chronometre-descend-a-l-atelier.jpg   <- Le chronomètre descend à l’atelier.
  img/docs/un-homme-se-presente-avec-une-jambe-en-moins.jpg   <- Un homme se présente avec une jambe en moins.
  img/docs/les-machines-reclament-du-courant.jpg   <- Les machines réclament du courant.
  img/docs/les-pieces-ne-s-emboitent-pas.jpg   <- Les pièces ne s’emboîtent pas.
  img/docs/le-marche-s-est-arrete-d-un-coup.jpg   <- Le marché s’est arrêté d’un coup.
  img/docs/ils-marchent-vers-l-usine.jpg   <- Ils marchent vers l’usine.
  img/docs/la-publicite-coute-un-million.jpg   <- La publicité coûte un million.
  img/docs/deux-hommes-attendent-a-l-embauche.jpg   <- Deux hommes attendent à l’embauche.
  img/docs/faut-il-arreter-la-voiture-qui-vous-a-faits.jpg   <- Faut-il arrêter la voiture qui vous a faits ?
  img/docs/un-contremaitre-interdit-de-parler.jpg   <- Un contremaître interdit de parler.

```

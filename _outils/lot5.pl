#!/usr/bin/perl
# LOT 5 — LES AFFAIRES 16 A 20
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $MARQUE = "/* --- fin du dictionnaire --- */";

my $LOT = <<'FIN';
/* ---------- affaire 16 ---------- */
"Les familles dans les caves":"The families in the cellars",
"Margaret Hughes, locataire d’une cave":"Margaret Hughes, cellar tenant",
"« Je veux quitter l’humidité sans dormir dehors avec mes enfants. »":
  "“I want out of the damp without sleeping in the street with my children.”",
"Des familles louent des caves humides faute de logements disponibles. Les fermer immédiatement pourrait les laisser sans aucun abri.":
  "Families rent damp cellars for want of anywhere else. Closing them at once could leave those families with no shelter at all.",
"Consultez Document 5 (Engels). Retenez **logement insalubre** : un logement dangereux pour la santé à cause de l’humidité, du manque d’air ou de la saleté. Quelles conséquences imprévues peut avoir l’interdiction d’un habitat dangereux ?":
  "See Document 5 (Engels). Remember **unfit housing**: a dwelling dangerous to health through damp, want of air or filth. What unintended consequences can follow from banning a dangerous dwelling?",
"Habiter une cave n’est pas un choix : c’est ce qui reste quand la ville grandit plus vite que ses maisons. Fermer la cave supprime le logement, pas le besoin de se loger.":
  "Living in a cellar is not a choice: it is what is left when a town grows faster than its houses. Closing the cellar removes the dwelling, not the need for one.",
"Nous ne voulons plus de caves humides, mais il nous faut un toit.":
  "We want no more damp cellars, but we must have a roof.",
"Nous voulons fermer ces caves sans abandonner les familles à la rue.":
  "We want these cellars closed without turning families into the street.",
"« J’interdis immédiatement la location des caves. »":"“I ban the letting of cellars at once.”",
"Le Parlement retire des logements malsains, mais les ouvriers concernés risquent la rue.":
  "Parliament removes unhealthy dwellings, but the workers in them may be left on the street.",
"Nous risquons de dormir dehors dès la fermeture des caves.":
  "We may be sleeping in the open the day the cellars close.",
"Nous pourrons enfin interdire la location de ces caves malsaines.":
  "At last we can forbid the letting of these unhealthy cellars.",
"« J’attends la construction d’autres logements. »":"“I wait until other housing is built.”",
"Les ouvriers gardent temporairement un toit, mais le Parlement laisse durer l’insalubrité.":
  "The workers keep a roof for now, but Parliament lets the squalor continue.",
"Nous conserverons un toit pendant que d’autres maisons se construisent.":
  "We shall keep a roof while other houses go up.",
"Nous laisserons des familles vivre encore dans l’humidité.":
  "We shall leave families living in the damp a while longer.",
"« Je finance des logements de remplacement. »":"“I fund replacement housing.”",
"Les ouvriers peuvent déménager, mais le Parlement engage des dépenses importantes.":
  "The workers can move out, but Parliament commits to heavy spending.",
"Nous pourrons quitter ces caves pour un logement moins dangereux.":
  "We shall be able to leave these cellars for something less dangerous.",
"Nous devrons trouver l’argent nécessaire pour bâtir ces logements.":
  "We must find the money to build this housing.",

/* ---------- affaire 17 ---------- */
"Des rues sans égouts":"Streets without drains",
"Frederick Lowe, responsable des rues de Manchester":"Frederick Lowe, surveyor of Manchester’s streets",
"« Je veux évacuer les eaux sales avant que les rues deviennent impraticables. »":
  "“I want the foul water carried off before the streets become impassable.”",
"Les rues ouvrières sont boueuses et les eaux sales y stagnent. Construire des égouts demanderait des dépenses que la ville hésite à engager.":
  "The workers’ streets are muddy and foul water stands in them. Building sewers would cost money the town is reluctant to commit.",
"Consultez Document 5 · trace écrite 2 §2. Retenez **condition de vie** : l’ensemble des circonstances matérielles dans lesquelles une personne vit. Quelles conséquences le manque d’évacuation des eaux peut-il avoir sur la santé des habitants ?":
  "See Document 5 · written record 2 §2. Remember **living conditions**: the whole of the material circumstances in which a person lives. What consequences can the want of drainage have for people’s health?",
"La condition de travail se joue dans l’usine ; la condition de vie, dehors. Les eaux sales qui stagnent tuent autant que la machine, et elles ne coûtent rien à personne tant qu’on ne les regarde pas.":
  "Working conditions are settled inside the mill; living conditions, outside it. Standing foul water kills as surely as the machine, and it costs nobody anything so long as nobody looks at it.",
"Nous voulons pouvoir traverser les rues sans enliser nos charrettes.":
  "We want to cross the streets without miring our carts.",
"Nous voulons évacuer les eaux sales, mais le chantier sera coûteux.":
  "We want the foul water carried off, but the works will be costly.",
"« Je lance les travaux d’égouts. »":"“I begin the sewer works.”",
"Les ouvriers gagnent des rues plus saines, mais le Parlement supporte de lourds frais.":
  "The workers gain healthier streets, but Parliament carries a heavy cost.",
"Nous pourrons traverser des rues moins sales près de nos maisons.":
  "We shall cross cleaner streets by our own doors.",
"Nous devons consacrer une forte somme à creuser les égouts.":
  "We must set aside a large sum to dig the sewers.",
"« Je reporte les travaux d’une année. »":"“I put the works off for a year.”",
"Le Parlement ménage ses finances, mais les ouvriers continuent de vivre près des eaux sales.":
  "Parliament spares its finances, but the workers go on living beside foul water.",
"Nous verrons encore les eaux sales stagner devant nos portes.":
  "We shall watch the foul water stand at our doors a while yet.",
"Nous gardons cette année l’argent nécessaire à d’autres travaux.":
  "This year we keep the money for other works.",
"« Je commence par les ruelles les plus touchées. »":"“I start with the worst alleys.”",
"Les ouvriers des rues choisies sont mieux protégés, mais les marchands d’autres quartiers attendent encore.":
  "The workers in the chosen streets are better protected, but merchants in other quarters are still waiting.",
"Nous attendrons toujours des travaux près de nos magasins.":
  "We shall still be waiting for works near our warehouses.",
"Nous aurons enfin des conduites dans les ruelles les plus touchées.":
  "At last there will be drains in the worst alleys.",

/* ---------- affaire 18 ---------- */
"Une fièvre dans le quartier":"A fever in the quarter",
"Dr. Arthur Bennett, médecin du quartier":"Dr Arthur Bennett, physician to the quarter",
"« Je veux limiter les morts avant que davantage de familles soient touchées. »":
  "“I want the deaths contained before more families are struck.”",
"Plusieurs habitants de la même ruelle sont morts après une maladie soudaine. Fermer le quartier protégerait peut-être les voisins, mais arrêterait deux usines.":
  "Several people in the same alley have died of a sudden sickness. Closing the quarter might protect the neighbours, but it would stop two mills.",
"Consultez Document 5 · trace écrite 2 §2. Retenez **condition de vie** : l’ensemble des circonstances matérielles dans lesquelles une personne vit. Quelles causes possibles relient l’état des rues et la santé des habitants ?":
  "See Document 5 · written record 2 §2. Remember **living conditions**: the whole of the material circumstances in which a person lives. What possible causes connect the state of the streets to people’s health?",
"On ne savait pas encore que l’eau sale transmet la maladie. On voyait seulement que les mêmes ruelles mouraient plus que les autres : l’épidémie suit la carte des logements, pas celle des personnes.":
  "No one yet knew that foul water carries disease. All that could be seen was that the same alleys died more than others: the epidemic follows the map of the housing, not of the people.",
"Nous craignons une fermeture qui laisserait deux usines sans travail.":
  "We fear a closure that would leave two mills idle.",
"Nous voulons freiner cette fièvre avant qu’elle touche d’autres ruelles.":
  "We want this fever checked before it reaches other alleys.",
"« Je ferme provisoirement les deux usines. »":"“I close the two mills for the time being.”",
"Les ouvriers du voisinage limitent les contacts, mais les industriels perdent plusieurs journées de travail.":
  "The workers nearby have fewer contacts, but the industrialists lose several days’ work.",
"Nous laisserons les machines arrêtées pendant plusieurs journées.":
  "We shall leave the machines idle for several days.",
"Nous aurons moins de contacts pendant que la maladie circule.":
  "We shall mix less while the sickness is about.",
"« Je garde les usines ouvertes sous surveillance. »":"“I keep the mills open, under watch.”",
"Les industriels poursuivent leur activité, mais les ouvriers restent exposés à une possible contagion.":
  "The industrialists carry on, but the workers remain exposed to possible contagion.",
"Nous pourrons maintenir les deux usines en activité.":
  "We shall be able to keep both mills working.",
"Nous devrons encore travailler près des maisons où la fièvre frappe.":
  "We shall go on working beside the houses where the fever strikes.",
"« Je finance de l’eau propre et des soins. »":"“I pay for clean water and care.”",
"Les ouvriers obtiennent de l’aide sanitaire, mais le Parlement doit payer les interventions.":
  "The workers get medical help, but Parliament must pay for it.",
"Nous aurons de l’eau plus propre et des soins pour nos familles.":
  "We shall have cleaner water, and care for our families.",
"Nous devrons financer les soins et l’arrivée d’eau propre.":
  "We must pay for the care and for bringing in clean water.",

/* ---------- affaire 19 ---------- */
"Une ville sans assez de toits":"A town short of roofs",
"Charles Miller, conseiller chargé des logements":"Charles Miller, councillor for housing",
"« Je veux éviter que les nouveaux arrivants dorment à plusieurs familles par pièce. »":
  "“I want to stop newcomers sleeping several families to a room.”",
"La population de Manchester augmente rapidement avec les arrivées de travailleurs. Les familles s’entassent, car les constructions ne suivent pas.":
  "Manchester’s population is rising fast as workers arrive. Families crowd together, because building does not keep up.",
"Consultez Document 3 (la population) · trace écrite 2 §2. Retenez **urbanisation** : l’augmentation de la population des villes et de leur espace bâti. Comment la croissance des usines provoque-t-elle aussi une crise du logement ?":
  "See Document 3 (the population) · written record 2 §2. Remember **urbanisation**: the growth of towns in people and in built-up ground. How does the growth of the mills bring on a housing crisis as well?",
"Le document 3 donnait une courbe de population. L’urbanisation, c’est ce que cette courbe produit au sol : des gens arrivent plus vite qu’on ne bâtit, et c’est cet écart qui fait l’entassement.":
  "Document 3 gave a population curve. Urbanisation is what that curve produces on the ground: people arrive faster than houses are built, and it is that gap which makes the crowding.",
"Nous voulons garder des terrains pour les entrepôts de coton.":
  "We want land kept back for cotton warehouses.",
"Nous demandons des logements avant que plusieurs familles partagent la même pièce.":
  "We ask for housing before several families share one room.",
"« Je réserve des terrains aux logements. »":"“I set land aside for housing.”",
"Les ouvriers trouvent plus de place pour habiter, mais les marchands perdent des terrains pour leurs entrepôts.":
  "The workers find more room to live in, but the merchants lose land for their warehouses.",
"Nous manquerons de terrains pour stocker nos ballots de coton.":
  "We shall be short of ground to store our cotton bales.",
"Nous aurons davantage de place pour habiter près de notre travail.":
  "We shall have more room to live near our work.",
"« Je laisse les propriétaires bâtir librement. »":"“I let the owners build as they please.”",
"Les industriels obtiennent des logements rapides pour leurs salariés, mais les ouvriers risquent des maisons trop serrées.":
  "The industrialists get quick housing for their hands, but the workers risk houses packed too close.",
"Nous pourrons loger rapidement les nouveaux bras de nos ateliers.":
  "We can quickly house the new hands for our workshops.",
"Nous craignons de nous entasser dans des maisons construites trop vite.":
  "We fear being packed into houses thrown up too fast.",
"« Je limite temporairement les nouvelles installations. »":"“I limit new arrivals for a time.”",
"Le Parlement freine l’encombrement des quartiers, mais les industriels manquent de nouveaux travailleurs.":
  "Parliament slows the crowding of the quarters, but the industrialists lack new workers.",
"Nous manquerons de travailleurs nouveaux pour faire tourner nos métiers.":
  "We shall lack the new workers to keep our looms running.",
"Nous limiterons l’arrivée de familles dans des rues déjà pleines.":
  "We shall limit families arriving in streets already full.",

/* ---------- affaire 20 ---------- */
"Le dernier terrain du centre":"The last open ground in the centre",
"Philip Dawson, propriétaire d’un terrain central":"Philip Dawson, owner of a central plot",
"« Je veux vendre ce terrain au projet qui me paiera le mieux. »":
  "“I mean to sell this ground to whichever scheme pays me best.”",
"Un terrain libre pourrait accueillir des entrepôts pour le coton. Des habitants préfèrent un jardin ouvert à tous.":
  "An empty plot could take warehouses for cotton. Some residents would rather have a garden open to all.",
"Consultez Document 2 (Wyld) · trace écrite 2 §2. Retenez **urbanisation** : l’augmentation de la population des villes et de leur espace bâti. Quelle importance accordez-vous à un espace accessible à tous dans une ville qui grandit ?":
  "See Document 2 (Wyld) · written record 2 §2. Remember **urbanisation**: the growth of towns in people and in built-up ground. How much weight do you give to space open to all in a town that is growing?",
"Une ville qui grandit doit choisir ce qu’elle met sur chaque mètre carré. Un entrepôt rapporte, un jardin ne rapporte rien et se voit tout de suite : l’urbanisation est une suite de ces arbitrages.":
  "A growing town must choose what goes on every square yard. A warehouse pays, a garden pays nothing and is seen at once: urbanisation is a long run of such choices.",
"Nous avons besoin d’entrepôts au centre pour garder notre coton.":
  "We need warehouses in the centre to hold our cotton.",
"Nous voulons un jardin où les familles puissent respirer et se reposer.":
  "We want a garden where families can breathe and rest.",
"« Je réserve le terrain aux entrepôts. »":"“I keep the ground for warehouses.”",
"Les marchands gagnent de la place pour leurs marchandises, mais les ouvriers perdent un possible jardin.":
  "The merchants gain room for their goods, but the workers lose a garden they might have had.",
"Nous pourrons stocker nos ballots de coton près des magasins.":
  "We shall be able to store our cotton bales near the warehouses.",
"Nous n’aurons plus de terrain libre pour un jardin commun.":
  "There will be no open ground left for a common garden.",
"« Je soutiens la création du jardin. »":"“I support making the garden.”",
"Les ouvriers obtiennent un espace de repos, mais les marchands manquent de stockage.":
  "The workers gain somewhere to rest, but the merchants are short of storage.",
"Nous devrons trouver une autre place pour nos entrepôts.":
  "We must find somewhere else for our warehouses.",
"Nous aurons enfin un lieu de promenade loin des ateliers.":
  "At last we shall have somewhere to walk, away from the workshops.",
"« Je partage le terrain entre les deux projets. »":"“I divide the ground between the two schemes.”",
"Les marchands disposent d’une partie du sol, mais les ouvriers n’obtiennent qu’un petit jardin.":
  "The merchants get part of the ground, but the workers get only a small garden.",
"Nous conserverons une partie du terrain pour nos marchandises.":
  "We shall keep part of the ground for our goods.",
"Nous n’aurons qu’un petit coin de verdure entre les entrepôts.":
  "We shall have only a scrap of green between the warehouses.",

FIN

my $n = () = ($s =~ /\Q$MARQUE\E/g);
$n == 1 or die "ARRET : marqueur trouve $n fois\n";
$s =~ s/\Q$MARQUE\E/$LOT$MARQUE/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
my $e = () = ($LOT =~ /^"/mg);
printf "  ok  lot 5 pose · %d entrees\n", $e;

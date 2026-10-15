#!/usr/bin/perl
# LOT 3 — LES AFFAIRES 06 A 10
#
#   perl _outils/lot3.pl index.html
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $MARQUE = "/* --- fin du dictionnaire --- */";

my $LOT = <<'FIN';
/* ---------- affaire 06 ---------- */
"Une condition encore absente":"One condition still missing",
"George Ashcroft, conseiller de la ville":"George Ashcroft, town councillor",
"« Je veux lancer les fabriques maintenant, même si les commandes manquent encore. »":
  "“I want the mills started now, even if the orders are still wanting.”",
"Le charbon, les machines et les travailleurs sont disponibles. Les acheteurs restent trop peu nombreux pour écouler toute la production.":
  "Coal, machines and workers are all to hand. Buyers are still too few to take up everything that would be made.",
"Consultez Trace écrite 1 · document 1. Retenez **industrialisation** : la transformation d’une société par le développement des usines et de leurs productions. Quelle importance accordez-vous aux acheteurs parmi les conditions nécessaires à ce changement ?":
  "See written record 1 · document 1. Remember **industrialisation**: the transformation of a society by the growth of mills and what they make. How much weight do you give to buyers among the conditions this change requires?",
"La trace écrite 1 énumérait les conditions nécessaires, mais elles ne pèsent pas toutes pareil. Ici le charbon, les machines et les bras sont là : il manque la seule qu’on ne peut pas se procurer soi-même.":
  "Written record 1 listed the necessary conditions, but they do not all weigh the same. Here the coal, the machines and the hands are present: what is missing is the only one you cannot provide yourself.",
"Nous pouvons ouvrir les ateliers grâce au charbon et aux machines disponibles.":
  "We can open the workshops, with the coal and the machines at hand.",
"Nous demandons des acheteurs avant d’accumuler des tissus invendus.":
  "We ask for buyers before we pile up cloth no one wants.",
"« Je soutiens immédiatement les nouvelles usines. »":"“I back the new mills at once.”",
"Les industriels peuvent investir, mais les marchands risquent de garder des tissus invendus.":
  "The industrialists can invest, but the merchants may be left with unsold cloth.",
"Nous pouvons commencer à produire avec les travailleurs déjà présents.":
  "We can begin producing with the workers already here.",
"Nous craignons de remplir nos entrepôts sans assez de clients.":
  "We fear filling our warehouses without buyers enough.",
"« Je cherche d’abord davantage de clients. »":"“I look for more buyers first.”",
"Les marchands gagnent du temps pour trouver des débouchés, mais les industriels doivent retarder leurs projets.":
  "The merchants gain time to find outlets, but the industrialists must put off their plans.",
"Nous devrons laisser nos nouvelles machines attendre les commandes.":
  "We shall have to let our new machines stand idle, waiting for orders.",
"Nous aurons le temps de trouver des acheteurs pour ces tissus.":
  "We shall have time to find buyers for this cloth.",
"« Je finance quelques ateliers seulement. »":"“I fund only a few workshops.”",
"Les industriels peuvent démarrer prudemment, mais les ouvriers obtiennent moins de nouveaux emplois.":
  "The industrialists can start cautiously, but the workers get fewer new places.",
"Nous pouvons démarrer quelques ateliers sans engager toutes nos économies.":
  "We can start a few workshops without risking all our savings.",
"Nous aurons moins de places offertes dans ces ateliers réduits.":
  "There will be fewer places on offer in these smaller workshops.",

/* ---------- affaire 07 ---------- */
"Une machine pour quatre étages":"One engine for four floors",
"Robert Henshaw, directeur d’une fabrique de coton":"Robert Henshaw, manager of a cotton mill",
"« Je veux faire tourner toutes les machines avec un seul moteur. »":
  "“I want every machine turning off a single engine.”",
"Une machine à vapeur pourrait entraîner les métiers des quatre étages. Elle ferait travailler tout l’atelier ensemble, mais remplacerait plusieurs travailleurs.":
  "A steam engine could drive the looms on all four floors. It would set the whole mill working as one, but it would replace several workers.",
"Consultez Document 4 (Schopenhauer) · trace écrite 2 §1. Retenez **filature** : une usine où l’on transforme le coton en fil. Comment ce rassemblement des machines et des travailleurs marque-t-il une rupture avec le travail à domicile ?":
  "See Document 4 (Schopenhauer) · written record 2 §1. Remember **spinning mill**: a works where cotton is turned into yarn. How does gathering machines and workers under one roof break with work done at home?",
"Avant, on filait chez soi, à son rythme. La filature rassemble les machines sous un même toit et un même moteur : ce n’est pas seulement plus grand, c’est un autre travail, réglé par la machine.":
  "Before, people spun at home, at their own pace. The mill gathers the machines under one roof and one engine: it is not merely bigger, it is a different kind of work, set by the machine.",
"Nous voulons faire tourner les quatre étages avec le même moteur.":
  "We want all four floors turning off the same engine.",
"Nous attendons une fabrication régulière pour recevoir assez de tissus.":
  "We are waiting for steady output, to receive cloth enough.",
"« J’installe le grand moteur. »":"“I install the great engine.”",
"Les industriels accroissent la fabrication, mais des ouvriers risquent de perdre leur emploi.":
  "The industrialists increase output, but some workers may lose their place.",
"Nous pourrons entraîner les machines des quatre étages ensemble.":
  "We shall be able to drive the machines on all four floors together.",
"Nous craignons que le grand moteur remplace plusieurs de nos postes.":
  "We fear the great engine will take several of our places.",
"« Je garde les machines actuelles. »":"“I keep the machines we have.”",
"Les ouvriers conservent leurs postes, mais les industriels renoncent à une fabrication plus régulière.":
  "The workers keep their places, but the industrialists give up steadier output.",
"Nous manquerons la chance de faire tourner tous les étages régulièrement.":
  "We shall miss the chance to keep every floor turning steadily.",
"Nous conservons nos places auprès des machines actuelles.":
  "We keep our places at the machines we know.",
"« J’équipe un étage avant les autres. »":"“I fit out one floor before the rest.”",
"Les industriels essaient la nouvelle installation, mais les marchands doivent attendre davantage de tissus.":
  "The industrialists try the new arrangement, but the merchants must wait longer for cloth.",
"Nous pourrons éprouver le moteur sur un seul étage.":
  "We can test the engine on a single floor.",
"Nous recevrons moins de tissus tant que les autres étages attendent.":
  "We shall receive less cloth while the other floors wait.",

/* ---------- affaire 08 ---------- */
"La journée de quatorze heures":"The fourteen-hour day",
"James Barlow, directeur d’une fabrique de coton":"James Barlow, manager of a cotton mill",
"« Je veux livrer cette commande sans perdre un client important. »":
  "“I want this order delivered without losing an important buyer.”",
"Un client exige une commande de fil pour mars. Le directeur propose d’allonger la journée de douze à quatorze heures pour tenir le délai.":
  "A buyer wants an order of yarn by March. The manager proposes stretching the day from twelve hours to fourteen to meet it.",
"Consultez Trace écrite 2 §1. Retenez **condition de travail** : l’ensemble des horaires, des tâches et des dangers du métier. Quelle continuité ou rupture voyez-vous entre les rythmes anciens et ceux de l’usine ?":
  "See written record 2 §1. Remember **working conditions**: the hours, the tasks and the dangers of the trade taken together. What continuity or break do you see between the old rhythms and those of the mill?",
"Le paysan travaillait du lever au coucher, selon la saison. L’usine ne dépend ni du jour ni du temps : l’horloge remplace le soleil, et la journée peut s’allonger parce qu’une commande l’exige.":
  "The farmhand worked from sunrise to sunset, as the season allowed. The mill depends on neither daylight nor weather: the clock replaces the sun, and the day can be stretched because an order demands it.",
"Nous voulons tenir la commande de mars sans perdre le client.":
  "We want to meet the March order without losing the buyer.",
"Nous attendons les fils promis à Liverpool avant le printemps.":
  "We are waiting on the yarn promised to Liverpool before spring.",
"« J’accepte les deux heures de plus. »":"“I grant the two extra hours.”",
"Les marchands reçoivent leur commande plus vite, mais les ouvriers perdent du temps de repos.":
  "The merchants get their order sooner, but the workers lose hours of rest.",
"Nous recevrons la commande assez tôt pour satisfaire notre client.":
  "We shall have the order early enough to satisfy our buyer.",
"Nous rentrerons deux heures plus tard après une journée déjà longue.":
  "We shall come home two hours later, after a day already long.",
"« Je maintiens la journée actuelle. »":"“I keep the day as it stands.”",
"Les ouvriers conservent leur repos, mais les marchands risquent de perdre le client.":
  "The workers keep their rest, but the merchants may lose the buyer.",
"Nous risquons de perdre le client qui attend son fil.":
  "We may well lose the buyer waiting on his yarn.",
"Nous gardons nos heures de repos malgré la commande de mars.":
  "We keep our hours of rest, March order or not.",
"« J’engage d’autres travailleurs pour aider. »":"“I take on more workers to help.”",
"Les ouvriers gagnent de nouveaux salaires, mais les industriels paient davantage de personnes.":
  "The workers gain new wages, but the industrialists pay more people.",
"Nous devrons payer davantage d’ouvriers pour livrer à temps.":
  "We shall have to pay more workers to deliver on time.",
"Nous aurons de nouvelles places et des salaires pour cette commande.":
  "There will be new places and wages for this order.",

/* ---------- affaire 09 ---------- */
"Des enfants sous les machines":"Children under the machines",
"Anne Collins, mère d’un jeune travailleur":"Anne Collins, mother of a young worker",
"« J’ai besoin de son salaire, mais je crains chaque jour un accident. »":
  "“I need his wage, but every day I fear an accident.”",
"Des fils cassent sous les machines en marche. Le directeur veut y faire passer des enfants, car arrêter les moteurs ralentirait la fabrication.":
  "Threads break under the running machines. The manager wants children sent in after them, since stopping the engines would slow production.",
"Consultez Document 4 · document 5. Retenez **condition de travail** : l’ensemble des horaires, des tâches et des dangers du métier. Quelle importance le salaire des enfants a-t-il pour les familles face au risque d’accident ?":
  "See Document 4 · document 5. Remember **working conditions**: the hours, the tasks and the dangers of the trade taken together. How much do children’s wages matter to families, set against the risk of an accident?",
"Les documents 4 et 5 décrivaient les dangers de l’atelier. Ils ne tombent pas au hasard : sous la machine on envoie le corps le plus petit, donc l’enfant — dont la famille a besoin du salaire.":
  "Documents 4 and 5 described the dangers of the mill. They do not fall at random: under the machine you send the smallest body, which means the child — whose family needs the wage.",
"Nous voulons renouer les fils sans arrêter les moteurs.":
  "We want the threads tied again without stopping the engines.",
"Nous avons besoin du salaire des enfants, mais craignons les machines en marche.":
  "We need the children’s wages, but we dread the machines in motion.",
"« J’interdis ce travail sous les machines en marche. »":"“I forbid this work under running machines.”",
"Les ouvriers gagnent en sécurité, mais les industriels doivent ralentir les machines.":
  "The workers are safer, but the industrialists must slow the machines.",
"Nous devrons interrompre les moteurs pour récupérer les fils cassés.":
  "We shall have to halt the engines to recover broken threads.",
"Nous éviterons de passer sous les machines pendant leur marche.":
  "We shall not have to crawl under machines while they run.",
"« J’autorise ce travail pour garder les salaires. »":"“I allow the work, to keep the wages.”",
"Les industriels évitent les arrêts, mais les ouvriers exposent leurs enfants au danger.":
  "The industrialists avoid stoppages, but the workers put their children in danger.",
"Nous maintenons les machines en marche pour achever nos tissus.":
  "We keep the machines running to finish our cloth.",
"Nous tremblerons encore pour les enfants qui passent dessous.":
  "We shall go on trembling for the children who go under them.",
"« J’impose l’arrêt des machines avant toute réparation. »":"“I require the machines stopped before any repair.”",
"Les ouvriers travaillent plus sûrement, mais les marchands reçoivent moins vite leurs commandes.":
  "The workers are safer, but the merchants get their orders more slowly.",
"Nous attendrons plus longtemps les tissus à livrer aux clients.":
  "We shall wait longer for the cloth owed to our buyers.",
"Nous pourrons réparer les fils sans risquer d’être happés.":
  "We can mend the threads without risking being caught.",

/* ---------- affaire 10 ---------- */
"Un poste fixe par ouvrier":"One fixed post per worker",
"John Radcliffe, contremaître d’une usine":"John Radcliffe, mill foreman",
"« Je veux que chacun répète le geste qu’il maîtrise le mieux. »":
  "“I want each man repeating the one motion he does best.”",
"Un contremaître veut confier à chacun un geste répété plutôt qu’un métier entier. Il promet davantage de tissus, mais le travail deviendrait monotone.":
  "A foreman wants to give each worker a single repeated motion rather than a whole trade. He promises more cloth, but the work would become dull.",
"Consultez Trace écrite 1 · trace écrite 2 §1. Retenez **division du travail** : le partage de la fabrication en tâches distinctes entre plusieurs travailleurs. Qu’est-ce qui change dans le métier, et que conserve-t-on de l’ancien travail ?":
  "See written record 1 · written record 2 §1. Remember **division of labour**: splitting the making of a thing into separate tasks given to different workers. What changes in the trade, and what is kept from the older work?",
"Le tisserand savait faire la pièce entière. Avec la division du travail, chacun ne fait plus qu’un geste : la production monte, mais un ouvrier qui ne sait qu’un geste se remplace en une heure.":
  "The weaver could make the whole piece. With the division of labour each worker performs one motion only: output rises, but a worker who knows one motion can be replaced in an hour.",
"Nous voulons fabriquer davantage avec un geste précis par poste.":
  "We want to make more, with one exact motion to each post.",
"Nous voulons conserver plusieurs gestes pour connaître notre métier.":
  "We want to keep several motions, so as to know our trade.",
"« Je fixe un geste à chaque ouvrier. »":"“I set one motion to each worker.”",
"Les industriels accélèrent la fabrication, mais les ouvriers perdent une part de leur savoir-faire.":
  "The industrialists speed up production, but the workers lose part of their skill.",
"Nous pourrons faire avancer les tissus plus vite dans chaque atelier.":
  "We shall move the cloth along faster in every workshop.",
"Nous ne saurons bientôt plus accomplir notre métier entier.":
  "Before long we shall no longer know how to do our whole trade.",
"« Je conserve des métiers variés. »":"“I keep the trades varied.”",
"Les ouvriers gardent leurs compétences, mais les industriels produisent moins rapidement.":
  "The workers keep their skills, but the industrialists produce more slowly.",
"Nous produirons moins vite sans attribuer un seul geste à chacun.":
  "We shall produce more slowly without one motion to each worker.",
"Nous conservons la possibilité de pratiquer tout notre savoir-faire.":
  "We keep the chance to practise the whole of our craft.",
"« J’alterne les postes pendant la semaine. »":"“I rotate the posts through the week.”",
"Les ouvriers conservent des gestes variés, mais les industriels renoncent à une partie des gains de vitesse.":
  "The workers keep a variety of motions, but the industrialists give up part of the gain in speed.",
"Nous perdrons une partie du temps gagné par les postes fixes.":
  "We shall lose some of the time that fixed posts had won.",
"Nous changerons de poste et garderons plusieurs gestes en mémoire.":
  "We shall move between posts and keep several motions in hand.",

FIN

my $n = () = ($s =~ /\Q$MARQUE\E/g);
$n == 1 or die "ARRET : marqueur trouve $n fois\n";
$s =~ s/\Q$MARQUE\E/$LOT$MARQUE/;

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
my $e = () = ($LOT =~ /^"/mg);
printf "  ok  lot 3 pose · %d entrees\n", $e;

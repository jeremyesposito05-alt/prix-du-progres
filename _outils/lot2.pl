#!/usr/bin/perl
# LOT 2 — LES AFFAIRES 03, 04 ET 05
#
#   perl _outils/lot2.pl index.html
#
# Pose au passage un marqueur de fin de dictionnaire, pour que les
# lots suivants s inserent sans avoir a deviner la derniere entree.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my $MARQUE = "/* --- fin du dictionnaire --- */\n};";

# Premier lot : on pose le marqueur.
unless(index($s, $MARQUE) >= 0){
  my $av = "\"Sharing the cost may still get us our link.\",\n};";
  my $n = () = ($s =~ /\Q$av\E/g);
  $n == 1 or die "ARRET : fin du dictionnaire introuvable ($n)\n";
  $s =~ s/\Q$av\E/"Sharing the cost may still get us our link.",\n\n$MARQUE/;
}

my $LOT = <<'FIN';
/* ---------- affaire 03 ---------- */
"La vapeur à la place de l’eau":"Steam in place of water",
"William Hartley, mécanicien dans une usine":"William Hartley, mill engineer",
"« Je veux installer mon moteur pour que les ateliers tournent sans dépendre de la rivière. »":
  "“I want my engine installed, so the workshops run without depending on the river.”",
"Un mécanicien propose un moteur à vapeur pour remplacer la roue de la rivière. La machine coûte cher, mais elle fonctionnerait loin du cours d’eau.":
  "An engineer proposes a steam engine to replace the river wheel. The machine costs a great deal, but it would work far from any watercourse.",
"Consultez Document 4 (Schopenhauer) · trace écrite 2 §1. Retenez **mécanisation** : le remplacement d’une partie du travail humain par des machines. Qu’est-ce qui change avec la vapeur, et qu’est-ce qui reste identique dans le travail ?":
  "See Document 4 (Schopenhauer) · written record 2 §1. Remember **mechanisation**: the replacement of part of human labour by machines. What changes with steam, and what stays the same in the work itself?",
"La roue hydraulique obligeait l’usine à rester au bord de la rivière. La vapeur la libère : elle peut désormais s’installer là où sont le charbon et les ouvriers. C’est ce déplacement qui fabrique la ville.":
  "The water wheel forced the mill to stay by the river. Steam frees it: it can now settle where the coal and the workers are. That shift is what builds the town.",
"Nous pourrions installer nos ateliers loin de la rivière.":
  "We could set our workshops well away from the river.",
"Nous voulons savoir quels postes disparaîtront avec ce moteur.":
  "We want to know which jobs will go with this engine.",
"« J’achète le moteur à vapeur. »":"“I buy the steam engine.”",
"Les industriels gagnent en liberté d’installation, mais les ouvriers craignent la suppression de postes.":
  "The industrialists gain freedom in where they build, but the workers fear jobs will be cut.",
"Nous ne dépendrons plus du courant pour faire tourner nos ateliers.":
  "We shall no longer depend on the current to keep our workshops turning.",
"Nous craignons de perdre nos places avec le nouveau moteur.":
  "We fear losing our places to the new engine.",
"« Je conserve la roue à eau. »":"“I keep the water wheel.”",
"Les ouvriers gardent leurs habitudes, mais les industriels restent dépendants du cours d’eau.":
  "The workers keep their ways, but the industrialists stay tied to the river.",
"Nous restons liés au débit de la rivière pour fabriquer.":
  "We remain tied to the flow of the river to make anything.",
"Nous gardons les gestes et les postes que nous connaissons.":
  "We keep the work and the places we know.",
"« Je teste d’abord le moteur dans un atelier. »":"“I try the engine in one workshop first.”",
"Les industriels peuvent essayer la nouveauté, mais les marchands attendent un accroissement des livraisons.":
  "The industrialists can try the new thing, but the merchants are still waiting for larger deliveries.",
"Nous pourrons essayer la vapeur sans transformer toute l’usine.":
  "We can try steam without rebuilding the whole mill.",
"Nous attendrons encore les tissus promis par la nouvelle machine.":
  "We shall go on waiting for the cloth the new machine promised.",

/* ---------- affaire 04 ---------- */
"Des familles devant l’usine":"Families at the mill gate",
"Mary Fletcher, mère arrivée de la campagne":"Mary Fletcher, a mother come from the country",
"« Je cherche un salaire et un toit pour mes enfants avant l’hiver. »":
  "“I am looking for a wage and a roof for my children before winter.”",
"Des familles ont quitté la campagne après la disparition de terres utilisées en commun. Elles demandent du travail, alors que les logements manquent près des usines.":
  "Families have left the countryside after the loss of land once held in common. They are asking for work, and there is little housing near the mills.",
"Consultez Document 1 · document 3 (la population). Retenez **monde ouvrier** : l’ensemble des personnes qui vivent de leur salaire dans les ateliers et les usines. Quelles transformations des campagnes ont causé l’arrivée de ces travailleurs en ville ?":
  "See Document 1 · document 3 (the population). Remember **the working class**: all those who live on a wage in the workshops and the mills. What changes in the countryside brought these workers to the town?",
"Le graphique de population montait sans qu’on voie pourquoi. Le voici : des terres communes fermées, des familles qui n’ont plus de quoi vivre à la campagne, et plus que leur salaire à vendre.":
  "The population graph climbed without showing why. Here is the reason: common land enclosed, families with nothing left to live on in the country, and nothing to sell but their labour.",
"Nous avons besoin de bras supplémentaires dans les ateliers.":
  "We need more hands in the workshops.",
"Nous cherchons du travail, mais aussi un toit pour nos familles.":
  "We are looking for work, but for a roof for our families too.",
"« J’ouvre des postes aux nouveaux arrivants. »":"“I open places to the newcomers.”",
"Les ouvriers trouvent des salaires, mais le Parlement doit affronter une pénurie de logements.":
  "The workers find wages, but Parliament must face a shortage of housing.",
"Nous pourrons enfin gagner de quoi nourrir nos enfants.":
  "At last we shall earn enough to feed our children.",
"Nous devons loger davantage de familles près des usines.":
  "We must house more families near the mills.",
"« Je limite les embauches pour le moment. »":"“I hold back on hiring for now.”",
"Les industriels évitent de nouvelles charges, mais les ouvriers arrivés de la campagne restent sans travail.":
  "The industrialists avoid fresh costs, but the workers come from the country are left without work.",
"Nous évitons d’embaucher plus de monde que nos ateliers ne peuvent accueillir.":
  "We avoid taking on more people than our workshops can hold.",
"Nous resterons devant les grilles sans salaire pour l’hiver.":
  "We shall stand at the gates with no wage for the winter.",
"« J’aide les familles à trouver un logement d’abord. »":"“I help the families find housing first.”",
"Les ouvriers gagnent un abri, mais les industriels attendent plus longtemps de nouveaux bras.":
  "The workers gain a shelter, but the industrialists wait longer for new hands.",
"Nous devrons attendre avant de recevoir ces nouveaux travailleurs.":
  "We shall have to wait before these new workers reach us.",
"Nous aurons un abri avant de chercher une place à l’usine.":
  "We shall have a roof before we look for a place at the mill.",

/* ---------- affaire 05 ---------- */
"De nouvelles commandes lointaines":"New orders from far away",
"Samuel Prescott, exportateur de tissus":"Samuel Prescott, cloth exporter",
"« Je veux remplir ces commandes avant que les clients choisissent d’autres fabricants. »":
  "“I want these orders filled before the buyers go to other makers.”",
"Des clients d’Europe et d’Amérique du Sud demandent davantage de tissus. Doubler les machines permettrait de vendre plus, mais engagerait de lourdes dépenses.":
  "Buyers in Europe and South America are asking for more cloth. Doubling the machines would let us sell more, but it would mean heavy spending.",
"Consultez Document 1 · trace écrite 1. Retenez **production de masse** : la fabrication de grandes quantités de produits semblables. Pourquoi la présence d’acheteurs lointains peut-elle expliquer le développement des usines ?":
  "See Document 1 · written record 1. Remember **mass production**: the making of large quantities of similar goods. Why can the presence of distant buyers explain the growth of the mills?",
"La trace écrite 1 listait les conditions de l’industrialisation : le charbon, les machines, les bras. Il en manque une qu’on oublie souvent — des acheteurs. Sans eux, doubler les machines ne sert à rien.":
  "Written record 1 listed the conditions of industrialisation: coal, machines, hands. One is missing that is often forgotten — buyers. Without them, doubling the machines serves no purpose.",
"Nous voulons davantage de machines pour livrer ces clients étrangers.":
  "We want more machines, to supply these foreign buyers.",
"Nous craignons que les nouvelles commandes allongent nos journées.":
  "We fear the new orders will lengthen our days.",
"« J’achète de nouvelles machines. »":"“I buy new machines.”",
"Les marchands gagnent davantage de tissus à vendre, mais les ouvriers subissent une cadence plus forte.":
  "The merchants gain more cloth to sell, but the workers face a harder pace.",
"Nous disposerons de plus de tissus à envoyer à nos clients.":
  "We shall have more cloth to send to our buyers.",
"Nous redoutons une cadence plus dure avec ces machines supplémentaires.":
  "We dread a harder pace with these extra machines.",
"« Je garde la production actuelle. »":"“I keep output as it is.”",
"Les ouvriers évitent une hausse de cadence, mais les marchands perdent une partie des commandes.":
  "The workers avoid a rise in pace, but the merchants lose part of the orders.",
"Nous laisserons partir une partie des clients vers d’autres vendeurs.":
  "We shall let some of the buyers go to other sellers.",
"Nous gardons nos journées actuelles malgré les commandes lointaines.":
  "We keep our days as they are, distant orders or not.",
"« Je prends seulement une partie des commandes. »":"“I take only part of the orders.”",
"Les industriels limitent leurs dépenses, mais les marchands doivent renoncer à des ventes.":
  "The industrialists hold their spending down, but the merchants must give up sales.",
"Nous pouvons accepter quelques commandes sans acheter trop de machines.":
  "We can take a few orders without buying too many machines.",
"Nous renoncerons à vendre les tissus que ces clients réclament.":
  "We shall give up selling the cloth these buyers are asking for.",

FIN

my $n = () = ($s =~ /\Q$MARQUE\E/g);
$n == 1 or die "ARRET : marqueur trouve $n fois\n";
$s =~ s/\Q$MARQUE\E/$LOT$MARQUE/;

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
my $e = () = ($LOT =~ /^"/mg);
printf "  ok  lot 2 pose · %d entrees\n", $e;

#!/usr/bin/perl
# LOT 4 — LES AFFAIRES 11 A 15
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $MARQUE = "/* --- fin du dictionnaire --- */";

my $LOT = <<'FIN';
/* ---------- affaire 11 ---------- */
"Un incendie et des familles sans salaire":"A fire, and families with no wage",
"Elizabeth Turner, ouvrière sans emploi":"Elizabeth Turner, mill hand out of work",
"« Je veux nourrir mes enfants pendant que notre usine reste fermée. »":
  "“I want to feed my children while our mill stands shut.”",
"Un incendie a détruit plusieurs étages d’une usine de coton. Des familles se retrouvent sans revenu pendant sa reconstruction.":
  "A fire has destroyed several floors of a cotton mill. Families are left without income while it is rebuilt.",
"Consultez Trace écrite 2 §1. Retenez **condition de travail** : l’ensemble des horaires, des tâches et des dangers du métier. Quelles conséquences la concentration des travailleurs dans une seule usine entraîne-t-elle lors d’un incendie ?":
  "See written record 2 §1. Remember **working conditions**: the hours, the tasks and the dangers of the trade taken together. What follows from gathering every worker into one mill, when that mill burns?",
"Rassembler tout le travail sous un toit, c’est aussi rassembler tout le risque. Quand l’atelier à domicile brûlait, une famille perdait son revenu ; quand l’usine brûle, c’est un quartier entier.":
  "Gathering all the work under one roof gathers all the risk as well. When a workshop at home burned, one family lost its income; when the mill burns, a whole quarter does.",
"Nous voulons reconstruire les étages pour reprendre la fabrication.":
  "We want the floors rebuilt so production can start again.",
"Nous n’avons plus de salaire depuis l’incendie de notre atelier.":
  "We have had no wage since our workshop burned.",
"« Je verse une aide aux familles touchées. »":"“I grant relief to the stricken families.”",
"Les ouvriers peuvent acheter du pain, mais le Parlement doit financer les secours.":
  "The workers can buy bread, but Parliament must pay for the relief.",
"Nous pourrons acheter du pain pendant la fermeture de l’usine.":
  "We shall be able to buy bread while the mill is shut.",
"Nous devons trouver l’argent des secours après cet incendie.":
  "We must find the money for relief after this fire.",
"« Je privilégie la reconstruction de l’usine. »":"“I put the rebuilding of the mill first.”",
"Les industriels retrouvent plus vite leur atelier, mais les ouvriers attendent une aide immédiate.":
  "The industrialists get their works back sooner, but the workers are left waiting for relief.",
"Nous pourrons remettre nos machines en service plus tôt.":
  "We shall have our machines running again sooner.",
"Nous attendrons la reconstruction sans argent pour nos familles.":
  "We shall wait out the rebuilding with no money for our families.",
"« Je propose du travail dans d’autres ateliers. »":"“I offer work in other workshops.”",
"Les ouvriers retrouvent certains salaires, mais les industriels voisins doivent réorganiser leur travail.":
  "The workers find some wages again, but the neighbouring industrialists must rearrange their work.",
"Nous devrons faire une place imprévue aux ouvriers de l’usine brûlée.":
  "We shall have to make unplanned room for the burnt mill’s workers.",
"Nous retrouverons un salaire dans les ateliers encore ouverts.":
  "We shall find a wage again in the workshops still open.",

/* ---------- affaire 12 ---------- */
"Une loi pour les plus jeunes":"A law for the youngest",
"Henry Wilkins, inspecteur des fabriques":"Henry Wilkins, factory inspector",
"« Je veux pouvoir faire respecter cette loi sans abandonner les familles. »":
  "“I want to enforce this law without abandoning the families.”",
"Le Parlement limite désormais le travail des très jeunes enfants dans certaines usines. Les contrôles restent rares et les familles redoutent de perdre des salaires.":
  "Parliament now limits the work of very young children in certain mills. Inspections are few, and families dread losing the wages.",
"Consultez Trace écrite 2 §3. Retenez **inégalité** : une différence de droits, de revenus ou de possibilités entre des groupes. Quelle rupture cette loi introduit-elle, et quelles difficultés anciennes subsistent ?":
  "See written record 2 §3. Remember **inequality**: a difference in rights, income or opportunity between groups. What break does this law introduce, and which old hardships remain?",
"La trace écrite 2 §3 montrait l’État qui commence à intervenir. Une loi n’est pourtant qu’un texte tant que personne ne vient vérifier : c’est le contrôle, pas le texte, qui change la vie des enfants.":
  "Written record 2 §3 showed the State beginning to step in. A law is only a text until someone comes to check: it is the inspection, not the text, that changes a child’s life.",
"Nous avons besoin des salaires des enfants pour vivre.":
  "We need the children’s wages to live on.",
"Nous voulons faire respecter la nouvelle limite d’âge dans les usines.":
  "We want the new age limit enforced in the mills.",
"« Je fais appliquer la loi avec des contrôles. »":"“I enforce the law, with inspections.”",
"Le Parlement renforce les protections, mais les ouvriers pauvres perdent certains revenus.":
  "Parliament strengthens the protections, but the poorest workers lose part of their income.",
"Nous perdrons le salaire de certains enfants sans autre secours.":
  "We shall lose some children’s wages with nothing to replace them.",
"Nous pourrons vérifier si les plus jeunes sont retirés des ateliers.":
  "We shall be able to check that the youngest are taken off the floor.",
"« Je demande davantage d’inspecteurs avant d’agir. »":"“I ask for more inspectors before acting.”",
"Les ouvriers conservent provisoirement leurs salaires, mais le Parlement retarde les protections promises.":
  "The workers keep their wages for now, but Parliament delays the protections it promised.",
"Nous gardons pour un temps les salaires des plus jeunes.":
  "For a time we keep the youngest children’s wages.",
"Nous laissons la loi sans contrôle pendant que nous cherchons des inspecteurs.":
  "We leave the law unchecked while we look for inspectors.",
"« Je prévois une aide aux familles concernées. »":"“I arrange relief for the families affected.”",
"Les ouvriers reçoivent un soutien, mais les industriels craignent de nouveaux prélèvements.":
  "The workers receive support, but the industrialists fear fresh levies.",
"Nous craignons de nouveaux frais pour financer cette aide familiale.":
  "We fear new charges to pay for this family relief.",
"Nous recevrons une aide pour remplacer les salaires perdus.":
  "We shall receive relief in place of the wages lost.",

/* ---------- affaire 13 ---------- */
"Le pain devient trop cher":"Bread grows too dear",
"Sarah Greenwood, ouvrière dans une fabrique de coton":"Sarah Greenwood, cotton mill hand",
"« Je veux un salaire qui permette de nourrir ma famille. »":
  "“I want a wage that feeds my family.”",
"Des ouvrières cessent le travail pour protester contre le prix du pain. Leurs salaires ne suffisent plus à nourrir correctement leurs familles.":
  "Women have stopped work in protest at the price of bread. Their wages no longer feed their families properly.",
"Consultez Trace écrite 2 §3. Retenez **monde ouvrier** : l’ensemble des personnes qui vivent de leur salaire dans les ateliers et les usines. Pourquoi la hausse du pain entraîne-t-elle une protestation de travailleurs payés en argent ?":
  "See written record 2 §3. Remember **the working class**: all those who live on a wage in the workshops and the mills. Why does a rise in the price of bread bring out workers who are paid in money?",
"Un salaire ne se juge pas en chiffres mais en ce qu’il permet d’acheter. Quand le pain monte et que le salaire ne bouge pas, l’ouvrier s’appauvrit sans qu’on lui ait rien retiré.":
  "A wage is judged not by its figure but by what it buys. When bread rises and the wage does not, the worker grows poorer though nothing has been taken from him.",
"Nous voulons rouvrir les ateliers sans augmenter fortement les salaires.":
  "We want the workshops open again without a steep rise in wages.",
"Nous craignons de vendre moins de grain si son prix baisse.":
  "We fear selling less grain if its price comes down.",
"« Je soutiens une hausse des salaires. »":"“I support a rise in wages.”",
"Les ouvriers peuvent mieux acheter leur pain, mais les industriels paient davantage.":
  "The workers can better afford their bread, but the industrialists pay more.",
"Nous devrons relever les salaires alors que les ateliers sont arrêtés.":
  "We must raise wages while the workshops stand idle.",
"Nous pourrons acheter davantage de pain avec notre paie.":
  "Our pay will buy more bread.",
"« Je négocie une baisse du prix du pain. »":"“I negotiate a fall in the price of bread.”",
"Les ouvriers pourraient dépenser moins pour manger, mais les marchands de grains perdraient des recettes.":
  "The workers might spend less on food, but the grain merchants would lose takings.",
"Nous vendrons notre grain moins cher malgré les frais de transport.":
  "We shall sell our grain cheaper, carriage costs notwithstanding.",
"Nous paierons moins pour le pain de nos enfants.":
  "We shall pay less for our children’s bread.",
"« Je demande une reprise du travail sans hausse. »":"“I call for work to resume without a rise.”",
"Les industriels retrouvent les machines en marche, mais les ouvriers gardent leurs difficultés.":
  "The industrialists get the machines turning again, but the workers keep their hardship.",
"Nous pourrons remettre les machines en marche sans hausse de paie.":
  "We can set the machines going again with no rise in pay.",
"Nous travaillerons encore sans assez d’argent pour le pain.":
  "We shall work on without money enough for bread.",

/* ---------- affaire 14 ---------- */
"Des métiers à tisser brisés":"Broken looms",
"Thomas Atkinson, tisserand à la main":"Thomas Atkinson, handloom weaver",
"« Je veux encore vivre de mon métier sans voir mes enfants manquer de pain. »":
  "“I want to live by my trade still, without my children going short of bread.”",
"Des tisserands qui travaillent à la main attaquent des machines qui produisent à moindre coût. Les fabricants demandent une punition et les familles ruinées réclament du secours.":
  "Handloom weavers are attacking machines that produce at lower cost. The manufacturers call for punishment; the ruined families call for relief.",
"Consultez Trace écrite 1 · trace écrite 2 §3. Retenez **mécanisation** : le remplacement d’une partie du travail humain par des machines. Quelle importance donnez-vous aux métiers détruits par ce changement technique ?":
  "See written record 1 · written record 2 §3. Remember **mechanisation**: the replacement of part of human labour by machines. How much weight do you give to the trades this technical change destroys?",
"On dit la mécanisation inévitable, mais elle a des perdants précis, et ils le savent. Ces tisserands ne cassent pas des machines par ignorance : ils cassent ce qui leur a pris leur métier.":
  "Mechanisation is called inevitable, but it has particular losers, and they know who they are. These weavers are not breaking machines out of ignorance: they are breaking the thing that took their trade.",
"Nous voulons protéger nos métiers mécaniques contre les destructions.":
  "We want our power looms protected from destruction.",
"Nous voulons une aide depuis que les machines nous ont privés de travail.":
  "We want relief, now that the machines have put us out of work.",
"« Je poursuis les auteurs des destructions. »":"“I prosecute those who did the breaking.”",
"Les industriels protègent leurs machines, mais les ouvriers ruinés perdent tout espoir de clémence.":
  "The industrialists protect their machines, but the ruined workers lose any hope of leniency.",
"Nous pourrons garder nos métiers mécaniques sans craindre de nouvelles attaques.":
  "We shall keep our power looms without fearing fresh attacks.",
"Nous risquons la prison alors que nos familles manquent déjà de pain.":
  "We risk prison while our families already go short of bread.",
"« Je propose une aide aux tisserands sans travail. »":"“I offer relief to the weavers out of work.”",
"Les ouvriers en difficulté reçoivent du secours, mais le Parlement doit payer cette aide.":
  "The workers in difficulty receive relief, but Parliament must pay for it.",
"Nous recevrons du secours pendant que nous cherchons un autre métier.":
  "We shall have relief while we look for another trade.",
"Nous devrons payer une aide aux tisserands ruinés.":
  "We shall have to pay relief to the ruined weavers.",
"« J’impose une négociation avant toute sanction. »":"“I require talks before any punishment.”",
"Les ouvriers obtiennent la parole, mais les industriels craignent de nouvelles attaques.":
  "The workers are given a hearing, but the industrialists fear further attacks.",
"Nous craignons d’autres bris de machines pendant ces discussions.":
  "We fear more machines broken while these talks go on.",
"Nous pourrons expliquer pourquoi les machines nous ont ruinés.":
  "We shall be able to explain how the machines ruined us.",

/* ---------- affaire 15 ---------- */
"Des maisons construites dos à dos":"Houses built back to back",
"Benjamin Cooper, constructeur de logements":"Benjamin Cooper, housebuilder",
"« Je peux loger rapidement des familles si vous acceptez mon projet. »":
  "“I can house families quickly, if you accept my plan.”",
"Un constructeur propose des maisons serrées et peu coûteuses pour loger des ouvriers. Sans cour ni évacuation des eaux, ces logements seraient malsains.":
  "A builder proposes cheap, tightly packed houses for workers. With no yard and no drainage, they would be unhealthy.",
"Consultez Document 5 (Engels) · trace écrite 2 §2. Retenez **logement insalubre** : un logement dangereux pour la santé à cause de l’humidité, du manque d’air ou de la saleté. Quelle importance auront ces choix de construction pour la vie future des habitants ?":
  "See Document 5 (Engels) · written record 2 §2. Remember **unfit housing**: a dwelling dangerous to health through damp, want of air or filth. How much will these building choices matter to the lives of those who live there?",
"Engels décrivait des maisons serrées, sans cour ni évacuation. Elles ne sont pas mal bâties par hasard : elles sont bâties vite et au plus bas prix, pour loger des ouvriers tout près de l’usine.":
  "Engels described houses packed close, with no yard and no drains. They are not badly built by accident: they are built fast and as cheaply as possible, to house workers near the mill.",
"Nous avons besoin de maisons, mais pas de pièces humides et sans cour.":
  "We need houses, but not damp rooms with no yard.",
"Nous refusons de laisser les eaux sales s’accumuler entre ces maisons.":
  "We will not let foul water stand between these houses.",
"« J’autorise ces maisons sans modification. »":"“I approve these houses unchanged.”",
"Les industriels trouvent des travailleurs logés près d’eux, mais les ouvriers vivent dans des conditions malsaines.":
  "The industrialists get their workers housed close by, but those workers live in unhealthy conditions.",
"Nous pourrons loger rapidement les bras nécessaires à nos usines.":
  "We can quickly house the hands our mills require.",
"Nous vivrons serrés dans ces maisons sans évacuation des eaux.":
  "We shall live packed into these houses with no drainage.",
"« J’exige des cours et des évacuations. »":"“I require yards and drains.”",
"Les ouvriers gagnent des logements plus sains, mais les industriels attendent leur construction.":
  "The workers gain healthier housing, but the industrialists wait for it to be built.",
"Nous attendrons plus longtemps les logements de nos travailleurs.":
  "We shall wait longer for our workers to be housed.",
"Nous aurons des cours et moins d’eaux sales près de nos portes.":
  "We shall have yards, and less foul water at our doors.",
"« Je fais bâtir moins de maisons mieux équipées. »":"“I have fewer houses built, better fitted.”",
"Le Parlement améliore la salubrité, mais des ouvriers restent sans logement.":
  "Parliament improves public health, but some workers are left without a home.",
"Nous serons encore nombreux sans toit puisque moins de maisons seront construites.":
  "Many of us will still be without a roof, since fewer houses will be built.",
"Nous pourrons éviter de nouvelles ruelles malsaines autour des maisons.":
  "We can avoid more unhealthy alleys springing up around the houses.",

FIN

my $n = () = ($s =~ /\Q$MARQUE\E/g);
$n == 1 or die "ARRET : marqueur trouve $n fois\n";
$s =~ s/\Q$MARQUE\E/$LOT$MARQUE/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
my $e = () = ($LOT =~ /^"/mg);
printf "  ok  lot 4 pose · %d entrees\n", $e;

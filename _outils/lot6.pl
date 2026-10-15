#!/usr/bin/perl
# LOT 6 — LES AFFAIRES 21 A 25
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $MARQUE = "/* --- fin du dictionnaire --- */";

my $LOT = <<'FIN';
/* ---------- affaire 21 ---------- */
"Une salle pour soigner les pauvres":"A room to treat the poor",
"Dr. Edward Phillips, médecin des quartiers ouvriers":"Dr Edward Phillips, physician to the workers’ quarters",
"« Je veux soigner les malades même lorsqu’ils ne peuvent pas me payer. »":
  "“I want to treat the sick even when they cannot pay me.”",
"Un médecin propose une petite salle de soins pour les habitants sans argent. Certains conseillers préfèrent laisser cette aide aux dons privés.":
  "A physician proposes a small treatment room for those without money. Some councillors would rather leave such help to private charity.",
"Consultez Trace écrite 2 §3. Retenez **condition de vie** : l’ensemble des circonstances matérielles dans lesquelles une personne vit. Comment un médecin pauvre et un conseiller préoccupé par les dépenses voient-ils différemment ce projet ?":
  "See written record 2 §3. Remember **living conditions**: the whole of the material circumstances in which a person lives. How differently do a poor physician and a councillor worried about spending see this scheme?",
"Avant l’État, c’est la charité qui soignait les pauvres — quand elle le voulait, et où elle le voulait. La question du §3 est exactement celle-ci : qui doit s’en charger, et avec quel argent ?":
  "Before the State, it was charity that treated the poor — when it chose to, and where it chose to. The question in §3 is exactly this: who should take it on, and with whose money?",
"Nous ne voulons pas de prélèvements supplémentaires pour une salle de soins.":
  "We want no further levies for a treatment room.",
"Nous hésitons à payer des soins que les dons privés finançaient.":
  "We hesitate to pay for care that private giving once funded.",
"« Je finance une salle de soins publique. »":"“I fund a public treatment room.”",
"Les ouvriers accèdent plus facilement aux soins, mais le Parlement doit assumer une dépense nouvelle.":
  "The workers reach care more easily, but Parliament must carry a new expense.",
"Nous pourrons consulter un médecin même sans avoir d’argent.":
  "We shall be able to see a physician even with no money.",
"Nous devrons inscrire une nouvelle dépense pour cette salle de soins.":
  "We must enter a new expense for this treatment room.",
"« Je laisse les dons privés financer les soins. »":"“I leave private giving to fund the care.”",
"Le Parlement limite ses dépenses, mais les ouvriers dépendent de la générosité des donateurs.":
  "Parliament keeps its spending down, but the workers depend on the generosity of donors.",
"Nous ne savons pas si les dons suffiront pour nous soigner.":
  "We do not know whether the gifts will be enough to treat us.",
"Nous laissons aux donateurs la charge de soigner les malades.":
  "We leave the care of the sick to the donors.",
"« Je prête une salle aux médecins bénévoles. »":"“I lend a room to volunteer physicians.”",
"Les ouvriers obtiennent un lieu de consultation, mais les industriels doivent rechercher les fonds nécessaires.":
  "The workers get somewhere to be seen, but the industrialists must find the funds for it.",
"Nous devrons solliciter des dons pour faire vivre cette salle.":
  "We shall have to beg gifts to keep this room going.",
"Nous aurons au moins une salle où consulter les médecins bénévoles.":
  "At least we shall have a room where the volunteer physicians see us.",

/* ---------- affaire 22 ---------- */
"Une visite de la reine":"A royal visit",
"Richard Ellis, organisateur des cérémonies municipales":"Richard Ellis, organiser of the town’s ceremonies",
"« Je veux offrir à la reine une image digne de notre ville. »":
  "“I want to give the Queen a picture worthy of our town.”",
"Une visite royale doit traverser Manchester. Des conseillers veulent embellir uniquement les rues du cortège plutôt que montrer les quartiers ouvriers.":
  "A royal visit is to pass through Manchester. Some councillors want only the procession route made handsome, rather than show the workers’ quarters.",
"Consultez Document 2 (Wyld, peint après la visite royale). Retenez **urbanisation** : l’augmentation de la population des villes et de leur espace bâti. Quel point de vue chaque parcours donnera-t-il à la reine sur Manchester ?":
  "See Document 2 (Wyld, painted after the royal visit). Remember **urbanisation**: the growth of towns in people and in built-up ground. What view of Manchester will each route give the Queen?",
"Le tableau de Wyld a été peint après la visite royale, et il montre une ville propre. Ce n’est pas un mensonge, c’est un point de vue choisi : une image de ville dit d’abord ce qu’on a décidé de montrer.":
  "Wyld’s painting was made after the royal visit, and it shows a clean town. That is not a lie, it is a chosen point of view: a picture of a town says first of all what someone decided to show.",
"Nous voulons montrer aux visiteurs une ville digne de leurs affaires.":
  "We want to show visitors a town worthy of their business.",
"Nous voudrions que la reine voie aussi les ruelles où nous habitons.":
  "We should like the Queen to see the alleys we live in too.",
"« Je fais repeindre les façades du parcours. »":"“I have the route’s frontages repainted.”",
"Les marchands gagnent une belle vitrine pour la ville, mais les ouvriers ne voient pas leurs rues améliorées.":
  "The merchants gain a fine shopfront for the town, but the workers see no improvement in their own streets.",
"Nous pourrons accueillir la reine devant des façades bien entretenues.":
  "We shall receive the Queen before well-kept frontages.",
"Nous garderons nos ruelles sales derrière les façades repeintes.":
  "We shall keep our dirty alleys behind the fresh paint.",
"« Je choisis un parcours dans les quartiers ouvriers. »":"“I choose a route through the workers’ quarters.”",
"Les ouvriers peuvent montrer leurs difficultés, mais les industriels craignent une mauvaise image.":
  "The workers can show their hardship, but the industrialists fear a poor impression.",
"Nous craignons que cette visite fasse oublier les succès de nos usines.":
  "We fear this visit will eclipse what our mills have achieved.",
"Nous pourrons montrer à la reine nos logements et nos difficultés.":
  "We shall be able to show the Queen our housing and our hardship.",
"« Je consacre l’argent au nettoyage des ruelles. »":"“I spend the money cleaning the alleys.”",
"Les ouvriers vivent dans des rues plus propres, mais les marchands perdent les décorations prévues.":
  "The workers live in cleaner streets, but the merchants lose the decorations planned.",
"Nous perdons les décorations qui devaient attirer l’attention sur nos commerces.":
  "We lose the decorations that were to draw attention to our trade.",
"Nous marcherons dans des ruelles nettoyées après le passage royal.":
  "We shall walk alleys that stay clean after the royal party has gone.",

/* ---------- affaire 23 ---------- */
"Une visiteuse dans les ateliers":"A visitor in the workshops",
"Clara Vogel, voyageuse allemande intéressée par les usines":"Clara Vogel, German traveller with an interest in mills",
"« Je veux voir de mes yeux ce que les machines ont changé. »":
  "“I want to see with my own eyes what the machines have changed.”",
"Une voyageuse allemande veut découvrir les machines de Manchester. Les fabricants souhaitent lui présenter une usine moderne plutôt qu’un atelier aux conditions difficiles.":
  "A German traveller wishes to see Manchester’s machines. The manufacturers would rather show her a modern mill than a workshop in hard conditions.",
"Consultez Document 4 et son bonus. Retenez **mécanisation** : le remplacement d’une partie du travail humain par des machines. Comment la perspective de la visiteuse dépendra-t-elle des ateliers qu’elle verra ?":
  "See Document 4 and its supplement. Remember **mechanisation**: the replacement of part of human labour by machines. How will the visitor’s view depend on which workshops she is shown?",
"Le document 4 est le récit d’une voyageuse, donc de ce qu’on a bien voulu lui faire voir. Savoir quelle usine on lui montre, c’est savoir ce que vaut son témoignage.":
  "Document 4 is a traveller’s account, and so an account of what she was willingly shown. Knowing which mill she was taken to is knowing what her testimony is worth.",
"Nous préférons lui montrer nos machines les plus impressionnantes.":
  "We would rather show her our most impressive machines.",
"Nous voulons que la voyageuse reparte en parlant des tissus de Manchester.":
  "We want the traveller to leave talking about Manchester cloth.",
"« Je lui montre la plus grande usine. »":"“I show her the largest mill.”",
"Les industriels exposent leurs réussites, mais les ouvriers des petits ateliers restent invisibles.":
  "The industrialists display their success, but the workers in the small workshops stay invisible.",
"Nous pourrons lui présenter les machines qui font notre fierté.":
  "We can show her the machines we are proud of.",
"Nous resterons invisibles dans les petits ateliers moins modernes.":
  "We shall stay out of sight in the smaller, older workshops.",
"« Je lui laisse choisir les ateliers. »":"“I let her choose the workshops.”",
"Les ouvriers peuvent montrer leur quotidien, mais les industriels perdent le contrôle de la visite.":
  "The workers can show their daily life, but the industrialists lose control of the visit.",
"Nous ne saurons pas quels ateliers elle visitera ni ce qu’elle écrira.":
  "We shall not know which workshops she visits, nor what she writes.",
"Nous pourrons lui raconter nos journées dans les ateliers ordinaires.":
  "We shall be able to tell her about our days in the ordinary workshops.",
"« J’organise deux visites très différentes. »":"“I arrange two very different visits.”",
"Les industriels présentent leurs machines, mais les marchands craignent des récits sur les difficultés sociales.":
  "The industrialists present their machines, but the merchants fear accounts of social hardship.",
"Nous pourrons montrer nos machines au cours des deux visites.":
  "We can show our machines on both visits.",
"Nous craignons que les récits de souffrance fassent fuir des clients.":
  "We fear accounts of suffering will drive buyers away.",

/* ---------- affaire 24 ---------- */
"Un enquêteur dans Ancoats":"An investigator in Ancoats",
"Friedrich Engels, observateur des quartiers ouvriers":"Friedrich Engels, observer of the workers’ quarters",
"« Je veux décrire ce que vivent les familles derrière les murs des fabriques. »":
  "“I want to describe how families live behind the walls of the mills.”",
"Un Allemand installé à Manchester prend des notes sur la pauvreté d’Ancoats. Certains propriétaires craignent que ses descriptions nuisent à la réputation des usines.":
  "A German living in Manchester is taking notes on the poverty of Ancoats. Some owners fear his descriptions will damage the mills’ reputation.",
"Consultez Document 5 et son bonus. Retenez **monde ouvrier** : l’ensemble des personnes qui vivent de leur salaire dans les ateliers et les usines. Pourquoi le regard de cet observateur peut-il différer de celui des propriétaires ?":
  "See Document 5 and its supplement. Remember **the working class**: all those who live on a wage in the workshops and the mills. Why might this observer see things differently from the owners?",
"L’Allemand qui prend des notes dans Ancoats, c’est Engels : le document 5 vient de là. Vous décidez maintenant s’il voit les caves, c’est-à-dire ce que l’histoire retiendra de Manchester.":
  "The German taking notes in Ancoats is Engels: Document 5 comes from this. You are deciding now whether he sees the cellars — that is, what history will remember of Manchester.",
"Nous craignons que les notes d’Engels discréditent nos fabriques.":
  "We fear Engels’s notes will discredit our mills.",
"Nous voulons qu’Engels voie aussi les pièces où vivent nos familles.":
  "We want Engels to see the rooms our families live in as well.",
"« Je lui ouvre les quartiers et les ateliers. »":"“I open the quarters and the workshops to him.”",
"Les ouvriers peuvent faire entendre leurs difficultés, mais les industriels redoutent les critiques.":
  "The workers can make their hardship heard, but the industrialists dread the criticism.",
"Nous craignons que ses descriptions détournent les acheteurs de nos fabriques.":
  "We fear his descriptions will turn buyers away from our mills.",
"Nous pourrons lui raconter ce que nous subissons dans les ateliers.":
  "We shall be able to tell him what we endure in the workshops.",
"« Je limite son entrée dans les usines. »":"“I restrict his entry to the mills.”",
"Les industriels protègent leur image, mais les ouvriers perdent une occasion d’être entendus.":
  "The industrialists protect their name, but the workers lose a chance to be heard.",
"Nous limiterons les critiques sur nos machines et nos ateliers.":
  "We shall limit the criticism of our machines and our workshops.",
"Nous perdrons une occasion de raconter nos journées de travail.":
  "We shall lose a chance to speak of our working days.",
"« Je lui propose aussi des entretiens avec les patrons. »":"“I offer him interviews with the owners too.”",
"Les industriels exposent leur point de vue, mais les ouvriers craignent que leur parole passe au second plan.":
  "The industrialists set out their view, but the workers fear their own words will come second.",
"Nous pourrons expliquer à Engels pourquoi nous avons bâti ces usines.":
  "We can explain to Engels why we built these mills.",
"Nous craignons que nos témoignages passent derrière ceux des patrons.":
  "We fear our testimony will be placed behind the owners’.",

/* ---------- affaire 25 ---------- */
"Une peinture pour représenter Manchester":"A painting to represent Manchester",
"William Wyld, peintre de vues urbaines":"William Wyld, painter of town views",
"« Je veux montrer la beauté du paysage sans cacher les cheminées. »":
  "“I want to show the beauty of the landscape without hiding the chimneys.”",
"Un peintre propose de représenter Manchester depuis une colline verdoyante. Les cheminées seraient visibles au loin, mais les logements pauvres disparaîtraient de la vue.":
  "A painter proposes to show Manchester from a green hill. The chimneys would be visible in the distance, but the poor housing would drop out of the picture.",
"Consultez Document 2 et son bonus. Retenez **industrialisation** : la transformation d’une société par le développement des usines et de leurs productions. Quelle perspective chaque peinture donne-t-elle des transformations de Manchester ?":
  "See Document 2 and its supplement. Remember **industrialisation**: the transformation of a society by the growth of mills and what they make. What view of Manchester’s changes does each painting give?",
"Peindre Manchester depuis une colline verte, c’est montrer les cheminées au loin et cacher ce qui se passe dessous. Le document 2 est exactement cela : une image vraie et incomplète à la fois.":
  "To paint Manchester from a green hill is to show the chimneys at a distance and hide what goes on beneath them. Document 2 is exactly that: an image both true and incomplete.",
"Nous souhaitons une vue agréable de Manchester pour nos acheteurs.":
  "We should like a pleasing view of Manchester for our buyers.",
"Nous voulons que le peintre montre aussi nos logements serrés.":
  "We want the painter to show our crowded housing as well.",
"« Je commande cette vue depuis la colline. »":"“I commission the view from the hill.”",
"Les marchands obtiennent une image flatteuse, mais les ouvriers voient leurs quartiers laissés hors du tableau.":
  "The merchants get a flattering image, but the workers see their quarters left out of the picture.",
"Nous aurons une belle vue à montrer aux clients de passage.":
  "We shall have a handsome view to show buyers passing through.",
"Nous ne verrons pas nos rues pauvres dans ce paysage verdoyant.":
  "Our poor streets will not appear in that green landscape.",
"« Je demande une vue des rues ouvrières. »":"“I ask for a view of the workers’ streets.”",
"Les ouvriers rendent leurs conditions visibles, mais les industriels craignent une image sombre.":
  "The workers make their conditions visible, but the industrialists fear a dark picture.",
"Nous craignons que ce tableau détourne l’attention de nos inventions.":
  "We fear this painting will draw attention away from what we have built.",
"Nous pourrons montrer nos rues et nos maisons telles qu’elles sont.":
  "We shall be able to show our streets and our houses as they are.",
"« Je commande deux vues de la ville. »":"“I commission two views of the town.”",
"Les ouvriers gagnent une représentation de leurs quartiers, mais le Parlement doit financer deux tableaux.":
  "The workers gain a picture of their own quarters, but Parliament must pay for two paintings.",
"Nous aurons enfin un tableau qui représente nos quartiers.":
  "At last there will be a painting that shows our quarters.",
"Nous devrons payer deux peintures au lieu d’une seule.":
  "We shall have to pay for two paintings instead of one.",

FIN

my $n = () = ($s =~ /\Q$MARQUE\E/g);
$n == 1 or die "ARRET : marqueur trouve $n fois\n";
$s =~ s/\Q$MARQUE\E/$LOT$MARQUE/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
my $e = () = ($LOT =~ /^"/mg);
printf "  ok  lot 6 pose · %d entrees\n", $e;

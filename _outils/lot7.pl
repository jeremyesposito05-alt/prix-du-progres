#!/usr/bin/perl
# LOT 7 — LES AFFAIRES 26 A 30, ET LE NIVEAU I EST COMPLET
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $MARQUE = "/* --- fin du dictionnaire --- */";

my $LOT = <<'FIN';
/* ---------- affaire 26 ---------- */
"Un pasteur réclame une enquête":"A clergyman calls for an inquiry",
"Reverend John Foster, pasteur d’un quartier ouvrier":"Reverend John Foster, minister of a workers’ quarter",
"« Je veux que la ville écoute les familles qui vivent dans ces caves. »":
  "“I want the town to listen to the families living in those cellars.”",
"Un pasteur décrit publiquement les caves humides et les maladies. Les fabricants redoutent ses accusations, tandis que des habitants demandent une enquête.":
  "A clergyman is describing the damp cellars and the sickness in public. The manufacturers dread his charges, while residents are calling for an inquiry.",
"Consultez Trace écrite 2 §3. Retenez **condition de vie** : l’ensemble des circonstances matérielles dans lesquelles une personne vit. Quelle importance ces témoignages peuvent-ils avoir dans la naissance de mesures publiques ?":
  "See written record 2 §3. Remember **living conditions**: the whole of the material circumstances in which a person lives. How much can such testimony matter in bringing public measures into being?",
"Les lois du §3 ne sont pas tombées du ciel : elles viennent d’enquêtes, de rapports, de gens qui ont parlé en public. Avant de légiférer, il a fallu que quelqu’un prenne le risque de décrire.":
  "The laws in §3 did not fall from the sky: they came out of inquiries, reports, people who spoke in public. Before anyone could legislate, someone had to take the risk of describing.",
"Nous voulons que le pasteur puisse parler de nos caves humides.":
  "We want the minister free to speak of our damp cellars.",
"Nous voulons vérifier les accusations avant d’engager des mesures.":
  "We want the charges checked before any measures are taken.",
"« J’ouvre une enquête sur les logements. »":"“I open an inquiry into the housing.”",
"Les ouvriers obtiennent une écoute officielle, mais les industriels craignent des contrôles coûteux.":
  "The workers get an official hearing, but the industrialists fear costly inspections.",
"Nous craignons que cette enquête impose des travaux coûteux à nos logements.":
  "We fear this inquiry will force expensive work on our properties.",
"Nous pourrons enfin témoigner devant ceux qui enquêteront sur nos caves.":
  "At last we can speak to those who come to inspect our cellars.",
"« Je demande au pasteur de cesser ses accusations. »":"“I ask the minister to drop his charges.”",
"Les industriels préservent leur réputation, mais les ouvriers perdent un défenseur public.":
  "The industrialists keep their good name, but the workers lose a public defender.",
"Nous éviterons que les accusations du pasteur ternissent nos fabriques.":
  "We shall keep the minister’s charges from tarnishing our mills.",
"Nous perdrons une voix qui dénonçait les fièvres de nos caves.":
  "We shall lose the voice that spoke of the fevers in our cellars.",
"« Je l’invite au conseil de salubrité. »":"“I invite him onto the board of health.”",
"Les ouvriers gagnent un représentant, mais le Parlement doit partager ses décisions avec un critique.":
  "The workers gain a representative, but Parliament must share its decisions with a critic.",
"Nous aurons quelqu’un pour parler de nos quartiers au conseil.":
  "We shall have someone to speak for our quarters on the board.",
"Nous devrons écouter ce pasteur avant de décider des mesures.":
  "We shall have to hear this minister before deciding anything.",

/* ---------- affaire 27 ---------- */
"Une foule réclame le vote":"A crowd demands the vote",
"Joseph Fielding, organisateur d’une réunion publique":"Joseph Fielding, organiser of a public meeting",
"« Je veux que nos demandes de vote puissent être entendues en paix. »":
  "“I want our demand for the vote heard in peace.”",
"Une foule nombreuse se rassemble près de Manchester pour réclamer des droits politiques. Les magistrats demandent comment agir sans perdre le contrôle de la réunion.":
  "A great crowd is gathering near Manchester to demand political rights. The magistrates are asking how to act without losing control of the meeting.",
"Consultez Trace écrite 2 §3 · tableau de vocabulaire. Retenez **inégalité** : une différence de droits, de revenus ou de possibilités entre des groupes. Pourquoi l’absence de droit de vote est-elle aussi importante que les différences de richesse ?":
  "See written record 2 §3 · vocabulary table. Remember **inequality**: a difference in rights, income or opportunity between groups. Why does having no vote matter as much as differences in wealth?",
"Manchester fabriquait une part de la richesse du pays et n’envoyait aucun député au Parlement. L’inégalité n’est pas qu’une affaire de salaire : c’est aussi le droit de peser sur les décisions.":
  "Manchester made a share of the country’s wealth and sent not one member to Parliament. Inequality is not only a matter of wages: it is also the right to weigh on decisions.",
"Nous voulons réclamer le vote sans subir la charge des soldats.":
  "We want to demand the vote without being charged by soldiers.",
"Nous voulons éviter que cette réunion tourne à l’affrontement.":
  "We want to keep this meeting from turning into a clash.",
"« J’autorise la réunion sous surveillance. »":"“I allow the meeting, under watch.”",
"Les ouvriers peuvent défendre leurs droits, mais le Parlement redoute une agitation prolongée.":
  "The workers can argue for their rights, but Parliament dreads a long unrest.",
"Nous pourrons défendre notre droit de vote devant la foule réunie.":
  "We shall argue for our right to vote before the whole gathering.",
"Nous devrons surveiller une foule nombreuse malgré les risques de troubles.":
  "We must watch a great crowd, for all the risk of disorder.",
"« J’ordonne la dispersion de la foule. »":"“I order the crowd dispersed.”",
"Le Parlement affirme son autorité, mais les ouvriers perdent la possibilité de se réunir.":
  "Parliament asserts its authority, but the workers lose the chance to meet at all.",
"Nous ne pourrons plus présenter ensemble notre demande de vote.":
  "We shall no longer be able to put our demand together.",
"Nous disperserons la réunion avant qu’elle échappe à notre autorité.":
  "We shall break up the meeting before it slips our control.",
"« Je propose de recevoir une délégation. »":"“I offer to receive a delegation.”",
"Les ouvriers peuvent présenter leurs demandes, mais les marchands craignent que la contestation se poursuive.":
  "The workers can put their case, but the merchants fear the agitation will go on.",
"Nous craignons que les rassemblements continuent et gênent nos affaires.":
  "We fear the gatherings will continue and hinder our trade.",
"Nous pourrons exposer nos demandes directement aux magistrats.":
  "We shall be able to put our demands to the magistrates directly.",

/* ---------- affaire 28 ---------- */
"Le pain et les intérêts des fabricants":"Bread, and the manufacturers’ interest",
"Nathaniel Briggs, fabricant de tissus":"Nathaniel Briggs, cloth manufacturer",
"« Je veux du grain moins cher sans augmenter les salaires de mon usine. »":
  "“I want cheaper grain without raising the wages in my mill.”",
"Des fabricants demandent de supprimer les taxes sur le grain importé au nom du pain moins cher. Ils refusent pourtant une hausse de salaire réclamée par leurs employés.":
  "Manufacturers are calling for the duties on imported grain to be abolished, in the name of cheaper bread. Yet they refuse the rise in wages their own workers are asking for.",
"Consultez Trace écrite 2 §3. Retenez **inégalité** : une différence de droits, de revenus ou de possibilités entre des groupes. De quelle perspective parle chaque groupe lorsqu’il prétend défendre le prix du pain ?":
  "See written record 2 §3. Remember **inequality**: a difference in rights, income or opportunity between groups. From whose point of view does each group speak when it claims to defend the price of bread?",
"Les fabricants réclament le pain bon marché au nom des ouvriers, et refusent la hausse de salaire que ces mêmes ouvriers demandent. Les deux tiennent ensemble : un pain moins cher évite d’augmenter les salaires.":
  "The manufacturers call for cheap bread in the workers’ name, and refuse the wage rise those same workers ask for. The two hold together: cheaper bread saves them raising wages.",
"Nous voulons payer notre pain moins cher sans perdre notre salaire.":
  "We want to pay less for our bread without losing our wage.",
"Nous devons entendre les propriétaires terriens aussi bien que les fabricants.":
  "We must hear the landowners as well as the manufacturers.",
"« Je soutiens la suppression des taxes. »":"“I support abolishing the duties.”",
"Les ouvriers pourraient acheter du pain moins cher, mais les propriétaires terriens perdent leur protection.":
  "The workers might buy cheaper bread, but the landowners lose their protection.",
"Nous pourrions payer moins pour le pain acheté chaque semaine.":
  "We might pay less for the bread we buy each week.",
"Nous mécontenterons les propriétaires de terres protégés par ces taxes.":
  "We shall displease the landowners those duties protect.",
"« Je défends le maintien des taxes. »":"“I defend keeping the duties.”",
"Les propriétaires terriens conservent leur avantage, mais les ouvriers continuent de payer leur pain cher.":
  "The landowners keep their advantage, but the workers go on paying dearly for bread.",
"Nous continuerons à acheter le pain trop cher pour nos familles.":
  "We shall go on buying bread too dear for our families.",
"Nous préserverons les intérêts des propriétaires de terres à grain.":
  "We shall protect the interests of those who own the corn land.",
"« Je réclame aussi une négociation salariale. »":"“I call for wage talks as well.”",
"Les ouvriers gagnent une possibilité de hausse, mais les industriels craignent une augmentation des coûts.":
  "The workers gain a chance of a rise, but the industrialists fear rising costs.",
"Nous craignons de devoir relever les salaires dans nos usines.":
  "We fear having to raise wages in our mills.",
"Nous pourrons aussi demander une paie suffisante pour acheter du pain.":
  "We shall be able to ask for pay enough to buy bread as well.",

/* ---------- affaire 29 ---------- */
"Les égouts sous contrôle de Londres":"Sewers under London’s control",
"Sir Henry Wallace, représentant du gouvernement":"Sir Henry Wallace, representative of the government",
"« Je veux financer les égouts et vérifier que l’argent est bien dépensé. »":
  "“I want to fund the sewers and see the money properly spent.”",
"L’État propose de financer les égouts de Manchester. En échange, ses inspecteurs superviseraient les travaux et les dépenses de la ville.":
  "The State offers to fund Manchester’s sewers. In return, its inspectors would oversee the works and the town’s spending.",
"Consultez Trace écrite 2 §3. Retenez **condition de vie** : l’ensemble des circonstances matérielles dans lesquelles une personne vit. Quelle rupture représente l’intervention de l’État dans la santé des quartiers ?":
  "See written record 2 §3. Remember **living conditions**: the whole of the material circumstances in which a person lives. What break does the State’s intervention in public health represent?",
"Le §3 montrait l’État qui prend la main sur l’hygiène. Il n’y a pas d’argent public sans contrôle public : accepter les fonds de Londres, c’est accepter que Londres regarde comment la ville les dépense.":
  "Paragraph 3 showed the State taking charge of public health. There is no public money without public oversight: to accept London’s funds is to accept that London watches how the town spends them.",
"Nous voulons des égouts sans attendre encore des années.":
  "We want sewers without waiting years more.",
"Nous hésitons à laisser les inspecteurs de Londres décider chez nous.":
  "We hesitate to let London’s inspectors decide matters here.",
"« J’accepte les fonds et les inspecteurs. »":"“I accept the funds and the inspectors.”",
"Les ouvriers bénéficient de futurs égouts, mais le Parlement local perd une part de son autonomie.":
  "The workers gain sewers to come, but the local Parliament loses part of its independence.",
"Nous pourrons bientôt voir partir les eaux sales de nos rues.":
  "We shall soon see the foul water carried off our streets.",
"Nous céderons une partie du contrôle des travaux à Londres.":
  "We shall give up part of the control of the works to London.",
"« Je refuse toute intervention de Londres. »":"“I refuse any intervention from London.”",
"Le Parlement local garde le contrôle, mais les ouvriers attendent encore des égouts.":
  "The local Parliament keeps control, but the workers are still waiting for sewers.",
"Nous attendrons encore dans les ruelles où stagnent les eaux sales.":
  "We shall wait on in alleys where the foul water stands.",
"Nous garderons la main sur les chantiers décidés à Manchester.":
  "We shall keep our hand on works decided in Manchester.",
"« Je négocie des contrôles partagés. »":"“I negotiate shared oversight.”",
"Les ouvriers peuvent obtenir les travaux, mais les marchands craignent des délais de négociation.":
  "The workers may yet get the works, but the merchants fear delays in the talks.",
"Nous craignons que les discussions retardent les rues utiles à nos livraisons.":
  "We fear the talks will delay the streets our deliveries need.",
"Nous pourrons espérer les égouts si les contrôles sont partagés.":
  "We may hope for sewers if the oversight is shared.",

/* ---------- affaire 30 ---------- */
"Manchester à l’Exposition de 1851":"Manchester at the Exhibition of 1851",
"Francis Cartwright, représentant des fabricants de coton":"Francis Cartwright, spokesman for the cotton manufacturers",
"« Je veux que Londres admire nos tissus et les machines qui les fabriquent. »":
  "“I want London to admire our cloth and the machines that make it.”",
"Londres invite Manchester à présenter ses tissus à une grande exposition. Des journalistes veulent aussi visiter les usines et les quartiers voisins.":
  "London invites Manchester to show its cloth at a great exhibition. Journalists also want to visit the mills and the quarters around them.",
"Consultez Trace écrite 2 §3, conclusion. Retenez **progrès technique** : les améliorations apportées aux outils et aux machines pour fabriquer ou transporter. Quelle importance historique faut-il donner aux inventions face à leurs effets sur les habitants ?":
  "See written record 2 §3, conclusion. Remember **technical progress**: improvements to tools and machines for making or carrying goods. What historical weight should inventions be given, set against their effects on people?",
"1851 est la date de bilan du cours. L’Exposition célèbre les machines et les tissus ; la question est de savoir si l’on montre aussi ce qu’ils ont coûté. C’est tout le sujet de l’unité.":
  "1851 is the date the course takes stock. The Exhibition celebrates the machines and the cloth; the question is whether what they cost is shown as well. That is the whole subject of the unit.",
"Nous voulons montrer à Londres les tissus que nous vendons.":
  "We want to show London the cloth we sell.",
"Nous voulons que les journalistes regardent aussi nos vies autour des usines.":
  "We want the journalists to look at our lives around the mills too.",
"« J’envoie les tissus et j’ouvre les visites. »":"“I send the cloth and open the visits.”",
"Les industriels montrent leurs inventions, mais les marchands craignent les critiques des journalistes.":
  "The industrialists show what they have built, but the merchants fear what the journalists will write.",
"Nous pourrons faire admirer nos machines aux visiteurs de l’exposition.":
  "We shall have our machines admired by the exhibition’s visitors.",
"Nous craignons que les articles sur les quartiers pauvres découragent les acheteurs.":
  "We fear articles on the poor quarters will put buyers off.",
"« Je présente seulement les tissus à Londres. »":"“I send only the cloth to London.”",
"Les marchands gagnent une vitrine commerciale, mais les ouvriers restent absents du récit.":
  "The merchants gain a shop window, but the workers stay absent from the story.",
"Nous pourrons exposer nos tissus sans détour par les quartiers ouvriers.":
  "We can exhibit our cloth without any detour through the workers’ quarters.",
"Nous resterons absents du récit consacré aux étoffes de Manchester.":
  "We shall be left out of the story told about Manchester cloth.",
"« J’organise aussi une visite des quartiers ouvriers. »":"“I arrange a visit to the workers’ quarters as well.”",
"Les ouvriers peuvent montrer leur vie quotidienne, mais les industriels craignent que les souffrances éclipsent leurs succès.":
  "The workers can show their daily life, but the industrialists fear the hardship will eclipse their success.",
"Nous craignons que la visite des quartiers fasse oublier nos machines.":
  "We fear a visit to the quarters will overshadow our machines.",
"Nous pourrons raconter nos journées et montrer nos logements aux journalistes.":
  "We shall be able to speak of our days and show the journalists our housing.",

FIN

my $n = () = ($s =~ /\Q$MARQUE\E/g);
$n == 1 or die "ARRET : marqueur trouve $n fois\n";
$s =~ s/\Q$MARQUE\E/$LOT$MARQUE/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
my $e = () = ($LOT =~ /^"/mg);
printf "  ok  lot 7 pose · %d entrees\n", $e;

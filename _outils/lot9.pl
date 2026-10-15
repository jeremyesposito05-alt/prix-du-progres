#!/usr/bin/perl
# LOT 9 — L INTRODUCTION, LES FINS, LES CONSEQUENCES DIFFEREES
#         ET LES NOTES DU VERDICT. LE NIVEAU I EST COMPLET.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $MARQUE = "/* --- fin du dictionnaire --- */";

my $LOT = <<'FIN';
/* ---------- l'entree dans le niveau ---------- */
"1re révolution industrielle":"First Industrial Revolution",
"C’est encore une petite ville de drapiers. Elle a du <strong>charbon</strong> tout près, une rivière qui fait tourner les machines, et des marchands qui cherchent à vendre plus loin.":
  "It is still a small clothiers’ town. It has <strong>coal</strong> close at hand, a river to turn the machines, and merchants looking to sell further afield.",
"En soixante-dix ans, elle va devenir la première ville industrielle du monde. C’est vous qui décidez comment.":
  "In seventy years it will become the first industrial city in the world. How, is for you to decide.",
"<strong>Jusqu’en 1851.</strong> Cette année-là, l’Angleterre compte pour la première fois plus de citadins que de ruraux.":
  "<strong>Until 1851.</strong> That year, for the first time, England had more town dwellers than country dwellers.",
"Plus les industriels sont contents, plus la ville grossit. Et plus elle grossit, <strong>plus les ouvriers s’épuisent tout seuls</strong>, sans que vous ayez rien décidé : les logements ne suivent jamais le rythme des usines.":
  "The happier the industrialists, the faster the town grows. And the faster it grows, <strong>the more the workers wear out on their own</strong>, without your deciding anything: housing never keeps pace with the mills.",

/* ---------- les quatre fins de partie ---------- */
"Les machines brisées":"The machines broken",
"Les ouvriers vous ont lâché. Ateliers désertés, métiers brisés, émeutes du pain : la ville ne trouve plus personne pour faire tourner ses filatures. Manchester a connu Peterloo en 1819 et le chartisme dans les années 1840. <strong>Une industrie ne se maintient pas sans ceux qui la font tourner.</strong>":
  "The workers have abandoned you. Deserted workshops, broken looms, bread riots: the town can no longer find anyone to keep its mills turning. Manchester knew Peterloo in 1819 and Chartism in the 1840s. <strong>An industry does not hold without the people who run it.</strong>",
"Les cheminées froides":"The chimneys cold",
"Les industriels vous ont lâché. Les fabricants ferment ou remontent leurs machines à Bolton, où on les laisse travailler. Sans usines, la ville redevient ce qu’elle était : un bourg de marché. <strong>Une révolution industrielle n’est pas acquise une fois pour toutes.</strong>":
  "The industrialists have abandoned you. The manufacturers close, or move their machines to Bolton, where they are left to work in peace. Without mills the town becomes what it was: a market borough. <strong>An industrial revolution is not won once and for all.</strong>",
"Le crédit coupé":"The credit cut off",
"Les marchands vous ont lâché. Plus un shilling de Liverpool, plus un débouché pour le fil. Les entrepôts se vident et les banques placent leur argent ailleurs. <strong>Sans capitaux ni marchés, les machines ne sont que du métal.</strong>":
  "The merchants have abandoned you. Not a shilling from Liverpool, not a buyer for the yarn. The warehouses empty and the banks put their money elsewhere. <strong>Without capital or markets, machines are only metal.</strong>",
"La ville sous tutelle":"The town under supervision",
"Le Parlement vous a lâché. Une commission d’enquête arrive de Londres : caves insalubres, épidémies, travail des enfants. Votre gestion s’arrête là. <strong>L’État finit toujours par regarder ce que l’industrie laisse derrière elle.</strong>":
  "Parliament has abandoned you. A commission of inquiry arrives from London: unfit cellars, epidemics, child labour. Your stewardship ends here. <strong>The State always ends up looking at what industry leaves behind.</strong>",

/* ---------- les consequences differees ---------- */
"Les mêmes appellent à se réunir de nouveau la semaine prochaine. Les magistrats attendent votre avis avant la nuit.":
  "The same people are calling for another meeting next week. The magistrates want your view before nightfall.",
"« Qu’on les laisse se réunir. »":"“Let them meet.”",
"Le rassemblement a lieu sans un blessé. Londres note votre nom, et pas en bien.":
  "The gathering passes without a single injury. London notes your name, and not with approval.",
"« Qu’on interdise le rassemblement. »":"“Ban the gathering.”",
"On interdit, on disperse, on arrête. Le calme revient — celui qu’on obtient par la peur.":
  "It is banned, broken up, and arrests are made. Quiet returns — the kind that fear buys.",
"Vous n’avez rien répondu. Les magistrats ont décidé seuls, et mal : on a chargé de nouveau.":
  "You gave no answer. The magistrates decided alone, and badly: there was another charge.",
"Une vingtaine d’émeutiers sont sous les verrous. La peine prévue va de la déportation à la corde. On vous demande ce qu’il faut requérir.":
  "A score of rioters are in custody. The sentence ranges from transportation to the rope. You are asked what should be sought.",
"« La rigueur : qu’on fasse un exemple. »":"“Severity: let an example be made.”",
"On déporte. Les ateliers sont tranquilles, et personne dans les faubourgs ne l’oubliera.":
  "They are transported. The workshops are quiet, and nobody in the outer streets will forget it.",
"« La clémence : ils ont perdu leur métier. »":"“Mercy: they have lost their trade.”",
"Les peines sont légères. Les fabricants parlent d’encouragement au désordre.":
  "The sentences are light. The manufacturers call it an encouragement to disorder.",
"Faute d’instruction, l’affaire a traîné en prison. Deux hommes y sont morts avant d’être jugés.":
  "With no one to pursue it, the case dragged on in gaol. Two men died there before they were tried.",
"Les chaudières sont froides depuis six jours. Le préfet propose la troupe ; les meneurs proposent de discuter. Il faut répondre ce soir.":
  "The boilers have been cold for six days. The magistrate proposes troops; the leaders propose talks. An answer is needed tonight.",
"« Faisons intervenir la troupe. »":"“Send in the troops.”",
"Les usines rouvrent sous escorte militaire. On a gagné la semaine et perdu la confiance.":
  "The mills reopen under military escort. The week is won and the trust is lost.",
"« Recevons les meneurs. »":"“Receive the leaders.”",
"On négocie le retour poste par poste. Les fabricants du comté vous accusent de capituler.":
  "The return to work is negotiated post by post. The county’s manufacturers accuse you of surrender.",
"Personne n’a tranché. L’arrêt a duré trois semaines de plus, et tout le monde y a perdu.":
  "Nobody decided. The stoppage ran three weeks longer, and everyone lost by it.",
"Des milliers de familles dorment dans les cours d’Ancoats. Le conseil vous demande une décision avant l’hiver.":
  "Thousands of families are sleeping in the courts of Ancoats. The council wants a decision before winter.",
"« Ouvrons des abris et des soupes populaires. »":"“Open shelters and soup kitchens.”",
"On ouvre des baraquements. Ils sont pleins le premier soir, et cela coûte une fortune.":
  "Huts are put up. They are full the first night, and the cost is enormous.",
"« Ce n’est pas à la ville de les nourrir. »":"“It is not the town’s place to feed them.”",
"On les laisse où ils sont. Le typhus part des mêmes cours six semaines plus tard.":
  "They are left where they are. Typhus breaks out in those same courts six weeks later.",
"L’hiver est arrivé avant votre réponse. On a compté les morts au printemps.":
  "Winter came before your answer did. The dead were counted in the spring.",

/* ---------- les notes du verdict ---------- */
"Le charbon est la **ressource** énergétique de toute la période. La Grande-Bretagne en possède d’énormes gisements : c’est l’une des raisons pour lesquelles la révolution industrielle y commence.":
  "Coal is the energy **resource** of the whole period. Britain holds enormous deposits of it: that is one of the reasons the industrial revolution begins there.",
"Avant la vapeur, il fallait la force de l’eau : l’usine dépendait de la géographie et s’arrêtait quand la rivière gelait. La vapeur la libère de cette contrainte.":
  "Before steam you needed the force of water: the mill depended on geography and stopped when the river froze. Steam frees it from that constraint.",
"L’**exode rural** fournit la **main-d’œuvre** dont les filatures ont besoin. Il produit en même temps l’**urbanisation** : Manchester passe de 25 000 habitants en 1772 à plus de 300 000 en 1851.":
  "The **drift from the land** supplies the **workforce** the mills require. At the same time it produces **urbanisation**: Manchester goes from 25,000 people in 1772 to more than 300,000 in 1851.",
"Elles partagent trois murs sur quatre : pas de traversée d’air, pas de cour, pas d’évacuation. Le logement ouvrier est le premier endroit où se lit l’inégalité du progrès.":
  "They share three walls out of four: no through draught, no yard, no drainage. Workers’ housing is the first place where the inequality of progress can be read.",
"Contre trente-huit ans dans un comté rural voisin. La mortalité des jeunes enfants pèse lourd dans ce chiffre, qui obligera l’État à intervenir.":
  "Against thirty-eight years in a neighbouring rural county. Infant mortality weighs heavily in that figure, which will force the State to act.",
"Le chemin de fer transforme l’échelle des **marchés** : ce qu’on produit ici peut être vendu partout. Il crée aussi une demande énorme de fer et de charbon — une innovation en entraîne d’autres.":
  "The railway transforms the scale of **markets**: what is made here can be sold anywhere. It also creates an enormous demand for iron and coal — one innovation draws others after it.",
"Produire en masse n’a de sens que si l’on peut vendre en masse. L’industrie et le commerce mondial se développent ensemble, souvent à travers l’Empire britannique.":
  "Producing on a large scale only makes sense if you can sell on a large scale. Industry and world trade grow together, often through the British Empire.",
"On les appelle des « rattacheurs » : ils sont les seuls assez petits pour passer sans qu’on arrête la production. Le salaire de l’enfant est indispensable au revenu familial.":
  "They are called “piecers”: they alone are small enough to go under without stopping production. The child’s wage is essential to the family income.",
"Adam Smith l’a décrite dès 1776 à propos d’une fabrique d’épingles. On produit beaucoup plus, mais chacun ne sait plus faire qu’un fragment du métier.":
  "Adam Smith described it as early as 1776, writing about a pin factory. Far more is produced, but each worker knows only a fragment of the trade.",
"Le salaire industriel est versé en argent : l’ouvrier dépend entièrement du marché, contrairement au paysan qui produisait une partie de sa nourriture.":
  "The industrial wage is paid in money: the worker depends entirely on the market, unlike the farmhand who grew part of his own food.",
"Elles maintenaient le pain cher. La Ligue contre les Corn Laws naît à **Manchester en 1838** : c’est l’un des premiers grands conflits entre la richesse foncière et la richesse industrielle.":
  "They kept bread dear. The Anti-Corn Law League is founded in **Manchester in 1838**: one of the first great conflicts between landed wealth and industrial wealth.",
"C’est l’aboutissement de l’exode rural commencé un siècle plus tôt. La même année, l’**Exposition universelle** met en scène la suprématie industrielle britannique.":
  "It is the outcome of a drift from the land begun a century earlier. That same year the **Great Exhibition** stages British industrial supremacy.",
"Soixante mille personnes s’étaient rassemblées ; on compte dix-huit morts. Le nom parodie **Waterloo**, quatre ans plus tôt.":
  "Sixty thousand people had gathered; eighteen were killed. The name mocks **Waterloo**, four years earlier.",
"Sans vapeur, rien ne tourne. C’est la première grève générale de l’histoire industrielle britannique.":
  "Without steam, nothing turns. It is the first general strike in British industrial history.",
"Ils ne pouvaient plus vivre de leur métier. La mécanisation ne crée pas seulement des emplois : elle en détruit, et pas les mêmes.":
  "They could no longer live by their trade. Mechanisation does not only create work: it destroys work, and not the same work.",
"La ville qu’on montre : les quais, le coton, les trains.":
  "The town that is shown: the wharves, the cotton, the trains.",
"La même ville deux rues plus loin : la fumée, les courées, les enfants.":
  "The same town two streets away: the smoke, the courts, the children.",
"Vous partiez de 36 267 habitants en 1780. Le vrai Manchester en comptait <b>303 382</b> au recensement de 1851 : la ville a été multipliée par huit en deux générations.":
  "You began with 36,267 inhabitants in 1780. The real Manchester counted <b>303,382</b> at the census of 1851: the town multiplied eightfold in two generations.",
"Les marchands, eux, commencent à regarder vers Leeds.":
  "The merchants, for their part, are beginning to look towards Leeds.",
"Une invention ne devient une révolution industrielle que si <strong>plusieurs conditions se combinent</strong> : ressources, savoirs, capitaux, main-d’œuvre, marchés, transports, organisation du travail.":
  "An invention becomes an industrial revolution only when <strong>several conditions combine</strong>: resources, knowledge, capital, workforce, markets, transport, and the organisation of work.",
"Chaque décision a <strong>fait un gagnant et un perdant</strong>. Aucune ne contentait les quatre forces à la fois : c’est ce que veut dire « le progrès ne profite pas également à tous ».":
  "Every decision <strong>made one winner and one loser</strong>. Not one satisfied all four forces at once: that is what “progress does not benefit everyone equally” means.",
"La croissance de la population n’est pas seulement une conséquence de l’industrialisation, <strong>elle en est aussi le coût</strong> : les logements ne suivent jamais le rythme des usines.":
  "The growth of the population is not only a consequence of industrialisation, <strong>it is also its cost</strong>: housing never keeps pace with the mills.",

FIN

my $n = () = ($s =~ /\Q$MARQUE\E/g);
$n == 1 or die "ARRET : marqueur trouve $n fois\n";
$s =~ s/\Q$MARQUE\E/$LOT$MARQUE/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
my $e = () = ($LOT =~ /^"/mg);
printf "  ok  lot 9 pose · %d entrees\n", $e;

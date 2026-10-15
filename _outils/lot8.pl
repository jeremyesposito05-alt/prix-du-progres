#!/usr/bin/perl
# LOT 8 — LE QUIZ, LES EVENEMENTS ET LES TEXTES DU NIVEAU
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";
my $MARQUE = "/* --- fin du dictionnaire --- */";

my $LOT = <<'FIN';
/* ---------- le questionnaire ---------- */
"Pourquoi le charbon est-il décisif dans la première révolution industrielle ?":
  "Why is coal decisive in the first industrial revolution?",
"C’est lui qui chauffe l’eau des machines à vapeur":"It heats the water in the steam engines",
"C’est lui qui sert à fabriquer les bobines de coton":"It is used to make the cotton bobbins",
"C’est lui qui actionne directement les métiers à tisser":"It drives the looms directly",
"Qu’est-ce que la machine à vapeur change pour l’emplacement des usines ?":
  "What does the steam engine change about where mills are built?",
"Elles ne sont plus obligées de s’installer au bord d’une rivière":
  "They no longer have to stand beside a river",
"Elles doivent désormais se rapprocher des mines de fer pour fonctionner":
  "They must now be built near iron mines to work",
"Elles doivent être installées près des ports pour recevoir la vapeur":
  "They must be built near ports to receive steam",
"Comment appelle-t-on le départ des paysans vers les villes industrielles ?":
  "What is the movement of country people to the industrial towns called?",
"L’exode rural":"The drift from the land",
"L’urbanisation":"Urbanisation",
"L’émigration":"Emigration",
"Pourquoi construit-on des maisons ouvrières « dos à dos » ?":
  "Why were workers’ houses built back to back?",
"Pour loger le plus de monde possible au moindre coût":
  "To house as many people as possible at the lowest cost",
"Pour mieux garder la chaleur entre les logements voisins":
  "To keep the heat better between neighbouring dwellings",
"Pour respecter les règles sanitaires imposées par la ville":
  "To meet the sanitary rules laid down by the town",
"Selon l’enquête officielle de 1842, quelle est l’espérance de vie moyenne d’un ouvrier de Manchester ?":
  "According to the official inquiry of 1842, what was the average life expectancy of a Manchester worker?",
"Environ 17 ans":"About 17 years",
"Environ 35 ans":"About 35 years",
"Environ 50 ans":"About 50 years",
"Qu’a d’exceptionnel la ligne Liverpool–Manchester ouverte en 1830 ?":
  "What was exceptional about the Liverpool–Manchester line opened in 1830?",
"C’est la première au monde à relier deux grandes villes":
  "It was the first in the world to link two large cities",
"C’est la première au monde à transporter du charbon en train":
  "It was the first in the world to carry coal by rail",
"C’est la première au monde à fonctionner sans aucun cheval":
  "It was the first in the world to run without any horses",
"Pourquoi les débouchés lointains sont-ils une condition de la production de masse ?":
  "Why are distant markets a condition of mass production?",
"Sans acheteurs nombreux, des machines coûteuses ne sont jamais rentables":
  "Without buyers in number, costly machines never pay for themselves",
"Sans coton venu des colonies, les machines des usines ne peuvent pas fonctionner":
  "Without cotton from the colonies, the mills’ machines cannot run",
"Sans marchés étrangers, les ouvriers ne peuvent pas toucher leur salaire":
  "Without foreign markets, the workers cannot be paid at all",
"Quel travail confie-t-on aux enfants dans les filatures ?":
  "What work were children given in the spinning mills?",
"Passer sous les machines en marche pour renouer les fils cassés":
  "Crawling under running machines to tie broken threads",
"Surveiller les machines à vapeur et en régler la vitesse":
  "Watching the steam engines and setting their speed",
"Diriger les métiers à tisser et remplacer les ouvriers adultes absents":
  "Running the looms and standing in for absent adult workers",
"Qu’appelle-t-on la division du travail ?":"What is meant by the division of labour?",
"Découper la fabrication en tâches simples confiées chacune à un ouvrier différent":
  "Splitting the making of a thing into simple tasks, each given to a different worker",
"Confier la fabrication de chaque objet entier à une usine différente":
  "Giving the making of each whole object to a different mill",
"Partager les recettes de chaque vente entre les ouvriers selon leur poste":
  "Sharing the takings of each sale among the workers by their post",
"Pourquoi le prix du pain est-il un enjeu politique majeur pour les ouvriers ?":
  "Why was the price of bread a major political question for workers?",
"Il représente près de la moitié du budget d’une famille ouvrière":
  "It took up nearly half of a working family’s budget",
"Il est soumis à une taxe qui augmente avec les salaires des ouvriers":
  "It carried a duty that rose with workers’ wages",
"Il est le seul aliment que les patrons fournissent aux familles ouvrières":
  "It was the only food the owners supplied to working families",
"Que sont les Corn Laws, abolies en 1846 ?":"What were the Corn Laws, repealed in 1846?",
"Des taxes sur le grain importé, qui protégeaient les propriétaires terriens":
  "Duties on imported grain, which protected the landowners",
"Des lois sur le prix du pain qui limitaient les profits des boulangers":
  "Laws on the price of bread that capped bakers’ profits",
"Des taxes sur le grain produit en Angleterre, qui favorisaient les importations":
  "Duties on grain grown in England, which favoured imports",
"Que révèle le recensement britannique de 1851 ?":"What did the British census of 1851 reveal?",
"Le pays compte pour la première fois plus de citadins que de ruraux":
  "For the first time the country had more town dwellers than country dwellers",
"Le pays compte pour la première fois davantage d’ouvriers que de paysans":
  "For the first time the country had more workers than farmhands",
"Le pays compte pour la première fois plus d’habitants que la France":
  "For the first time the country had more people than France",
"Que s’est-il passé à Peterloo, à Manchester, le 16 août 1819 ?":
  "What happened at Peterloo, in Manchester, on 16 August 1819?",
"La cavalerie a chargé une foule réunie pour réclamer le droit de vote":
  "Cavalry charged a crowd gathered to demand the right to vote",
"Des ouvriers ont incendié une usine pour obtenir une hausse":
  "Workers set fire to a mill to win a rise",
"La police a dispersé une foule opposée aux nouvelles machines":
  "Police broke up a crowd opposed to the new machines",
"Comment les grévistes d’août 1842 arrêtaient-ils les usines ?":
  "How did the strikers of August 1842 stop the mills?",
"En retirant le bouchon des chaudières, ce qui coupait la vapeur":
  "By pulling the plugs from the boilers, which cut off the steam",
"En bloquant les portes des ateliers pour arrêter le travail":
  "By blocking the workshop doors to halt the work",
"En coupant les voies ferrées qui apportaient le charbon aux usines":
  "By cutting the railways that brought coal to the mills",
"Qui brise les métiers mécaniques dans le Lancashire en 1826 ?":
  "Who broke the power looms in Lancashire in 1826?",
"Des tisserands à bras que la machine a ruinés":"Handloom weavers ruined by the machine",
"Des ouvriers des usines opposés à une baisse de salaire":
  "Mill workers opposed to a cut in wages",
"Des paysans privés de leurs terres par les usines":
  "Country people whose land the mills had taken",

/* ---------- les evenements dates ---------- */
"Le Parlement interdit les coalitions":"Parliament outlaws combination",
"Les Combination Acts rendent illégal, pour des ouvriers, de s’associer afin de réclamer un meilleur salaire ou moins d’heures. Se réunir devient un délit.":
  "The Combination Acts make it illegal for workers to join together to demand better wages or shorter hours. To meet is now an offence.",
"**Combination Acts**, votés en **1799 et 1800**, abrogés en 1824.":
  "**Combination Acts**, passed in **1799 and 1800**, repealed in 1824.",
"Peterloo":"Peterloo",
"Soixante mille personnes se rassemblent à St Peter’s Field, ici même, pour réclamer le droit de vote. La cavalerie charge la foule sabre au clair. Dix-huit morts, des centaines de blessés.":
  "Sixty thousand people gather at St Peter’s Field, here, to demand the right to vote. Cavalry charge the crowd with sabres drawn. Eighteen dead, hundreds wounded.",
"Le **massacre de Peterloo**, Manchester, **16 août 1819**. Le nom parodie Waterloo, quatre ans plus tôt.":
  "The **Peterloo massacre**, Manchester, **16 August 1819**. The name mocks Waterloo, four years earlier.",
"Les briseurs de métiers":"The loom breakers",
"Des tisserands à bras, ruinés par les métiers mécaniques, parcourent le Lancashire et brisent les machines atelier par atelier. Des centaines de métiers détruits en trois jours.":
  "Handloom weavers, ruined by the power looms, move across Lancashire breaking machines workshop by workshop. Hundreds of looms destroyed in three days.",
"**Révolte des briseurs de métiers**, Lancashire, **avril 1826**. Les tisserands à la main ne pouvaient plus vivre de leur métier.":
  "**The loom breakers’ revolt**, Lancashire, **April 1826**. Handloom weavers could no longer live by their trade.",
"La ligne de Liverpool est inaugurée":"The Liverpool line is opened",
"Le premier chemin de fer entre deux grandes villes s’ouvre en fanfare. Le jour même, le député William Huskisson descend sur la voie et se fait écraser par la Rocket. Il meurt le soir.":
  "The first railway between two great cities opens amid fanfare. That same day the member of Parliament William Huskisson steps onto the track and is run down by the Rocket. He dies that evening.",
"Ouverture du **Liverpool & Manchester Railway** et mort de **William Huskisson**, **15 septembre 1830** — le premier accident ferroviaire mortel connu.":
  "Opening of the **Liverpool & Manchester Railway** and the death of **William Huskisson**, **15 September 1830** — the first known fatal railway accident.",
"La crise s’installe":"The slump sets in",
"Les banques américaines s’effondrent, les commandes s’arrêtent, les filatures tournent trois jours par semaine. On appellera ces années-là les Hungry Forties.":
  "The American banks collapse, the orders stop, the mills run three days a week. These years will be called the Hungry Forties.",
"**Panique de 1837** et dépression qui suit, jusqu’en 1842-43.":
  "**The Panic of 1837** and the depression that followed, lasting into 1842-43.",
"La grève des bouchons":"The Plug Plot strike",
"Les grévistes vont d’usine en usine retirer le bouchon des chaudières. Sans vapeur, rien ne tourne. En quelques jours, la moitié du Lancashire est à l’arrêt.":
  "The strikers go from mill to mill pulling the plugs from the boilers. Without steam, nothing turns. Within days half of Lancashire has stopped.",
"**Grève des bouchons**, **août 1842** — la première grève générale de l’histoire industrielle britannique.":
  "**The Plug Plot strike**, **August 1842** — the first general strike in British industrial history.",
"La famine chasse l’Irlande":"Famine drives Ireland out",
"Le mildiou détruit la pomme de terre, seule nourriture de millions d’Irlandais. Ils fuient par Liverpool, et beaucoup s’arrêtent ici. La ville n’a rien prévu.":
  "Blight destroys the potato, the only food of millions in Ireland. They flee through Liverpool, and many stop here. The town has made no provision.",
"**Grande Famine irlandaise**, 1845-1852. En 1851, plus d’un habitant de Manchester sur huit était né en Irlande.":
  "**The Great Irish Famine**, 1845-1852. By 1851 more than one Manchester resident in eight had been born in Ireland.",
"L’Europe s’embrase":"Europe catches fire",
"Paris chasse son roi, Vienne et Berlin se soulèvent. À Londres paraît un opuscule signé de deux Allemands, dont l’un a passé deux ans à observer vos filatures. Les chartistes reprennent espoir.":
  "Paris drives out its king; Vienna and Berlin rise. In London a pamphlet appears signed by two Germans, one of whom has spent two years observing your mills. The Chartists take heart again.",
"**Printemps des peuples**, **1848**. Le Manifeste du parti communiste paraît à Londres en février ; Engels séjournait à Manchester depuis 1842.":
  "**The Springtime of Nations**, **1848**. The Communist Manifesto appears in London in February; Engels had been living in Manchester since 1842.",

/* ---------- le niveau ---------- */
"Manchester, 1780 — 1851":"Manchester, 1780 — 1851",
"Population":"Population",

FIN

my $n = () = ($s =~ /\Q$MARQUE\E/g);
$n == 1 or die "ARRET : marqueur trouve $n fois\n";
$s =~ s/\Q$MARQUE\E/$LOT$MARQUE/;
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
my $e = () = ($LOT =~ /^"/mg);
printf "  ok  lot 8 pose · %d entrees\n", $e;

#!/usr/bin/perl
# LE MECANISME DE TRADUCTION DU JEU, ET SON PREMIER LOT
#
#   perl _outils/traduire.pl index.html
#
# POURQUOI UN DICTIONNAIRE ET PAS UN DEUXIEME FICHIER. Le jeu anglais
# existant est un second index.html, fige au 7 octobre : il a diverge
# des que le francais a bouge, et il est aujourd hui quarante versions
# en retard. Une copie ne se maintient pas.
#
# COMMENT. Un dictionnaire plat, francais vers anglais. Au changement
# de langue, on copie l objet du niveau en passant CHAQUE chaine par
# ce dictionnaire. Une chaine absente revient en francais.
#
# C est la propriete qui rend l entreprise raisonnable : on peut
# s arreter a n importe quelle ligne sans jamais laisser le jeu dans
# un etat casse. Le niveau I compte 616 chaines et 53 636 caracteres ;
# on les traduira par lots, et chaque lot est jouable le jour meme.
#
# CE LOT-CI. Les quatre forces — ce que les quatre cartes d acteur
# affichent a chaque tour — et les deux premieres affaires, completes.
# Plus l habillage de l ecran de jeu. De quoi jouer deux tours
# entiers en anglais, et verifier que chaque type de champ passe.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ================================================================= 1
# Le dictionnaire et le mecanisme, poses juste avant NIVEAUX.
ech("le dictionnaire et le mecanisme de traduction", <<'AV', <<'AP');
let N = NIVEAUX.I;
AV
/* ==================================================================
   LE JEU EN ANGLAIS
   Un dictionnaire plat, francais vers anglais. Au changement de
   langue on copie l'objet du niveau en passant chaque chaine par lui.
   UNE CHAINE ABSENTE REVIENT EN FRANCAIS : on peut s'arreter a
   n'importe quelle ligne sans laisser le jeu dans un etat casse.
   ================================================================== */
const TRAD = {

/* ---------- les quatre forces ---------- */
"Industriels":"Industrialists",
"des machines, du charbon, des bras":"machines, coal, hands",
"Vous venez de leur donner de quoi produire davantage, ou de leur épargner une dépense.":
  "You have just given them the means to produce more, or spared them an expense.",
"Vous venez de leur imposer une dépense ou une contrainte : c’est autant de profit en moins.":
  "You have just imposed a cost or a constraint on them: that is profit lost.",
"Les **fabricants** qui possèdent les filatures. Ce sont eux qui investissent les **capitaux**, achètent les machines et embauchent. Sans eux, pas d’industrie — mais ils cherchent le profit, et chaque dépense qu’on leur impose le réduit. Ils quitteront la ville pour une autre si elle devient trop coûteuse.":
  "The **manufacturers** who own the mills. They are the ones who invest the **capital**, buy the machines and hire. Without them there is no industry — but they are after profit, and every cost imposed on them cuts into it. They will leave the town for another if it becomes too expensive.",

"Ouvriers":"Workers",
"un salaire, un toit, des heures vivables":"a wage, a roof, hours a body can stand",
"Vous venez d’alléger leur peine, ou d’assurer leur pain.":
  "You have just eased their burden, or secured their bread.",
"Vous venez d’alourdir leur journée, ou de les laisser payer à votre place.":
  "You have just lengthened their day, or left them to pay in your stead.",
"La **main-d’œuvre**, venue des campagnes par l’**exode rural**. C’est l’une des conditions de la révolution industrielle : sans bras, les machines ne tournent pas. Ces hommes, ces femmes et ces enfants n’ont que leur travail pour vivre. Épuisés ou affamés, ils cessent de venir — et tout s’arrête.":
  "The **workforce**, come from the countryside in the **drift from the land**. It is one of the conditions of the industrial revolution: without hands, the machines do not turn. These men, women and children have nothing but their labour to live on. Worn out or starving, they stop coming — and everything stops.",

"Marchands":"Merchants",
"des canaux, des rails, des débouchés":"canals, rails, markets to sell in",
"Vous venez de faire circuler les marchandises, et donc l’argent.":
  "You have just set the goods moving, and the money with them.",
"Cet argent-là ne circule pas : il ne leur rapporte rien, et il manque ailleurs.":
  "That money is not moving: it earns them nothing, and it is missing elsewhere.",
"Les **négociants** qui apportent le coton brut et revendent le fil dans le monde entier. Ils représentent les **marchés** et les **transports**, deux autres conditions de l’industrialisation. Produire en masse n’a de sens que si l’on peut vendre en masse : s’ils se détournent, la production ne sert plus à rien.":
  "The **traders** who bring in the raw cotton and sell the yarn across the world. They stand for the **markets** and the **transport**, two further conditions of industrialisation. Producing on a large scale only makes sense if you can sell on a large scale: if they turn away, the output is worth nothing.",

"Parlement":"Parliament",
"l’ordre public et la salubrité":"public order and public health",
"Vous allez dans le sens de l’ordre et de la salubrité — ce que Londres réclame.":
  "You are moving towards order and public health — which is what London demands.",
"Londres n’aimera pas : vous laissez la ville se dégrader, ou vous passez outre la loi.":
  "London will not like this: you are letting the town decay, or going around the law.",
"L’**État** et les autorités de Londres. Longtemps absents de l’économie, ils commencent à intervenir : lois sur le travail des enfants, enquêtes sanitaires, maintien de l’ordre. Ils jugent ce que la ville laisse derrière elle. Perdre leur confiance, c’est risquer la mise sous tutelle.":
  "The **State** and the authorities in London. Long absent from the economy, they are beginning to step in: laws on child labour, sanitary inquiries, the keeping of order. They judge what the town leaves behind it. Lose their confidence and you risk being placed under supervision.",

/* ---------- affaire 01 ---------- */
"Le charbon et la route":"Coal and the road",
"Thomas Whitworth, marchand de charbon":"Thomas Whitworth, coal merchant",
"« Je veux un canal pour livrer davantage de charbon à meilleur prix. »":
  "“I want a canal, to deliver more coal at a better price.”",
"Le charbon arrive par charrette et coûte très cher. Un canal vers les mines réduirait son transport, mais sa construction prendrait des années.":
  "Coal comes in by cart and costs a great deal. A canal to the pits would cut the cost of carrying it, but building one would take years.",
"Consultez Document 1 (la carte) · trace écrite 2 §1. Retenez **bassin houiller** : une région où l’on extrait le charbon. Quelles causes expliquent le prix du charbon, et quelles conséquences auront vos travaux ?":
  "See Document 1 (the map) · written record 2 §1. Remember **coalfield**: a region where coal is mined. What causes explain the price of coal, and what consequences will your works have?",
"En classe, la carte montrait Manchester posée au bord d’un bassin houiller. Ce voisinage ne suffit pourtant pas : entre la mine et la machine il reste la route, et c’est elle qui fixe le prix.":
  "In class, the map showed Manchester sitting on the edge of a coalfield. That closeness is not enough, though: between the pit and the machine there is still the road, and it is the road that sets the price.",
"Nous voulons du charbon moins cher sans attendre des années.":
  "We want cheaper coal without waiting years for it.",
"Nous devons mesurer le coût du canal avant d’engager l’argent public.":
  "We must weigh the cost of the canal before committing public money.",
"« Je fais creuser le canal. »":"“I have the canal dug.”",
"Les marchands gagnent une voie de transport, mais le Parlement doit engager de fortes dépenses.":
  "The merchants gain a route for their goods, but Parliament must commit heavy spending.",
"Nous pourrons enfin acheminer davantage de charbon par le canal.":
  "At last we shall be able to bring more coal through by canal.",
"Nous devrons financer un chantier qui pèsera sur nos comptes.":
  "We shall have to fund works that will weigh on our accounts.",
"« Je garde le transport par charrette. »":"“I keep the carts.”",
"Le Parlement évite les travaux, mais les industriels continuent de payer leur charbon cher.":
  "Parliament avoids the works, but the industrialists go on paying dearly for their coal.",
"Nous continuerons à payer cher chaque charrette de charbon.":
  "We shall go on paying dearly for every cartload of coal.",
"Nous évitons pour l’instant une lourde dépense de travaux.":
  "For now we avoid a heavy outlay on public works.",
"« Je finance seulement une meilleure route. »":"“I pay only for a better road.”",
"Les industriels obtiennent des livraisons plus faciles, mais les marchands perdent l’espoir d’un canal.":
  "The industrialists get easier deliveries, but the merchants lose their hope of a canal.",
"Nous recevrons plus facilement le charbon par la route améliorée.":
  "The improved road will bring us our coal more easily.",
"Nous espérions un canal pour transporter de plus grandes cargaisons.":
  "We had hoped for a canal, to carry larger loads.",

/* ---------- affaire 02 ---------- */
"Une ligne vers Liverpool":"A line to Liverpool",
"Edward Mercer, négociant en coton":"Edward Mercer, cotton trader",
"« Je veux rejoindre le port rapidement pour recevoir mon coton et expédier mes tissus. »":
  "“I want to reach the port quickly, to take in my cotton and send out my cloth.”",
"Liverpool propose un chemin de fer vers Manchester. Il faut acheter des terrains, sinon les trains pourraient desservir une autre ville.":
  "Liverpool proposes a railway to Manchester. Land must be bought, or the trains may well serve another town instead.",
"Consultez Document 1 (la carte). Retenez **textile** : l’ensemble des activités qui transforment des fibres en fil et en tissu. Quelles conséquences une liaison au port peut-elle avoir sur la fabrication des tissus ?":
  "See Document 1 (the map). Remember **textiles**: all the trades that turn fibre into yarn and cloth. What consequences might a link to the port have on the making of cloth?",
"La carte reliait Manchester au port de Liverpool. Cette ligne n’apporte pas du tissu : elle fait entrer le coton brut et sortir le tissu fini. Sans elle, la filature tourne à vide.":
  "The map linked Manchester to the port of Liverpool. This line does not bring cloth in: it brings raw cotton in and takes finished cloth out. Without it, the mill runs on nothing.",
"Nous avons besoin de coton livré rapidement depuis Liverpool.":
  "We need cotton delivered quickly from Liverpool.",
"Nous voulons préserver les fonds de la ville malgré le projet ferroviaire.":
  "We want to protect the town’s funds, railway or no railway.",
"« J’achète les terrains nécessaires. »":"“I buy the land that is needed.”",
"Les marchands gagnent un accès au port, mais le Parlement supporte le prix des terrains.":
  "The merchants gain access to the port, but Parliament carries the cost of the land.",
"Nous pourrons faire circuler nos tissus vers le port par train.":
  "We shall be able to move our cloth to the port by rail.",
"Nous devons acheter les terrains avant même le premier voyage.":
  "We must buy the land before a single journey is made.",
"« Je refuse de payer les terrains. »":"“I refuse to pay for the land.”",
"Le Parlement préserve son argent, mais les marchands risquent de perdre la liaison.":
  "Parliament keeps its money, but the merchants may well lose the link.",
"Nous risquons de voir les trains de Liverpool partir ailleurs.":
  "We may well see Liverpool’s trains go elsewhere.",
"Nous gardons l’argent prévu pour les terrains du chemin de fer.":
  "We keep the money set aside for the railway land.",
"« Je propose de partager les frais. »":"“I propose we share the cost.”",
"Les marchands peuvent obtenir leur ligne, mais les industriels doivent contribuer aux achats.":
  "The merchants may get their line, but the industrialists must help pay for it.",
"Nous devons payer une part des terrains pour recevoir notre coton.":
  "We must pay a share of the land to get our cotton.",
"Nous pouvons encore obtenir notre liaison grâce au partage des frais.":
  "Sharing the cost may still get us our link.",
};

/* Une chaine absente du dictionnaire revient en francais, telle
   quelle. C'est la regle qui permet de traduire par lots. */
function trTexte(x){
  if(LANG !== "en" || typeof x !== "string" || !x) return x;
  const t = TRAD[x];
  return t === undefined ? x : t;
}
/* Copie profonde : on ne touche jamais aux donnees francaises. */
function traduireTout(x){
  if(typeof x === "string") return trTexte(x);
  if(Array.isArray(x)) return x.map(traduireTout);
  if(x && typeof x === "object" && x.constructor === Object){
    const o = {};
    for(const k in x) o[k] = traduireTout(x[k]);
    return o;
  }
  return x;
}
const NIVEAUX_EN = {};
function niveau(id){
  if(LANG !== "en") return NIVEAUX[id];
  if(!NIVEAUX_EN[id]) NIVEAUX_EN[id] = traduireTout(NIVEAUX[id]);
  return NIVEAUX_EN[id];
}
/* Combien de chaines sont traduites ? Sert aux mesures, pas au jeu. */
function couverture(id){
  let tot = 0, fait = 0;
  (function voir(x){
    if(typeof x === "string"){ if(x.length > 1){ tot++; if(TRAD[x] !== undefined) fait++ } return }
    if(Array.isArray(x)) return x.forEach(voir);
    if(x && typeof x === "object" && x.constructor === Object)
      for(const k in x) voir(x[k]);
  })(NIVEAUX[id]);
  return {tot, fait, pct: tot ? Math.round(100*fait/tot) : 0};
}

let N = NIVEAUX.I;
AP

# ================================================================= 2
# Les quatre points ou le niveau est charge.
ech("le niveau charge sa version traduite · 1", <<'AV', <<'AP');
  if(niv) N=NIVEAUX[niv];
AV
  if(niv) N=niveau(niv);
AP

ech("le niveau charge sa version traduite · 2", <<'AV', <<'AP');
  N = NIVEAUX.I;
  app.innerHTML=`
  <div class="titre-ecran">
AV
  N = niveau("I");
  app.innerHTML=`
  <div class="titre-ecran">
AP

# Ancres en milieu de ligne : des chaines simples, pas des heredocs —
# un heredoc ajoute un saut de ligne final qui ne peut pas correspondre.
ech("le niveau charge sa version traduite · 3",
    q{N=NIVEAUX.I; peindreVille(); chercherVue("menu")},
    q{N=niveau("I"); peindreVille(); chercherVue("menu")});

ech("le niveau charge sa version traduite · 4",
    q{N=NIVEAUX[id]; document.body.dataset.niveau=id},
    q{N=niveau(id); document.body.dataset.niveau=id});

# ================================================================= 3
# La lettre se decoupe aussi en anglais.
ech("la lettre se decoupe dans les deux langues", <<'AV', <<'AP');
    /^(?:Consultez|Révisez)\s+(.+?)\.\s*(?:Retenez\s+\*\*(.+?)\*\*\s*:\s*|Le terme\s+\*\*(.+?)\*\*\s+désigne\s+)(.+?)\.\s+([A-ZÀ-Þ].*)$/);
AV
    /* Les deux langues : « Consultez … Retenez **mot** : … ? » et
       « See … Remember **word**: … ? ». Les groupes restent aux memes
       rangs — les variantes sont non capturantes. */
    /^(?:Consultez|Révisez|See|Review)\s+(.+?)\.\s*(?:(?:Retenez|Remember)\s+\*\*(.+?)\*\*\s*:\s*|(?:Le terme\s+\*\*(.+?)\*\*\s+désigne|The term\s+\*\*(.+?)\*\*\s+means)\s+)(.+?)\.\s+([A-ZÀ-Þ].*)$/);
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-46s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

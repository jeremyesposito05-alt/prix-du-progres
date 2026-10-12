#!/usr/bin/perl
# LES LETTRES EXPLIQUENT, AU LIEU DE DEFINIR
#
#   perl _outils/liens.pl index.html
#
# CE QU ELLES ETAIENT. Les soixante avaient la meme forme : « Consultez
# X. Retenez **mot** : definition. Question ? » Trois fentes, et le
# lien avec le cours tenait tout entier dans une definition de
# dictionnaire. L eleve recevait du vocabulaire, pas une explication.
#
# CE QU ON AJOUTE. Un paragraphe « Le lien avec le cours », deux
# phrases, avant le mot. La premiere rappelle ce que la classe a vu
# sur ce point precis ; la seconde dit ce que l affaire du jour en
# montre, du cote de la decision. Jamais plus de deux phrases : ce qui
# manquait etait l explication, pas la longueur.
#
# ET LA PREMIERE LETTRE SE PRESENTE. Elle disait seulement « je vous
# glisserai un mot avant chaque decision ». Elle dit maintenant qui
# ecrit, et ce que ces courriers feront — et surtout ce qu ils ne
# feront pas : ils ne disent jamais quoi choisir.
#
# L ORDRE COMPTE. Le lien explique, le mot nomme, la question fait
# trancher. Mettre la definition en tete revenait a nommer avant d
# avoir explique.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

# ================= les trente liens de Manchester =================
my %LIEN = (
"01" => "En classe, la carte montrait Manchester posée au bord d’un bassin houiller. Ce voisinage ne suffit pourtant pas : entre la mine et la machine il reste la route, et c’est elle qui fixe le prix.",
"02" => "La carte reliait Manchester au port de Liverpool. Cette ligne n’apporte pas du tissu : elle fait entrer le coton brut et sortir le tissu fini. Sans elle, la filature tourne à vide.",
"03" => "La roue hydraulique obligeait l’usine à rester au bord de la rivière. La vapeur la libère : elle peut désormais s’installer là où sont le charbon et les ouvriers. C’est ce déplacement qui fabrique la ville.",
"04" => "Le graphique de population montait sans qu’on voie pourquoi. Le voici : des terres communes fermées, des familles qui n’ont plus de quoi vivre à la campagne, et plus que leur salaire à vendre.",
"05" => "La trace écrite 1 listait les conditions de l’industrialisation : le charbon, les machines, les bras. Il en manque une qu’on oublie souvent — des acheteurs. Sans eux, doubler les machines ne sert à rien.",
"06" => "La trace écrite 1 énumérait les conditions nécessaires, mais elles ne pèsent pas toutes pareil. Ici le charbon, les machines et les bras sont là : il manque la seule qu’on ne peut pas se procurer soi-même.",
"07" => "Avant, on filait chez soi, à son rythme. La filature rassemble les machines sous un même toit et un même moteur : ce n’est pas seulement plus grand, c’est un autre travail, réglé par la machine.",
"08" => "Le paysan travaillait du lever au coucher, selon la saison. L’usine ne dépend ni du jour ni du temps : l’horloge remplace le soleil, et la journée peut s’allonger parce qu’une commande l’exige.",
"09" => "Les documents 4 et 5 décrivaient les dangers de l’atelier. Ils ne tombent pas au hasard : sous la machine on envoie le corps le plus petit, donc l’enfant — dont la famille a besoin du salaire.",
"10" => "Le tisserand savait faire la pièce entière. Avec la division du travail, chacun ne fait plus qu’un geste : la production monte, mais un ouvrier qui ne sait qu’un geste se remplace en une heure.",
"11" => "Rassembler tout le travail sous un toit, c’est aussi rassembler tout le risque. Quand l’atelier à domicile brûlait, une famille perdait son revenu ; quand l’usine brûle, c’est un quartier entier.",
"12" => "La trace écrite 2 §3 montrait l’État qui commence à intervenir. Une loi n’est pourtant qu’un texte tant que personne ne vient vérifier : c’est le contrôle, pas le texte, qui change la vie des enfants.",
"13" => "Un salaire ne se juge pas en chiffres mais en ce qu’il permet d’acheter. Quand le pain monte et que le salaire ne bouge pas, l’ouvrier s’appauvrit sans qu’on lui ait rien retiré.",
"14" => "On dit la mécanisation inévitable, mais elle a des perdants précis, et ils le savent. Ces tisserands ne cassent pas des machines par ignorance : ils cassent ce qui leur a pris leur métier.",
"15" => "Engels décrivait des maisons serrées, sans cour ni évacuation. Elles ne sont pas mal bâties par hasard : elles sont bâties vite et au plus bas prix, pour loger des ouvriers tout près de l’usine.",
"16" => "Habiter une cave n’est pas un choix : c’est ce qui reste quand la ville grandit plus vite que ses maisons. Fermer la cave supprime le logement, pas le besoin de se loger.",
"17" => "La condition de travail se joue dans l’usine ; la condition de vie, dehors. Les eaux sales qui stagnent tuent autant que la machine, et elles ne coûtent rien à personne tant qu’on ne les regarde pas.",
"18" => "On ne savait pas encore que l’eau sale transmet la maladie. On voyait seulement que les mêmes ruelles mouraient plus que les autres : l’épidémie suit la carte des logements, pas celle des personnes.",
"19" => "Le document 3 donnait une courbe de population. L’urbanisation, c’est ce que cette courbe produit au sol : des gens arrivent plus vite qu’on ne bâtit, et c’est cet écart qui fait l’entassement.",
"20" => "Une ville qui grandit doit choisir ce qu’elle met sur chaque mètre carré. Un entrepôt rapporte, un jardin ne rapporte rien et se voit tout de suite : l’urbanisation est une suite de ces arbitrages.",
"21" => "Avant l’État, c’est la charité qui soignait les pauvres — quand elle le voulait, et où elle le voulait. La question du §3 est exactement celle-ci : qui doit s’en charger, et avec quel argent ?",
"22" => "Le tableau de Wyld a été peint après la visite royale, et il montre une ville propre. Ce n’est pas un mensonge, c’est un point de vue choisi : une image de ville dit d’abord ce qu’on a décidé de montrer.",
"23" => "Le document 4 est le récit d’une voyageuse, donc de ce qu’on a bien voulu lui faire voir. Savoir quelle usine on lui montre, c’est savoir ce que vaut son témoignage.",
"24" => "L’Allemand qui prend des notes dans Ancoats, c’est Engels : le document 5 vient de là. Vous décidez maintenant s’il voit les caves, c’est-à-dire ce que l’histoire retiendra de Manchester.",
"25" => "Peindre Manchester depuis une colline verte, c’est montrer les cheminées au loin et cacher ce qui se passe dessous. Le document 2 est exactement cela : une image vraie et incomplète à la fois.",
"26" => "Les lois du §3 ne sont pas tombées du ciel : elles viennent d’enquêtes, de rapports, de gens qui ont parlé en public. Avant de légiférer, il a fallu que quelqu’un prenne le risque de décrire.",
"27" => "Manchester fabriquait une part de la richesse du pays et n’envoyait aucun député au Parlement. L’inégalité n’est pas qu’une affaire de salaire : c’est aussi le droit de peser sur les décisions.",
"28" => "Les fabricants réclament le pain bon marché au nom des ouvriers, et refusent la hausse de salaire que ces mêmes ouvriers demandent. Les deux tiennent ensemble : un pain moins cher évite d’augmenter les salaires.",
"29" => "Le §3 montrait l’État qui prend la main sur l’hygiène. Il n’y a pas d’argent public sans contrôle public : accepter les fonds de Londres, c’est accepter que Londres regarde comment la ville les dépense.",
"30" => "1851 est la date de bilan du cours. L’Exposition célèbre les machines et les tissus ; la question est de savoir si l’on montre aussi ce qu’ils ont coûté. C’est tout le sujet de l’unité.",
);

# ================= pose des liens sur les cartes =================
my $de  = index($s, "const CARTES_I = [");
$de >= 0 or die "ARRET : CARTES_I introuvable\n";
my $fin = index($s, "\n];\n", $de);
my $tete = substr($s, 0, $de);
my $bloc = substr($s, $de, $fin - $de);
my $queue = substr($s, $fin);

my @cartes = split /\n\n(?=\{)/, $bloc;
$cartes[0] =~ s/^const CARTES_I = \[\n// or die "ARRET : en-tete du tableau\n";

my (@mal, @neuves, $posees, $vues);
for my $c (@cartes){
  unless($c =~ /\S/){ push @neuves, $c; next }
  my ($n) = $c =~ /^\{n:"(\d+)"/;
  unless(defined $n){ push @neuves, $c; next }
  $vues++;
  my $t = $LIEN{$n};
  unless($t){ push @mal, "carte $n : pas de lien ecrit"; push @neuves, $c; next }
  if($c =~ /\n li:"/){ push @mal, "carte $n : elle a deja un lien"; push @neuves, $c; next }
  push @mal, "carte $n : guillemet droit dans le lien" if $t =~ /"/;
  push @mal, "carte $n : apostrophe droite dans le lien" if $t =~ /'/;
  my $neuf = $c;
  unless($neuf =~ s/(\n l:"[^"]*",)\n/$1\n li:"$t",\n/){
    push @mal, "carte $n : impossible d'y poser le lien";
    push @neuves, $c; next;
  }
  $posees++;
  push @neuves, $neuf;
}
if(@mal){
  print "\n  REFUS — rien n'a ete ecrit :\n";
  print "    · $_\n" for @mal;
  die sprintf "\n  %d probleme(s) sur %d cartes.\n", scalar(@mal), $vues;
}
$neuves[0] = "const CARTES_I = [\n" . $neuves[0];
$s = $tete . join("\n\n", @neuves) . $queue;

# ================= la lettre change de forme =================
my @T;
sub ech { push @T, [ @_ ] }

ech("la premiere lettre se presente et dit son objet", <<'AV', <<'AP');
  const premiere = !(E.lettresLues || []).length;
  const intro = premiere ? `<p class="cp-ouverture">Je vous glisserai un mot avant
      chaque décision — juste de quoi relier ce qui arrive sur votre bureau à ce que
      nous avons vu en classe.</p>` : "";
AV
  const premiere = !(E.lettresLues || []).length;
  /* La toute premiere dit qui ecrit, ce que ces courriers font, et
     surtout ce qu'ils ne font pas. Un eleve qui croit y trouver la
     bonne reponse ne les lit plus des qu'il a compris que non. */
  const intro = premiere ? `<div class="cp-ouverture">
      <p>Bonjour. Je suis M. Esposito, votre professeur d’histoire. C’est moi qui ai
      écrit les affaires que vous allez trancher, et toutes sont tirées de ce que
      ${esc(N.lieu)} a réellement vécu.</p>
      <p>Je vous glisserai un mot avant chaque décision. Il ne vous dira jamais quoi
      choisir : il vous rappelle ce que nous avons vu en classe sur ce point, vous
      donne le mot qui le nomme, et vous pose la question à se poser avant de
      trancher.</p></div>` : "";
AP

ech("le lien avec le cours passe avant le mot", <<'AV', <<'AP');
  const corps = d ? `
      <div class="cp-notion">
AV
  /* L'ORDRE : le lien explique, le mot nomme, la question fait
     trancher. Nommer avant d'avoir explique, c'etait donner du
     vocabulaire et appeler cela un lien avec le cours. */
  const lien = E.carte.li
    ? `<p class="cp-lien"><span>Le lien avec le cours</span>${esc(E.carte.li)}</p>`
    : "";

  const corps = d ? `
      ${lien}
      <div class="cp-notion">
AP

ech("une lettre non decoupee garde son lien", <<'AV', <<'AP');
    : `<p class="cp-q">${gras(esc(E.carte.l))}</p>`;
AV
    : `${lien}<p class="cp-q">${gras(esc(E.carte.l))}</p>`;
AP

ech("css : le lien avec le cours", <<'AV', <<'AP');
/* ---------- LE CURSEUR DE LA MACHINE A ECRIRE ----------
AV
/* ---------- LE LIEN AVEC LE COURS ----------
   Deux phrases, du texte courant, pas un encart : c'est ce qu'on lit
   d'abord et le plus longtemps. L'intitule est une petite capitale
   au-dessus, qui n'enleve pas de place a la ligne. */
.cp-lien{margin:0 0 15px; font-size:15.5px; line-height:1.55; color:#3A2D1F}
.cp-lien span{display:block; margin:0 0 4px;
  font-family:var(--sans); font-size:10.5px; letter-spacing:.13em;
  text-transform:uppercase; color:var(--rge)}
.cp-ouverture{margin:0 0 15px; padding:0 0 13px;
  border-bottom:1px solid rgba(107,87,65,.3)}
.cp-ouverture p{margin:0 0 8px; font-size:15px; line-height:1.5; color:#3A2D1F}
.cp-ouverture p:last-child{margin:0}

/* ---------- LE CURSEUR DE LA MACHINE A ECRIRE ----------
AP

my $mauvais = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-50s %d occurrence(s)\n", $nom, $n; $mauvais++ }
}
die "\nARRET : $mauvais sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mauvais;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d liens poses sur %d cartes · %d remplacements\n",
  $posees, $vues, scalar(@T);

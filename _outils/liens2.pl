#!/usr/bin/perl
# LES TRENTE LIENS DE DETROIT
#
#   perl _outils/liens2.pl index.html
#
# Memes regles qu a Manchester : deux phrases, jamais plus. La
# premiere rappelle ce que la classe a vu sur ce point precis, la
# seconde dit ce que l affaire du jour en montre du cote de la
# decision. Plusieurs renvoient explicitement au niveau I — c est le
# meme cours, cent ans plus tard, et l eleve doit voir le fil.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my %LIEN = (
"01" => "Manchester achetait son coton à d’autres. Ici l’usine veut fabriquer jusqu’à son propre acier : ne plus dépendre d’un fournisseur, c’est maîtriser son prix, et c’est une étape de plus de l’industrialisation.",
"02" => "Un siècle plus tôt, on s’installait près de la rivière, puis près du charbon. Le choix reste le même : produire en masse exige d’abord un endroit où faire entrer les matières et sortir les voitures.",
"03" => "Une voiture de luxe se vend cher à peu de gens ; une voiture simple se vend peu cher à beaucoup. La production de masse suppose ce second pari, et il faut le faire avant de savoir s’il est gagné.",
"04" => "Six modèles, c’est six fois des pièces différentes et six fois des gestes à réapprendre. La standardisation commence ici : un seul modèle, donc des pièces identiques, donc un geste qu’on peut répéter.",
"05" => "Les ateliers savent déjà construire des voitures : l’innovation n’est pas d’inventer l’automobile. Elle est de changer la façon de la fabriquer, pour en faire beaucoup à un prix que l’on puisse payer.",
"06" => "Tant qu’une pièce doit être retaillée pour entrer, aucune chaîne ne peut tourner. La standardisation n’est pas un détail technique : c’est la condition sans laquelle le travail à la chaîne est impossible.",
"07" => "Avant, l’ouvrier se déplaçait autour de la voiture. Avec la chaîne, c’est la voiture qui vient à lui : il ne perd plus un pas, et il ne décide plus du moment où il travaille.",
"08" => "Douze heures de montage ramenées à quatre-vingt-treize minutes : c’est le chiffre du cours. Ce gain n’est pas pris sur la machine mais sur le temps de l’ouvrier, qui n’a plus une seconde à lui.",
"09" => "C’est l’idée de Manchester poussée plus loin. Le métier se décompose jusqu’au geste unique : on forme en une heure, on remplace en une heure, et l’ouvrier ne vaut plus par son savoir-faire.",
"10" => "Le chef ne commande plus en criant : il règle la vitesse du tapis. La cadence est une autorité sans voix, et c’est ce qui la rend si difficile à discuter.",
"11" => "Interdire de parler et de s’asseoir n’est pas de la discipline pour la discipline : c’est tenir la cadence. Le règlement fait sur le corps ce que le tapis fait sur le rythme.",
"12" => "Quand un travail n’a plus de sens, on le quitte. Ces départs incessants ne sont pas un caprice : ils sont la mesure la plus honnête de ce que le cours appelle l’aliénation.",
"13" => "Cinq dollars par jour, c’est le double. Mais Ford n’est pas généreux : il paie assez pour qu’on reste malgré la chaîne, et assez pour que l’ouvrier puisse acheter la voiture qu’il fabrique.",
"14" => "Un travail découpé en gestes simples n’exige plus ni la force ni le métier. Cela ouvre l’usine à des gens qu’on en écartait, et cette ouverture vient de la division du travail qui l’a appauvri.",
"15" => "Le noir n’est pas un goût : c’est la seule peinture qui sèche à la vitesse de la chaîne. La standardisation ne décide pas seulement des pièces, elle décide jusqu’à la couleur.",
"16" => "Baisser le prix fait entrer de nouveaux acheteurs, qui permettent de produire plus, donc de baisser encore. C’est ce cercle que le cours appelle la société de consommation.",
"17" => "Le crédit fait acheter ceux qui n’ont pas l’argent. Il élargit le marché, et il engage l’acheteur sur des mois : il transforme un achat en dette.",
"18" => "Tant que la voiture était rare, le prix suffisait. Dès qu’elle est répandue, l’acheteur compare autre chose : la nouveauté devient un argument, et le modèle unique devient un handicap.",
"19" => "La publicité ne vend pas une voiture, elle vend ce qu’elle promet — ici, la liberté. Dans une société de consommation, l’objet porte une image autant qu’un usage.",
"20" => "Produire en masse suppose d’acheter en masse. Quand les acheteurs manquent, la machine ne s’arrête pas d’elle-même : elle continue de remplir les entrepôts, et c’est là que la crise commence.",
"21" => "La force du modèle unique devient sa faiblesse : tout l’outillage a été fait pour lui. Changer de modèle oblige à arrêter les ateliers — la standardisation coûte cher le jour où il faut en sortir.",
"22" => "Donner un jour de plus, c’est donner du temps pour dépenser. Le fordisme tient en cela : l’ouvrier bien payé et un peu libéré devient le client de ce qu’il fabrique.",
"23" => "L’aliénation n’est pas une idée abstraite : c’est ce que cette ouvrière décrit. Le cours vous donne le mot ; elle, elle vous dit ce qu’il y a derrière.",
"24" => "Faire tourner les postes rend le travail supportable et la chaîne plus lente. Tout le problème du §4 est là : ce qui soulage l’ouvrier coûte à la production.",
"25" => "Travailler sans jamais voir ce qu’on fabrique, c’est exactement ce que le mot aliénation désigne. Montrer la voiture finie ne change pas le geste, mais lui rend un sens.",
"26" => "Ford décrit le travail ouvrier depuis son bureau. Sa perspective n’est pas fausse, elle est située : il a intérêt à croire que la répétition convient à ceux qu’il emploie.",
"27" => "Se réunir pour discuter son salaire, c’est ce que les ouvriers de Manchester réclamaient déjà. Un siècle plus tard la question revient, et elle se joue encore sur le trottoir devant l’usine.",
"28" => "Les usines du Nord embauchaient, et des centaines de milliers d’Afro-Américains ont quitté le Sud pour ces emplois. L’inégalité ne les empêchait pas d’entrer : elle décidait à quel poste.",
"29" => "Le krach ne casse aucune machine : il supprime les acheteurs. On découvre alors que produire en masse rend fragile en masse, puisque tout dépend d’une demande qui peut disparaître.",
"30" => "La ville qui avait fabriqué la voiture du monde entier ne nourrit plus les siens. C’est la question de bilan de l’unité : le progrès technique profite-t-il à ceux qui l’ont fabriqué ?",
);

my $de  = index($s, "const CARTES_II = [");
$de >= 0 or die "ARRET : CARTES_II introuvable\n";
my $fin = index($s, "\n];\n", $de);
my $tete = substr($s, 0, $de);
my $bloc = substr($s, $de, $fin - $de);
my $queue = substr($s, $fin);

my @cartes = split /\n\n(?=\{)/, $bloc;
$cartes[0] =~ s/^const CARTES_II = \[\n// or die "ARRET : en-tete du tableau\n";

my (@mal, @neuves, $posees, $vues);
for my $c (@cartes){
  unless($c =~ /\S/){ push @neuves, $c; next }
  my ($n) = $c =~ /^\{n:"(\d+)"/;
  unless(defined $n){ push @neuves, $c; next }
  $vues++;
  my $t = $LIEN{$n};
  unless($t){ push @mal, "carte $n : pas de lien ecrit"; push @neuves, $c; next }
  if($c =~ /\n li:"/){ push @mal, "carte $n : elle a deja un lien"; push @neuves, $c; next }
  push @mal, "carte $n : guillemet droit"  if $t =~ /"/;
  push @mal, "carte $n : apostrophe droite" if $t =~ /'/;
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
$neuves[0] = "const CARTES_II = [\n" . $neuves[0];
$s = $tete . join("\n\n", @neuves) . $queue;

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "  %d liens poses sur %d cartes\n", $posees, $vues;

#!/usr/bin/perl
# LE RESIDU FRANCAIS DU JEU ANGLAIS
#
#   perl _outils/reste-anglais.pl index-en.html
#
# Deux passes ont traduit les donnees (931) et l'interface (126). Restent
# les chaines qui vivent dans le CODE et non dans un gabarit :
# « Juste », « Faux », « Grace a », « au bord de la rupture ». Un
# extracteur les saute expres, parce qu'une chaine de code peut etre une
# cle — c'est cette prudence qui a evite de casser le jeu, et c'est elle
# qui laisse ce residu. On les traite donc une par une, nommees.
#
# CE QU ON NE TOUCHE PAS, ET POURQUOI :
#   — « Main-d'oeuvre » est une des sept CLES de condition ;
#   — les fragments contenant ${...} ou } sont des morceaux de code
#     attrapes par erreur, pas du texte ;
#   — « COLLEGE ALPIN BEAU SOLEIL » est un nom propre.
#
# Rien n'est ecrit tant que TOUTES les chaines n'ont pas ete retrouvees :
# une seule qui manque trahit une erreur de recopie, et il vaut mieux
# tout arreter que remplacer a moitie.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift or die "usage: reste-anglais.pl <index-en.html>\n";
open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
local $/; my $s = <$h>; close $h;
$s =~ s/\x0D\x0A/\n/g;

# Les caracteres non ASCII, nommes : une chaine entre guillemets simples
# n'interprete pas les echappements.
my $AP = "\x{2019}";   # ’
my $OE = "\x{0153}";   # œ
my $TD = "\x{2014}";   # —
my $GO = "\x{00AB}";   # «
my $GF = "\x{00BB}";   # »
my $QO = "\x{201C}";   # “
my $QF = "\x{201D}";   # ”

# ---- la table : le francais tel qu'il est, l'anglais voulu -----------
# L'ordre compte : une chaine courte contenue dans une plus longue doit
# venir APRES elle, sinon elle la couperait en deux.
my @table = (
  # le bandeau de son
  [ "Couper le son",    "Mute" ],
  [ "R\x{E9}tablir le son", "Unmute" ],

  # l'alerte quand une force s'effondre
  [ "Vous allez perdre", "You are about to lose" ],
  [ "l${AP}une de ces forces tombe", "one of these forces falls" ],
  [ "cette force tombe", "this force falls" ],
  [ "au bord de la rupture", "on the brink" ],

  # la consequence differee
  [ "Gr\x{E2}ce \x{E0}", "Thanks to" ],
  [ "\x{C0} cause de", "Because of" ],

  # le chronometre
  [ "Le temps a d\x{E9}cid\x{E9} \x{E0} votre place.", "Time has decided for you." ],

  # les affaires datees
  [ "La gr\x{E8}ve des bouchons", "The Plug Plot strike" ],
  [ "Les briseurs de m\x{E9}tiers", "The machine breakers" ],
  [ "L${AP}incendie de la Triangle Shirtwaist", "The Triangle Shirtwaist fire" ],

  # le reproche de decider sans lire
  [ "vos derni\x{E8}res affaires", "your recent cases" ],
  [ "$GO Je tranche sans ouvrir les dossiers. $GF",
    "${QO}I decide without opening the files.${QF}" ],
  [ " rapports que vous n${AP}avez pas ouverts. ",
    " reports you did not open. " ],
  [ "Vous n${AP}en avez consult\x{E9} que ", "You consulted only " ],
  [ "Vous n${AP}en avez consult\x{E9} aucun. ", "You consulted none of them. " ],
  [ "On commence \x{E0} dire en ville que vous d\x{E9}cidez sans savoir $TD et ce que cela vous a ",
    "People are starting to say in town that you decide without knowing $TD and what that has " ],
  [ "co\x{FB}t\x{E9} finit par se voir.", "cost you shows in the end." ],
  [ "d\x{E9}cision, quitte \x{E0} vous faire perdre du temps.",
    "decision, even if it costs you time." ],

  # l'ecran de fin
  [ "Ceux qui vous ont l\x{E2}ch\x{E9}", "Those who abandoned you" ],
  [ "Votre appui jusqu${AP}au bout", "Your support to the end" ],
  [ "Ceux qui ont le plus pay\x{E9}", "Those who paid the most" ],
  [ "Vous \x{EA}tes all\x{E9} jusqu${AP}au bout de la p\x{E9}riode.",
    "You reached the end of the period." ],
  [ "Vous les avez toutes r\x{E9}unies.", "You brought them all together." ],
  [ "Vous n${AP}en avez r\x{E9}uni aucune : la ville n${AP}a jamais vraiment bascul\x{E9}.",
    "You brought none of them together: the city never really made the leap." ],
  [ "Men\x{E9}e jusqu${AP}au bout de la p\x{E9}riode.", "Carried through to the end of the period." ],
  [ "Men\x{E9}e jusqu${AP}au bout.", "Carried through to the end." ],
  [ "Jamais jou\x{E9}", "Never played" ],

  # les courbes
  [ "Courbe de la ", "Curve of " ],
  [ "\x{C9}volution des quatre forces au fil de la partie",
    "How the four forces changed over the game" ],
  [ "sans r\x{E9}ponse", "no answer" ],

  # l'humeur des acteurs
  [ "Tr\x{E8}s satisfaits", "Very satisfied" ],
  [ "Plut\x{F4}t contents", "Rather pleased" ],
  [ "Tr\x{E8}s m\x{E9}contents", "Very unhappy" ],

  # les deux vues de la mission
  [ "La ville qu${AP}on montre : les quais, le coton, les trains.",
    "The city on show: the quays, the cotton, the trains." ],
  [ "L${AP}usine qu${AP}on fait visiter : la cha\x{EE}ne, les voitures, le salaire.",
    "The factory on show: the line, the cars, the wage." ],

  # la trace de travail, en texte
  [ "LE PRIX DU PROGR\x{C8}S $TD trace de travail",
    "THE PRICE OF PROGRESS $TD work record" ],
  [ "R\x{C9}SULTAT DE LA PARTIE", "GAME RESULT" ],
  [ "  D\x{E9}cisions prises : ", "  Decisions made: " ],
  [ "  Conditions r\x{E9}unies : ", "  Conditions met: " ],
  [ "  Rapports d${AP}enqu\x{EA}te consult\x{E9}s : ", "  Inquiry reports viewed: " ],
  [ "CE QUE J${AP}AI RETENU  $TD  ", "WHAT I LEARNED  $TD  " ],
  [ "      ma r\x{E9}ponse : ", "      my answer: " ],
  [ "      r\x{E9}ponse attendue : ", "      expected answer: " ],
  [ "MA R\x{C9}FLEXION", "MY REFLECTION" ],
  [ "  La d\x{E9}cision dont je suis le plus s\x{FB}r :",
    "  The decision I am most confident about:" ],
  [ "  La d\x{E9}cision que je regrette :", "  The decision I regret:" ],
  [ "  Ce que cette partie m${AP}apprend sur le progr\x{E8}s industriel :",
    "  What this game teaches me about industrial progress:" ],
  [ "MON AVIS SUR LE JEU", "MY OPINION OF THE GAME" ],
  [ "  Un moment o\x{F9} j${AP}\x{E9}tais perdu ou ennuy\x{E9} :",
    "  A moment when I felt lost or bored:" ],
  [ "  \x{C0} ajouter, retirer ou corriger :", "  To add, remove or correct:" ],
  [ "  ann\x{E9}e   ", "  year    " ],

  # les messages apres une action
  [ "Copi\x{E9}. Vous pouvez le coller dans un document ou dans Teams.",
    "Copied. You can paste it into a document or into Teams." ],
  [ "La copie a \x{E9}chou\x{E9} $TD utilisez $GO T\x{E9}l\x{E9}charger $GF.",
    "Copying failed $TD use ${QO}Download${QF}." ],
  [ "Document t\x{E9}l\x{E9}charg\x{E9}. Il s${AP}ouvre dans Word.",
    "Document downloaded. It opens in Word." ],
  [ "\x{C9}crivez d${AP}abord votre nom", "Enter your name first" ],
  [ "Corrigez d${AP}abord le questionnaire", "Mark the quiz first" ],
  [ "Enregistrez d${AP}abord votre trace", "Save your work first" ],
  [ "Cochez la case ci-dessus", "Tick the box above" ],

  # la correction du questionnaire
  [ "Le questionnaire n${AP}a pas \x{E9}t\x{E9} corrig\x{E9}.", "The quiz has not been marked." ],
  [ "Juste", "Just" ],
  [ "Faux", "Wrong" ],

  # ce qui reste des gabarits : des bouts de phrase sans balise
  # La phrase est coupee par un retour a la ligne du source : on traite
  # les deux moities separement plutot que de deviner l'indentation.
  [ "\x{E0} z\x{E9}ro, la partie s${AP}arr\x{EA}te", "to zero, the game ends" ],
  [ "imm\x{E9}diatement $TD", "immediately $TD" ],
  [ "Le bureau d${AP}enqu\x{EA}te a joint une note.", "The inquiry office has attached a note." ],
  [ "D\x{E9}cision urgente $TD", "Urgent decision $TD" ],
  [ "votre choix d${AP}il y a", "your choice" ],
  [ "tour\x{24}{ecart>1?\"s\":\"\"}", "turn\x{24}{ecart>1?\"s\":\"\"} ago" ],
  [ "\x{E0} l${AP}affaire $GO ", "on the case ${QO}" ],
  [ "La population passe de", "The population rises from" ],
  [ "habitants. Les logements ne suivent jamais le rythme des usines $TD et ce sont les ouvriers qui s${AP}entassent.",
    "inhabitants. Housing never keeps pace with the factories $TD and it is the workers who end up crowded together." ],
  [ "La production passe de", "Production rises from" ],
  [ "voitures par an. La cha\x{EE}ne, elle, suit le rythme ; les hommes beaucoup moins.",
    "cars per year. The line keeps pace; the men much less so." ],
  [ "Votre r\x{E9}ponse :", "Your answer:" ],
  [ "Le prix du progr\x{E8}s $TD", "The price of progress $TD" ],
  [ "d\x{E9}cisions jusqu${AP}en", "decisions until" ],
  [ "C${AP}est ce qui rendra la fin de partie difficile.",
    "That is what will make the end of the game difficult." ],
  [ "Survie", "Survival" ],
  [ "d\x{E9}cision ", "decision " ],
  [ " r\x{E9}ponse", " answer" ],

  # RETIREES, ET A NE PAS REMETTRE TELLES QUELLES.
  #   [ "les ", "the " ]   a frappe 118 fois : « les » est aussi la fin
  #                        de « files », « rules », « tables »…
  #   [ " sur ", " of " ]  a frappe 61 fois, bien au-dela du francais.
  # Ces deux-la ne peuvent pas se traiter par substitution de texte :
  # « les » sort de `"les "+n` et « sur » de `${a} sur ${b}`. Il faut les
  # corriger a la main, chacune a sa place, en lisant le code autour.
);

# ---- phase 1 : tout verifier avant d'ecrire ---------------------------
my (@absents, @faits);
for my $e (@table){
  my ($av) = @$e;
  my $n = () = $s =~ /\Q$av\E/g;
  push @absents, $av unless $n;
}
if(@absents){
  printf "  ARRET - rien n'a \x{E9}t\x{E9} \x{E9}crit. %d cha\x{EE}ne(s) introuvable(s) :\n", scalar @absents;
  printf "    %s\n", $_ for @absents;
  exit 1;
}

# ---- phase 2 : remplacer ---------------------------------------------
for my $e (@table){
  my ($av, $ap) = @$e;
  my $n = ($s =~ s/\Q$av\E/$ap/g);
  push @faits, sprintf("%3d \x{D7}  %s", $n, length($av) > 56 ? substr($av,0,53)."..." : $av);
}

open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";
print $o $s; close $o;
print "  $_\n" for @faits;
printf "\n  %d cha\x{EE}nes trait\x{E9}es, %d octets\n", scalar(@table), -s $f;

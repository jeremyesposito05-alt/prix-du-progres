#!/usr/bin/perl
# ADAPTER L EN-TETE DES FICHIERS DE DETROIT
#
#   perl _outils/detroit-entete.pl _a-installer/refonte-detroit
#
# « prompt-cartes.pl » ecrit l'en-tete de Manchester : le lieu, la
# periode et les quatre forces. Detroit n'a ni les memes acteurs ni la
# meme epoque — ce sont des actionnaires, des clients et une opinion
# publique, pas un Parlement et des marchands. On corrige l'en-tete une
# fois les fichiers produits, plutot que de parametrer le generateur :
# deux remplacements exacts valent mieux qu'une mecanique de plus.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $dos = shift or die "usage: detroit-entete.pl <dossier>\n";
my @f = sort glob("$dos/cartes-*.md");
@f or die "ARRET : aucun fichier dans $dos\n";

# Les fichiers engendres portent l'apostrophe DROITE, celle du heredoc de
# « prompt-cartes.pl », et non la courbe : chercher la courbe ne trouvait
# rien, et seul le remplacement du lieu passait.
my $AP = "'";
my $av_lieu = "Le joueur dirige **Manchester entre 1780 et 1851**.";
my $ap_lieu = "Le joueur dirige **l${AP}usine Ford, a Detroit, entre 1908 et 1932**.";

my $av_f = "| **Les industriels** | des machines, du charbon, des bras |\n"
         . "| **Les ouvriers** | un salaire, un toit, des heures vivables |\n"
         . "| **Les marchands** | des canaux, des rails, des d\x{E9}bouch\x{E9}s |\n"
         . "| **Le Parlement** | l${AP}ordre public et la salubrit\x{E9} |";
my $ap_f = "| **Les actionnaires** | du rendement, des dividendes, une usine qui ne s${AP}arr\x{EA}te jamais |\n"
         . "| **Les ouvriers** | une cadence tenable, un salaire, le droit de s${AP}organiser |\n"
         . "| **Les clients** | une voiture fiable, bon march\x{E9}, qu${AP}on ait envie d${AP}acheter |\n"
         . "| **L${AP}opinion** | des comptes, de la d\x{E9}cence \x{2014} et bient\x{F4}t des lois |";

# Le ton d'epoque change aussi : on ne parle pas de 1830 comme de 1913.
my $av_ana = "9. **Pas d${AP}anachronisme** : ni \x{AB} rentabilit\x{E9} \x{BB}, ni \x{AB} productivit\x{E9} \x{BB}, ni \x{AB} ressources\n   humaines \x{BB} dans la bouche de quelqu${AP}un de 1830.";
my $ap_ana = "9. **Pas d${AP}anachronisme** : on est aux \x{C9}tats-Unis entre 1908 et 1932. \x{AB} Productivit\x{E9} \x{BB}\n   et \x{AB} rendement \x{BB} se disent d\x{E9}j\x{E0} ; \x{AB} ressources humaines \x{BB}, \x{AB} management \x{BB} et\n   \x{AB} burn-out \x{BB} non. Les personnages disent \x{AB} dollars \x{BB}, pas \x{AB} euros \x{BB}.";

my $faits = 0;
for my $f (@f){
  open my $h, "<:encoding(UTF-8)", $f or die "$f: $!"; local $/;
  my $s = <$h>; close $h;
  my $n = 0;
  $n += ($s =~ s/\Q$av_lieu\E/$ap_lieu/g);
  $n += ($s =~ s/\Q$av_f\E/$ap_f/g);
  $n += ($s =~ s/\Q$av_ana\E/$ap_ana/g);
  $n == 3 or die "ARRET - $f : $n remplacements sur 3\n";
  $s =~ s/Dialogues des quatre acteurs \x{2014} Manchester/Detroit/g;
  open my $o, ">:encoding(UTF-8)", $f or die "$f: $!";
  print $o $s; close $o;
  $faits++;
}
printf "  %d fichier(s) adapt\x{E9}s \x{E0} Detroit\n", $faits;

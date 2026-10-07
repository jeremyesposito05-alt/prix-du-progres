#!/usr/bin/perl
# FAIRE ECRIRE LES TRENTE NOUVELLES CARTES
#
#   perl _outils/prompt-cartes.pl _a-installer/refonte/situations.tsv _a-installer/refonte
#
# POURQUOI ON REPART DE ZERO. Les vingt cartes actuelles ont ete ecrites
# avant qu'on ait lu le cours. Resultat mesure : le jeu mettait en gras
# 74 notions dont 64 absentes du vocabulaire du professeur — dont les
# sept conditions, qui sont pourtant son mecanisme central. Les eleves
# n'avaient pas tort de trouver le vocabulaire trop lourd : ce
# n'etaient pas leurs mots.
#
# Chaque carte part donc d'une SITUATION DU COURS, porte UN mot du
# vocabulaire du professeur et UN concept de G11.
#
# LA LETTRE REMPLACE LE RAPPORT D'ENQUETE, elle ne s'y ajoute pas. Une
# campagne fait deja 10 800 caracteres a lire, 16 600 en depliant les
# rapports ; vingt lettres de plus en ajouteraient 8 000. La lettre fait
# mieux que le rapport sur tous les points — elle vient du professeur,
# elle renvoie au cours par une reference precise, elle porte le concept,
# et elle s'ouvre AVANT la decision au lieu d'etre un pave qu'on deplie
# apres.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $src = shift or die "usage: prompt-cartes.pl <situations.tsv> <dossier>\n";
my $dos = shift or die "usage: prompt-cartes.pl <situations.tsv> <dossier>\n";

open(my $h, "<:encoding(UTF-8)", $src) or die "$src: $!";
my @s;
while(my $l = <$h>){
  next if $l =~ /^#/; chomp $l; next unless length $l;
  my @f = split /\t/, $l;
  next unless @f >= 7;
  push @s, { n=>$f[0], groupe=>$f[1], situation=>$f[2], mot=>$f[3],
             comprendre=>$f[4], concept=>$f[5], ancrage=>$f[6] };
}
close $h;
@s or die "ARRET : aucune situation lue\n";

mkdir $dos unless -d $dos;
my $PAR = 5;
my $nbf = int((@s + $PAR - 1) / $PAR);

for my $i (0 .. $nbf-1){
  my $de = $i*$PAR;
  my $a  = $de + $PAR - 1; $a = $#s if $a > $#s;
  my $f = sprintf "%s/cartes-%02d.md", $dos, $i+1;
  open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";

  printf $o <<'TETE', $i+1, $nbf, $a-$de+1;
# Écrire les cartes du jeu — partie %d sur %d (%d situations)

## Le jeu

« Le prix du progrès » est un jeu d'histoire pour des élèves de 15 ans (seconde).
Le joueur dirige **Manchester entre 1780 et 1851**. Une situation arrive sur son bureau,
il choisit une réponse parmi trois, et **chaque réponse contente un groupe et en fâche
un autre**. Quatre groupes le jugent :

| Le groupe | Ce qu'il veut |
|---|---|
| **Les industriels** | des machines, du charbon, des bras |
| **Les ouvriers** | un salaire, un toit, des heures vivables |
| **Les marchands** | des canaux, des rails, des débouchés |
| **Le Parlement** | l'ordre public et la salubrité |

Si l'un d'eux l'abandonne tout à fait, la partie s'arrête. **Le joueur ne voit aucun
chiffre** : il décide parce que c'est ce qu'il pense, puis il découvre.

## Ce que je te demande, pour chaque situation

Six textes. Je te donne la situation, le mot de vocabulaire du cours qu'elle doit faire
travailler, l'idée que l'élève doit comprendre, et le concept d'histoire qu'elle porte.

1. **LETTRE** — une lettre du professeur, qui s'ouvre **avant** le dilemme. C'est elle
   qui rattache la décision au cours. Elle dit, dans cet ordre : *où réviser*, *le mot à
   retenir avec sa définition*, et *la question que l'élève doit se poser en décidant* —
   formulée avec le concept. **80 mots maximum.** Elle tutoie ? Non : **elle vouvoie**,
   comme un professeur qui écrit à sa classe. Signée « J. E. ».
2. **TITRE** — l'ordre du jour, **huit mots maximum**, sans verbe conjugué si possible.
   Exemple de ton : « Le charbon manque à la filature. »
3. **SITUATION** — ce que le joueur doit savoir pour décider. **Deux phrases, pas trois.**
   C'est la règle la plus importante du lot : la classe a trouvé qu'il y avait trop à lire.
4. **QUI** — le nom et la fonction de la personne qui apporte l'affaire. Un nom anglais
   plausible de l'époque, et une fonction en clair : « Josiah Halliwell, propriétaire
   d'une filature de coton ».
5. **REPLIQUE** — ce qu'elle dit, **une phrase**, à la première personne, dans son propre
   intérêt. Pas d'explication historique : elle plaide.
6. **TROIS REPONSES** — chacune en **dix mots maximum**, à la première personne du joueur
   qui tranche (« Qu'on creuse le canal. »). Et pour chacune, **UNE CONSEQUENCE** en une
   phrase : ce qui arrive, en disant le gagnant et le perdant.

## Neuf règles

1. **Vocabulaire d'un élève de 15 ans.** Aucun mot de métier sans qu'il s'explique dans
   la phrase même : jamais « les cardes », mais « les machines qui démêlent le coton ».
   Jamais de renvoi à un lexique.
2. **Des phrases courtes.** Une idée par phrase. Pas de subordonnée dans une subordonnée.
3. **Le mot du cours est mis en gras avec deux astérisques** — `**filature**` — et
   **une seule fois**, dans la lettre. Nulle part ailleurs : le gras est le signal
   « à apprendre », et il ne doit désigner que les mots du cours.
4. **Aucune autre mise en gras.** C'est le défaut qu'on corrige.
5. **Des faits authentiques.** Pas de chiffre inventé. Si tu n'es pas sûr d'une donnée,
   écris la situation sans elle.
6. **Aucune réponse n'est la bonne.** Les trois doivent être défendables. Si l'une est
   manifestement stupide, le dilemme disparaît.
7. **N'emploie jamais le guillemet droit** `"` : il casserait le jeu. Pour citer, emploie
   les chevrons « ».
8. **Ne dis jamais au joueur ce qu'il doit décider**, ni dans la lettre ni ailleurs. La
   lettre donne de quoi penser, pas la réponse.
9. **Pas d'anachronisme** : ni « rentabilité », ni « productivité », ni « ressources
   humaines » dans la bouche de quelqu'un de 1830.

## Comment répondre

Recopie le fichier entier en remplissant les lignes `>>`. Ne touche pas aux numéros entre
crochets, ni aux blocs « LA SITUATION », ni à l'ordre.

---

TETE

  for my $n ($de .. $a){
    my $e = $s[$n];
    printf $o "## LA SITUATION %s  (groupe %s)\n\n", $e->{n}, $e->{groupe};
    printf $o "**Ce qui arrive.** %s\n\n", $e->{situation};
    printf $o "**Le mot du cours à faire travailler.** %s\n\n", $e->{mot};
    printf $o "**Ce que l'élève doit comprendre.** %s\n\n", $e->{comprendre};
    printf $o "**Le concept d'histoire.** %s\n\n", $e->{concept};
    printf $o "**Où c'est dans le cours.** %s\n\n", $e->{ancrage};
    print  $o "**À écrire :**\n\n";
    printf $o "[[%s-LETTRE]]\n>> \n\n", $e->{n};
    printf $o "[[%s-TITRE]]\n>> \n\n", $e->{n};
    printf $o "[[%s-SITUATION]]\n>> \n\n", $e->{n};
    printf $o "[[%s-QUI]]\n>> \n\n", $e->{n};
    printf $o "[[%s-REPLIQUE]]\n>> \n\n", $e->{n};
    for my $k (qw(A B C)){
      printf $o "[[%s-REPONSE%s]]\n>> \n\n", $e->{n}, $k;
      printf $o "[[%s-CONSEQUENCE%s]]\n>> \n\n", $e->{n}, $k;
    }
    print  $o "---\n\n";
  }
  close $o;
}

my %c; $c{$_->{concept}}++ for @s;
my %m; $m{$_->{mot}}++ for @s;
printf "  %d situations, %d fichier(s) de %d dans %s\n", scalar(@s), $nbf, $PAR, $dos;
printf "  %d textes a ecrire (11 par situation)\n", 11 * scalar(@s);
printf "  concepts : %s\n", join(" · ", map { "$_ ($c{$_})" } sort keys %c);
printf "  %d mots du cours distincts\n", scalar keys %m;

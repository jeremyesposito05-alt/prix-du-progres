#!/usr/bin/perl
# FABRIQUER LE PROMPT QUI FERA ECRIRE LES DIALOGUES
#
#   perl _outils/prompt-dialogues.pl <cartes.json> <dossier> [I|II]
#
# La nouvelle mise en page met l'ordre du jour au centre et les quatre
# acteurs autour. Il faut donc, par carte et par acteur, trois repliques
# courtes : ce qu'il reclame AVANT la decision, et sa reaction APRES,
# selon qu'elle lui profite ou lui coute.
#
# POURQUOI LES EFFETS FIGURENT DANS LE PROMPT. Sans le signe de l'effet,
# ChatGPT ecrirait des reactions qui contredisent la mecanique : un
# ouvrier content d'une decision qui lui fait perdre six points. On lui
# donne donc, pour chaque reponse, qui y gagne et qui y perd — en mots,
# pas en chiffres, pour qu'il raisonne en historien et non en comptable.
#
# Le format de sortie est celui des chaines de traduction : un numero
# entre crochets, une ligne « >> ». La reinjection sera donc le meme
# travail, deja eprouve.
use strict; use warnings; use utf8;
use JSON::PP;
binmode(STDOUT, ":encoding(UTF-8)");

my $src = shift or die "usage: prompt-dialogues.pl <cartes.json> <dossier> [I|II]\n";
my $dos = shift or die "usage: prompt-dialogues.pl <cartes.json> <dossier> [I|II]\n";
my $niv = shift // "I";

open(my $h, "<:raw", $src) or die "$src: $!";
local $/; my $brut = <$h>; close $h;
my $D = decode_json($brut);
my $N = $D->{$niv} or die "ARRET : le niveau $niv est introuvable\n";

my @CLES = qw(i o m p);
my @cartes = @{ $N->{cartes} };
@cartes or die "ARRET : aucune carte\n";

mkdir $dos unless -d $dos;

# ---- la consigne, en tete de chaque fichier ---------------------------
sub entete {
  my ($no, $sur, $nb, $de, $a) = @_;
  my $forces = join "\n", map {
    sprintf("| **%s** | %s |", $N->{forces}{$_}{nom}, $N->{forces}{$_}{veut})
  } @CLES;
  return <<"TETE";
# Dialogues des quatre acteurs — $N->{lieu}, partie $no sur $sur
*Cartes $de à $a — $nb répliques à écrire.*

## Le jeu

« Le prix du progrès » est un jeu d'histoire pour des élèves de 15 ans. Le joueur
dirige **$N->{lieu}** ($N->{sous}). Une situation arrive sur son bureau, il choisit
une réponse parmi trois, et **chaque réponse contente un groupe et en fâche un autre**.

Quatre groupes le jugent. Chacun veut quelque chose :

| Le groupe | Ce qu'il veut |
|---|---|
$forces

Si l'un d'eux l'abandonne tout à fait, la partie s'arrête.

## Ce que je te demande

Pour chaque carte, **trois répliques par groupe** :

- **PLAIDE** — ce que ce groupe réclame **avant** la décision. Il défend son intérêt.
- **CONTENT** — sa réaction **après**, si la décision lui profite.
- **FACHE** — sa réaction **après**, si elle lui coûte.

Elles s'afficheront dans une bulle, à côté d'un portrait. Elles doivent donc être
**courtes**.

## Huit règles, toutes importantes

1. **Quatorze mots au maximum par réplique.** C'est une bulle, pas un paragraphe.
   Une seule phrase. Mieux vaut dix mots que quatorze.
2. **Vocabulaire accessible à un élève de 15 ans.** Aucun mot de métier sans qu'il
   s'explique dans la phrase même : jamais « la carde », mais « la machine qui démêle
   le coton ». Jamais de renvoi à un lexique.
3. **Des arguments authentiques de l'époque.** Ce que les gens de cette condition
   disaient vraiment. Pas de mot qui n'existait pas : ni « rentabilité », ni
   « ressources humaines », ni « productivité » dans la bouche d'un ouvrier de 1830.
4. **Le personnage parle à la première personne, dans son intérêt.** Il ne fait pas
   la leçon et n'explique pas l'histoire : il défend ce qui le fait vivre.
5. **Il s'adresse au joueur, et le vouvoie.**
6. **N'emploie jamais le guillemet droit** `"` : il casserait le jeu. Les chevrons
   « » ne sont pas nécessaires non plus, le jeu les ajoute.
7. **Ne répète pas** ce que dit déjà la personne qui apporte l'affaire : sa réplique
   t'est donnée pour que tu l'évites.
8. **CONTENT et FACHE sont dits après coup.** Au passé ou au présent de constat
   (« Vous nous avez entendus », « Nous ne tiendrons pas l'hiver »), jamais comme une
   demande.

## Comment répondre

Recopie le fichier entier en remplissant chaque ligne `>>`. **Ne touche pas** aux
numéros entre crochets, ni aux blocs « LA CARTE », ni à l'ordre.

---

TETE
}

# ---- qui gagne, qui perd, en mots -------------------------------------
sub signes {
  my ($e) = @_;
  my (@plus, @moins);
  for my $k (@CLES){
    my $v = $e->{$k} // 0;
    next unless $v;
    my $nom = $N->{forces}{$k}{nom};
    my $fort = abs($v) >= 8 ? " (beaucoup)" : "";
    $v > 0 ? push @plus, "$nom$fort" : push @moins, "$nom$fort";
  }
  my @l;
  push @l, "profite à : " . join(", ", @plus)  if @plus;
  push @l, "coûte à : "   . join(", ", @moins) if @moins;
  return @l ? join(" · ", @l) : "n'avantage ni ne lèse personne";
}

# ---- les fichiers -----------------------------------------------------
my $PAR = 5;                       # cinq cartes par fichier
my $nbf = int((@cartes + $PAR - 1) / $PAR);
my $total = 0;

for my $i (0 .. $nbf-1){
  my $de = $i*$PAR;
  my $a  = $de + $PAR - 1;
  $a = $#cartes if $a > $#cartes;
  my $nb = ($a - $de + 1) * 4 * 3;
  $total += $nb;

  my $f = sprintf "%s/dialogues-%s-%02d.md", $dos, $niv, $i+1;
  open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";
  print $o entete($i+1, $nbf, $nb, $de+1, $a+1);

  for my $n ($de .. $a){
    my $c = $cartes[$n];
    my $num = sprintf "%s-%02d", $niv, $n+1;

    print $o "## LA CARTE $num — « $c->{t} »\n\n";
    print $o "**La situation.** $c->{ex}\n\n";
    print $o "**Qui apporte l'affaire.** $c->{qui}\n";
    print $o "Il dit déjà : $c->{d}\n\n";
    print $o "**Les réponses possibles, et qui elles touchent :**\n\n";
    my $L = 'a';
    for my $ch (@{ $c->{choix} }){
      printf $o "- %s %s\n  *(%s)*\n", uc($L), $ch->{q}, signes($ch->{e});
      $L++;
    }
    print $o "\n**À écrire :**\n\n";
    for my $k (@CLES){
      my $nom = $N->{forces}{$k}{nom};
      print $o "*$nom*\n";
      for my $quoi (qw(PLAIDE CONTENT FACHE)){
        printf $o "[[%s-%s-%s]]\n>> \n", $num, $k, $quoi;
      }
      print $o "\n";
    }
    print $o "---\n\n";
  }
  close $o;
}

printf "  %s : %d cartes, %d répliques à écrire\n", $N->{lieu}, scalar(@cartes), $total;
printf "  %d fichier(s) de %d cartes dans %s\n", $nbf, $PAR, $dos;

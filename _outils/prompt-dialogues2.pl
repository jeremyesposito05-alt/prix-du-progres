#!/usr/bin/perl
# FAIRE ECRIRE LES DIALOGUES, CARTE PAR CARTE
#
#   perl _outils/prompt-dialogues2.pl index.html I _a-installer/dialogues-I
#
# LE DEFAUT CORRIGE. Le jeu contient huit jeux de deux phrases : une
# par acteur pour « j'ai gagne », une pour « j'ai perdu ». Seize
# repliques en tout. Une partie fait dix-huit decisions et quatre
# bulles par decision, soit soixante-douze moments de bulle. L'ouvriere
# repete donc mot pour mot la meme phrase six a huit fois par partie.
#
# CE QU'ON DEMANDE A LA PLACE. Pour chaque carte :
#   — AVANT la decision, les deux acteurs les plus concernes donnent
#     leur avis sur CETTE affaire. Deux phrases.
#   — APRES chaque reponse, le gagnant et le perdant reagissent a CE
#     choix-la. Six phrases.
# Huit repliques par carte, 240 par niveau.
#
# LE GAGNANT ET LE PERDANT NE SONT PAS A DEVINER : ils sont deja dans
# les effets de chaque reponse, derives des consequences a
# l'injection des cartes. Le fichier les nomme, pour qu'une replique
# ne puisse pas contredire ce que le jeu fait.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $src = shift or die "usage: prompt-dialogues2.pl <index.html> <I|II> <dossier>\n";
my $niv = shift or die "usage\n";
my $dos = shift or die "usage\n";

open(my $h, "<:raw", $src) or die "$src: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);

# ---------- relecture des cartes du niveau ----------
my $de = index($s, "const CARTES_$niv = [");
$de >= 0 or die "ARRET : CARTES_$niv introuvable\n";
my $a = index($s, "\n];\n", $de);
my $bloc = substr($s, $de, $a - $de);

my %NOM = (
  I  => { i=>"Les industriels", o=>"Les ouvriers",
          m=>"Les marchands",   p=>"Le Parlement" },
  II => { i=>"Les actionnaires", o=>"Les ouvriers",
          m=>"Les clients",      p=>"L'opinion" },
);
my $nom = $NOM{$niv} or die "ARRET : niveau $niv inconnu\n";

# Ce que chaque groupe veut, repris mot pour mot de l'ecran du jeu :
# la demande doit decrire aux memes termes ce que le joueur a sous les
# yeux, sinon les repliques parleront d'autre chose.
my %VEUT = (
  I  => { i=>"des machines, du charbon, des bras",
          o=>"un salaire, un toit, des heures vivables",
          m=>"des canaux, des rails, des d\x{E9}bouch\x{E9}s",
          p=>"l\x{2019}ordre public et la salubrit\x{E9}" },
  II => { i=>"du rendement, une usine qui ne s\x{2019}arr\x{EA}te jamais",
          o=>"une cadence tenable, un salaire, le droit de s\x{2019}organiser",
          m=>"une voiture fiable, bon march\x{E9}, qu\x{2019}on ait envie d\x{2019}acheter",
          p=>"des comptes, de la d\x{E9}cence \x{2014} et bient\x{F4}t des lois" },
);
my $veut = $VEUT{$niv};

my @C;
for my $carte (split /\n\n(?=\{)/, $bloc){
  next unless $carte =~ /\bt:"([^"]*)"/;
  my %c = (t => $1);
  $c{n}   = $carte =~ /\{n:"(\d+)"/        ? $1 : sprintf("%02d", scalar(@C)+1);
  $c{qui} = $carte =~ /\bqui:"([^"]*)"/    ? $1 : "";
  $c{ex}  = $carte =~ /\bex:"([^"]*)"/     ? $1 : "";
  $c{d}   = $carte =~ /\bd:"([^"]*)"/      ? $1 : "";
  for my $k (qw(a b c)){
    next unless $carte =~ /\n $k:\{q:"([^"]*)", e:\{([^}]*)\},\s*\n\s*c:"([^"]*)"\}/;
    my ($q, $ef, $cq) = ($1, $2, $3);
    my (%e, $g, $p);
    while($ef =~ /(\w+):(-?\d+)/g){ $e{$1} = $2 + 0 }
    for my $f (sort keys %e){ $g = $f if $e{$f} > 0; $p = $f if $e{$f} < 0 }
    push @{$c{rep}}, { cle=>$k, q=>$q, c=>$cq, g=>$g, p=>$p };
  }
  next unless $c{rep} && @{$c{rep}} >= 2;
  push @C, \%c;
}
@C or die "ARRET : aucune carte relue\n";
printf "  %d cartes relues dans CARTES_%s\n", scalar(@C), $niv;

# ---------- ecriture des demandes ----------
mkdir $dos unless -d $dos;
my $PAR = 5;
my $nbf = int((@C + $PAR - 1) / $PAR);
my $total = 0;

for my $i (0 .. $nbf-1){
  my $d0 = $i * $PAR;
  my $d1 = $d0 + $PAR - 1; $d1 = $#C if $d1 > $#C;
  my $f = sprintf "%s/dialogues-%02d.md", $dos, $i+1;
  open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";

  my $lieu = $niv eq "I" ? "**Manchester entre 1780 et 1851**"
                         : "**l'usine Ford, a Detroit, entre 1908 et 1932**";
  $lieu =~ s/a Detroit/à Detroit/;

  my $table = join("\n", "| Le groupe | Ce qu'il veut |", "|---|---|",
    map { sprintf "| **%s** | %s |", $nom->{$_}, $veut->{$_} } qw(i o m p));
  my $ana = $niv eq "I"
    ? "Ni « rentabilité », ni « productivité », ni « ressources humaines » dans la bouche\n   de quelqu'un de 1830."
    : "On est aux États-Unis entre 1908 et 1932. « Productivité » et « rendement » se disent\n   déjà ; « ressources humaines », « management » et « burn-out » non. On dit « dollars »,\n   pas « euros ».";

  printf $o <<"TETE", $i+1, $nbf, $d1-$d0+1, $lieu, $table, $ana;
# Écrire les dialogues du jeu — partie %d sur %d (%d situations)

## Le jeu, et le défaut qu'on corrige

« Le prix du progrès » est un jeu d'histoire pour des élèves de 15 ans. Le joueur dirige
%s. Quatre groupes le jugent, et ils sont affichés tout autour de
l'affaire du jour, chacun avec une bulle de bande dessinée :

%s

Aujourd'hui chaque groupe n'a **que deux phrases** : une pour « on m'a entendu », une pour
« on m'a ignoré. » Une partie fait dix-huit décisions, donc soixante-douze bulles. L'ouvrière
répète la même phrase six fois. C'est ce qu'on remplace.

## Ce que je te demande, pour chaque situation

**Huit répliques.** Deux avant la décision, six après.

1. **DEUX AVIS**, avant que le joueur ne tranche. Les deux groupes les plus concernés
   disent ce qu'ils veulent **pour cette affaire précise**. Pas leur programme général :
   leur intérêt dans ce cas-là.
2. **SIX RÉACTIONS**, une par groupe touché et par réponse. Pour chaque réponse je te dis
   **qui gagne et qui perd** — ce n'est pas à deviner, c'est ce que le jeu applique
   réellement. Le gagnant réagit, le perdant réagit.

## Huit règles

1. **Une seule phrase par réplique.** Courte. Elle s'affiche dans une bulle de bande
   dessinée, à côté d'un portrait, sur un téléphone.
2. **À la première personne du groupe** — « nous », ou « je » si c'est une voix seule.
3. **Chaque réplique parle de CETTE affaire**, avec ses mots à elle. Si on peut la déplacer
   d'une carte à l'autre sans que ça change, elle est ratée : c'est exactement le défaut
   qu'on corrige.
4. **Le gagnant ne triomphe pas, le perdant ne gémit pas.** Ce sont des gens qui défendent
   un intérêt, pas des personnages de dessin animé. Un gagnant peut être soulagé, méfiant,
   ou déjà en train de demander la suite.
5. **Vocabulaire d'un élève de 15 ans.** Aucun mot de métier sans qu'il s'explique dans la
   phrase même. Jamais de renvoi à un lexique.
6. **Aucune mise en gras.** Le gras est réservé aux mots du cours, et il est déjà posé
   ailleurs.
7. **N'emploie jamais le guillemet droit** `"` : il casserait le jeu. Pour citer, les
   chevrons « ».
8. **Pas d'anachronisme.** %s

## Comment répondre

Recopie le fichier entier en remplissant les lignes `>>`. Ne touche pas aux numéros entre
crochets, ni aux blocs de contexte, ni à l'ordre.

---

TETE

  close $o;
  open($o, ">>:encoding(UTF-8)", $f) or die "$f: $!";

  for my $n ($d0 .. $d1){
    my $c = $C[$n];
    printf $o "## SITUATION %s — %s\n\n", $c->{n}, $c->{t};
    printf $o "**Ce que le joueur lit.** %s\n\n", $c->{ex};
    printf $o "**Qui apporte l'affaire.** %s — %s\n\n", $c->{qui}, $c->{d};

    # Les deux groupes que cette carte touche le plus. On compte les
    # mentions, gagnantes comme perdantes : un groupe nomme dans les
    # trois reponses est au coeur de l'affaire, un groupe nomme une
    # fois ne l'est pas. Les cles indefinies sont ecartees — une carte
    # dont une reponse n'aurait pas de perdant ne doit pas faire
    # trebucher le tri.
    my %conc;
    for my $r (@{$c->{rep}}){
      $conc{$r->{g}}++ if defined $r->{g} && length $r->{g};
      $conc{$r->{p}}++ if defined $r->{p} && length $r->{p};
    }
    my @tri = sort { ($conc{$b}||0) <=> ($conc{$a}||0) || $a cmp $b } keys %conc;
    my @deux = @tri[0 .. ($#tri < 1 ? $#tri : 1)];

    printf $o "**Les deux groupes les plus concernés.** %s et %s\n\n",
      $nom->{$deux[0]}, $nom->{$deux[1]};
    print  $o "**À écrire — leur avis AVANT la décision, une phrase chacun :**\n\n";
    for my $k (@deux){
      printf $o "[[%s-AVIS-%s]]  (%s)\n>> \n\n", $c->{n}, uc($k), $nom->{$k};
      $total++;
    }

    print $o "**À écrire — leur réaction APRÈS chaque réponse :**\n\n";
    for my $r (@{$c->{rep}}){
      printf $o "### Réponse %s : %s\n", uc($r->{cle}), $r->{q};
      printf $o "*Ce qui arrive : %s*\n\n", $r->{c};
      printf $o "[[%s-%s-%s]]  (%s — **gagne**)\n>> \n\n",
        $c->{n}, uc($r->{cle}), uc($r->{g}), $nom->{$r->{g}};
      printf $o "[[%s-%s-%s]]  (%s — **perd**)\n>> \n\n",
        $c->{n}, uc($r->{cle}), uc($r->{p}), $nom->{$r->{p}};
      $total += 2;
    }
    print $o "---\n\n";
  }
  close $o;
}

printf "  %d fichier(s) de %d situations dans %s\n", $nbf, $PAR, $dos;
printf "  %d repliques a ecrire (8 par situation)\n", $total;

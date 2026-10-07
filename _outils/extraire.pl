#!/usr/bin/perl
# EXTRAIRE LES TEXTES DU JEU
#
#   perl extraire.pl <jeu.html> <dossier>
#
# Le français est tissé dans le code : on ne peut pas le donner à
# traduire d'un bloc sans casser le jeu. On sort donc les chaînes une à
# une, numérotées, dans des fichiers que l'on peut faire traduire ;
# « reinjecter.pl » les remet à leur place.
#
# Chaque chaîne est relevée avec SA POSITION EXACTE dans le fichier. La
# réinjection n'a donc rien à reconnaître ni à re-parcourir : elle coupe
# et recolle aux octets près, après avoir vérifié qu'à cette position se
# trouve bien le texte qu'on y a laissé. Si le français a bougé
# entre-temps, elle refuse d'écrire.
use strict; use warnings; use utf8;

my $src = shift or die "usage: extraire.pl <jeu.html> <dossier>\n";
my $dos = shift or die "usage: extraire.pl <jeu.html> <dossier>\n";
open(my $h, "<:encoding(UTF-8)", $src) or die "$src: $!";
local $/; my $s = <$h>; close $h;
$s =~ s/\x0D\x0A/\n/g;

# ---- ce qui mérite d'être traduit -----------------------------------------
sub garde {
  my ($t) = @_;
  return 0 if $t =~ /\$\{/;              # un gabarit : on n'y touche pas
  return 0 if length($t) < 2;
  return 0 if $t !~ /\p{L}/;             # pas une lettre : pas du texte
  # Un chemin de fichier n'est pas du texte : le champ « f » porte aussi
  # bien le rapport d'enquête que « son/menu.mp3 ».
  return 0 if $t =~ m{^[\w.-]+/} || $t =~ /\.(?:mp3|jpg|jpeg|png|svg|css|js|html)$/i;
  return 0 if $t =~ /^[a-z][\w-]*$/ && $t !~ /\s/;   # un identifiant
  return 1;
}

my @lot;
sub prendre {
  my ($champ, $txt, $deb) = @_;
  return unless garde($txt);
  push @lot, { n=>scalar(@lot)+1, champ=>$champ, fr=>$txt,
               deb=>$deb, len=>length($txt) };
}

# Les champs de données du jeu, nommés.
my $champs = join "|", qw(
  t qui d ex f q c x src texte nom veut role date lieu sous ord but note
  avant cit unite unite2 reel titre pays impatience plus moins
);
while($s =~ /\b($champs)\s*:\s*"([^"]*)"/g){
  prendre($1, $2, $-[2]);
}

# Les tableaux de chaînes nues, qu'aucun nom de champ n'annonce.
sub dansTableau {
  my ($motif, $nom) = @_;
  while($s =~ /$motif/g){
    my ($b, $base) = ($1, $-[1]);
    while($b =~ /"([^"]+)"/g){
      prendre($nom, $1, $base + $-[1]);
    }
  }
}
# « r: » porte les réponses du questionnaire et celles du retour sur le
# jeu. Rien d'autre dans le fichier ne s'appelle ainsi.
dansTableau(qr/\br:\s*\[([^\]]*)\]/s, "r");
dansTableau(qr/lecons:\s*\[(.*?)\n\s*\]\}/s, "lecons");

# LES SEPT CONDITIONS NE SONT PAS ICI, ET C'EST VOULU.
# « Ressources », « Capitaux »… servent à la fois d'étiquette affichée
# et de clé : les cartes les accordent par « g: » et les exigent par
# « req: ». Traduire l'étiquette sans traduire les deux autres casserait
# le jeu ; les traduire séparément risquerait trois libellés différents
# pour la même condition. Elles se régleront avec les textes d'interface,
# en séparant proprement la clé de son libellé.

@lot or die "ARRET : rien n'a été extrait\n";

# Une position relevée deux fois trahirait un double comptage.
my %deja;
for my $e (@lot){
  die "ARRET : la position $e->{deb} est relevée deux fois\n" if $deja{$e->{deb}}++;
  my $v = substr($s, $e->{deb}, $e->{len});
  die "ARRET : relecture fausse à $e->{deb}\n" unless $v eq $e->{fr};
}

mkdir $dos unless -d $dos;

# ---- le fichier machine, qui sert de garantie -----------------------------
open(my $m, ">:encoding(UTF-8)", "$dos/source.tsv") or die $!;
print $m "# numéro\tposition\tlongueur\tchamp\toriginal — NE PAS MODIFIER\n";
printf $m "%04d\t%d\t%d\t%s\t%s\n", @{$_}{qw(n deb len champ fr)} for @lot;
close $m;

# ---- les fichiers à faire traduire ----------------------------------------
my $PAR = 90;                      # de quoi tenir dans une conversation
my $nb  = int((@lot + $PAR - 1) / $PAR);
my $car = 0; $car += length($_->{fr}) for @lot;

for my $i (0 .. $nb-1){
  # « .. » lie plus fort que « ? : » : écrite d'un trait, la borne
  # devenait le résultat d'une comparaison, et chaque fichier ne
  # recevait qu'une entrée. On la calcule donc à part.
  my $fin = ($i+1)*$PAR - 1;
  $fin = $#lot if $fin > $#lot;
  my @p = @lot[ $i*$PAR .. $fin ];
  my $f = sprintf "%s/%02d.md", $dos, $i+1;
  open(my $o, ">:encoding(UTF-8)", $f) or die $!;
  printf $o <<'TETE', $i+1, $nb, scalar(@p);
# À traduire — partie %d sur %d (%d entrées)

Traduis en anglais la ligne `FR >>` et écris la traduction après `EN >>`.

**Six règles, toutes importantes :**

1. **Ne touche à rien d'autre.** Pas aux numéros entre crochets, pas aux lignes `FR >>`,
   pas à l'ordre des entrées. Rends-moi le fichier entier, même structure.
2. **Garde les doubles astérisques** exactement où ils sont : ils mettent en gras les
   notions du cours. `la **main-d'œuvre**` devient `the **workforce**`.
3. **Garde les balises `<strong>` et `</strong>`** si tu en vois.
4. **N'emploie jamais le guillemet droit** `"` dans ta traduction : il casserait le jeu.
   Utilise `'` ou les chevrons « ».
5. **Ne traduis pas les noms propres** — Manchester, Detroit, Peterloo, Ford, Engels — ni
   les noms des personnages inventés. **Garde les chiffres et les dates** à l'identique.
6. **Registre** : anglais britannique, ton d'un jeu d'histoire pour des élèves de quinze ans.
   Sobre, concret, pas de familiarité.

---

TETE
  for my $e (@p){
    printf $o "[[%04d]]\nFR >> %s\nEN >> \n\n", $e->{n}, $e->{fr};
  }
  close $o;
}

printf "  %d chaînes extraites, %d caractères\n", scalar(@lot), $car;
printf "  %d fichiers de %d entrées dans %s\n", $nb, $PAR, $dos;

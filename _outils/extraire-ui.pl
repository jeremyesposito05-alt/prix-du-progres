#!/usr/bin/perl
# EXTRAIRE LES TEXTES DE L'INTERFACE
#
#   perl _outils/extraire-ui.pl index-en.html _a-installer/interface
#
# La premiere passe a traduit les donnees du jeu. Restent les textes de
# l'interface : le titre, les boutons, le tutoriel, le carnet de bord.
# Ce sont eux qu'un eleve rencontre d'abord.
#
# MEME GARANTIE : chaque chaine est relevee avec sa position exacte, et
# « reinjecter.pl » coupe et recolle aux octets pres apres avoir verifie
# qu'a cette place se trouve bien ce qu'on y a laisse.
#
# OU ILS SE CACHENT. Le balisage nu ne fait que 1 % du fichier : presque
# toute l'interface est fabriquee par le script, dans des gabarits
# `comme ceci`. On entre donc dans le script, mais on n'y prend que les
# NOEUDS DE TEXTE et les attributs que le joueur lit — jamais une chaine
# entiere, qui pourrait etre une cle ou un nom de classe.
use strict; use warnings; use utf8;
require "./_outils/gabarits.pl";

my $src = shift or die "usage: extraire-ui.pl <jeu.html> <dossier>\n";
my $dos = shift or die "usage: extraire-ui.pl <jeu.html> <dossier>\n";

# ---- ce que la premiere passe a deja traduit --------------------------
# Les donnees du jeu portent des <strong> : le balayage y verrait des
# noeuds de texte, et rendrait a traduire des bouts d'anglais deja
# traduit. On ecarte donc tout candidat contenu dans une traduction de
# la premiere passe.
my @passe1;
for my $f (glob("_a-installer/traduction/[0-9]*.md")){
  open(my $p, "<:encoding(UTF-8)", $f) or die "$f: $!";
  while(my $l = <$p>){ chomp $l; push @passe1, $1 if $l =~ /^EN >> (.+)/ }
  close $p;
}
@passe1 or die "ARRET : la premiere passe est introuvable\n";
my $PASSE1 = join "\n", @passe1;
open(my $h, "<:encoding(UTF-8)", $src) or die "$src: $!";
local $/; my $s = <$h>; close $h;
$s =~ s/\x0D\x0A/\n/g;

# ---- ce qui merite d'etre traduit -------------------------------------
my $DIAC = qr/[àâäçéèêëîïôöûùüÿœæÀÂÇÉÈÊËÎÏÔÖÛÙÜŒÆ]/;
my $MOT  = qr/\b(?:le|la|les|des|une|un|vous|votre|qui|que|dans|pour|avec|sur|est|sont|pas|plus|tout|toute|cette|aux|par|mais|chaque|sans|ne|du|au|en|il|elle|on|se|sa|son|ces|leur|nos|ont|fait|deux|trois|mon|ma|mes|rien|ici)\b/i;

# Du francais sans accent ni mot outil. Les nommer vaut mieux que les deviner.
my %AUSSI = map { $_ => 1 } (
  "Musique", "Bruitages", "Courrier", "Demain", "Fermer", "Ouvrir",
  "Continuer", "Imprimer", "Rejouer", "Relire", "Menu", "Faux", "Juste",
  "Issue", "Survie", "Satisfaits", "Cachet intact", "Population",
  "Production", "Carnet de bord", "Mon carnet de bord", "Ma trace de travail",
  "Revoir ma trace", "Copier ma trace", "Changer de niveau",
  "Valider et terminer", "Avant de commencer", "Avant de quitter",
  "Jeudi noir", "Dodge contre Ford",
);

# Ce qu'il ne faut surtout pas toucher.
#   — les noms propres et les noms de polices ;
#   — LES SEPT CONDITIONS, qui servent a la fois d'etiquette affichee et
#     de cle : les cartes les accordent par « g: » et les exigent par
#     « req: ». Les traduire ici casserait le jeu. Elles se regleront a
#     part, en separant proprement la cle de son libelle.
my %JAMAIS = map { $_ => 1 } (
  "Jeremy Esposito", "SangBleu OG Sans", "SangBleu Sans", "Bodoni MT",
  "Playfair Display", "Segoe UI", "Didot", "NFD", "Manchester", "Detroit",
  "Ressources", "Capitaux", "Main-d\x{2019}\x{0153}uvre", "March\x{00E9}s",
  "Transports", "Organisation", "Savoirs techniques",
);

sub garde {
  my ($t) = @_;
  return 0 if length($t) < 2;
  return 0 if $t !~ /\p{L}/;
  return 0 if $JAMAIS{$t};
  return 0 if $t =~ /\$\{/;                        # un morceau de gabarit
  return 0 if $t =~ /[<>{}]/ || $t =~ /&[a-z#]+;/; # du balisage, pas du texte
  return 0 if $t =~ /^[a-z][\w-]*$/;               # un identifiant
  return 0 if $t =~ /^[.#]/;                       # un selecteur
  return 0 if $t =~ m{[\w-]+/[\w./-]+};            # un chemin
  return 0 if $t =~ /\.(?:mp3|jpg|jpeg|png|svg|css|js|html)$/i;
  return 0 if $t =~ /^[\d\s.,%:+\x{2014}\x{2013}\x{00B7}-]+$/;
  return 0 if index($PASSE1, $t) >= 0;             # deja traduit, passe 1
  return 1 if $AUSSI{$t};
  return 1 if $t =~ $DIAC || $t =~ $MOT;
  return 0;
}

my @lot;
sub prendre {
  my ($champ, $txt, $deb) = @_;
  return unless garde($txt);
  push @lot, { n=>0, champ=>$champ, fr=>$txt, deb=>$deb, len=>length($txt) };
}

# Le balayage d'un morceau de balisage : les noeuds de texte, puis les
# attributs que le joueur lit. « $base » est la position du morceau dans
# le fichier entier, pour que les positions restent absolues.
sub balayer {
  my ($bout, $base, $ou) = @_;
  while($bout =~ />([^<>]+)</g){
    my ($brut, $i) = ($1, $-[1]);
    my ($g) = $brut =~ /^(\s*)/;
    my $t = $brut; $t =~ s/^\s+//; $t =~ s/\s+$//;
    next unless length $t;
    prendre($ou, $t, $base + $i + length($g));
  }
  while($bout =~ /\b(title|aria-label|placeholder|alt)\s*=\s*"([^"]*)"/g){
    prendre($1, $2, $base + $-[2]);
  }
}

# ---- zone 1 : le balisage nu ------------------------------------------
# On masque le script et le style, sans bouger les positions. On releve
# les plages d'abord, on masque ensuite : modifier la chaine pendant
# qu'un //g la parcourt remet « pos » a zero, et la boucle ne finit pas.
my (@corps, @plages);
while($s =~ /<(script|style)\b[^>]*>(.*?)<\/\1>/gis){
  my ($quoi, $c) = ($1, $2);
  next unless length $c;
  push @plages, [ $-[2], length $c ];
  push @corps,  [ $-[2], $c ] if lc $quoi eq "script";
}
my $nu = $s;
substr($nu, $_->[0], $_->[1]) = " " x $_->[1] for @plages;
balayer($nu, 0, "texte");

# ---- zone 2 : les gabarits du script ----------------------------------
# Une expression reguliere ne sait pas compter les accolades : voir
# « gabarits.pl », qui lit le script caractere par caractere et rend les
# morceaux de texte fixe avec leur position.
for my $c (@corps){
  my ($base, $js) = @$c;
  balayer($_->[1], $_->[0], "gabarit") for morceaux($js, $base);
}

@lot or die "ARRET : rien n'a ete extrait\n";

# ---- se relire avant d'ecrire -----------------------------------------
my (%deja, @net);
for my $e (@lot){
  next if $deja{$e->{deb}}++;          # la meme place vue deux fois
  my $v = substr($s, $e->{deb}, $e->{len});
  die "ARRET : relecture fausse a $e->{deb}\n   attendu « $e->{fr} »\n   trouve  « $v »\n"
    unless $v eq $e->{fr};
  push @net, $e;
}
@lot = @net;
$lot[$_]{n} = $_ + 1 for 0 .. $#lot;

# ---- l'ecriture, et le cas des textes sur plusieurs lignes ------------
# Onze textes du balisage sont coupes par un retour a la ligne et son
# indentation : « il sera lu devant le conseil, à votre\n  prochaine
# décision ». Un fichier a colonnes tabulees ne peut pas porter un retour
# a la ligne, et la ligne « FR >> » pas davantage.
#
#   — dans source.tsv, on echappe : l'original est conserve exactement,
#     et « reinjecter.pl » le retablit avant de verifier la position ;
#   — dans le fichier a traduire, on aplatit en une seule ligne, parce
#     que c'est une phrase et qu'elle se traduit d'un bloc. Le HTML
#     ramasse les espaces : rendre une ligne la ou il y en avait deux ne
#     change rien a l'affichage.
my $AS = chr(92);
sub echapper {
  my ($t) = @_;
  $t =~ s/\Q$AS\E/${AS}${AS}/g;
  $t =~ s/\n/${AS}n/g;
  $t =~ s/\t/${AS}t/g;
  return $t;
}
sub aplatir { my ($t) = @_; $t =~ s/\s*\n\s*/ /g; return $t }

mkdir $dos unless -d $dos;
open(my $t, ">:encoding(UTF-8)", "$dos/source.tsv") or die $!;
print $t "# numéro\tposition\tlongueur\tchamp\toriginal échappé — NE PAS MODIFIER\n";
printf $t "%04d\t%d\t%d\t%s\t%s\n",
  @{$_}{qw(n deb len champ)}, echapper($_->{fr}) for @lot;
close $t;

my $PAR = 90;
my $nb  = int((@lot + $PAR - 1) / $PAR);
my $car = 0; $car += length($_->{fr}) for @lot;

for my $i (0 .. $nb-1){
  my $fin = ($i+1)*$PAR - 1;
  $fin = $#lot if $fin > $#lot;
  my @p = @lot[ $i*$PAR .. $fin ];
  my $f = sprintf "%s/ui-%02d.md", $dos, $i+1;
  open(my $o, ">:encoding(UTF-8)", $f) or die $!;
  printf $o <<'TETE', $i+1, $nb, scalar(@p);
# L’interface du jeu — partie %d sur %d (%d entrées)

Traduis en anglais la ligne `FR >>` et écris la traduction après `EN >>`.

Ce sont les textes de l’**interface** : le titre, les boutons, le tutoriel, le
carnet de bord. Ils sont courts, souvent isolés, et c’est ce qu’un élève voit
en premier.

**Sept règles, toutes importantes :**

1. **Ne touche à rien d’autre.** Pas aux numéros entre crochets, pas aux lignes
   `FR >>`, pas à l’ordre des entrées. Rends-moi le fichier entier.
2. **N’emploie jamais le guillemet droit** `"` ni les signes `<`, `>`, `&` :
   ils casseraient le jeu. Pour citer, emploie les guillemets courbes “ ”.
3. **Garde la longueur.** Un bouton n’a pas de place : si le français dit
   `Fermer`, l’anglais dit `Close`, pas `Close this panel`.
4. **Garde la casse du français.** `LE PRIX DU PROGRÈS` reste tout en
   capitales ; `Ouvrir` garde sa majuscule.
5. **Ne traduis pas** les noms propres — Manchester, Detroit, Jeremy Esposito,
   Collège Alpin Beau Soleil — ni les noms de polices.
6. **Si une entrée est déjà en anglais**, recopie-la telle quelle.
7. **Registre** : anglais britannique, ton d’un jeu d’histoire pour des élèves
   de quinze ans. Sobre, concret.

**Vocabulaire déjà fixé par la première passe** — emploie exactement ces mots :
capital · rural exodus · manufacturers · industrialists · workforce · markets ·
merchants · organisation of work · workers · progress · resource · transport ·
urbanisation · State · mill · foreman

---

TETE
  for my $e (@p){
    printf $o "[[%04d]]\nFR >> %s\nEN >> \n\n", $e->{n}, aplatir($e->{fr});
  }
  close $o;
}

binmode(STDOUT, ":encoding(UTF-8)");
printf "  %d chaînes d’interface, %d caractères\n", scalar(@lot), $car;
printf "  %d fichier(s) dans %s\n", $nb, $dos;

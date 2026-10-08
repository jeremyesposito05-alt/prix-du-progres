#!/usr/bin/perl
# LES TRENTE CARTES DE MANCHESTER ENTRENT DANS LE JEU
#
#   perl _outils/cartes-injecter.pl index.html _a-installer/refonte/situations.tsv *.md
#
# D'OU VIENNENT LES EFFETS. Une carte a besoin de chiffres : combien
# chaque reponse fait gagner ou perdre a chacune des quatre forces.
# Personne ne les a ecrits — et je ne veux pas les inventer, parce
# qu'alors le jeu dirait une chose et ferait l'autre.
#
# La demande imposait que chaque consequence dise « ce qui arrive, en
# disant le gagnant et le perdant ». Les effets se LISENT donc dans le
# texte : le groupe nomme avant le « mais » gagne, celui nomme apres
# perd. Le jeu ne peut plus contredire sa propre prose, et si une
# consequence est reecrite un jour, les chiffres suivront.
#
# +9 / -8 : l'echelle des anciennes cartes allait de 3 a 14. Les forces
# partent a 60 et il y a dix-huit decisions ; un groupe touche neuf
# fois du mauvais cote tombe a zero, un groupe menage tient. C'est
# verifie par simulation apres coup, pas suppose.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $cible = shift or die "usage: cartes-injecter.pl <index.html> <situations.tsv> <*.md>\n";
my $tsv   = shift or die "usage\n";
my @md    = @ARGV or die "usage\n";

# ================= lecture du cours =================
my (%mot, @nums);
open(my $t, "<:encoding(UTF-8)", $tsv) or die "$tsv: $!";
while(my $l = <$t>){
  next if $l =~ /^#/; chomp $l; next unless length $l;
  my @f = split /\t/, $l; next unless @f >= 7;
  $mot{$f[0]} = $f[3]; push @nums, $f[0];
}
close $t;

# ================= lecture des cartes rendues =================
my %C;
for my $f (@md){
  open(my $m, "<:encoding(UTF-8)", $f) or die "$f: $!";
  my $s = do { local $/; <$m> }; close $m;
  while($s =~ /^\[\[(\d+)-([A-Z]+)\]\]\s*\n>>\s*(.*?)\s*$/mg){ $C{$1}{$2} = $3 }
}
my @CLES = qw(LETTRE TITRE SITUATION QUI REPLIQUE
              REPONSEA CONSEQUENCEA REPONSEB CONSEQUENCEB REPONSEC CONSEQUENCEC);
for my $n (@nums){
  exists $C{$n} or die "ARRET : situation $n absente des fichiers rendus\n";
  for my $k (@CLES){
    $C{$n}{$k} && $C{$n}{$k} =~ /\S/
      or die "ARRET : situation $n, $k non rempli\n";
  }
}
printf "  %d situations completes\n", scalar(@nums);

# ================= qui gagne, qui perd =================
# Les groupes, tels qu'ils se nomment dans les consequences. Les
# proprietaires terriens n'existent pas comme force : historiquement,
# ce sont eux que le Parlement represente — c'est le sens meme des
# Corn Laws. On les y rattache plutot que d'ouvrir une cinquieme force
# pour deux cartes.
my %GRP = (
  i => qr/industriel|fabricant|filateur|patron|propri\x{E9}taire d/i,
  o => qr/ouvri|fileus|tisserand|famille ouvri/i,
  m => qr/marchand|n\x{E9}gociant|commer\x{E7}ant/i,
  p => qr/parlement|londres|\x{C9}tat\b|autorit\x{E9}|inspecteur|propri\x{E9}taires? terriens?/i,
);
my $BASCULE = qr/\bmais\b|\ben revanche\b|\btandis que\b|\bau prix d|\bcependant\b|\bpourtant\b/i;

# Le PREMIER groupe nomme de chaque cote, et lui seul : « Les
# industriels trouvent des travailleurs loges pres d'eux » nomme deux
# fois les memes gens, et compter les deux ferait d'un gagnant un
# perdant.
sub premier {
  my ($bout) = @_;
  my ($gagne, $pos);
  for my $k (sort keys %GRP){
    next unless $bout =~ $GRP{$k};
    my $p = $-[0];
    if(!defined $pos || $p < $pos){ ($gagne, $pos) = ($k, $p) }
  }
  return $gagne;
}
sub effets {
  my ($txt, $ou) = @_;
  my ($av, $ap) = ($txt, "");
  if($txt =~ $BASCULE){ ($av, $ap) = ($`, $') }
  my $g = premier($av);
  my $p = premier($ap);
  die "ARRET - $ou : gagnant illisible\n        $txt\n" unless $g;
  die "ARRET - $ou : perdant illisible\n        $txt\n"  unless $p;
  die "ARRET - $ou : le meme groupe gagne et perd\n        $txt\n" if $g eq $p;
  return { $g => 9, $p => -8 };
}

# ================= mise en forme =================
sub typo {
  my ($x) = @_;
  $x =~ s/'/\x{2019}/g;                      # l'apostrophe du jeu est courbe
  $x =~ s/\s+/ /g; $x =~ s/^\s+|\s+$//g;
  return $x;
}
sub js {                                      # une chaine JavaScript sure
  my ($x) = @_;
  die "ARRET : guillemet droit dans « $x »\n" if $x =~ /"/;
  die "ARRET : contre-oblique dans « $x »\n"  if $x =~ /\\/;
  return '"' . $x . '"';
}
sub ef {                                      # {i:9,o:-8}
  my ($e) = @_;
  return "{" . join(",", map { "$_:$e->{$_}" } grep { $e->{$_} } qw(i o m p)) . "}";
}

# ================= construction =================
my (@blocs, %compte, %bilan);
for my $n (@nums){
  my $c = $C{$n};
  my $lettre = typo($c->{LETTRE});
  $lettre =~ s/\s*J\.\s*E\.\s*$//;            # la signature est posee par la page
  my @rep;
  for my $k (qw(A B C)){
    my $e = effets(typo($c->{"CONSEQUENCE$k"}), "situation $n, reponse $k");
    $compte{$_}++ for keys %$e;
    $bilan{$_} += $e->{$_} for keys %$e;
    push @rep, sprintf(" %s:{q:%s, e:%s,\n    c:%s}",
      lc($k),
      js("\x{AB} " . typo($c->{"REPONSE$k"}) . " \x{BB}"),
      ef($e),
      js(typo($c->{"CONSEQUENCE$k"})));
  }
  # Le numero est une CHAINE : « 08 » et « 09 » ne sont pas des nombres
  # valides en JavaScript — le zero initial en fait de l'octal, et le
  # fichier entier cesse de se charger.
  push @blocs, sprintf("{n:%s, t:%s, qui:%s,\n d:%s,\n ex:%s,\n l:%s,\n%s},",
    js($n),
    js(typo($c->{TITRE})),
    js(typo($c->{QUI})),
    js("\x{AB} " . typo($c->{REPLIQUE}) . " \x{BB}"),
    js(typo($c->{SITUATION})),
    js($lettre),
    join(",\n", @rep));
}

# ================= remplacement =================
open(my $h, "<:raw", $cible) or die "$cible: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $cible est en CRLF — le normaliser en LF d'abord\n";

my $de = index($s, "const CARTES_I = [");
$de >= 0 or die "ARRET : CARTES_I introuvable\n";
my $a = index($s, "\n];\n", $de);
$a > $de or die "ARRET : fin de CARTES_I introuvable\n";
my $vieux = () = (substr($s, $de, $a-$de) =~ /^\{t:/mg);

my $neuf = "const CARTES_I = [\n" . join("\n\n", @blocs) . "\n];\n";
substr($s, $de, $a + 4 - $de) = $neuf;

utf8::encode($s);
open(my $o, ">:raw", $cible) or die "$cible: $!";
print $o $s; close $o;

# ================= ce que cela donne =================
printf "\n  %d cartes remplacent les %d anciennes\n", scalar(@blocs), $vieux;
printf "  chaque force est nommee : %s\n",
  join(" · ", map { "$_ $compte{$_}x" } qw(i o m p));
printf "  solde si l'on prenait tout au hasard : %s\n",
  join(" · ", map { sprintf "%s %+d", $_, $bilan{$_}/3 } qw(i o m p));

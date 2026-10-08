#!/usr/bin/perl
# LES DEUX CENT QUARANTE REPLIQUES ENTRENT DANS LE JEU
#
#   perl _outils/dialogues-injecter.pl index.html I *.md
#
# CE QU'ON REMPLACE. Chaque acteur avait deux phrases : une pour « on
# m'a entendu », une pour « on m'a ignore ». Seize repliques pour
# soixante-douze bulles par partie. L'ouvriere repetait la meme phrase
# six fois.
#
# CE QUI ENTRE. Par carte : deux avis AVANT la decision, et six
# reactions APRES — le gagnant et le perdant de chacune des trois
# reponses. Huit repliques par carte, 240 par niveau.
#
# LE CONTROLE QUI COMPTE. Chaque reaction est etiquetee d'un groupe et
# d'un sens (« gagne » ou « perd »). On verifie contre les effets que
# le jeu applique REELLEMENT : si [[01-A-M]] est annonce gagnant, la
# reponse a de la carte 01 doit porter un effet positif sur m. Une
# replique ne peut donc pas dire le contraire de ce qui se passe.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $cible = shift or die "usage: dialogues-injecter.pl <index.html> <I|II> <*.md>\n";
my $niv   = shift or die "usage\n";
my @md    = @ARGV or die "usage\n";

open(my $h, "<:raw", $cible) or die "$cible: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $cible est en CRLF — le normaliser en LF d'abord\n";

# ================= lecture des repliques rendues =================
my %R;   # $R{carte}{AVIS}{groupe} ou $R{carte}{A|B|C}{groupe}
my $lus = 0;
for my $f (@md){
  open(my $m, "<:encoding(UTF-8)", $f) or die "$f: $!";
  my $t = do { local $/; <$m> }; close $m;
  while($t =~ /^\[\[(\d+)-(AVIS|[ABC])-([IOMP])\]\][^\n]*\n>>\s*(.+?)\s*$/mg){
    $R{$1}{$2}{lc $3} = $4; $lus++;
  }
}
printf "  %d repliques lues dans %d fichier(s)\n", $lus, scalar(@md);

# ================= relecture des cartes =================
my $de = index($s, "const CARTES_$niv = [");
$de >= 0 or die "ARRET : CARTES_$niv introuvable\n";
my $fin = index($s, "\n];\n", $de);
my $tete = substr($s, 0, $de);
my $bloc = substr($s, $de, $fin - $de);
my $queue = substr($s, $fin);

my @cartes = split /\n\n(?=\{)/, $bloc;
$cartes[0] =~ s/^const CARTES_$niv = \[\n// or die "ARRET : en-tete du tableau\n";

# ================= mise en forme =================
sub typo {
  my ($x) = @_;
  $x =~ s/'/\x{2019}/g;
  $x =~ s/\s+/ /g; $x =~ s/^\s+|\s+$//g;
  return $x;
}
sub js {
  my ($x, $ou) = @_;
  die "ARRET - $ou : guillemet droit\n        $x\n" if $x =~ /"/;
  die "ARRET - $ou : contre-oblique\n"              if $x =~ /\\/;
  die "ARRET - $ou : du gras\n        $x\n"         if $x =~ /\*\*/;
  return '"' . $x . '"';
}

# ================= verification, puis ecriture =================
my (@mal, $mis, $cartes_vues);
my @neuves;
for my $c (@cartes){
  next unless $c =~ /\S/;
  my ($n) = $c =~ /^\{n:"(\d+)"/;
  unless(defined $n){ push @neuves, $c; next }
  $cartes_vues++;
  my $r = $R{$n};
  unless($r){ push @mal, "carte $n : aucune replique rendue"; push @neuves, $c; next }

  # --- les deux avis ---
  my @av = sort keys %{$r->{AVIS} || {}};
  push @mal, "carte $n : " . scalar(@av) . " avis, deux attendus" unless @av == 2;
  my $av = join(", ", map { "$_:" . js(typo($r->{AVIS}{$_}), "carte $n, avis $_") } @av);

  # --- les six reactions, verifiees contre les effets reels ---
  my $neuf = $c;
  for my $k (qw(a b c)){
    my $K = uc $k;
    my ($ef) = $neuf =~ /\n $k:\{q:"[^"]*", e:\{([^}]*)\},/;
    unless(defined $ef){ push @mal, "carte $n, reponse $K : effets illisibles"; next }
    my %e; while($ef =~ /(\w+):(-?\d+)/g){ $e{$1} = $2 + 0 }

    my @g = sort keys %{$r->{$K} || {}};
    unless(@g == 2){
      push @mal, "carte $n, reponse $K : " . scalar(@g) . " replique(s), deux attendues";
      next;
    }
    for my $gr (@g){
      unless($e{$gr}){
        push @mal, "carte $n, reponse $K : la replique parle de « $gr », que cette "
                 . "reponse ne touche pas";
      }
    }
    my $dit = join(",", map { "$_:" . js(typo($r->{$K}{$_}), "carte $n, $K, $_") } @g);
    my $av_ = "\n    c:";
    unless($neuf =~ s/(\n $k:\{q:"[^"]*", e:\{[^}]*\},\n    c:"[^"]*")\}/$1, dit:\{$dit\}\}/){
      push @mal, "carte $n, reponse $K : impossible d'y poser les repliques";
    }
    $mis += 2;
  }

  # l'avis se pose juste apres la lettre
  unless($neuf =~ s/(\n l:"[^"]*",)\n/$1\n av:\{$av\},\n/){
    push @mal, "carte $n : impossible d'y poser les avis";
  }
  $mis += 2;
  push @neuves, $neuf;
}

if(@mal){
  print "\n  REFUS — rien n'a ete ecrit :\n";
  print "    · $_\n" for @mal;
  die sprintf "\n  %d probleme(s) sur %d cartes.\n", scalar(@mal), $cartes_vues;
}

$neuves[0] = "const CARTES_$niv = [\n" . $neuves[0];
$s = $tete . join("\n\n", @neuves) . $queue;

# ================= le jeu s'en sert =================
my @T;
sub ech { push @T, [ @_ ] }

ech("le carnet retient ce que la reponse faisait dire", <<'AV', <<'AP');
  E.carnet.push({t:c.t, q:r.q, e:r.e, an:(E.mode==="campagne"?AN(E.tour):null),
AV
  /* « dit » voyage avec la decision : la bulle de chaque acteur se lit
     apres coup dans le carnet, et c'est lui qui porte la reaction
     propre a CETTE reponse. */
  E.carnet.push({t:c.t, q:r.q, e:r.e, dit:r.dit, an:(E.mode==="campagne"?AN(E.tour):null),
AP

ech("l acteur dit ce qui est ecrit pour cette carte", <<'AV', <<'AP');
function diraActeur(k){
  const d = dernierChoix();
  const v = d && d.e ? (d.e[k]||0) : 0;
  if(d && v){
    const logique = (N.forces[k].pourquoi || {})[v>0?"plus":"moins"] || "";
    return { txt: logique || (v>0 ? "Vous nous avez entendus." : "Nous n'oublierons pas."),
             sens: v>0 ? "gagne" : (v<=-8 ? "perd-fort" : "perd") };
  }
  return { txt: N.forces[k].veut, sens: "attend" };
}
AV
function diraActeur(k){
  const d = dernierChoix();
  const v = d && d.e ? (d.e[k]||0) : 0;
  if(d && v){
    /* La reaction ecrite pour CETTE reponse, si elle existe. Les deux
       phrases generales de la force ne servent plus que de filet —
       pour Detroit, qui n'a pas encore ses dialogues. */
    const propre = (d.dit || {})[k];
    const logique = propre || (N.forces[k].pourquoi || {})[v>0?"plus":"moins"] || "";
    return { txt: logique || (v>0 ? "Vous nous avez entendus." : "Nous n'oublierons pas."),
             sens: v>0 ? "gagne" : (v<=-8 ? "perd-fort" : "perd") };
  }
  /* Avant la decision : l'avis ecrit pour cette affaire, sinon ce que
     le groupe veut en general. */
  const avis = (E.carte && E.carte.av || {})[k];
  return { txt: avis || N.forces[k].veut, sens: "attend" };
}
AP

my $mauvais = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-50s %d occurrence(s)\n", $nom, $n; $mauvais++ }
}
die "\nARRET : $mauvais branchement(s) introuvable(s). Rien n'a ete ecrit.\n" if $mauvais;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $cible) or die "$cible: $!";
print $o $s; close $o;
printf "\n  %d repliques posees sur %d cartes\n", $mis, $cartes_vues;

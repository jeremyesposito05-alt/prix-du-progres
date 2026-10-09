#!/usr/bin/perl
# « ACTIONNAIRES » NE SE COUPE PLUS
#
#   perl _outils/nom-entier.pl index.html
#
# Le nom cassait en deux et laissait un « s » tout seul a la ligne.
# C'est « overflow-wrap:anywhere », pose la veille pour qu'un nom trop
# long ne deborde pas de sa carte : il ne debordait plus, il se
# coupait. Les deux sont mauvais.
#
# La bonne reponse n'est ni l'un ni l'autre : le nom ne casse JAMAIS,
# et c'est sa TAILLE qui suit la largeur de la carte. « cqi » mesure
# la largeur du conteneur, pas celle de la fenetre — or c'est bien la
# carte qui manque de place, et elle ne vaut pas toujours la meme
# fraction de l'ecran. Les paliers fixes poses par media queries
# disparaissent : une seule regle, continue, cale sur la boite reelle.
#
# 7,4 cqi : « Actionnaires », le plus long des huit noms, tient
# exactement dans la colonne du nom — qui vaut environ 47 % de la
# carte, medaillon et marges deduits.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";

my @T; sub ech { push @T, [ @_ ] }

ech("la carte devient un conteneur mesurable", <<'AV', <<'AP');
  display:grid; grid-template-columns:var(--rond) minmax(0,1fr);
AV
  /* « container-type » pour que le nom puisse se caler sur la largeur
     de SA carte, et non sur celle de la fenetre. */
  container-type:inline-size;
  display:grid; grid-template-columns:var(--rond) minmax(0,1fr);
AP

ech("le nom se reduit au lieu de se couper", <<'AV', <<'AP');
.poste .nm{font-family:var(--serif);font-size:23px;color:#F2E7D2;
  letter-spacing:.01em; line-height:1.1}
AV
.poste .nm{font-family:var(--serif);color:#F2E7D2;
  letter-spacing:.01em; line-height:1.1;
  /* il ne casse jamais : c'est sa taille qui cede */
  white-space:nowrap;
  font-size:clamp(13px, 7.4cqi, 23px)}
AP

ech("plus de coupure au milieu d un mot", <<'AV', <<'AP');
/* un nom trop long passe a la ligne plutot que de deborder */
.poste .nm{overflow-wrap:anywhere}

AV
AP

ech("le palier de 1150 ne fige plus la taille du nom", <<'AV', <<'AP');
  .poste{padding:11px 13px 11px 11px; column-gap:13px}
  .poste .nm{font-size:19px}
  .poste .tige{max-width:160px; height:6px}
AV
  .poste{padding:11px 13px 11px 11px; column-gap:13px}
  .poste .tige{max-width:160px; height:6px}
AP

ech("le palier de 1000 non plus", <<'AV', <<'AP');
  .poste{padding:9px 11px 9px 9px; column-gap:11px}
  .poste .nm{font-size:17px}
  .poste .tige{max-width:130px; margin-top:6px}
AV
  .poste{padding:9px 11px 9px 9px; column-gap:11px}
  .poste .tige{max-width:130px; margin-top:6px}
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-48s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

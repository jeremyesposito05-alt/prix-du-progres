#!/usr/bin/perl
# LES BOUTONS DE LANGUE NE RECOUVRENT PLUS LE SOUS-TITRE
#
# Poses en absolu dans le coin, ils passaient PAR-DESSUS la ligne
# « Manchester · Detroit · Demain » et en mangeaient la fin. Un coin
# libre a l'oeil ne l'est pas : il appartenait deja a quelque chose.
#
# Ils entrent donc dans le flux du bandeau du haut, qui est une rangee
# souple : blason a gauche, sous-titre au milieu, langues a droite.
# Plus aucun recouvrement possible, a aucune largeur — ce n'est plus
# une question de reglage mais de disposition.
#
# L'ecran du mode d'emploi garde la pose en absolu : la, le coin est
# reellement vide.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";

my @T; sub ech { push @T, [ @_ ] }

ech("les boutons entrent dans le bandeau du haut", <<'AV', <<'AP');
      <div class="surtitre-txt">${tx("lieux")}</div>
    </div>
    ${boutonsLangue()}
AV
      <div class="surtitre-txt">${tx("lieux")}</div>
      ${boutonsLangue()}
    </div>
AP

ech("css : dans le flux sur l ecran de titre", <<'AV', <<'AP');
.menu-ecran .langues{top:14px; right:16px}
AV
/* Sur l'ecran de titre ils sont DANS la rangee, pas au-dessus
   d'elle : le recouvrement devient impossible par construction. */
.te-haut .langues{position:static; flex:0 0 auto}
.menu-ecran .langues{top:14px; right:16px}
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-44s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

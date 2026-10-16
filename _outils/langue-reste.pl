#!/usr/bin/perl
# LES TROIS DERNIERS MORCEAUX DE FRANCAIS
#
#   perl _outils/langue-reste.pl index.html
#
# 1. L EN-TETE ET LE PIED AU CHARGEMENT. La langue est bien restauree
#    depuis le navigateur, mais « habillage() » — qui met a jour
#    « Musique », « Bruitages » et le pied de page, lesquels vivent hors
#    de « app » et ne sont jamais redessines — n est appele que depuis
#    « changerLangue ». Un eleve qui choisit l anglais, ferme la page et
#    revient retrouvait donc un en-tete francais. Mesure : la ligne de
#    restauration pose LANG et rien d autre.
#
# 2. LA LANGUE DU DOCUMENT. Elle n etait posee qu au changement de
#    langue, jamais a la restauration.
#
# 3. LE BOUTON « OUVRIR » DU CARNET. C est un « content: » de feuille de
#    style : il echappe au dictionnaire par construction. Puisque la
#    langue du document est maintenant juste des le chargement, le CSS
#    peut la lire — aucun detour par le script n est necessaire.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";

my @T; sub ech { push @T, [ @_ ] }

# ----------------------------------------------------------------- 1
ech("l en-tete et le pied suivent la langue des le chargement", <<'AV', <<'AP');
  const f = document.querySelector("footer");
  if(f) f.innerHTML = tx("pied") + `<br><span class="signature">`
      + tx("paraphe") + ` <b>Jeremy Esposito</b> · Collège Alpin Beau Soleil</span>`;
}
AV
  const f = document.querySelector("footer");
  if(f) f.innerHTML = tx("pied") + `<br><span class="signature">`
      + tx("paraphe") + ` <b>Jeremy Esposito</b> · Collège Alpin Beau Soleil</span>`;
}

/* AU CHARGEMENT, ET PAS SEULEMENT AU CHANGEMENT DE LANGUE.
   L'en-tete et le pied sont dans le document, pas dans « app » : rien
   ne les redessine. Sans cet appel, celui qui revient en anglais
   retrouvait « Musique » et « Bruitages » en francais.
   La langue du document est posee ici aussi : la feuille de style s'en
   sert pour les libelles qu'elle ecrit elle-meme. */
document.documentElement.lang = LANG;
if(LANG === "en") habillage();
AP

# ----------------------------------------------------------------- 2
ech("le bouton Ouvrir du carnet", <<'AV', <<'AP');
.carnet .pli::before{content:"Ouvrir"}
AV
.carnet .pli::before{content:"Ouvrir"}
html[lang="en"] .carnet .pli::before{content:"Open"}
AP

# ----------------------------------------------------------------- 3
ech("le bouton Ouvrir du dossier d enquete", <<'AV', <<'AP');
.d-enquete .pli::before{content:"Ouvrir"}
AV
.d-enquete .pli::before{content:"Ouvrir"}
html[lang="en"] .d-enquete .pli::before{content:"Open"}
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-52s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

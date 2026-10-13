#!/usr/bin/perl
# L EN-TETE ET LE PIED SUIVENT LA LANGUE
#
# Le tutoriel etait traduit, mais il reste entoure de francais : les
# deux reglages de son dans la barre du haut, et les deux lignes du
# pied de page. Sur l ecran qu on montre, ils sont aussi visibles que
# le reste.
#
# Ils vivent hors de « app » et ne sont pas redessines : on les met a
# jour a la main, au demarrage et a chaque bascule.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");
my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";

my @T; sub ech { push @T, [ @_ ] }

ech("les chaines de l habillage, en francais", <<'AV', <<'AP');
    unite2:{I:"habitants", II:"voitures par an"},
  },
AV
    unite2:{I:"habitants", II:"voitures par an"},
    musique:"Musique", bruitages:"Bruitages",
    pied:"Unité 1 — Quand l’innovation change la société",
  },
AP

ech("les chaines de l habillage, en anglais", <<'AV', <<'AP');
    unite2:{I:"inhabitants", II:"cars per year"},
  },
AV
    unite2:{I:"inhabitants", II:"cars per year"},
    musique:"Music", bruitages:"Sound",
    pied:"Unit 1 — When innovation changes society",
  },
AP

ech("la fonction qui met l habillage a jour", <<'AV', <<'AP');
function boutonsLangue(){
AV
/* L'en-tete et le pied vivent hors de « app » : ils ne sont jamais
   redessines, on les met donc a jour a la main. */
function habillage(){
  const r = document.querySelectorAll("header .regl i");
  if(r[0]) r[0].textContent = tx("musique");
  if(r[1]) r[1].textContent = tx("bruitages");
  const f = document.querySelector("footer");
  if(f) f.innerHTML = tx("pied") + `<br><span class="signature">`
      + tx("paraphe") + ` <b>Jeremy Esposito</b> · Collège Alpin Beau Soleil</span>`;
}

function boutonsLangue(){
AP

ech("la bascule met aussi l habillage a jour", <<'AV', <<'AP');
  document.documentElement.lang = l;
AV
  document.documentElement.lang = l;
  habillage();
AP

ech("et l ecran de titre l applique au demarrage", <<'AV', <<'AP');
function titre(){
  remonter(true);
AV
function titre(){
  remonter(true);
  habillage();
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-46s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

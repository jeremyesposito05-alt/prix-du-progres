#!/usr/bin/perl
# DES PNG DE DEUX MEGAOCTETS AUX JPEG DU JEU
#
#   perl _outils/convertir-visages.pl <dossier source> <table.txt>
#
# POURQUOI IL FAUT CONVERTIR. ChatGPT rend des PNG de 1254 x 1254 et
# 2,5 Mo. Seize font quarante megaoctets : la page serait injouable sur
# les telephones de la classe. Le jeu veut des portraits de 560 px.
#
# ET RECADRER. Les images sont CARREES, le cadre du jeu est en 4/5.
# Avec « object-fit:cover », un carre se fait rogner en haut et en bas
# — c'est-a-dire la tete, exactement le defaut corrige le 8 octobre au
# matin. On rogne donc les COTES : la hauteur est gardee en entier,
# le personnage se trouve centre, et rien d'essentiel ne part.
#
# COMMENT, SANS OUTIL D'IMAGE. Cette machine n'a ni Python, ni
# ImageMagick. Chrome, lui, sait dessiner une image dans un canevas et
# la rendre en JPEG. On lui fait ecrire les seize en base64 dans une
# page, on vide cette page dans un fichier, et Perl la decode. Rien de
# volumineux ne passe par le terminal.
use strict; use warnings; use utf8;
use MIME::Base64 qw(decode_base64);
binmode(STDOUT, ":encoding(UTF-8)");

my $src   = shift or die "usage: convertir-visages.pl <dossier> <table.txt>\n";
my $table = shift or die "usage\n";
my $dest  = "img/acteurs";
my $LARG  = 560;                 # le portrait du jeu
my $HAUT  = 700;                 # 4/5

# ---------- la table : « 1 I-m-content » par ligne ----------
my (@ordre, %nom);
open(my $t, "<:encoding(UTF-8)", $table) or die "$table: $!";
while(my $l = <$t>){
  next if $l =~ /^\s*#/; chomp $l; next unless $l =~ /\S/;
  my ($i, $n) = $l =~ /^\s*(\d+)\s+(\S+)\s*$/
    or die "ARRET : ligne illisible dans $table : $l\n";
  die "ARRET : l'image $i est nommee deux fois\n" if $nom{$i};
  $nom{$i} = $n; push @ordre, $i;
}
close $t;
@ordre or die "ARRET : table vide\n";

my @f = sort glob("$src/*.png");
@f = grep { !/_planche/ } @f;
printf "  %d images dans %s · %d noms dans la table\n", scalar(@f), $src, scalar(@ordre);
scalar(@f) == scalar(@ordre)
  or die "ARRET : autant de noms que d'images attendus\n";

# ---------- la page qui convertit ----------
sub url { my ($x) = @_; $x =~ s/([^A-Za-z0-9._\/-])/sprintf("%%%02X",ord($1))/ge; $x }
my $liste = join(",\n", map { '"' . url($_) . '"' } @f);
my $page = <<"HTML";
<html><head><meta charset=utf-8></head><body>
<div id="sortie"></div>
<script>
const SRC = [\n$liste\n];
const L = $LARG, H = $HAUT;
const out = document.getElementById("sortie");
let fait = 0;
SRC.forEach((s, i) => {
  const im = new Image();
  im.onload = () => {
    /* on rogne les COTES pour passer du carre au 4/5 : la hauteur
       entiere est gardee, donc la tete aussi. */
    const sh = im.height, sw = Math.round(sh * L / H);
    const sx = Math.max(0, Math.round((im.width - sw) / 2));
    const c = document.createElement("canvas");
    c.width = L; c.height = H;
    const g = c.getContext("2d");
    g.drawImage(im, sx, 0, Math.min(sw, im.width), sh, 0, 0, L, H);
    let d;
    try { d = c.toDataURL("image/jpeg", 0.84); }
    catch(e){ d = "ERREUR " + e.message; }
    const p = document.createElement("p");
    p.className = "img"; p.dataset.i = i;
    p.textContent = d;
    out.appendChild(p);
    if(++fait === SRC.length) document.title = "FINI";
  };
  im.onerror = () => {
    const p = document.createElement("p");
    p.className = "img"; p.dataset.i = i; p.textContent = "ERREUR chargement";
    out.appendChild(p);
    if(++fait === SRC.length) document.title = "FINI";
  };
  im.src = s;
});
</script></body></html>
HTML
open(my $o, ">:raw", "_convertir.html") or die "_convertir.html: $!";
print $o $page; close $o;
print "  page de conversion ecrite — lancez Chrome, puis relancez avec --poser\n"
  unless -e "_dump.html";

# ---------- decodage, si le vidage existe ----------
exit 0 unless -e "_dump.html";
open(my $d, "<:raw", "_dump.html") or die "_dump.html: $!";
my $dom = do { local $/; <$d> }; close $d;

mkdir $dest unless -d $dest;
my ($ok, @mal) = (0);
while($dom =~ /<p class="img" data-i="(\d+)">(.*?)<\/p>/gs){
  my ($i, $data) = ($1, $2);
  my $n = $nom{$i + 1};
  unless($n){ push @mal, "image " . ($i+1) . " : pas de nom dans la table"; next }
  unless($data =~ m{^data:image/jpeg;base64,(.+)$}s){
    push @mal, "$n : " . substr($data, 0, 60); next;
  }
  my $bin = decode_base64($1);
  unless(length($bin) > 3000){ push @mal, "$n : seulement " . length($bin) . " octets"; next }
  open(my $j, ">:raw", "$dest/$n.jpg") or die "$dest/$n.jpg: $!";
  print $j $bin; close $j;
  printf "  %-22s %6.0f Ko\n", "$n.jpg", length($bin)/1024;
  $ok++;
}
if(@mal){ print "\n  ECHECS :\n"; print "    · $_\n" for @mal }
printf "\n  %d image(s) ecrite(s) dans %s\n", $ok, $dest;

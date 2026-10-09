#!/usr/bin/perl
# LES SIX BUREAUX, DE DEUX MEGAOCTETS A DEUX CENTS KILO
#
#   perl _outils/convertir-decors.pl <dossier> <table.txt>
#   (deux fois : la premiere ecrit la page, la seconde decode le vidage)
#
# Meme chaine que pour les visages, a une difference pres : on ne
# recadre pas. Un decor est un fond, il doit garder sa largeur entiere
# — c'est son tiers superieur qui porte la ville, et ses bords qui
# tiennent la piece. On se contente de le mettre a la largeur du jeu
# et de le passer en JPEG.
#
# Six PNG de deux megaoctets font douze megaoctets a charger avant de
# voir quoi que ce soit. La classe joue sur des telephones.
use strict; use warnings; use utf8;
use MIME::Base64 qw(decode_base64);
binmode(STDOUT, ":encoding(UTF-8)");

my $src   = shift or die "usage: convertir-decors.pl <dossier> <table.txt>\n";
my $table = shift or die "usage\n";
my $dest  = "img/decor";
my $LARG  = 1680;          # la largeur du decor actuel, a onze pixels pres

my (@ordre, %nom);
open(my $t, "<:encoding(UTF-8)", $table) or die "$table: $!";
while(my $l = <$t>){
  next if $l =~ /^\s*#/; chomp $l; next unless $l =~ /\S/;
  my ($i, $n) = $l =~ /^\s*(\d+)\s+(\S+)\s*$/ or die "ARRET : ligne illisible : $l\n";
  die "ARRET : l'image $i est nommee deux fois\n" if $nom{$i};
  $nom{$i} = $n; push @ordre, $i;
}
close $t;

my @f = grep { !/_pl/ } sort glob("$src/*.png");
printf "  %d images dans %s · %d noms dans la table\n", scalar(@f), $src, scalar(@ordre);
scalar(@f) == scalar(@ordre) or die "ARRET : autant de noms que d'images attendus\n";

sub url { my ($x) = @_; $x =~ s/([^A-Za-z0-9._\/-])/sprintf("%%%02X",ord($1))/ge; $x }
my $liste = join(",\n", map { '"' . url($_) . '"' } @f);
my $page = <<"HTML";
<html><head><meta charset=utf-8></head><body>
<div id="sortie"></div>
<script>
const SRC = [\n$liste\n];
const L = $LARG;
const out = document.getElementById("sortie");
let fait = 0;
SRC.forEach((s, i) => {
  const im = new Image();
  im.onload = () => {
    /* pas de recadrage : un decor garde sa largeur entiere */
    const H = Math.round(im.height * L / im.width);
    const c = document.createElement("canvas");
    c.width = L; c.height = H;
    c.getContext("2d").drawImage(im, 0, 0, L, H);
    let d;
    try { d = c.toDataURL("image/jpeg", 0.82); }
    catch(e){ d = "ERREUR " + e.message; }
    const p = document.createElement("p");
    p.className = "img"; p.dataset.i = i; p.textContent = d;
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
unless(-e "_dump.html"){
  print "  page de conversion ecrite — lancez Chrome, puis relancez\n";
  exit 0;
}

open(my $d, "<:raw", "_dump.html") or die "_dump.html: $!";
my $dom = do { local $/; <$d> }; close $d;
mkdir $dest unless -d $dest;
my ($ok, @mal) = (0);
while($dom =~ /<p class="img" data-i="(\d+)">(.*?)<\/p>/gs){
  my ($i, $data) = ($1, $2);
  my $n = $nom{$i + 1};
  unless($n){ push @mal, "image " . ($i+1) . " : pas de nom"; next }
  unless($data =~ m{^data:image/jpeg;base64,(.+)$}s){
    push @mal, "$n : " . substr($data, 0, 60); next;
  }
  my $bin = decode_base64($1);
  unless(length($bin) > 10000){ push @mal, "$n : " . length($bin) . " octets"; next }
  open(my $j, ">:raw", "$dest/$n.jpg") or die "$dest/$n.jpg: $!";
  print $j $bin; close $j;
  printf "  %-24s %6.0f Ko\n", "$n.jpg", length($bin)/1024;
  $ok++;
}
if(@mal){ print "\n  ECHECS :\n"; print "    · $_\n" for @mal }
printf "\n  %d image(s) ecrite(s) dans %s\n", $ok, $dest;

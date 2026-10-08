#!/usr/bin/perl
# UN ENDROIT POUR LE PASSE, UN ENDROIT POUR LE PRESENT
#
#   perl _outils/retombee2.pl index.html
#
# CE QU'ON VOYAIT A L'ECRAN. Apres une decision, deux acteurs
# reagissaient a la carte precedente pendant que les deux autres
# donnaient leur avis sur la nouvelle — quatre bulles autour d'une
# affaire, dont deux parlaient d'autre chose, et rien pour les
# distinguer. Un eleve de quinze ans lit les quatre comme si elles
# portaient sur ce qu'il a sous les yeux.
#
# CE QU'ON FAIT. Tout ce qui est du passe monte dans le bandeau : la
# consequence, puis les deux voix qui y reagissent. Les quatre bulles
# ne parlent plus que de l'affaire en cours. Une zone, un moment.
#
# Les visages, eux, continuent de porter la derniere decision : celui
# qui a gagne avance, celui qui a perdu recule et tremble. L'emotion
# reste sur les faces, seules les paroles changent de place.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("js : le bandeau porte aussi les deux voix", <<'AV', <<'AP');
function retombee(){
  if(!E || !E.consq || !dernierChoix()) return "";
  return `<div class="retombee">
    <span class="rt-k">Ce qui est arrivé</span>
    <p>${esc(E.consq)}</p>
  </div>`;
}
AV
function retombee(){
  const d = dernierChoix();
  if(!E || !E.consq || !d) return "";
  /* Les deux voix que cette décision a fait parler. Elles sont ici et
     non dans les bulles : autour de l'affaire du jour, elles auraient
     commenté une affaire qui n'est plus celle-là. */
  const voix = Object.keys(d.dit || {}).map(k => {
    const v = (d.e || {})[k] || 0;
    return `<span class="rt-v ${v>0?"gagne":"perd"}">
      <b>${esc(N.forces[k].nom)}</b> ${esc(d.dit[k])}</span>`;
  }).join("");
  return `<div class="retombee">
    <div class="rt-tete">
      <span class="rt-k">Ce qui est arrivé</span>
      <p>${esc(E.consq)}</p>
    </div>
    ${voix ? `<div class="rt-voix">${voix}</div>` : ""}
  </div>`;
}
AP

ech("js : les bulles ne parlent que de l affaire en cours", <<'AV', <<'AP');
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
AV
function diraActeur(k){
  const d = dernierChoix();
  const v = d && d.e ? (d.e[k]||0) : 0;
  /* LE VISAGE PORTE LA DERNIERE DECISION, LA BULLE PORTE L'AFFAIRE EN
     COURS. « sens » commande le mouvement du portrait — celui qui a
     gagne avance, celui qui a perdu recule et tremble — tandis que le
     texte parle toujours de ce qui est sur le bureau maintenant. Ce
     qui s'est passe au tour precedent est dit en haut, par
     « retombee », ou il ne peut pas etre confondu.
     Pour Detroit, qui n'a pas encore ses dialogues, « veut » sert de
     filet : le groupe rappelle ce qu'il attend. */
  const avis = (E.carte && E.carte.av || {})[k];
  return { txt: avis || N.forces[k].veut,
           sens: (d && v) ? (v>0 ? "gagne" : (v<=-8 ? "perd-fort" : "perd")) : "attend" };
}
AP

ech("css : les deux voix sous la consequence", <<'AV', <<'AP');
.retombee p{margin:0; flex:1 1 300px; font-size:14.5px; line-height:1.45; color:var(--enc)}
AV
.retombee p{margin:0; flex:1 1 300px; font-size:14.5px; line-height:1.45; color:var(--enc)}
.retombee{flex-direction:column; align-items:stretch; gap:9px}
.retombee .rt-tete{display:flex; align-items:baseline; gap:14px; flex-wrap:wrap}
/* les deux voix : cote a cote quand la place le permet, l'une sous
   l'autre sinon. Un filet vert ou rouge dit qui a gagne, sans un mot. */
.retombee .rt-voix{display:flex; gap:9px; flex-wrap:wrap;
  padding-top:8px; border-top:1px solid rgba(107,87,65,.22)}
.retombee .rt-v{
  flex:1 1 260px; font-size:13px; line-height:1.4; color:var(--enc2);
  padding-left:9px; border-left:2px solid rgba(107,87,65,.4);
}
.retombee .rt-v b{color:var(--enc); font-weight:bold; margin-right:3px}
.retombee .rt-v.gagne{border-left-color:rgba(63,106,46,.75)}
.retombee .rt-v.perd{border-left-color:rgba(166,48,36,.7)}
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-50s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

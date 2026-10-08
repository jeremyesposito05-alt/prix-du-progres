#!/usr/bin/perl
# TROIS DECISIONS DU 8 OCTOBRE
#
#   perl _outils/sans-conditions.pl index.html
#
# 1. LES SEPT CONDITIONS S EN VONT. Elles etaient le mecanisme central
#    du jeu et ne figuraient nulle part dans le vocabulaire du cours :
#    ressource, capitaux, main-d'oeuvre, marches, transports, savoirs
#    techniques, organisation. Un eleve y lisait sept mots a apprendre
#    qui ne lui seraient jamais demandes. On les retire partout : la
#    pioche, l'acquisition, l'ecran de fin, le carnet, la trace ecrite
#    et l'export Word.
#
# 2. CINQ VISAGES, PAS QUATRE. Les bornes ne sont pas reparties
#    egalement : mesure sur vingt-six parties, 1796 relevés, une force
#    passe 46 % de son temps au-dessus de 58 et 2 % en dessous de 20.
#    Des bandes egales donnaient deux etats a 3 % et 1 % — invisibles.
#    Posees la ou le temps se passe, les cinq donnent
#    46 / 26 / 19 / 7 / 2 %.
#
# 3. LE TEMPS PASSE SUR LES VISAGES. Cinq images par acteur, c'est
#    cinq etats ; ce que l'on veut, c'est un portrait qui n'est jamais
#    deux fois le meme. La periode se depose donc sur l'image par le
#    code — le sepia monte, la couleur se retire, le contraste durcit,
#    le vignettage se ferme, a mesure que les annees avancent. Les cinq
#    images deviennent un continuum, et cela ne coute aucune image de
#    plus.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ===================================================================
# 1 · LES SEPT CONDITIONS S EN VONT
# ===================================================================

ech("la pioche ne depend plus d une condition acquise", <<'AV', <<'AP');
const ok=c=>!c.req||c.req.every(r=>E.acquis.includes(r));
AV
/* Les sept conditions ont ete retirees du jeu : plus rien ne les
   accorde, donc une carte qui en exigeait une ne sortirait jamais.
   Detroit garde des « req » dans ses anciennes cartes — on les ignore
   plutot que de les effacer, pour ne pas toucher a ses donnees avant
   sa refonte. */
const ok=c=>true;
AP

ech("une reponse n accorde plus de condition", <<'AV', <<'AP');
  (r.g||[]).forEach(g=>{ if(!E.acquis.includes(g)) E.acquis.push(g); });
AV
AP

ech("l ecran de fin : deux chiffres au lieu de trois", <<'AV', <<'AP');
/* Les trois chiffres, chacun expliqué. */
function blocChiffres(){
  const manque = CONDITIONS.filter(x => !E.acquis.includes(x));
  return `<div class="fin-chiffres">
AV
/* Les deux chiffres, chacun expliqué. Il y en avait trois : le
   troisième comptait les sept conditions, retirées du jeu. */
function blocChiffres(){
  return `<div class="fin-chiffres">
AP

ech("l ecran de fin : le bloc des conditions", <<'AV', <<'AP');
    <div class="fin-ch fin-ch-large">
      <div class="fin-n">${E.acquis.length} <small>/ ${CONDITIONS.length}</small></div>
      <div class="fin-k">Conditions de la révolution industrielle</div>
      <p>Ce sont les sept conditions vues en cours : réunies, elles font basculer une
      société dans l’industrie ; il en manque une, et les machines restent des
      curiosités. Chacune s’obtient en prenant la décision qui l’apporte.</p>
      <span class="cond fin-cond">${CONDITIONS.map(x=>
        `<span class="${E.acquis.includes(x)?"ok":""}">${condNom(x)}</span>`).join("")}</span>
      <p class="fin-manque">${
        manque.length === 0 ? "Vous les avez toutes réunies."
        : manque.length === CONDITIONS.length
          ? "Vous n’en avez réuni aucune : la ville n’a jamais vraiment basculé."
          : `Il vous manquait : ${condListe(manque).toLowerCase()}.`}</p>
    </div>

AV
AP

ech("le carnet : le bloc des conditions", <<'AV', <<'AP');
      ${N.cartes.some(x=>["a","b","c"].some(k=>x[k]&&x[k].g)) ? `
      <div class="cn-sep"></div>

      <div class="cn-ligne"><span class="cn-k">Conditions réunies</span>
        <span class="cn-v cn-petit">${E.acquis.length} <small>sur ${CONDITIONS.length}</small></span></div>
      <div class="cn-jauge"><i style="width:${
        Math.round(100*E.acquis.length/CONDITIONS.length)}%"></i></div>
      <ul class="cn-cond">${CONDITIONS.map(x=>
        `<li class="${E.acquis.includes(x)?"ok":""}">${condNom(x)}</li>`).join("")}</ul>
      ` : ""}

AV

AP

ech("la trace ecrite", <<'AV', <<'AP');
  L.push("  Conditions réunies : "+E.acquis.length+" / "+CONDITIONS.length
    +(E.acquis.length?"  ("+condListe(E.acquis)+")":""));
AV
AP

ech("l export Word", <<'AV', <<'AP');
  <tr><td class=k>Conditions réunies</td><td>${E.acquis.length} sur ${CONDITIONS.length}${
      E.acquis.length?" — "+e(condListe(E.acquis)):""}</td></tr>
AV
AP

ech("la table des conditions, et l etat qui la suivait", <<'AV', <<'AP');
const CONDITIONS = ["Ressources","Savoirs techniques","Capitaux","Main-d’œuvre","Marchés","Transports","Organisation"];
AV
/* LES SEPT CONDITIONS ONT ETE RETIREES DU JEU le 8 octobre 2026.
   Elles en etaient le mecanisme central, et aucune ne figurait dans le
   vocabulaire du cours — un eleve y lisait sept mots a apprendre qui
   ne lui seraient jamais demandes. La table reste pour la version
   anglaise, qui n'a pas encore ete refondue. */
const CONDITIONS = ["Ressources","Savoirs techniques","Capitaux","Main-d’œuvre","Marchés","Transports","Organisation"];
AP

# ===================================================================
# 2 · CINQ VISAGES
# ===================================================================

ech("cinq visages, bornes mesurees", <<'AV', <<'AP');
  const vis  = v>55 ? "content" : v>35 ? "portrait" : v>20 ? "fache" : "au-bord";
AV
  /* Bornes mesurees, non pas reparties egalement : 46 / 26 / 19 / 7 / 2 %
     du temps d'ecran. « portrait » est le visage neutre d'origine. */
  const vis  = v>58 ? "content" : v>48 ? "portrait" : v>35 ? "contrarie"
             : v>20 ? "fache" : "au-bord";
AP

# ===================================================================
# 3 · LA PERIODE SE DEPOSE SUR LES VISAGES
# ===================================================================

ech("css : le temps passe sur les portraits", <<'AV', <<'AP');
.poste .visage img{width:100%;height:100%;object-fit:cover;display:block;
  filter:sepia(.14) contrast(1.03)}
AV
/* LE TEMPS PASSE SUR LES VISAGES.
   « --age » va de 0 au premier tour a 1 au dernier. Le sepia monte, la
   couleur se retire, le contraste durcit : la meme image n'est jamais
   deux fois la meme, et cinq portraits par acteur deviennent un
   continuum sur dix-huit decisions. Aucune image de plus a produire. */
.poste .visage img{width:100%;height:100%;object-fit:cover;display:block;
  filter:sepia(calc(.14 + var(--age,0) * .3))
         saturate(calc(1 - var(--age,0) * .34))
         contrast(calc(1.03 + var(--age,0) * .14))
         brightness(calc(1 - var(--age,0) * .08));
  transition:filter 1.2s ease}
/* et le vignettage se ferme autour du visage */
.poste .visage::after{
  content:""; position:absolute; inset:0; pointer-events:none; z-index:1;
  opacity:calc(var(--age,0) * .55);
  background:radial-gradient(ellipse at 50% 40%,
    transparent 42%, rgba(28,19,11,.62) 100%);
  transition:opacity 1.2s ease;
}
AP

ech("js : l age de la partie se pose sur la page", <<'AV', <<'AP');
  app.classList.remove("presse");
  ecrire(c.t, c.ex, c.d);
AV
  app.classList.remove("presse");
  /* L'age de la partie, de 0 a 1 : le CSS s'en sert pour vieillir les
     portraits. En survie il n'y a pas de terme, on prend dix-huit
     decisions comme echelle. */
  document.body.style.setProperty("--age",
    Math.min(1, E.tour / (N.tours || 18)).toFixed(3));
  ecrire(c.t, c.ex, c.d);
AP

# ===================================================================
my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-54s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

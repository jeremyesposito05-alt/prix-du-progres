#!/usr/bin/perl
# LA LETTRE DU PROFESSEUR, ET CE QUE LES TRENTE CARTES ENTRAINENT
#
#   perl _outils/lettre.pl index.html
#
# 1. LA LETTRE s'ouvre AVANT le dilemme, une fois par carte. Elle dit
#    ou reviser, le mot a retenir, et la question a se poser. Elle
#    remplace le rapport d'enquete : elle ne s'y ajoute pas, sinon on
#    rajouterait huit mille caracteres a une campagne que la classe
#    trouve deja trop longue.
#
# 2. LE QUESTIONNAIRE ne pose que des questions portant sur ce que le
#    joueur a vu — il compare le titre de la carte. Les trente
#    nouvelles cartes ont de nouveaux titres : sans ce rattachement,
#    chaque question tombait dans le repli et le questionnaire devenait
#    aleatoire.
#
# 3. LES SEPT CONDITIONS ne sont plus accordees par personne : les
#    nouvelles cartes n'en portent pas. Le carnet affichait donc
#    « 0 sur 7 » du premier au dernier tour, ce qui est faux et
#    decourageant. On masque le bloc tant qu'aucune carte du niveau ne
#    peut en accorder une — Detroit, qui garde ses anciennes cartes,
#    continue de l'afficher. Le jour ou l'on tranchera sur les
#    conditions, il reviendra tout seul.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ================= 1 · LA LETTRE =================

ech("css : le pli du professeur", <<'AV', <<'AP');
/* ==================================================================
   LA SCENE — les quatre acteurs autour de l'affaire
AV
/* ==================================================================
   LE PLI DU PROFESSEUR
   Il s'ouvre avant le dilemme, une fois par carte. C'est le seul
   moment ou le jeu parle au nom du cours, et il parle seul : on ne
   decide pas tant qu'on ne l'a pas referme.
   ================================================================== */
.pli-prof{
  position:fixed; inset:0; z-index:60; display:flex;
  align-items:center; justify-content:center; padding:24px;
  background:rgba(14,10,7,.74);
  animation:pli-entre .3s ease-out;
}
.pli-prof.parti{animation:pli-sort .26s ease-in forwards}
@keyframes pli-entre{from{opacity:0}to{opacity:1}}
@keyframes pli-sort{to{opacity:0}}
.lettre-prof{
  max-width:560px; width:100%;
  background:
    linear-gradient(180deg, rgba(255,255,255,.55), transparent 22%),
    repeating-linear-gradient(94deg, rgba(160,140,110,.045) 0 2px, transparent 2px 5px),
    linear-gradient(152deg, var(--pap) 0%, var(--pap2) 100%);
  border:1px solid var(--fil); border-left:4px solid var(--rge);
  border-radius:2px; padding:26px 30px 22px; color:var(--enc);
  box-shadow:0 22px 60px rgba(0,0,0,.6);
  transform:rotate(-.35deg);
  animation:pli-pose .34s cubic-bezier(.2,.9,.3,1);
}
@keyframes pli-pose{from{opacity:0;transform:rotate(-1.6deg) translateY(16px)}
                    to{opacity:1;transform:rotate(-.35deg) translateY(0)}}
.lettre-prof .lt-tete{
  font-size:11px; letter-spacing:.18em; text-transform:uppercase;
  color:var(--rge); font-weight:bold; margin-bottom:13px;
}
.lettre-prof .lt-x{margin:0;font-size:16px;line-height:1.65;color:var(--enc)}
.lettre-prof .lt-x strong{color:var(--enc);font-weight:bold}
.lettre-prof .lt-sig{
  margin:18px 0 20px; text-align:right; font-family:var(--serif);
  font-size:20px; color:var(--enc2); letter-spacing:.06em;
}
.lettre-prof button{display:block;margin:0 auto}
@media(max-width:600px){ .lettre-prof{padding:20px 20px 18px}
  .lettre-prof .lt-x{font-size:15px} }
@media(prefers-reduced-motion:reduce){
  .pli-prof,.lettre-prof{animation:none}
}

/* ==================================================================
   LA SCENE — les quatre acteurs autour de l'affaire
AP

ech("js : la lettre, et le bouton qui la referme", <<'AV', <<'AP');
function rendre(){
  remonter();
AV
/* LA LETTRE DU PROFESSEUR — une fois par carte, avant de decider.
   On garde les titres deja lus plutot qu'un simple drapeau : apres la
   consequence, « rendre » repasse sur la meme carte, et la lettre se
   rouvrirait a chaque fois. */
function lettreAlire(){
  const c = E && E.carte;
  return !!(c && c.l && !(E.lettresLues || []).includes(c.t));
}
function lettreLue(){
  if(!E || !E.carte) return;
  E.lettresLues = E.lettresLues || [];
  if(!E.lettresLues.includes(E.carte.t)) E.lettresLues.push(E.carte.t);
  const el = document.getElementById("pli-prof");
  if(el){ el.classList.add("parti"); setTimeout(()=>el.remove(), 260); }
  try{ SON.papier() }catch(e){}
}
function pliProf(){
  if(!lettreAlire()) return "";
  return `<div class="pli-prof" id="pli-prof">
    <article class="lettre-prof">
      <div class="lt-tete">Un mot de votre professeur</div>
      <p class="lt-x">${gras(esc(E.carte.l))}</p>
      <div class="lt-sig">J. E.</div>
      <button class="plein" onclick="lettreLue()">J’ai lu</button>
    </article>
  </div>`;
}

function rendre(){
  remonter();
AP

ech("js : le pli s affiche avec le plateau", <<'AV', <<'AP');
  app.innerHTML=`
  ${alerte()}
  <div class="bureau"><div class="plateau large">
AV
  app.innerHTML=`
  ${alerte()}
  ${pliProf()}
  <div class="bureau"><div class="plateau large">
AP

# ================= 2 · LE QUESTIONNAIRE =================
# Chaque question de Manchester portait sur une carte, par son titre.
# Les titres ont change : on refait le lien, question par question.
my @liens = (
 ["Le charbon manque \x{E0} la filature.",          "Le charbon et la route"],
 ["Un m\x{E9}canicien vous montre un plan.",        "La vapeur \x{E0} la place de l\x{2019}eau"],
 ["Quarante familles attendent \x{E0} la grille.",  "Des familles devant l\x{2019}usine"],
 ["Un b\x{E2}tisseur propose soixante cottages.",   "Des maisons construites dos \x{E0} dos"],
 ["L\x{2019}eau croupit devant les portes.",        "Un enqu\x{EA}teur dans Ancoats"],
 ["Liverpool propose une voie ferr\x{E9}e.",        "Une ligne vers Liverpool"],
 ["Des acheteurs attendent \x{E0} Hambourg.",       "De nouvelles commandes lointaines"],
 ["Une fileuse demande \x{E0} vous parler.",        "Des enfants sous les machines"],
 ["Un contrema\x{EE}tre veut chronom\x{E9}trer les gestes.", "Un poste fixe par ouvrier"],
 ["Le pain a doubl\x{E9} depuis le printemps.",     "Le pain devient trop cher"],
 ["Une p\x{E9}tition contre les droits sur le grain.", "Le pain et les int\x{E9}r\x{EA}ts des fabricants"],
 ["Le monde entier d\x{E9}file au Crystal Palace.", "Manchester \x{E0} l\x{2019}Exposition de 1851"],
);
for my $l (@liens){
  ech("quiz : « " . substr($l->[0],0,34) . " »",
      "{c:\"$l->[0]\",", "{c:\"$l->[1]\",");
}

# ================= 3 · LES SEPT CONDITIONS =================
ech("js : le carnet masque les conditions que rien n accorde", <<'AV', <<'AP');
      <div class="cn-sep"></div>

      <div class="cn-ligne"><span class="cn-k">Conditions réunies</span>
AV
      ${N.cartes.some(x=>["a","b","c"].some(k=>x[k]&&x[k].g)) ? `
      <div class="cn-sep"></div>

      <div class="cn-ligne"><span class="cn-k">Conditions réunies</span>
AP

ech("js : fin du bloc des conditions", <<'AV', <<'AP');
      <ul class="cn-cond">${CONDITIONS.map(x=>
        `<li class="${E.acquis.includes(x)?"ok":""}">${condNom(x)}</li>`).join("")}</ul>
AV
      <ul class="cn-cond">${CONDITIONS.map(x=>
        `<li class="${E.acquis.includes(x)?"ok":""}">${condNom(x)}</li>`).join("")}</ul>
      ` : ""}
AP

# ================= verification puis ecriture =================
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

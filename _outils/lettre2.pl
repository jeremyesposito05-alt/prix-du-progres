#!/usr/bin/perl
# LA LETTRE ARRIVE, AU LIEU DE S AFFICHER
#
#   perl _outils/lettre2.pl index.html
#
# TROIS REPROCHES, TROIS REPONSES.
#
# 1. « Elle casse le rythme. » C'etait une boite de dialogue : elle
#    s'affichait, on cliquait, elle disparaissait. Elle ARRIVE
#    maintenant — l'enveloppe monte sur le bureau, le cachet de cire se
#    brise, le rabat s'ouvre, la feuille se deplie. Ce n'est plus une
#    interruption, c'est un evenement du jeu, et il dure une seconde.
#
# 2. « Mal habillee, pas agreable. » Une ligne rouge en capitales, un
#    paragraphe, deux initiales. Elle prend sa vraie forme : un
#    en-tete avec le college et l'annee en cours dans la partie, une
#    adresse au lecteur, le corps, et une signature a la main.
#
# 3. « A la premiere personne, comme si je leur envoyais une lettre. »
#    La PREMIERE lettre de chaque partie porte un mot d'introduction
#    qui dit ce que ces courriers seront. Les suivantes vont droit au
#    fait : repeter la meme entree en matiere dix-huit fois la rendrait
#    invisible.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("js : la lettre prend sa forme de lettre", <<'AV', <<'AP');
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
AV
function pliProf(){
  if(!lettreAlire()) return "";
  /* La toute premiere de la partie dit ce que ces courriers seront.
     Repetee dix-huit fois, cette entree en matiere deviendrait
     invisible : les suivantes vont droit au fait. */
  const premiere = !(E.lettresLues || []).length;
  const intro = premiere ? `
      <p class="lt-x lt-intro">Chère élève, cher élève,</p>
      <p class="lt-x">Je vous écrirai avant chacune de vos décisions. Rien de long :
      juste de quoi relier ce qui arrive sur votre bureau à ce que nous avons vu en
      classe. Voici le premier.</p>
      <div class="lt-filet" aria-hidden="true"></div>` : "";
  return `<div class="pli-prof" id="pli-prof">
    <div class="enveloppe" aria-hidden="true">
      <span class="env-rabat"></span><span class="env-cire"></span>
    </div>
    <article class="lettre-prof">
      <div class="lt-entete">
        <span class="lt-ecole">Collège Alpin Beau Soleil · Histoire</span>
        <span class="lt-date">${E.mode === "campagne" ? AN(E.tour) : N.lieu}</span>
      </div>
      ${intro}
      <p class="lt-x">${gras(esc(E.carte.l))}</p>
      <div class="lt-sig">J. E.</div>
      <button class="plein" onclick="lettreLue()">Continuer</button>
    </article>
  </div>`;
}
AP

ech("css : l enveloppe, le cachet, et le depliage", <<'AV', <<'AP');
.lettre-prof{
  max-width:560px; width:100%;
AV
/* ---------- l'enveloppe arrive, le cachet se brise ----------------
   Elle monte du bas, se pose, et son rabat s'ouvre pendant que la
   feuille se deplie par-dessus. Un peu plus d'une seconde en tout :
   assez pour qu'on voie ce qui se passe, trop court pour attendre. */
.pli-prof .enveloppe{
  position:absolute; width:300px; height:196px; border-radius:3px;
  background:linear-gradient(162deg,#E7D7B4,#CDB68C);
  border:1px solid #A98E5E;
  box-shadow:0 18px 40px rgba(0,0,0,.55);
  animation:env-monte .95s cubic-bezier(.2,.85,.3,1) forwards;
}
@keyframes env-monte{
  0%{opacity:0; transform:translateY(90px) rotate(-5deg) scale(.86)}
  55%{opacity:1; transform:translateY(0) rotate(0) scale(1)}
  100%{opacity:0; transform:translateY(-10px) scale(1.04)}
}
.pli-prof .env-rabat{
  position:absolute; inset:0 0 auto 0; height:58%;
  background:linear-gradient(170deg,#DCC79F,#C4AC80);
  clip-path:polygon(0 0,100% 0,50% 100%);
  transform-origin:top center;
  animation:env-ouvre .5s ease-in .42s both;
}
@keyframes env-ouvre{ to{ transform:rotateX(-168deg) } }
.pli-prof .env-cire{
  position:absolute; left:50%; top:48%; width:38px; height:38px;
  margin:-19px 0 0 -19px; border-radius:50%;
  background:radial-gradient(circle at 36% 32%,#C4503A,#7E2413 70%,#5A190C);
  box-shadow:0 2px 6px rgba(0,0,0,.5);
  animation:cire-brise .3s ease-in .4s both;
}
@keyframes cire-brise{
  0%{opacity:1; transform:scale(1)}
  60%{opacity:1; transform:scale(1.18) rotate(7deg)}
  100%{opacity:0; transform:scale(.6) rotate(-14deg)}
}
@media(prefers-reduced-motion:reduce){
  .pli-prof .enveloppe{display:none}
}

.lettre-prof{
  max-width:560px; width:100%;
AP

ech("css : l en-tete, l intro et le filet", <<'AV', <<'AP');
.lettre-prof .lt-tete{
  font-size:11px; letter-spacing:.18em; text-transform:uppercase;
  color:var(--rge); font-weight:bold; margin-bottom:13px;
}
AV
/* l'en-tete d'une vraie lettre : d'ou elle vient, et de quand */
.lettre-prof .lt-entete{
  display:flex; align-items:baseline; justify-content:space-between;
  gap:12px; flex-wrap:wrap; margin-bottom:16px; padding-bottom:9px;
  border-bottom:1px solid var(--fil);
}
.lettre-prof .lt-ecole{
  font-size:10.5px; letter-spacing:.16em; text-transform:uppercase;
  color:var(--rge); font-weight:bold;
}
.lettre-prof .lt-date{
  font-family:var(--serif); font-size:17px; color:var(--enc2);
}
.lettre-prof .lt-intro{font-family:var(--serif); font-size:18px; margin-bottom:.5em}
.lettre-prof .lt-filet{
  height:1px; margin:15px 0; background:linear-gradient(90deg,
    transparent, rgba(107,87,65,.45) 15%, rgba(107,87,65,.45) 85%, transparent);
}
.lettre-prof .lt-tete{
  font-size:11px; letter-spacing:.18em; text-transform:uppercase;
  color:var(--rge); font-weight:bold; margin-bottom:13px;
}
AP

ech("css : la feuille se deplie, et la signature s ecrit a la main", <<'AV', <<'AP');
  animation:pli-pose .34s cubic-bezier(.2,.9,.3,1);
}
@keyframes pli-pose{from{opacity:0;transform:rotate(-1.6deg) translateY(16px)}
                    to{opacity:1;transform:rotate(-.35deg) translateY(0)}}
AV
  animation:pli-deplie .62s cubic-bezier(.22,.9,.26,1) .62s both;
  transform-origin:top center;
}
/* la feuille sort de l'enveloppe et se deplie */
@keyframes pli-deplie{
  0%{opacity:0; transform:rotate(-.35deg) translateY(34px) scaleY(.46)}
  60%{opacity:1}
  100%{opacity:1; transform:rotate(-.35deg) translateY(0) scaleY(1)}
}
AP

ech("css : la signature", <<'AV', <<'AP');
.lettre-prof .lt-sig{
  margin:18px 0 20px; text-align:right; font-family:var(--serif);
  font-size:20px; color:var(--enc2); letter-spacing:.06em;
}
AV
.lettre-prof .lt-sig{
  margin:20px 0 22px; text-align:right; font-family:var(--serif);
  font-size:25px; color:#4A3B2C; letter-spacing:.1em;
  transform:rotate(-2.2deg); opacity:.88;
}
AP

ech("css : plus d air dans la lettre", <<'AV', <<'AP');
  border-radius:2px; padding:26px 30px 22px; color:var(--enc);
AV
  border-radius:2px; padding:30px 34px 24px; color:var(--enc);
AP

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

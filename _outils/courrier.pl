#!/usr/bin/perl
# LA LETTRE DEVIENT UN COURRIER QUI SE LIT EN DIX SECONDES
#
#   perl _outils/courrier.pl index.html
#
# CE QUI ETAIT REPROCHE, ET CE QUE J EN RETIENS.
#
#   « Elle occupe presque tout l'ecran et masque les quatre acteurs. »
#       Juste. Elle passe a six cents pixels, le voile s'allege et se
#       floute : on voit a travers que les portraits sont toujours la.
#
#   « Chere eleve, cher eleve manque de naturel. »
#       Juste. L'adresse disparait. On entre dans l'affaire.
#
#   « La definition est suivie d'une question complexe, et les
#     references au document 3 ressemblent a une consigne de devoir. »
#       Juste sur la forme, et c'est une question de PLACE, pas de
#       contenu : la reference reste — il l'a demandee, c'est elle qui
#       relie le jeu au cours — mais elle cesse d'etre la premiere
#       chose qu'on lit. Elle descend en bas, en petit, sous un filet.
#       La notion monte dans un encadre, la question ferme le courrier.
#
#   « Continuer ne precise pas l'action. »
#       Juste. « J'ai compris, place au choix. »
#
# CE QU'ON NE TOUCHE PAS : les soixante textes. Ils ont tous la meme
# forme — « Consultez <ou>. Retenez <mot> : <definition>. <question> »
# — et c'est l'affichage qui les decoupe. Verifie avant d'ecrire une
# ligne : les 60 se decoupent, aucune ne resiste. Si une lettre future
# echappait au motif, elle s'afficherait d'un bloc comme avant au lieu
# de disparaitre.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("js : le courrier, decoupe et remonte", <<'AV', <<'AP');
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
  /* Le temps de laisser les portraits reagir. Au tout premier tour il
     n'y a rien a regarder : elle vient presque tout de suite. */
  const retard = dernierChoix() ? "2.2s" : ".25s";
  return `<div class="pli-prof" id="pli-prof" style="--retard:${retard}">
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
AV
  /* La toute premiere de la partie dit, en une phrase, ce que ces
     courriers seront. Les suivantes entrent dans l'affaire. */
  const premiere = !(E.lettresLues || []).length;
  const intro = premiere ? `<p class="cp-ouverture">Je vous glisserai un mot avant
      chaque décision — juste de quoi relier ce qui arrive sur votre bureau à ce que
      nous avons vu en classe.</p>` : "";

  /* Le temps de laisser les portraits reagir. Au tout premier tour il
     n'y a rien a regarder : elle vient presque tout de suite. */
  const retard = dernierChoix() ? "2.2s" : ".25s";
  const d = decoupeLettre(E.carte.l);

  /* Decoupee, elle se lit en trois temps. Non decoupee — si un texte
     futur echappait au motif —, elle s'affiche d'un bloc : jamais
     rien d'invisible. */
  const corps = d ? `
      <div class="cp-notion">
        <span class="cp-n-k">À retenir · ${esc(d.mot)}</span>
        <p>${esc(d.def)}</p>
      </div>
      <p class="cp-q">${esc(d.question)}</p>
      <p class="cp-ref">À réviser : ${esc(d.ref)}</p>`
    : `<p class="cp-q">${gras(esc(E.carte.l))}</p>`;

  return `<div class="pli-prof" id="pli-prof" style="--retard:${retard}">
    <div class="enveloppe" aria-hidden="true">
      <span class="env-rabat"></span><span class="env-cire"></span>
    </div>
    <article class="lettre-prof courrier-prof">
      <div class="cp-tete">
        <span class="cp-qui">Le courrier du professeur</span>
        <span class="cp-ou">${esc(N.lieu)}${
          E.mode === "campagne" ? " · " + AN(E.tour) : ""}</span>
      </div>
      <div class="cp-titre">
        <span class="cp-icone" aria-hidden="true"><svg viewBox="0 0 24 24"
          ><path d="M3 6h18v12H3z"/><path d="M3.5 7l8.5 6 8.5-6"/></svg></span>
        <div>
          <h2>${esc(E.carte.t)}</h2>
          <p class="cp-sous">Comprendre avant de décider</p>
        </div>
      </div>
      ${intro}
      ${corps}
      <button class="plein" onclick="lettreLue()">J’ai compris · place au choix</button>
    </article>
  </div>`;
}

/* LE DECOUPAGE DES SOIXANTE LETTRES.
   Elles ont toutes la meme forme : ou reviser, le mot du cours et sa
   definition, puis la question a se poser. Mesure avant d'y toucher :
   les 60 se decoupent, aucune ne resiste. Rend « null » si une lettre
   future echappait au motif — l'affichage se replie alors sur le
   paragraphe entier. */
function decoupeLettre(l){
  if(!l) return null;
  const m = l.match(
    /^(?:Consultez|Révisez)\s+(.+?)\.\s*(?:Retenez\s+\*\*(.+?)\*\*\s*:\s*|Le terme\s+\*\*(.+?)\*\*\s+désigne\s+)(.+?)\.\s+([A-ZÀ-Þ].*)$/);
  if(!m) return null;
  return { ref:m[1], mot:(m[2] || m[3]), def:m[4], question:m[5] };
}
AP

ech("css : le courrier remplace la lettre scolaire", <<'AV', <<'AP');
/* l'en-tete d'une vraie lettre : d'ou elle vient, et de quand */
AV
/* ---------- LE COURRIER DU PROFESSEUR -----------------------------
   Six cents pixels, un voile leger et floute : on doit voir a travers
   que les quatre portraits sont toujours la. C'est eux qui donnent du
   sens a la decision — une lettre qui les masque entierement coupe le
   jeu en deux. */
.courrier-prof{max-width:600px}
.courrier-prof .cp-tete{
  display:flex; align-items:baseline; justify-content:space-between;
  gap:12px; flex-wrap:wrap; padding-bottom:9px; margin-bottom:15px;
  border-bottom:1px solid var(--fil);
  font-size:10.5px; letter-spacing:.15em; text-transform:uppercase;
}
.courrier-prof .cp-qui{color:var(--rge); font-weight:bold}
.courrier-prof .cp-ou{color:var(--enc2)}

.courrier-prof .cp-titre{display:flex; align-items:flex-start; gap:13px; margin-bottom:16px}
.courrier-prof .cp-icone{
  flex:0 0 auto; width:38px; height:38px; border-radius:3px;
  display:flex; align-items:center; justify-content:center;
  background:rgba(107,87,65,.12); border:1px solid var(--fil);
}
.courrier-prof .cp-icone svg{width:21px;height:21px;fill:none;
  stroke:var(--rge);stroke-width:1.6;stroke-linejoin:round;stroke-linecap:round}
.courrier-prof h2{
  margin:0; font-family:var(--serif); font-weight:normal; line-height:1.15;
  font-size:clamp(20px,2.6vw,26px); color:var(--enc);
}
.courrier-prof .cp-sous{
  margin:3px 0 0; font-size:12.5px; font-style:italic; color:var(--enc2);
}
.courrier-prof .cp-ouverture{
  margin:0 0 15px; font-size:15px; line-height:1.6; color:var(--enc2);
}

/* la notion du cours : encadree, c'est la seule chose a retenir */
.courrier-prof .cp-notion{
  margin:0 0 16px; padding:12px 15px; border-radius:2px;
  background:rgba(184,137,74,.13); border-left:3px solid var(--lai);
}
.courrier-prof .cp-n-k{
  display:block; font-size:10.5px; letter-spacing:.13em; text-transform:uppercase;
  color:#7A5A22; font-weight:bold; margin-bottom:5px;
}
.courrier-prof .cp-notion p{margin:0; font-size:15.5px; line-height:1.5; color:var(--enc)}

.courrier-prof .cp-q{
  margin:0 0 16px; font-family:var(--serif); font-size:17.5px; line-height:1.45;
  color:var(--enc);
}
/* la reference au cours : elle reste, mais elle n'est plus la premiere
   chose qu'on lit — c'est ce qui la faisait passer pour une consigne */
.courrier-prof .cp-ref{
  margin:0 0 18px; padding-top:10px; border-top:1px solid var(--fil);
  font-size:12px; line-height:1.5; color:var(--enc2); letter-spacing:.01em;
}
.courrier-prof button{display:block; margin:0 auto}

/* l'en-tete d'une vraie lettre : d'ou elle vient, et de quand */
AP

ech("css : un voile plus leger, qui laisse voir les acteurs", <<'AV', <<'AP');
  background:rgba(14,10,7,.74);
AV
  /* assez sombre pour qu'on lise, assez clair pour qu'on voie que les
     quatre portraits sont toujours autour */
  background:rgba(14,10,7,.5);
  backdrop-filter:blur(2.5px);
  -webkit-backdrop-filter:blur(2.5px);
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

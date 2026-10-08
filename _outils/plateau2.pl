#!/usr/bin/perl
# LE PLATEAU, DEUXIEME VERSION — d'apres le retour du 8 octobre 2026
#
#   perl _outils/plateau2.pl index.html
#
# Sept reproches, sept corrections :
#
#  1. « Votre but » illisible : la phrase etait posee a meme la
#     photographie du decor, sans papier dessous.
#  2. Le tutoriel revient a une mise en page classique — les points les
#     uns SOUS les autres — et a des phrases courtes.
#  3. Le texte de presentation du niveau racontait les regles une
#     seconde fois. Il raconte maintenant la VILLE, en quatre lignes.
#  4. Les quatre acteurs se voient tout de suite, en ronde, aux memes
#     places que dans la partie. Plus de dossier a derouler.
#  5. Les portraits etaient coupes : le cadre etait carre, les images
#     sont en 4/5. Et les trois reponses passent au centre, en bulles.
#  6. Les repliques deviennent de vraies bulles de bande dessinee, qui
#     mordent sur l'ordre du jour — mais jamais sur son texte, qui les
#     contourne (deux flotteurs mesures apres coup).
#  7. La bande du bas : trois languettes d'une ligne. Le carnet ne
#     s'ouvre plus tout seul, et le courrier vide ne s'affiche plus.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
my $avant_total = length $s;

my @T;   # [ nom, avant, apres ]
sub ech { push @T, [ @_ ] }

# ===================================================================
# 1 · LE TUTORIEL : une colonne, du papier sous le but
# ===================================================================

ech("css : les etapes en une colonne", <<'AV', <<'AP');
.etapes{display:grid;grid-template-columns:1fr 1fr;gap:16px}
@media(max-width:820px){.etapes{grid-template-columns:1fr}}
AV
/* Les temps de l'explication, les uns SOUS les autres. Sur deux
   colonnes, la classe lisait en zigzag et ne retenait rien. */
.etapes{display:grid;grid-template-columns:minmax(0,1fr);gap:13px;
  max-width:740px;margin:0 auto}
AP

ech("css : plus de regle pour une cinquieme fiche", <<'AV', <<'AP');
/* ---------- la cinquième fiche du tutoriel ------------------------
   Cinq fiches sur deux colonnes : la dernière reste seule. Calée à
   gauche, elle déséquilibrait la page ; on la centre sur la largeur
   d'une colonne, pour qu'on la lise comme les quatre autres. */
.etapes .etape:last-child:nth-child(odd){
  grid-column:1 / -1; justify-self:center;
  width:min(100%, calc(50% - 8px));
}
@media(max-width:820px){
  .etapes .etape:last-child:nth-child(odd){width:100%}
}
AV
/* ---------- il n'y a plus qu'une colonne --------------------------
   Les fiches se suivent : aucune ne reste seule au bout d'un rang,
   et la regle qui recentrait la derniere n'a plus d'objet. */
AP

ech("css : le but sur du papier", <<'AV', <<'AP');
.mini-forces{display:flex;flex-wrap:wrap;gap:15px;margin:0 0 10px}
AV
/* Le but du jeu. Pose a meme la photographie du decor, il se lisait a
   travers les cheminees : il lui fallait sa feuille. */
.but-jeu{
  max-width:740px; margin:0 auto 16px;
  background:
    linear-gradient(180deg, rgba(255,255,255,.5), transparent 26%),
    linear-gradient(152deg, var(--pap) 0%, var(--pap2) 100%);
  border:1px solid var(--fil); border-left:4px solid var(--rge);
  border-radius:2px; padding:15px 20px; color:var(--enc);
  box-shadow:0 11px 26px rgba(0,0,0,.46);
  font-size:16.5px; line-height:1.5; text-align:center;
}
.but-jeu strong{color:var(--enc);font-weight:bold}

.mini-forces{display:flex;flex-wrap:wrap;gap:15px;margin:0 0 10px}
AP

ech("tuto : le but, en une phrase", <<'AV', <<'AP');
      <p class="but-jeu">Votre but : <strong>conduire votre ville — ou votre usine — jusqu’au bout de la période sans qu’aucun des quatre groupes ne vous abandonne.</strong></p>
AV
      <p class="but-jeu">Quatre groupes vous jugent. <strong>Gardez-les tous les quatre jusqu’à la fin.</strong></p>
AP

ech("tuto : le premier point", <<'AV', <<'AP');
            <p>Une situation arrive sur votre bureau. Quelqu’un vient plaider sa cause, et vous avez <strong>trois réponses possibles</strong>.</p>
AV
            <p>Un problème arrive sur votre bureau. Quelqu’un vient vous demander quelque chose. Vous avez <strong>trois réponses</strong>.</p>
AP

ech("tuto : le deuxieme point", <<'AV', <<'AP');
            <p>Vous choisissez. Chaque réponse <strong>contente un groupe et en fâche un autre</strong> : aucune ne plaît à tout le monde.</p>
AV
            <p>Vous choisissez. Chaque réponse <strong>fait un content et un mécontent</strong>. Aucune ne plaît aux quatre.</p>
AP

ech("tuto : le troisieme point", <<'AV', <<'AP');
            <p>Si un groupe vous lâche tout à fait, <strong>la partie s’arrête</strong>. Sinon vous allez au bout, et vous découvrez ce que vous avez bâti.</p>
AV
            <p>Si un groupe vous abandonne, <strong>la partie s’arrête</strong>. Sinon vous allez au bout, et vous voyez la ville que vous avez faite.</p>
AP

# ===================================================================
# 2 · LA PRESENTATION DU NIVEAU : on raconte la ville, pas les regles
# ===================================================================

ech("niveau I : le contexte de Manchester", <<'AV', <<'AP');
     role:"Vous décidez pour Manchester.",
     qui:"Vous n’êtes ni le patron, ni l’ouvrier, ni le député. Vous êtes celui qui tranche — et <strong>chacune de vos décisions fait un gagnant et un perdant.</strong>",
     but:"Votre but : mener la ville jusqu’en 1851 sans qu’aucune force ne vous lâche — puis découvrir quelle Manchester vous avez bâtie.",
     note:"<strong>Pourquoi 1851 ?</strong> Cette année-là, Londres expose sous le Crystal Palace tout ce que l’industrie britannique sait faire, et le recensement établit que le pays compte désormais plus de citadins que de ruraux — une première dans l’histoire. C’est le moment où la société née en 1780 peut enfin se regarder en face.",
AV
     role:"Manchester, 1780.",
     qui:"C’est encore une petite ville de drapiers. Elle a du <strong>charbon</strong> tout près, une rivière qui fait tourner les machines, et des marchands qui cherchent à vendre plus loin.",
     but:"En soixante-dix ans, elle va devenir la première ville industrielle du monde. C’est vous qui décidez comment.",
     note:"<strong>Jusqu’en 1851.</strong> Cette année-là, l’Angleterre compte pour la première fois plus de citadins que de ruraux.",
AP

ech("niveau II : le contexte de Detroit", <<'AV', <<'AP');
     role:"Vous dirigez l’usine.",
     qui:"Vous n’êtes ni l’ingénieur, ni l’ouvrier de la chaîne, ni l’actionnaire. Vous êtes celui qui tranche — et <strong>chaque gain de productivité se prend quelque part.</strong>",
     but:"Votre but : mener l’usine jusqu’en 1932 sans qu’aucune force ne vous lâche — puis découvrir quelle entreprise vous avez bâtie.",
     note:"<strong>Pourquoi 1932 ?</strong> Le 7 mars, plusieurs milliers de chômeurs marchent sur les usines de Dearborn pour demander du travail. La police tire. La chaîne qui avait fait la prospérité de la ville venait de produire du chômage de masse : c’est là que la deuxième révolution industrielle se regarde en face.",
AV
     role:"Detroit, 1908.",
     qui:"On y fabrique des automobiles à la main, une par une, pour des gens riches. Autour de la ville : du fer, du <strong>charbon</strong>, du pétrole, des trains — et un pays immense où tout le monde voudrait rouler.",
     but:"En vingt-cinq ans, l’usine Ford va changer la façon de fabriquer. C’est vous qui la dirigez.",
     note:"<strong>Jusqu’en 1932.</strong> Le 7 mars, des milliers de chômeurs marchent sur les usines de Dearborn pour demander du travail. La police tire.",
AP

ech("niveau : la regle ne se repete plus", <<'AV', <<'AP');
    <p class="r-but"><strong>Si l’une des quatre forces tombe à zéro, la partie s’arrête.</strong> ${N.but}</p>
AV
    <p class="r-but">${N.but}</p>
AP

ech("niveau : la note de source, raccourcie", <<'AV', <<'AP');
    <p class="note-source">Ceux qui viennent vous parler sont des figures composites : ils n’ont pas porté ces noms, mais chacun dit ce que disaient les gens de sa condition. Les deux seuls témoignages authentiques du jeu vous attendent à la fin de la partie.</p>
AV
    <p class="note-source">Les personnages sont inventés ; ce qu’ils disent, non. Les deux seuls témoignages authentiques vous attendent à la fin de la partie.</p>
AP

# ===================================================================
# 3 · LA RONDE DES ACTEURS — visible tout de suite
# ===================================================================

ech("css : la ronde remplace la galerie repliee", <<'AV', <<'AP');
/* ---------- la galerie des acteurs --------------------------------
   Une fiche par force, repliée. L'emblème et le nom suffisent à la
   reconnaître ; le portrait et la scène récompensent celui qui ouvre. */
.acteurs{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin:20px 0 6px;
  align-items:start}   /* une fiche fermee ne doit pas s etirer */
@media(max-width:820px){.acteurs{grid-template-columns:1fr}}

details.acteur{
  background:
    linear-gradient(180deg, rgba(255,255,255,.5), transparent 26%),
    linear-gradient(152deg, var(--pap) 0%, var(--pap2) 100%);
  border:1px solid var(--fil); border-left:4px solid var(--lai); border-radius:2px;
  color:var(--enc); box-shadow:0 9px 22px rgba(0,0,0,.44); overflow:hidden;
}
details.acteur summary{
  list-style:none; cursor:pointer; display:flex; align-items:center; gap:13px;
  padding:12px 15px;
}
details.acteur summary::-webkit-details-marker{display:none}
details.acteur[open]{border-left-color:var(--rge)}

.embleme{margin:0;flex:0 0 auto}
.embleme img{width:58px;height:58px;object-fit:contain;display:block;
  filter:drop-shadow(0 2px 5px rgba(0,0,0,.3))}


.nom-acteur{font-family:var(--serif);font-size:20px;line-height:1.1}
summary .veut{font-size:12.5px;font-style:italic;color:var(--rge);
  flex:1 1 100%; order:3; margin-top:-4px}
@media(min-width:560px){ summary .veut{flex:1 1 auto; order:0; margin-top:0} }
details.acteur .pli{
  margin-left:auto; flex:0 0 auto; font-size:10px; letter-spacing:.1em;
  text-transform:uppercase; color:var(--enc2);
  border:1px solid var(--fil); border-radius:2px; padding:3px 9px;
  background:rgba(255,255,255,.45); white-space:nowrap;
}
details.acteur .pli::before{content:"Ouvrir le dossier"}
details.acteur[open] .pli::before{content:"Fermer"}
details.acteur .pli::after{content:" ▼"}
details.acteur[open] .pli::after{content:" ▲"}

.acteur .fiche{padding:0 15px 15px;display:grid;gap:0 15px;
  grid-template-columns:122px minmax(0,1fr)}
@media(max-width:560px){ .acteur .fiche{grid-template-columns:1fr} }
.acteur .fiche .role{font-size:14px;line-height:1.6;color:var(--enc2);
  border-top:1px solid var(--fil);padding-top:12px;margin-top:12px}
.acteur .fiche .role strong{color:var(--enc)}

.portrait-acteur{margin:12px 0 0;width:100%}
.portrait-acteur img{
  width:100%;height:auto;display:block;border:1px solid var(--fil);
  box-shadow:0 4px 12px rgba(0,0,0,.4);
}
.scene-acteur{grid-column:1 / -1;margin:13px 0 0}
.scene-acteur img{
  width:100%;height:auto;display:block;border:1px solid var(--fil);
  box-shadow:0 6px 18px rgba(0,0,0,.42);
}
@media(max-width:560px){ .portrait-acteur{float:none;width:100%;margin:0 0 10px} }
AV
/* ---------- la ronde des acteurs ----------------------------------
   Les quatre groupes, ouverts, aux MEMES places que dans la partie :
   industriels en haut a gauche, marchands en haut a droite, ouvriers
   en bas a gauche, Parlement en bas a droite. L'eleve qui entre dans
   sa premiere decision retrouve un plateau qu'il a deja vu.
   Les fiches etaient repliees derriere « Ouvrir le dossier » : la
   classe ne les ouvrait pas. */
.embleme{margin:0;flex:0 0 auto}
.embleme img{width:58px;height:58px;object-fit:contain;display:block;
  filter:drop-shadow(0 2px 5px rgba(0,0,0,.3))}

.ronde{
  display:grid; gap:14px 16px; align-items:stretch; margin:22px 0 6px;
  grid-template-columns:minmax(0,1fr) minmax(0,.72fr) minmax(0,1fr);
}
.r-i{grid-area:1/1} .r-m{grid-area:1/3}
.r-o{grid-area:2/1} .r-p{grid-area:2/3}
.ronde-c{grid-area:1/2/3/3; display:flex; flex-direction:column;
  align-items:center; justify-content:center; text-align:center; padding:8px 4px}

.fich{
  display:grid; gap:0 14px; grid-template-columns:96px minmax(0,1fr);
  background:
    linear-gradient(180deg, rgba(255,255,255,.5), transparent 26%),
    linear-gradient(152deg, var(--pap) 0%, var(--pap2) 100%);
  border:1px solid var(--fil); border-left:4px solid var(--lai);
  border-radius:2px; padding:14px 16px; color:var(--enc);
  box-shadow:0 9px 22px rgba(0,0,0,.44);
}
.fich figure{margin:0; grid-row:1 / span 3}
.fich figure img{
  width:100%; aspect-ratio:4/5; object-fit:cover; display:block;
  border:1px solid var(--fil); box-shadow:0 3px 10px rgba(0,0,0,.4);
  filter:sepia(.12) contrast(1.03);
}
.fich .fi-t{font-family:var(--serif);font-size:21px;line-height:1.1}
.fich .fi-v{font-size:12.5px;font-style:italic;color:var(--rge);margin:3px 0 8px}
.fich .fi-r{margin:0;font-size:13.5px;line-height:1.55;color:var(--enc2)}
.fich .fi-r strong{color:var(--enc);font-weight:bold}

.ronde-c .rc-t{
  margin:0 0 8px; font-family:var(--serif); font-size:clamp(17px,2vw,21px);
  color:var(--pap); text-shadow:0 2px 14px rgba(0,0,0,.85); line-height:1.2;
}
.ronde-c .rc-x{
  margin:0; font-size:13.5px; line-height:1.55; color:#CDBCA2;
  text-shadow:0 2px 10px rgba(0,0,0,.9); max-width:30ch;
}
@media(max-width:900px){
  .ronde{display:flex; flex-direction:column}
  .ronde-c{order:-1; padding:0 0 4px}
  .fich{grid-template-columns:76px minmax(0,1fr)}
}
AP

ech("niveau : la ronde remplace les dossiers", <<'AV', <<'AP');
  <div class="acteurs">${CLES.map(k=>`<details class="acteur">
     <summary>
       <figure class="embleme"><img src="img/acteurs/${N.id}-${k}-embleme.jpg" alt=""
         onerror="this.closest('figure').remove()"></figure>
       <span class="nom-acteur">${N.forces[k].nom}</span>
       <span class="veut">${esc(N.forces[k].veut)}</span>
       <span class="pli"></span>
     </summary>
     <div class="fiche">
       <figure class="portrait-acteur"><img src="img/acteurs/${N.id}-${k}-portrait.jpg" alt="" loading="lazy"
         onerror="this.closest('figure').remove()"></figure>
       <div class="role">${gras(esc(N.forces[k].role))}</div>
       <figure class="scene-acteur"><img src="img/acteurs/${N.id}-${k}-scene.jpg" alt="" loading="lazy"
         onerror="this.closest('figure').remove()"></figure>
     </div>
   </details>`).join("")}</div>
AV
  <div class="ronde">
    ${["i","m"].map(fichActeur).join("")}
    <div class="ronde-c">
      <p class="rc-t">Les quatre groupes qui vous jugent</p>
      <p class="rc-x">Chaque décision en contente un et en fâche un autre.
      Si l’un d’eux vous abandonne tout à fait, la partie s’arrête.</p>
    </div>
    ${["o","p"].map(fichActeur).join("")}
  </div>
AP

# ===================================================================
# 4 · LA SCENE : portraits entiers, bulles de BD, reponses au centre
# ===================================================================

ech("css : la grille de la scene", <<'AV', <<'AP');
.scene{
  display:grid; gap:12px 16px; align-items:stretch;
  grid-template-columns:minmax(0,1fr) minmax(0,1.6fr) minmax(0,1fr);
  grid-template-rows:auto auto;
  margin:0 0 18px;
}
.p-i{grid-area:1/1} .p-m{grid-area:1/3}
.p-o{grid-area:2/1} .p-p{grid-area:2/3}
.centre{grid-area:1/2/3/3; display:flex; flex-direction:column; gap:10px}
AV
.scene{
  display:grid; gap:14px 18px; align-items:stretch;
  grid-template-columns:minmax(0,.95fr) minmax(0,2fr) minmax(0,.95fr);
  grid-template-rows:auto auto;
  margin:0 0 4px;
}
.p-i{grid-area:1/1} .p-m{grid-area:1/3}
.p-o{grid-area:2/1} .p-p{grid-area:2/3}
/* Les bulles debordent des postes sur l'ordre du jour : elles ne
   peuvent le faire que si les postes passent DEVANT le centre. */
.centre{grid-area:1/2/3/3; display:flex; flex-direction:column; gap:10px;
  position:relative; z-index:1}
AP

ech("css : le portrait n'est plus coupe", <<'AV', <<'AP');
.poste .visage{
  position:relative; width:100%; aspect-ratio:1/1; max-height:124px;
  border-radius:2px; overflow:hidden; background:var(--pap2);
  border:1px solid rgba(107,87,65,.28);
  transition:box-shadow .42s ease;
}
AV
/* Les portraits sont en 540 x 675, soit 4/5. Le cadre etait carre :
   il leur coupait la tete. Le cadre prend desormais la forme de
   l'image, et plus rien n'est rogne. */
.poste .visage{
  position:relative; width:100%; aspect-ratio:4/5;
  border-radius:2px; overflow:hidden; background:var(--pap2);
  border:1px solid rgba(107,87,65,.28);
  transition:box-shadow .42s ease;
}
AP

ech("css : la replique devient une bulle de BD", <<'AV', <<'AP');
/* ---------- ce qu'il dit ---------- */
.poste .dit{
  position:relative; margin-top:1px; padding:7px 9px; border-radius:2px;
  background:rgba(255,255,255,.5); border:1px solid rgba(107,87,65,.22);
  font-size:12.5px; line-height:1.4; color:var(--enc);
}
.poste .dit::before{
  content:""; position:absolute; top:-5px; left:12px; width:8px; height:8px;
  background:rgba(255,255,255,.5); border-left:1px solid rgba(107,87,65,.22);
  border-top:1px solid rgba(107,87,65,.22); transform:rotate(45deg);
}
.poste.gagne .dit{border-color:rgba(63,106,46,.4)}
.poste.perd .dit,.poste.perd-fort .dit{border-color:rgba(166,48,36,.35)}
AV
/* ---------- ce qu'il dit : une bulle, pas un encart ----------
   Elle part du visage et mord sur l'ordre du jour. Elle ne passe
   jamais sur le texte : deux flotteurs invisibles, mesures apres
   coup par « calerBulles », reservent sa place et le texte la
   contourne. */
.poste .dit{
  position:absolute; top:24%; z-index:6; width:200px;
  padding:9px 13px 10px; border-radius:15px;
  background:#FFFCF2; border:1.5px solid rgba(74,56,38,.6);
  box-shadow:0 7px 18px rgba(0,0,0,.42);
  font-size:13px; line-height:1.38; color:var(--enc);
}
.p-i .dit,.p-o .dit{left:calc(100% - 90px)}
.p-m .dit,.p-p .dit{right:calc(100% - 90px)}
/* la queue : deux triangles, le bord puis le papier */
.poste .dit::before,.poste .dit::after{
  content:""; position:absolute; width:0; height:0; border:10px solid transparent;
}
.poste .dit::before{top:13px}
.poste .dit::after{top:14px; border-width:9px}
.p-i .dit::before,.p-o .dit::before{left:-20px; border-right-color:rgba(74,56,38,.6)}
.p-i .dit::after,.p-o .dit::after{left:-17px; border-right-color:#FFFCF2}
.p-m .dit::before,.p-p .dit::before{right:-20px; border-left-color:rgba(74,56,38,.6)}
.p-m .dit::after,.p-p .dit::after{right:-17px; border-left-color:#FFFCF2}

.poste.gagne .dit{border-color:rgba(63,106,46,.65)}
.p-i.gagne .dit::before,.p-o.gagne .dit::before{border-right-color:rgba(63,106,46,.65)}
.p-m.gagne .dit::before,.p-p.gagne .dit::before{border-left-color:rgba(63,106,46,.65)}
.poste.perd .dit,.poste.perd-fort .dit{border-color:rgba(166,48,36,.6)}
.p-i.perd .dit::before,.p-o.perd .dit::before,
.p-i.perd-fort .dit::before,.p-o.perd-fort .dit::before{border-right-color:rgba(166,48,36,.6)}
.p-m.perd .dit::before,.p-p.perd .dit::before,
.p-m.perd-fort .dit::before,.p-p.perd-fort .dit::before{border-left-color:rgba(166,48,36,.6)}
AP

ech("css : le centre, les encoches et les reponses en bulles", <<'AV', <<'AP');
/* ---------- le centre : l'affaire, et le joueur ---------- */
.centre .ordre{flex:1;display:flex;flex-direction:column}
AV
/* ---------- le centre : l'affaire, et le joueur ---------- */
/* En « flex », un flotteur est ignore : l'ordre du jour redevient un
   bloc, sans quoi le texte ne contournerait rien. */
.centre .ordre{display:block; position:relative}
/* Les deux encoches : invisibles, sans contenu, elles ne font que
   reserver le coin que la bulle occupe. JS leur donne leur taille. */
.centre .ordre .encoche{display:block;width:0;height:0;margin:0;padding:0;
  pointer-events:none}
.centre .ordre .encoche.eg{float:left}
.centre .ordre .encoche.ed{float:right}
.centre .ordre .d{clear:both}

/* Les trois reponses, au milieu du plateau, en bulles. Elles etaient
   sous la scene : il fallait quitter des yeux l'affaire pour les lire. */
.centre .question{margin:12px 0 8px;grid-column:auto}
.centre .rep{grid-template-columns:minmax(0,1fr);gap:9px;margin:0}
.centre .choix{
  border-radius:16px !important; padding:12px 17px !important;
  transform:none !important; text-align:left;
  border:1.5px solid rgba(74,56,38,.5) !important;
}
.centre .choix .q{font-size:16px;line-height:1.32}
.centre .choix:hover{transform:translateY(-2px) !important;
  border-color:var(--rge) !important}
AP

ech("css : la bande du bas, trois languettes", <<'AV', <<'AP');
/* ---------- les dossiers, en bande sous les reponses ---------- */
.appoints{
  display:flex; flex-wrap:wrap; gap:10px; margin-top:20px;
  padding-top:14px; border-top:1px solid rgba(107,87,65,.22);
}
.appoints > *{flex:1 1 220px; min-width:0}
.appoints .dossier{margin:0}
AV
/* ---------- les dossiers : trois languettes, pas trois panneaux ----
   Ferme, un dossier tenait encore un tiers de l'ecran : le carnet
   s'ouvrait tout seul et deployait l'annee, la population, les sept
   conditions ; le courrier vide affichait une enveloppe geante pour
   dire qu'il n'y avait rien. C'est l'encombrement que la classe a
   reproche au jeu. Desormais : une ligne chacun, et on tire. */
.appoints{
  display:flex; flex-wrap:wrap; align-items:flex-start; gap:10px;
  margin-top:22px; padding-top:13px;
  border-top:1px solid rgba(107,87,65,.22);
}
.appoints > *{flex:1 1 230px; min-width:0; align-self:flex-start}
.appoints .dossier{margin:0}
.appoints details:not([open]) > summary{padding:9px 14px}
.appoints .courrier:not([open]) .env{display:none}
.appoints .carnet:not([open]) .spirale{display:none}
AP

ech("css : le telephone", <<'AV', <<'AP');
@media(max-width:860px){
  .scene{grid-template-columns:1fr;grid-template-rows:auto}
  .centre{grid-area:auto;order:-1}
  .p-i,.p-m,.p-o,.p-p{grid-area:auto}
  .scene{display:grid}
  .poste{flex-direction:row;align-items:center;gap:9px;transform:none!important}
  .poste .visage{width:58px;height:58px;max-height:58px;flex:0 0 58px;aspect-ratio:auto}
  .poste .ident{flex:0 0 92px}
  .poste .tige{display:none}
  .poste .dit{flex:1;margin:0}
  .poste .dit::before{top:12px;left:-5px;border:none;
    border-left:1px solid rgba(107,87,65,.22);border-bottom:1px solid rgba(107,87,65,.22)}
}
AV
/* ---------- le telephone : une colonne, dans l'ordre de lecture ----
   L'affaire, les quatre acteurs, puis la question. « display:contents »
   sort les enfants du centre pour qu'ils prennent leur rang entre les
   postes : sans lui, les reponses arrivaient avant les arguments. */
@media(max-width:860px){
  .scene{display:flex; flex-direction:column; gap:11px}
  .centre{display:contents}
  .centre .ordre{order:-2}
  .poste{order:0}
  .centre .question{order:1;margin:6px 0 2px}
  .centre .rep{order:2}
  .centre .moi{display:none}
  .centre .ordre .encoche{display:none}
  .poste{flex-direction:row;align-items:center;gap:10px;transform:none!important}
  .poste .visage{width:62px;flex:0 0 62px;aspect-ratio:4/5}
  .poste .ident{flex:0 0 96px}
  .poste .tige{display:none}
  .poste .dit{position:static;flex:1;width:auto;border-radius:12px;
    padding:8px 11px;box-shadow:none}
  .poste .dit::after{display:none}
  .poste .dit::before{top:16px;left:-19px;right:auto;border-width:9px;
    border-right-color:rgba(74,56,38,.6) !important;
    border-left-color:transparent !important}
}
AP

# ===================================================================
# 5 · LE JS DE LA SCENE
# ===================================================================

ech("js : la scene accueille la question et les reponses", <<'AV', <<'AP');
function scene(c){
  const vus = concernes(c);
  const d = dernierChoix();
  return `<div class="scene" data-phase="${d?"apres":"avant"}">
    ${poste("i", c, vus)}
    ${poste("m", c, vus)}
    <div class="centre">
      <div class="situ ordre dossier d-situation">
        <span class="onglet">Affaire du jour</span>
        <div class="t"></div>
        <div class="ex"></div>
        <div class="parle">${illuPersonne(c.qui)}<span>${esc(c.qui)}</span></div>
        <div class="d"></div>
      </div>
      <div class="moi" aria-hidden="true"><span></span></div>
    </div>
    ${poste("o", c, vus)}
    ${poste("p", c, vus)}
  </div>`;
}
AV
function scene(c, reponses){
  const vus = concernes(c);
  const d = dernierChoix();
  return `<div class="scene" data-phase="${d?"apres":"avant"}">
    ${poste("i", c, vus)}
    ${poste("m", c, vus)}
    <div class="centre">
      <div class="situ ordre dossier d-situation">
        <i class="encoche eg" aria-hidden="true"></i>
        <i class="encoche ed" aria-hidden="true"></i>
        <span class="onglet">Affaire du jour</span>
        <div class="t"></div>
        <div class="ex"></div>
        <div class="parle">${illuPersonne(c.qui)}<span>${esc(c.qui)}</span></div>
        <div class="d"></div>
      </div>
      <div class="question">Que décidez-vous ?</div>
      ${reponses}
      <div class="moi" aria-hidden="true"><span></span></div>
    </div>
    ${poste("o", c, vus)}
    ${poste("p", c, vus)}
  </div>`;
}

/* LES BULLES ET LE TEXTE QU'ELLES NE DOIVENT PAS COUVRIR.
   Une bulle est posee par-dessus l'ordre du jour, en absolu : elle
   ignore le texte, et le texte l'ignore. On mesure donc, apres coup,
   de combien elle mord sur la feuille, et on donne cette taille aux
   deux flotteurs places en tete du bloc. Le texte les contourne, donc
   il contourne les bulles. Mesure plutot que calcul : la largeur des
   colonnes depend de la fenetre, et une formule se serait trompee. */
function calerBulles(){
  const sc = app.querySelector(".scene"); if(!sc) return;
  const ord = sc.querySelector(".ordre"); if(!ord) return;
  const r = ord.getBoundingClientRect();
  if(!r.width) return;
  const cs = getComputedStyle(ord);
  const hg = r.left  + parseFloat(cs.paddingLeft);
  const hd = r.right - parseFloat(cs.paddingRight);
  const ht = r.top   + parseFloat(cs.paddingTop);
  for(const [cote, cle] of [["eg","i"],["ed","m"]]){
    const e = ord.querySelector(".encoche." + cote);
    const b = sc.querySelector(".p-" + cle + " .dit");
    if(!e) continue;
    if(!b){ e.style.width = e.style.height = "0px"; continue; }
    const bb = b.getBoundingClientRect();
    const l = (cote === "eg") ? (bb.right - hg) : (hd - bb.left);
    const h = bb.bottom - ht;
    e.style.width  = Math.max(0, Math.round(l) + 14) + "px";
    e.style.height = Math.max(0, Math.round(h) + 10) + "px";
  }
}
let calage = 0;
addEventListener("resize", ()=>{
  clearTimeout(calage); calage = setTimeout(calerBulles, 120);
});
AP

ech("js : rendre() donne les reponses a la scene", <<'AV', <<'AP');
  app.innerHTML=`
  ${alerte()}
  <div class="bureau"><div class="plateau large">
    ${scene(c)}
    <div class="question" ${D()}>Que décidez-vous ?</div>
    <div class="rep ${trois.length===2?"deux":""}" ${D()}>
      ${trois.map(k=>`<button class="choix" onclick="choisir('${k}')">
        <span class="q">${esc(c[k].q)}</span></button>`).join("")}
    </div>
    <div class="appoints" ${D()}>
AV
  app.innerHTML=`
  ${alerte()}
  <div class="bureau"><div class="plateau large">
    ${scene(c, `<div class="rep" ${D()}>
      ${trois.map(k=>`<button class="choix" onclick="choisir('${k}')">
        <span class="q">${esc(c[k].q)}</span></button>`).join("")}
    </div>`)}
    <div class="appoints" ${D()}>
AP

ech("js : on cale les bulles apres le rendu", <<'AV', <<'AP');
  app.classList.remove("presse");
  ecrire(c.t, c.ex, c.d);
  try{ SON.majTension(); SON.papier() }catch(e){}
  majVue();
}
AV
  app.classList.remove("presse");
  ecrire(c.t, c.ex, c.d);
  /* Les images des portraits arrivent apres : on cale une fois tout de
     suite pour que le premier mot tombe au bon endroit, une fois la
     mise en page faite, et une fois le chargement termine. */
  calerBulles();
  requestAnimationFrame(calerBulles);
  addEventListener("load", calerBulles, { once:true });
  try{ SON.majTension(); SON.papier() }catch(e){}
  majVue();
}
AP

ech("js : le compte des dossiers d acteurs ouverts disparait", <<'AV', <<'AP');
document.addEventListener("toggle",e=>{
  const t=e.target;
  if(t.classList&&t.classList.contains("acteur")&&t.open){
    document.body.dataset.acteursLus =
      String(document.querySelectorAll("details.acteur[open]").length);
  }
AV
document.addEventListener("toggle",e=>{
  const t=e.target;
AP

ech("js : le courrier vide ne s affiche plus", <<'AV', <<'AP');
  /* Sans pli en attente et sans pli reçu, il n'y a rien à ouvrir : le
     dossier reste un simple carton, et il ne remue pas. */
  if(!recus.length && !proche)
    return `<div class="${classe}" ${attr}>
      <span class="onglet">Courrier</span>${cachet}
      <div class="env"></div>${resume}</div>`;
AV
  /* Sans pli en attente et sans pli reçu, il n'y a rien à ouvrir : on
     n'affiche rien. Un carton vide occupait un tiers de la bande pour
     annoncer qu'il était vide. */
  if(!recus.length && !proche) return "";
AP

ech("js : le carnet ne s ouvre plus tout seul", <<'AV', <<'AP');
  const ouvert = (E.carnetOuvert !== false);
AV
  /* Fermé par défaut. Ouvert, il étalait l'année, la population, la
     courbe et les sept conditions sous les réponses : trois écrans de
     chiffres pour une décision qui ne s'en sert pas. Il reste à un
     clic — son rabat montre déjà l'année et le numéro du tour. */
  const ouvert = (E.carnetOuvert === true);
AP

ech("js : la fiche d un acteur, pour la ronde", <<'AV', <<'AP');
function menuNiveau(id){
AV
/* Une fiche d'acteur, ouverte : le portrait entier, le nom, ce qu'il
   veut, et son rôle. C'est le seul endroit du jeu où on les présente
   au calme — autant qu'ils soient lus. */
function fichActeur(k){
  return `<div class="fich r-${k}">
    <figure><img src="img/acteurs/${N.id}-${k}-portrait.jpg" alt="" loading="lazy"
      onerror="this.closest('figure').remove()"></figure>
    <div class="fi-t">${esc(N.forces[k].nom)}</div>
    <div class="fi-v">${esc(N.forces[k].veut)}</div>
    <p class="fi-r">${gras(esc(N.forces[k].role))}</p>
  </div>`;
}

function menuNiveau(id){
AP

# ===================================================================
# PREMIERE PASSE : on verifie TOUT avant d'ecrire quoi que ce soit
# ===================================================================
my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-52s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal remplacement(s) sur " . scalar(@T) . " ne correspondent pas.\n"
  . "Rien n'a ete ecrit.\n" if $mal;

# DEUXIEME PASSE : on ecrit
for my $p (@T){
  my ($nom, $av, $ap) = @$p;
  $s =~ s/\Q$av\E/$ap/;
  printf "  ok  %s\n", $nom;
}

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements · %d -> %d octets\n",
  scalar(@T), $avant_total, length($s);

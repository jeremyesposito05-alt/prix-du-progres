#!/usr/bin/perl
# UN BOUTON FR / EN, ET LES DEUX PREMIERS ECRANS EN ANGLAIS
#
#   perl _outils/langue.pl index.html
#
# CE QU ON TRADUIT, ET POURQUOI PAS PLUS. La demande portait sur le
# tutoriel seul. Mais le bouton se pose sur l ECRAN DE TITRE : s il n y
# changeait rien, il passerait pour casse au moment precis ou l on
# montre le jeu. Les quatre phrases du titre sont donc traduites
# aussi — accroche, bouton, mention, signature.
#
# Le titre de l oeuvre, lui, reste « Le prix du progres » : on ne
# traduit pas le nom d une chose.
#
# Le JEU reste en francais, comme demande. La bascule ne touche que ce
# qu on voit avant d entrer dans une partie.
#
# COMMENT. Une table de chaines, une fonction « tr », et les deux
# ecrans qui s y referent. La langue se retient d une visite a l autre
# dans le stockage local ; en cas d echec — navigation privee, stockage
# bloque — on retombe sur le francais sans rien casser.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

# ================================================================= 1
# La table des chaines et la bascule, posees avant ROLES.
ech("la table des chaines et la bascule de langue", <<'AV', <<'AP');
const ROLES = [
AV
/* ==================================================================
   DEUX LANGUES, SUR LES DEUX PREMIERS ECRANS
   Le jeu se joue en francais. Le titre et le mode d'emploi, eux,
   peuvent se lire en anglais : c'est ce qu'on montre a quelqu'un
   avant qu'il sache de quoi il s'agit.
   ================================================================== */
const TXT = {
  fr: {
    lieux:"Manchester <i>·</i> Detroit <i>·</i> Demain",
    accroche1:"Vous décidez. Quatre forces vous jugent.",
    accroche2:"Une seule question : qui paie le progrès ?",
    demarrer:"Démarrer",
    mention:"Unité 1 — Quand l’innovation change la société · Grade 10",
    paraphe:"Conçu et écrit par",
    avant:"Avant de commencer",
    comment:"Comment on joue ?",
    but1:"Quatre groupes. Trois choix à chaque étape.",
    but2:"Un seul objectif : garder tout le monde de ton côté !",
    e1t:"Un problème, trois solutions",
    e1p:"À chaque tour, un problème apparaît dans ta ville. Tu dois choisir une solution parmi les trois proposées. Réfléchis bien, chaque décision a des conséquences !",
    e2t:"Quatre groupes à satisfaire",
    e2p:"Les industriels, les ouvriers, les commerçants et les dirigeants ne veulent pas tous la même chose. Chaque décision peut rendre certains groupes heureux et d’autres mécontents.",
    e2g:"Attention : impossible de satisfaire tout le monde à chaque fois !",
    e3t:"Garde l’équilibre pour gagner !",
    e3p:"Si un seul groupe t’abandonne, la partie est terminée ! Réussis à garder les quatre groupes jusqu’à la fin pour découvrir la ville que tu as créée grâce à tes décisions.",
    e3g:"À toi de jouer ! Chaque choix compte.",
    roles:{i:"ceux qui produisent", o:"ceux qui travaillent",
           m:"ceux qui achètent",   p:"ceux qui font la loi"},
    epoque:"Choisissez votre époque",
    note:"Les personnages qui vous parlent sont des figures composites. Les événements datés, eux, sont authentiques — le jeu cite ses sources.",
    record:"Record :", jamais:"Jamais joué", bientot:"En préparation.",
    ord:{I:"1re révolution industrielle", II:"2e révolution industrielle",
         III:"3e révolution industrielle"},
    num:"La révolution numérique", numper:"1970 — aujourd’hui",
    unite2:{I:"habitants", II:"voitures par an"},
  },
  en: {
    lieux:"Manchester <i>·</i> Detroit <i>·</i> Tomorrow",
    accroche1:"You decide. Four forces judge you.",
    accroche2:"One question: who pays for progress?",
    demarrer:"Start",
    mention:"Unit 1 — When innovation changes society · Grade 10",
    paraphe:"Designed and written by",
    avant:"Before you start",
    comment:"How do you play?",
    but1:"Four groups. Three choices every turn.",
    but2:"One goal: keep everyone on your side!",
    e1t:"One problem, three solutions",
    e1p:"Every turn, a problem lands on your desk. You pick one of the three solutions offered. Think it through — every decision has consequences.",
    e2t:"Four groups to satisfy",
    e2p:"Industrialists, workers, merchants and lawmakers do not want the same things. Every decision makes some of them happy and others angry.",
    e2g:"Careful: you cannot please everyone every time.",
    e3t:"Keep the balance to win!",
    e3p:"If a single group walks out on you, the game is over. Keep all four to the end, and you discover the city your decisions have built.",
    e3g:"Your turn. Every choice counts.",
    roles:{i:"those who produce", o:"those who work",
           m:"those who buy",     p:"those who make the law"},
    epoque:"Choose your era",
    note:"The characters who speak to you are composite figures. The dated events are real — the game cites its sources.",
    record:"Best:", jamais:"Never played", bientot:"Coming soon.",
    ord:{I:"1st Industrial Revolution", II:"2nd Industrial Revolution",
         III:"3rd Industrial Revolution"},
    num:"The digital revolution", numper:"1970 — today",
    unite2:{I:"inhabitants", II:"cars per year"},
  },
};
let LANG = "fr";
try{ const l = localStorage.getItem("pdp_lang"); if(l === "en") LANG = l }catch(e){}
/* Le repli sur le francais est systematique : une cle oubliee dans la
   table anglaise n'affiche jamais un trou. */
function tx(k){ const a = TXT[LANG] || TXT.fr; return (k in a) ? a[k] : TXT.fr[k] }

function changerLangue(l){
  if(l !== "fr" && l !== "en") return;
  LANG = l;
  try{ localStorage.setItem("pdp_lang", l) }catch(e){}
  document.documentElement.lang = l;
  /* on redessine l'ecran courant, et lui seul */
  if(document.body.classList.contains("surtitre")) titre();
  else if(document.body.classList.contains("surmenu")) accueil();
}

function boutonsLangue(){
  return `<div class="langues" role="group" aria-label="Language">
    <button type="button" class="${LANG==="fr"?"on":""}"
      onclick="changerLangue('fr')" lang="fr">FR</button>
    <button type="button" class="${LANG==="en"?"on":""}"
      onclick="changerLangue('en')" lang="en">EN</button>
  </div>`;
}

const ROLES = [
AP

# ================================================================= 2
# L ecran de titre.
ech("l ecran de titre passe par la table", <<'AV', <<'AP');
      <div class="surtitre-txt">Manchester <i>·</i> Detroit <i>·</i> Demain</div>
    </div>

    <div class="dedans">
      <h1>Le prix<br><span>du progrès</span></h1>
      <div class="filet"></div>
      <p class="accroche">Vous décidez. Quatre forces vous jugent.<br>
        <strong>Une seule question : qui paie le progrès ?</strong></p>
      <button class="demarrer" onclick="demarrer()">Démarrer</button>
    </div>

    <div class="te-bas">
      <p class="mention">Unité 1 — Quand l’innovation change la société · Grade 10</p>
      <p class="paraphe">Conçu et écrit par <b>Jeremy Esposito</b></p>
    </div>
AV
      <div class="surtitre-txt">${tx("lieux")}</div>
    </div>
    ${boutonsLangue()}

    <div class="dedans">
      <h1>Le prix<br><span>du progrès</span></h1>
      <div class="filet"></div>
      <p class="accroche">${tx("accroche1")}<br>
        <strong>${tx("accroche2")}</strong></p>
      <button class="demarrer" onclick="demarrer()">${tx("demarrer")}</button>
    </div>

    <div class="te-bas">
      <p class="mention">${tx("mention")}</p>
      <p class="paraphe">${tx("paraphe")} <b>Jeremy Esposito</b></p>
    </div>
AP

# ================================================================= 3
# Les cartes d epoque.
ech("les cartes d epoque passent par la table", <<'AV', <<'AP');
      const o = n ? n.ord  : "3e révolution industrielle";
      const l = n ? n.lieu : "La révolution numérique";
      const p = n ? n.sous.replace(n.lieu+", ","") : "1970 — aujourd’hui";
      return `<button class="niv" disabled>
        <span class="ord">${o}</span>
        <span class="lieu">${l}</span>
        <span class="per">${p}</span>
        <span class="rec">En préparation.</span></button>`;
    }
    let r=0; try{ r=+(localStorage.getItem("pdp_pop_"+id)||0) }catch(e){}
    return `<button class="niv" onclick="menuNiveau('${id}')">
      <span class="ord">${n.ord}</span>
      <span class="lieu">${n.lieu}</span>
      <span class="per">${n.sous.replace(n.lieu+", ","")}</span>
      <span class="rec">${r?`Record : ${fmt(r)} ${n.unite2}`:"Jamais joué"}</span></button>`; };
AV
      const o = tx("ord")[id] || (n ? n.ord : "");
      const l = n ? n.lieu : tx("num");
      const p = n ? n.sous.replace(n.lieu+", ","") : tx("numper");
      return `<button class="niv" disabled>
        <span class="ord">${o}</span>
        <span class="lieu">${l}</span>
        <span class="per">${p}</span>
        <span class="rec">${tx("bientot")}</span></button>`;
    }
    let r=0; try{ r=+(localStorage.getItem("pdp_pop_"+id)||0) }catch(e){}
    const u = tx("unite2")[id] || n.unite2;
    return `<button class="niv" onclick="menuNiveau('${id}')">
      <span class="ord">${tx("ord")[id] || n.ord}</span>
      <span class="lieu">${n.lieu}</span>
      <span class="per">${n.sous.replace(n.lieu+", ","")}</span>
      <span class="rec">${r?`${tx("record")} ${fmt(r)} ${u}`:tx("jamais")}</span></button>`; };
AP

# ================================================================= 4
# Le tutoriel.
ech("le tutoriel passe par la table", <<'AV', <<'AP');
      <div class="entete">
        <div class="surtitre-txt">Avant de commencer</div>
        <h1>Comment on joue ?</h1>
      </div>

      <p class="but-jeu">Quatre groupes. Trois choix à chaque étape.
      <strong>Un seul objectif : garder tout le monde de ton côté !</strong></p>
AV
      ${boutonsLangue()}
      <div class="entete">
        <div class="surtitre-txt">${tx("avant")}</div>
        <h1>${tx("comment")}</h1>
      </div>

      <p class="but-jeu">${tx("but1")}
      <strong>${tx("but2")}</strong></p>
AP

ech("les trois etapes passent par la table", <<'AV', <<'AP');
            <h3>Un problème, trois solutions</h3>
            <p>À chaque tour, un problème apparaît dans ta ville. Tu dois choisir une
            solution parmi les trois proposées. Réfléchis bien, chaque décision a des
            conséquences !</p>
AV
            <h3>${tx("e1t")}</h3>
            <p>${tx("e1p")}</p>
AP

ech("la deuxieme etape et les quatre groupes", <<'AV', <<'AP');
            <h3>Quatre groupes à satisfaire</h3>
            <div class="mini-forces">${ROLES.map(r=>`<span>
              ${icone(r.k)}<i>${esc(r.t)}</i></span>`).join("")}</div>
            <p>Les industriels, les ouvriers, les commerçants et les dirigeants ne veulent
            pas tous la même chose. Chaque décision peut rendre certains groupes heureux et
            d’autres mécontents.</p>
            <p class="et-gras"><strong>Attention : impossible de satisfaire tout le monde
            à chaque fois !</strong></p>
AV
            <h3>${tx("e2t")}</h3>
            <div class="mini-forces">${ROLES.map(r=>`<span>
              ${icone(r.k)}<i>${esc(tx("roles")[r.k] || r.t)}</i></span>`).join("")}</div>
            <p>${tx("e2p")}</p>
            <p class="et-gras"><strong>${tx("e2g")}</strong></p>
AP

ech("la troisieme etape", <<'AV', <<'AP');
            <h3>Garde l’équilibre pour gagner !</h3>
            <p>Si un seul groupe t’abandonne, la partie est terminée ! Réussis à garder les
            quatre groupes jusqu’à la fin pour découvrir la ville que tu as créée grâce à
            tes décisions.</p>
            <p class="et-gras"><strong>À toi de jouer ! Chaque choix compte.</strong></p>
AV
            <h3>${tx("e3t")}</h3>
            <p>${tx("e3p")}</p>
            <p class="et-gras"><strong>${tx("e3g")}</strong></p>
AP

ech("le choix de l epoque et la note", <<'AV', <<'AP');
      <div class="separation"><span>Choisissez votre époque</span></div>
      <div class="niveaux">${carte("I",1)}${carte("II",1)}${carte("III",0)}</div>

      <p class="note-menu">Les personnages qui vous parlent sont des figures composites.
      Les événements datés, eux, sont authentiques — le jeu cite ses sources.</p>
AV
      <div class="separation"><span>${tx("epoque")}</span></div>
      <div class="niveaux">${carte("I",1)}${carte("II",1)}${carte("III",0)}</div>

      <p class="note-menu">${tx("note")}</p>
AP

# ================================================================= 5
# La CSS du bouton.
ech("css : les deux boutons de langue", <<'AV', <<'AP');
.titre-ecran .surtitre-txt{
AV
/* ---------- FR / EN ----------
   Deux petits boutons, en haut a droite, sur les deux ecrans qui
   precedent la partie. Discrets mais lisibles : on doit les trouver
   sans les chercher, et ne pas les prendre pour le bouton de
   demarrage. */
.langues{
  position:absolute; top:18px; right:20px; z-index:12;
  display:flex; gap:0; border:1px solid rgba(214,176,106,.5);
  border-radius:3px; overflow:hidden;
  background:rgba(14,10,7,.42);
  backdrop-filter:blur(3px); -webkit-backdrop-filter:blur(3px);
}
.langues button{
  all:unset; cursor:pointer; padding:6px 13px;
  font-family:var(--sans); font-size:12px; letter-spacing:.1em;
  color:#E8D8BC; line-height:1; transition:background .2s, color .2s;
}
.langues button + button{border-left:1px solid rgba(214,176,106,.35)}
.langues button:hover{background:rgba(214,176,106,.22)}
.langues button.on{background:var(--lai,#D6B06A); color:#241C16}
.menu-ecran .langues{top:14px; right:16px}
@media(max-width:700px){
  .langues{top:10px; right:10px}
  .langues button{padding:5px 10px; font-size:11px}
}

.titre-ecran .surtitre-txt{
AP

ech("css : les deux ecrans portent le bouton", <<'AV', <<'AP');
body.surtitre main{max-width:none;padding:0;justify-content:stretch}
AV
body.surtitre main{max-width:none;padding:0;justify-content:stretch}
/* le bouton se place par rapport a l'ecran, pas a la page */
.titre-ecran,.menu-ecran{position:relative}
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-48s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

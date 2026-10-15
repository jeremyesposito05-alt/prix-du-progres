#!/usr/bin/perl
# LE BLASON RAMENE A L ACCUEIL, APRES DEUX CONFIRMATIONS
#
#   perl _outils/sortie.pl index.html
#
# POURQUOI DEUX. Quitter une partie en cours detruit tout ce que
# l eleve a produit : ses dix-huit decisions, son carnet de bord et sa
# trace de travail — celle qu il doit rendre. Une seule confirmation
# se clique sans lire. La seconde nomme precisement ce qui sera perdu,
# et c est elle qui compte.
#
# Si aucune partie n est en cours — ecran de titre, mode d emploi,
# choix de l epoque, ou partie deja terminee — on revient sans rien
# demander : il n y a rien a perdre.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";

my @T; sub ech { push @T, [ @_ ] }

# ----------------------------------------------------------------- 1
ech("le blason devient un bouton", <<'AV', <<'AP');
  <span class="marque"><img src="img/blason-bs.png" alt="Collège Alpin Beau Soleil"
AV
  <span class="marque" id="marque" role="button" tabindex="0"
        onclick="quitterVersAccueil()"
        onkeydown="if(event.key==='Enter'||event.key===' '){event.preventDefault();quitterVersAccueil()}"
        ><img src="img/blason-bs.png" alt="Collège Alpin Beau Soleil"
AP

# ----------------------------------------------------------------- 2
ech("les chaines de la sortie, en francais", <<'AV', <<'AP');
    musique:"Musique", bruitages:"Bruitages",
AV
    musique:"Musique", bruitages:"Bruitages",
    accueil:"Revenir à l’accueil",
    q1t:"Quitter la partie en cours ?",
    q1x:"Vous en êtes à la décision",
    q1y:"Tout sera perdu : vos décisions, votre carnet de bord et votre trace de travail.",
    q2t:"Dernière confirmation",
    q2x:"Votre trace de travail n’a pas été rendue. Une fois sorti, elle ne pourra plus être produite — il faudra recommencer une partie entière.",
    rester:"Rester dans la partie",
    oui:"Oui, quitter",
    def:"Quitter définitivement",
AP

ech("les chaines de la sortie, en anglais", <<'AV', <<'AP');
    musique:"Music", bruitages:"Sound",
AV
    musique:"Music", bruitages:"Sound",
    accueil:"Back to the home screen",
    q1t:"Leave the game in progress?",
    q1x:"You are at decision",
    q1y:"Everything will be lost: your decisions, your logbook and your work record.",
    q2t:"Last confirmation",
    q2x:"Your work record has not been handed in. Once you leave it cannot be produced — you would have to play a whole game again.",
    rester:"Stay in the game",
    oui:"Yes, leave",
    def:"Leave for good",
AP

# ----------------------------------------------------------------- 3
ech("js : la sortie en deux temps", <<'AV', <<'AP');
function demarrer(){
AV
/* ==================================================================
   REVENIR A L'ACCUEIL PAR LE BLASON
   Quitter une partie en cours detruit les dix-huit decisions, le
   carnet et la trace de travail. Une seule confirmation se clique
   sans lire : la seconde nomme ce qui sera perdu.
   ================================================================== */
function partieEnCours(){
  return !!(typeof E !== "undefined" && E && E.carte && !E.fini
            && !document.body.classList.contains("surtitre")
            && !document.body.classList.contains("surmenu"));
}

function fermerSortie(){
  const el = document.getElementById("sortie-pli");
  if(el) el.remove();
}

function quitterVersAccueil(etape){
  if(!partieEnCours()){ fermerSortie(); titre(); return }
  const e = etape || 1;
  fermerSortie();
  const tour = (E && E.tour) ? E.tour : 1;
  const tot  = (N && N.tours) ? N.tours : 18;
  const corps = e === 1
    ? `<h2>${tx("q1t")}</h2>
       <p class="so-ou">${tx("q1x")} ${tour} / ${tot}.</p>
       <p>${tx("q1y")}</p>
       <div class="so-bt">
         <button onclick="fermerSortie()">${tx("rester")}</button>
         <button class="so-danger" onclick="quitterVersAccueil(2)">${tx("oui")}</button>
       </div>`
    : `<h2 class="so-rouge">${tx("q2t")}</h2>
       <p>${tx("q2x")}</p>
       <div class="so-bt">
         <button onclick="fermerSortie()">${tx("rester")}</button>
         <button class="so-danger" onclick="fermerSortie();titre()">${tx("def")}</button>
       </div>`;
  const d = document.createElement("div");
  d.id = "sortie-pli"; d.className = "sortie-pli";
  d.innerHTML = `<div class="sortie-feuille">${corps}</div>`;
  document.body.appendChild(d);
}
/* La touche d'echappement annule — jamais elle ne quitte. */
addEventListener("keydown", e => {
  if(e.key === "Escape" && document.getElementById("sortie-pli")) fermerSortie();
});

function demarrer(){
AP

# ----------------------------------------------------------------- 4
ech("css : la feuille de sortie", <<'AV', <<'AP');
/* ---------- LE CURSEUR DE LA MACHINE A ECRIRE ----------
AV
/* ---------- REVENIR A L'ACCUEIL ----------
   Le blason se clique. La feuille qui s'ouvre reprend les materiaux
   des lettres du professeur : c'est du papier qu'on lit, pas une
   boite de dialogue du systeme. */
#marque{cursor:pointer}
#marque:hover{opacity:.82}
#marque:focus-visible{outline:2px solid var(--lai,#D6B06A); outline-offset:3px}
.sortie-pli{
  position:fixed; inset:0; z-index:80; display:flex;
  align-items:center; justify-content:center; padding:20px;
  background:rgba(14,10,7,.46); overflow-y:auto;
}
.sortie-feuille{
  margin:auto; max-width:470px; width:100%;
  background:linear-gradient(152deg,var(--pap) 0%,var(--pap2) 100%);
  border:1px solid var(--fil); border-left:4px solid var(--rge);
  border-radius:2px; padding:26px 28px 22px; color:var(--enc);
  box-shadow:0 22px 60px rgba(0,0,0,.6);
}
.sortie-feuille h2{margin:0 0 10px; font-family:var(--serif);
  font-size:21px; color:var(--enc); font-weight:normal}
.sortie-feuille h2.so-rouge{color:var(--rge)}
.sortie-feuille p{margin:0 0 12px; font-size:15px; line-height:1.5}
.sortie-feuille .so-ou{font-weight:bold}
.so-bt{display:flex; gap:10px; flex-wrap:wrap; margin-top:16px}
.so-bt button{flex:1 1 auto}
.so-bt .so-danger{background:var(--rge); border-color:var(--rge); color:#FFF4EC}
.so-bt .so-danger:hover{background:#8E2A20; border-color:#8E2A20}

/* ---------- LE CURSEUR DE LA MACHINE A ECRIRE ----------
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-40s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

#!/usr/bin/perl
# L HABILLAGE DE L ECRAN DE JEU SUIT LA LANGUE
#
#   perl _outils/habillage.pl index.html
#
# Le dictionnaire traduit les DONNEES — affaires, repliques, quiz. Il
# ne touche pas aux libelles ecrits en dur dans les gabarits :
# « Affaire du jour », « Que decidez-vous ? », « Carnet de bord »…
# Une capture l a montre : tout le plateau en anglais, et la bascule
# du tour encore en francais au milieu.
#
# Ces libelles passent donc par la table des deux langues, comme
# l ecran de titre et le mode d emploi.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";

my @T; sub ech { push @T, [ @_ ] }

ech("les libelles du plateau, en francais", <<'AV', <<'AP');
    rester:"Rester dans la partie",
AV
    affaire:"Affaire du jour", arrive:"Ce qui est arrivé",
    madecision:"Votre décision", decider:"Que décidez-vous ?",
    suivante:"Affaire suivante",
    courrier:"Le courrier du professeur",
    comprendre:"Comprendre avant de décider",
    retenir:"À retenir", reviser:"À réviser :",
    compris:"J’ai compris · place au choix",
    carnet:"Carnet de bord", decision:"décision", sur:"sur",
    survie:"Survie",
    rester:"Rester dans la partie",
AP

ech("les libelles du plateau, en anglais", <<'AV', <<'AP');
    rester:"Stay in the game",
AV
    affaire:"Today’s business", arrive:"What happened",
    madecision:"Your decision", decider:"What do you decide?",
    suivante:"Next business",
    courrier:"A letter from your teacher",
    comprendre:"Understand before you decide",
    retenir:"Remember", reviser:"Revise:",
    compris:"Understood · on to the choice",
    carnet:"Logbook", decision:"decision", sur:"of",
    survie:"Endless",
    rester:"Stay in the game",
AP

ech("l onglet du dossier", <<'AV', <<'AP');
        <span class="onglet">${cq?"Ce qui est arrivé":"Affaire du jour"}</span>
AV
        <span class="onglet">${cq?tx("arrive"):tx("affaire")}</span>
AP

ech("le nom de celui qui parle", <<'AV', <<'AP');
        <div class="parle">${cq?`<span>Votre décision</span>`
AV
        <div class="parle">${cq?`<span>${tx("madecision")}</span>`
AP

ech("la bascule du tour", <<'AV', <<'AP');
    ${cq?"":`<div class="question">Que décidez-vous ?</div>`}
AV
    ${cq?"":`<div class="question">${tx("decider")}</div>`}
AP

ech("l intitule de la notion", <<'AV', <<'AP');
        <span class="cp-n-k">À retenir · ${esc(d.mot)}</span>
AV
        <span class="cp-n-k">${tx("retenir")} · ${esc(d.mot)}</span>
AP

ech("le renvoi au cours", <<'AV', <<'AP');
      <p class="cp-ref">À réviser : ${esc(d.ref)}</p>`
AV
      <p class="cp-ref">${tx("reviser")} ${esc(d.ref)}</p>`
AP

ech("l en-tete de la lettre", <<'AV', <<'AP');
        <span class="cp-qui">Le courrier du professeur</span>
AV
        <span class="cp-qui">${tx("courrier")}</span>
AP

ech("le sous-titre de la lettre", <<'AV', <<'AP');
          <p class="cp-sous">Comprendre avant de décider</p>
AV
          <p class="cp-sous">${tx("comprendre")}</p>
AP

ech("le bouton de la lettre",
    q{J’ai compris · place au choix</button>},
    q{${tx("compris")}</button>});

ech("le bouton de l ecran de consequence", <<'AV', <<'AP');
      <button class="plein" onclick="suiteApresConsq()">Affaire suivante</button>
AV
      <button class="plein" onclick="suiteApresConsq()">${tx("suivante")}</button>
AP

ech("l onglet du carnet", <<'AV', <<'AP');
      <span class="onglet">Carnet de bord</span>
AV
      <span class="onglet">${tx("carnet")}</span>
AP

ech("le compteur de decisions", <<'AV', <<'AP');
        ? `<b>${AN(E.tour)}</b> · décision ${E.tour+1} sur ${N.tours}`
        : `<b>Survie</b> · décision ${E.tour+1}`}</span>
AV
        ? `<b>${AN(E.tour)}</b> · ${tx("decision")} ${E.tour+1} ${tx("sur")} ${N.tours}`
        : `<b>${tx("survie")}</b> · ${tx("decision")} ${E.tour+1}`}</span>
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-38s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

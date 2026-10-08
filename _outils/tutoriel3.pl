#!/usr/bin/perl
# LE TUTORIEL, TEXTE DU PROFESSEUR
#
#   perl _outils/tutoriel3.pl index.html
#
# Texte fourni mot pour mot le 8 octobre 2026. Deux changements de ton
# qui viennent de lui et qu'on garde tels quels :
#   — il TUTOIE, la ou le reste du jeu vouvoie ;
#   — il nomme les groupes en termes generaux — industriels, ouvriers,
#     commercants, dirigeants — et non avec les noms de chaque niveau.
#     C'est juste : le tutoriel se lit AVANT d'avoir choisi son epoque,
#     et ces quatre mots valent pour Manchester comme pour Detroit.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : $f est en CRLF — le normaliser en LF d'abord\n";

my @T;
sub ech { push @T, [ @_ ] }

ech("le titre de l ecran", <<'AV', <<'AP');
        <h1>Comment on joue</h1>
AV
        <h1>Comment on joue ?</h1>
AP

ech("le but, en tete", <<'AV', <<'AP');
      <p class="but-jeu">Quatre groupes vous jugent. <strong>Gardez-les tous les quatre jusqu’à la fin.</strong></p>
AV
      <p class="but-jeu">Quatre groupes. Trois choix à chaque étape.
      <strong>Un seul objectif : garder tout le monde de ton côté !</strong></p>
AP

ech("le premier point", <<'AV', <<'AP');
        <div class="etape sans-titre">
          <span class="num">1</span>
          <div>
            <p>Un problème arrive sur votre bureau. Quelqu’un vient vous demander quelque chose. Vous avez <strong>trois réponses</strong>.</p>
          </div>
        </div>
AV
        <div class="etape">
          <span class="num">1</span>
          <div>
            <h3>Un problème, trois solutions</h3>
            <p>À chaque tour, un problème apparaît dans ta ville. Tu dois choisir une
            solution parmi les trois proposées. Réfléchis bien, chaque décision a des
            conséquences !</p>
          </div>
        </div>
AP

ech("le deuxieme point", <<'AV', <<'AP');
        <div class="etape sans-titre">
          <span class="num">2</span>
          <div>
            <div class="mini-forces">${ROLES.map(r=>`<span>
              ${icone(r.k)}<i>${esc(r.t)}</i></span>`).join("")}</div>
            <p>Vous choisissez. Chaque réponse <strong>fait un content et un mécontent</strong>. Aucune ne plaît aux quatre.</p>
          </div>
        </div>
AV
        <div class="etape">
          <span class="num">2</span>
          <div>
            <h3>Quatre groupes à satisfaire</h3>
            <div class="mini-forces">${ROLES.map(r=>`<span>
              ${icone(r.k)}<i>${esc(r.t)}</i></span>`).join("")}</div>
            <p>Les industriels, les ouvriers, les commerçants et les dirigeants ne veulent
            pas tous la même chose. Chaque décision peut rendre certains groupes heureux et
            d’autres mécontents.</p>
            <p class="et-gras"><strong>Attention : impossible de satisfaire tout le monde
            à chaque fois !</strong></p>
          </div>
        </div>
AP

ech("le troisieme point", <<'AV', <<'AP');
        <div class="etape sans-titre">
          <span class="num">3</span>
          <div>
            <p>Si un groupe vous abandonne, <strong>la partie s’arrête</strong>. Sinon vous allez au bout, et vous voyez la ville que vous avez faite.</p>
          </div>
        </div>
AV
        <div class="etape">
          <span class="num">3</span>
          <div>
            <h3>Garde l’équilibre pour gagner !</h3>
            <p>Si un seul groupe t’abandonne, la partie est terminée ! Réussis à garder les
            quatre groupes jusqu’à la fin pour découvrir la ville que tu as créée grâce à
            tes décisions.</p>
            <p class="et-gras"><strong>À toi de jouer ! Chaque choix compte.</strong></p>
          </div>
        </div>
AP

ech("css : la ligne en gras qui ferme une fiche", <<'AV', <<'AP');
.etape p{margin:0;font-size:14.5px;line-height:1.6;color:var(--enc2)}
AV
.etape p{margin:0;font-size:14.5px;line-height:1.6;color:var(--enc2)}
/* la ligne qui ferme une fiche : detachee, pour qu'on la lise comme un
   avertissement et non comme la suite du paragraphe */
.etape .et-gras{margin-top:.7em}
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-46s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }

utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!";
print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

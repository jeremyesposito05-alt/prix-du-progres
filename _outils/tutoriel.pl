#!/usr/bin/perl
# LE TUTORIEL : DIRE LE BUT, PUIS TROIS POINTS
#
#   perl _outils/tutoriel.pl index.html     fr
#   perl _outils/tutoriel.pl index-en.html  en
#
# LE DEFAUT, releve par la premiere classe qui a joue (7 oct. 2026) :
# les eleves ont lu les cinq points et n'ont pas compris l'objectif.
# En relisant les cinq titres a la suite, la raison saute aux yeux —
#
#   Vous etes celui qui tranche / Quatre forces vous jugent / Si l'une
#   tombe a zero tout s'arrete / Ouvrez les dossiers / Rien ne se perd
#
# aucun ne dit CE QUE LE JOUEUR FAIT. Il apprend qui il est, qui le juge,
# comment il perd, quoi lire et ce qu'il garde — jamais la boucle : une
# situation arrive, on choisit une reponse, chaque reponse a un prix.
# L'objectif n'etait pas ecrit.
#
# CE QUI CHANGE
#   — le but en premiere ligne, avant tout le reste ;
#   — trois points au lieu de cinq ;
#   — des titres qui enoncent un fait, non une formule ;
#   — « quatre groupes » plutot que « quatre forces » : des gens, pas une
#     abstraction ;
#   — plus de definition par exclusion (« ni le patron, ni l'ouvrier,
#     ni le depute ») avant d'avoir dit ce qu'on EST.
#
# CE QUI PART AILLEURS. L'ancien point 4 — ouvrez les dossiers — ne
# disparait pas, il se deplace : on le dira dans la partie, au moment ou
# le joueur peut agir dessus, plutot que sur un ecran qu'il traverse.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift or die "usage: tutoriel.pl <jeu.html> <fr|en>\n";
my $lg = shift // "";
$lg =~ /^(?:fr|en)$/ or die "usage: tutoriel.pl <jeu.html> <fr|en>\n";

open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
local $/; my $s = <$h>; close $h;
$s =~ s/\x0D\x0A/\n/g;

# ---- reperer le bloc, de l'entete au separateur -----------------------
my $deb = $lg eq "fr" ? '      <div class="entete">' : '      <div class="entete">';
my $fin = '      <div class="separation">';
my $i = index($s, $deb);
my $j = index($s, $fin, $i);
($i >= 0 && $j > $i) or die "ARRET - $f : le bloc du tutoriel est introuvable\n";

my $ancien = substr($s, $i, $j - $i);
# une seule mesure honnete : le texte, balises retirees
my $txt = $ancien;
$txt =~ s/<[^>]*>/ /g; $txt =~ s/\$\{[^}]*\}/ /g; $txt =~ s/\s+/ /g; $txt =~ s/^\s|\s$//g;
my $avant = length $txt;

# ---- le nouveau bloc --------------------------------------------------
my ($sur, $titre, $but, @pts);

if($lg eq "fr"){
  $sur   = "Avant de commencer";
  $titre = "Comment on joue";
  $but   = "Votre but : <strong>conduire la ville jusqu\x{2019}au bout de la p\x{E9}riode sans "
         . "qu\x{2019}aucun des quatre groupes ne vous abandonne.</strong>";
  @pts = (
    [ "Une situation, trois r\x{E9}ponses",
      "Quelqu\x{2019}un vient vous demander de d\x{E9}cider. Vous choisissez. "
      . "<strong>Aucune r\x{E9}ponse n\x{2019}est bonne pour tout le monde</strong> : "
      . "c\x{2019}est le sujet du cours.", 0 ],
    [ "Quatre groupes, jamais d\x{2019}accord",
      "Chaque d\x{E9}cision en contente un et en f\x{E2}che un autre. Si l\x{2019}un d\x{2019}eux "
      . "vous l\x{E2}che tout \x{E0} fait, <strong>la partie s\x{2019}arr\x{EA}te</strong>. "
      . "Vous \x{EA}tes pr\x{E9}venu bien avant.", 1 ],
    [ "\x{C0} la fin, vous rendez votre travail",
      "Vos d\x{E9}cisions, huit questions sur ce que vous avez vu, et ce que vous en pensez.", 0 ],
  );
} else {
  $sur   = "Before you begin";
  $titre = "How to play";
  $but   = "Your aim: <strong>lead the city to the end of the period without any of the four "
         . "groups abandoning you.</strong>";
  @pts = (
    [ "One situation, three answers",
      "Someone comes to you for a decision. You choose. <strong>No answer is good for "
      . "everyone</strong>: that is what this unit is about.", 0 ],
    [ "Four groups, never in agreement",
      "Every decision pleases one and angers another. If one of them gives up on you "
      . "completely, <strong>the game ends</strong>. You are warned well in advance.", 1 ],
    [ "At the end, you hand in your work",
      "Your decisions, eight questions on what you saw, and what you make of it.", 0 ],
  );
}

my $neuf = <<"TETE";
      <div class="entete">
        <div class="surtitre-txt">$sur</div>
        <h1>$titre</h1>
      </div>

      <p class="but-jeu">$but</p>

      <div class="etapes">
TETE

my $n = 0;
for my $p (@pts){
  my ($t, $corps, $forces) = @$p;
  $n++;
  my $mini = $forces
    ? "            <div class=\"mini-forces\">\${ROLES.map(r=>`<span>\n"
      . "              \${icone(r.k)}<i>\${esc(r.t)}</i></span>`).join(\"\")}</div>\n"
    : "";
  $neuf .= <<"PT";
        <div class="etape">
          <span class="num">$n</span>
          <div>
            <h3>$t</h3>
$mini            <p>$corps</p>
          </div>
        </div>
PT
}
$neuf .= "      </div>\n\n";

substr($s, $i, $j - $i) = $neuf;

# ---- l'habillage du but, une seule fois -------------------------------
unless($s =~ /\.but-jeu\s*\{/){
  my $css = <<'CSS';

/* Le but du jeu, dit avant tout le reste : les eleves lisaient cinq
   points sans trouver l'objectif, parce qu'il n'etait ecrit nulle part. */
.but-jeu{
  margin:0 0 20px; padding:12px 16px; text-align:center;
  font-family:var(--serif); font-size:16.5px; line-height:1.45;
  color:var(--enc); background:rgba(243,190,49,.13);
  border-top:1px solid rgba(243,190,49,.5);
  border-bottom:1px solid rgba(243,190,49,.5);
}
.but-jeu strong{color:var(--enc)}
@media(max-width:600px){ .but-jeu{font-size:15px;padding:10px 12px} }
CSS
  my $ancre = "\n/* l'ordre du jour";
  index($s, $ancre) >= 0 or die "ARRET - $f : ancrage CSS introuvable\n";
  $s =~ s/\Q$ancre\E/$css$ancre/;
}

my $t2 = $neuf;
$t2 =~ s/<[^>]*>/ /g; $t2 =~ s/\$\{[^}]*\}/ /g; $t2 =~ s/\s+/ /g; $t2 =~ s/^\s|\s$//g;
my $apres = length $t2;

open(my $o, ">:encoding(UTF-8)", $f) or die "$f: $!";
print $o $s; close $o;
printf "  %-16s %d caract\x{E8}res de texte -> %d  (%d %% de moins)\n",
  $f, $avant, $apres, int(100*($avant-$apres)/$avant + .5);

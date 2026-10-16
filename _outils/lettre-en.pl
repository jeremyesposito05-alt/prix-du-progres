#!/usr/bin/perl
# LA PREMIERE LETTRE DU PROFESSEUR SUIT LA LANGUE
#
#   perl _outils/lettre-en.pl index.html
#
# CE QUI CLOCHAIT. Le dictionnaire traduit les DONNEES des cartes —
# les champs « l » et « li » sont couverts a 100 % pour Manchester,
# mesure faite. Mais deux morceaux de la lettre sont ecrits en dur
# dans la fonction d affichage, et n ont donc jamais ete traduits :
#   - le preambule de presentation, qui n apparait que sur la toute
#     premiere lettre — deux paragraphes entiers ;
#   - le libelle « Le lien avec le cours ».
# Resultat : en anglais, la premiere lettre s ouvre en francais.
#
# LE NOM DU LIEU. Le preambule nomme la ville. Plutot que de couper la
# phrase en deux morceaux a recoller, on garde une phrase entiere avec
# un jeton {lieu}, remplace a l affichage. Une phrase se traduit ;
# deux moities de phrase, non.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $f = shift || "index.html";
open(my $h, "<:raw", $f) or die "$f: $!";
my $s = do { local $/; <$h> }; close $h;
utf8::decode($s);
$s =~ /\r\n/ and die "ARRET : CRLF\n";

my @T; sub ech { push @T, [ @_ ] }

# ----------------------------------------------------------------- 1
ech("les chaines de la lettre, en francais", <<'AV', <<'AP');
    accueil:"Revenir à l’accueil",
AV
    accueil:"Revenir à l’accueil",
    lien:"Le lien avec le cours",
    pr1:"Bonjour. Je suis M. Esposito, votre professeur d’histoire. C’est moi qui ai écrit les affaires que vous allez trancher, et toutes sont tirées de ce que {lieu} a réellement vécu.",
    pr2:"Je vous glisserai un mot avant chaque décision. Il ne vous dira jamais quoi choisir : il vous rappelle ce que nous avons vu en classe sur ce point, vous donne le mot qui le nomme, et vous pose la question à se poser avant de trancher.",
AP

# ----------------------------------------------------------------- 2
ech("les chaines de la lettre, en anglais", <<'AV', <<'AP');
    accueil:"Back to the home screen",
AV
    accueil:"Back to the home screen",
    lien:"The link with the course",
    pr1:"Hello. I am Mr Esposito, your history teacher. I wrote the cases you are about to decide, and every one of them is drawn from what {lieu} really went through.",
    pr2:"I will slip you a note before each decision. It will never tell you what to choose: it reminds you what we studied in class on that point, gives you the word that names it, and asks you the question to ask yourself before deciding.",
AP

# ----------------------------------------------------------------- 3
ech("le preambule passe par la table des langues", <<'AV', <<'AP');
  const intro = premiere ? `<div class="cp-ouverture">
      <p>Bonjour. Je suis M. Esposito, votre professeur d’histoire. C’est moi qui ai
      écrit les affaires que vous allez trancher, et toutes sont tirées de ce que
      ${esc(N.lieu)} a réellement vécu.</p>
      <p>Je vous glisserai un mot avant chaque décision. Il ne vous dira jamais quoi
      choisir : il vous rappelle ce que nous avons vu en classe sur ce point, vous
      donne le mot qui le nomme, et vous pose la question à se poser avant de
      trancher.</p></div>` : "";
AV
  const intro = premiere ? `<div class="cp-ouverture">
      <p>${tx("pr1").replace("{lieu}", esc(N.lieu))}</p>
      <p>${tx("pr2")}</p></div>` : "";
AP

# ----------------------------------------------------------------- 4
ech("le libelle du lien avec le cours", <<'AV', <<'AP');
    ? `<p class="cp-lien"><span>Le lien avec le cours</span>${esc(E.carte.li)}</p>`
AV
    ? `<p class="cp-lien"><span>${tx("lien")}</span>${esc(E.carte.li)}</p>`
AP

my $mal = 0;
for my $p (@T){
  my ($nom, $av) = @$p;
  my $n = () = ($s =~ /\Q$av\E/g);
  if($n != 1){ printf "  MANQUE  %-44s %d occurrence(s)\n", $nom, $n; $mal++ }
}
die "\nARRET : $mal sur " . scalar(@T) . ". Rien n'a ete ecrit.\n" if $mal;
for my $p (@T){ my ($nom,$av,$ap)=@$p; $s =~ s/\Q$av\E/$ap/; printf "  ok  %s\n", $nom }
utf8::encode($s);
open(my $o, ">:raw", $f) or die "$f: $!"; print $o $s; close $o;
printf "\n  %d remplacements\n", scalar(@T);

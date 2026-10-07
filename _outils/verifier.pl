#!/usr/bin/perl
# CONTROLER UN FICHIER DE TRADUCTION QUI REVIENT
#
#   perl _outils/verifier.pl _a-installer/traduction/01.md
#   perl _outils/verifier.pl _a-installer/traduction      (tous)
#
# « reinjecter.pl » refuse d'écrire si quelque chose ne va pas, mais il
# juge le dossier entier : un fichier abîmé bloque les dix autres. Ici on
# juge un fichier seul, tout de suite, pour pouvoir le redemander avant
# de passer au suivant.
#
# Ce qu'on regarde, dans l'ordre de gravité :
#   — un numéro perdu, ajouté, ou une ligne FR réécrite : le fichier ne
#     correspond plus au jeu, la réinjection sera refusée ;
#   — un guillemet droit dans la traduction : il casserait le code ;
#   — les ** du cours et les balises <strong> : elles portent le
#     surlignage des notions, et personne ne les voit manquer ;
#   — une traduction restée en français, ou restée vide.
use strict; use warnings; use utf8;
binmode(STDOUT, ":encoding(UTF-8)");

my $cible = shift or die "usage: verifier.pl <fichier.md | dossier>\n";
my @fichiers = -d $cible ? (sort glob("$cible/[0-9]*.md")) : ($cible);
@fichiers or die "ARRET : aucun fichier à contrôler\n";

# le dossier qui contient source.tsv
my $dos = -d $cible ? $cible : do { my $d = $cible; $d =~ s{/[^/]+$}{}; $d };
my %fr;
open(my $m, "<:encoding(UTF-8)", "$dos/source.tsv") or die "$dos/source.tsv: $!";
while(<$m>){ next if /^#/; chomp; next unless length;
  my (undef, undef, undef, undef, $t) = split /\t/, $_, 5;
  my ($n) = /^(\d+)/; $fr{$n+0} = $t if defined $t; }
close $m;

my ($totGraves, $totFaits, $totVides) = (0,0,0);
for my $f (@fichiers){
  my (@graves, @legers, @vides, @francais, %present);
  my ($faits, $vus) = (0, 0);
  open(my $h, "<:encoding(UTF-8)", $f) or die "$f: $!";
  my ($n, $ligneFr, $attendu);
  my $dernier = 0;
  while(my $l = <$h>){
    chomp $l; $l =~ s/\x0D$//;
    if($l =~ /^\s*\[\[(\d+)\]\]\s*$/){
      push @graves, "n°$n annoncé mais sans ligne EN" if defined $n;
      $n = $1+0; $vus++; $present{$n} = 1;
      push @graves, sprintf("n°%04d est inconnu du jeu", $n) unless exists $fr{$n};
      push @graves, sprintf("n°%04d revient après n°%04d : ordre rompu", $n, $dernier)
        if $n <= $dernier;
      $dernier = $n; undef $ligneFr;
      next;
    }
    if($l =~ /^\s*FR\s*>>\s?(.*)$/){
      $ligneFr = $1;
      if(defined $n && exists $fr{$n}){
        my $o = $fr{$n}; my $v = $ligneFr;
        $o =~ s/\s+$//; $v =~ s/\s+$//; $o =~ s/^\s+//; $v =~ s/^\s+//;
        push @graves, sprintf("n°%04d : la ligne FR a été réécrite", $n) if $v ne $o;
      }
      next;
    }
    if($l =~ /^\s*EN\s*>>\s?(.*)$/){
      my $t = $1; $t =~ s/\s+$//; $t =~ s/^\s+//;
      unless(defined $n){ push @graves, "une ligne EN sans numéro au-dessus"; next }
      my $o = exists $fr{$n} ? $fr{$n} : "";
      if(!length $t){ push @vides, $n }
      else {
        $faits++;
        push @graves, sprintf("n°%04d : guillemet droit dans la traduction", $n)
          if $t =~ /"/;
        my $a = () = $o =~ /\*\*/g; my $b = () = $t =~ /\*\*/g;
        # on compte les marques, pas les paires : une étoile orpheline
        # est justement la faute la plus fréquente
        push @legers, sprintf("n°%04d : %d marque(s) ** au lieu de %d", $n, $b, $a)
          if $a != $b;
        for my $bal ("<strong>", "</strong>"){
          my $x = () = $o =~ /\Q$bal\E/g; my $y = () = $t =~ /\Q$bal\E/g;
          push @legers, sprintf("n°%04d : %s manque ou en trop", $n, $bal) if $x != $y;
        }
        push @francais, $n if $t eq $o;
      }
      undef $n;
      next;
    }
  }
  close $h;
  push @graves, "n°$n annoncé mais sans ligne EN" if defined $n;
  # L OUBLI SILENCIEUX : une entree que ChatGPT a sautee ou fondue
  # dans la precedente. Le fichier reste lisible, la traduction part
  # incomplete, et rien ne le dit. Le decoupage est regulier — le
  # fichier NN porte les entrees (NN-1)*90+1 a NN*90 — donc on sait
  # exactement qui devrait etre la.
  my ($num) = $f =~ m{(\d+)\.md$};
  if($num){
    my $PAR = 90;
    my @doit = grep { $_ > ($num-1)*$PAR && $_ <= $num*$PAR } keys %fr;
    my @absents = sort { $a <=> $b } grep { !$present{$_} } @doit;
    unshift @graves, sprintf("%d entrée(s) ont disparu du fichier : %s%s",
      scalar(@absents),
      join(", ", map { sprintf "n°%04d", $_ } @absents[0 .. ($#absents > 5 ? 5 : $#absents)]),
      @absents > 6 ? ", …" : "") if @absents;
  }

  printf "\n%s\n", $f;
  printf "  %d entrées, %d traduites, %d en attente\n", $vus, $faits, scalar(@vides);
  if(@graves){
    printf "  %d PROBLEME(S) — la réinjection refusera ce fichier :\n", scalar(@graves);
    print  "    · $_\n" for @graves[0 .. ($#graves > 9 ? 9 : $#graves)];
    print  "    · …\n" if @graves > 10;
  }
  if(@legers){
    printf "  %d mise(s) en gras à revoir :\n", scalar(@legers);
    print  "    · $_\n" for @legers[0 .. ($#legers > 7 ? 7 : $#legers)];
    print  "    · …\n" if @legers > 8;
  }
  printf "  %d laissée(s) en français à l identique : %s\n", scalar(@francais),
         join(", ", map { sprintf "%04d", $_ } @francais[0 .. ($#francais > 5 ? 5 : $#francais)])
    if @francais;
  print  "  rien à signaler\n" if !@graves && !@legers && !@francais;
  $totGraves += @graves; $totFaits += $faits; $totVides += @vides;
}

printf "\n  ---- %d fichier(s) : %d traduites, %d en attente, %d problème(s)\n",
       scalar(@fichiers), $totFaits, $totVides, $totGraves;
exit($totGraves ? 1 : 0);

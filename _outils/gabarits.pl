#!/usr/bin/perl
# LIRE LES GABARITS DU SCRIPT SANS SE TROMPER
#
# Ce fichier ne s'execute pas seul : « extraire-ui.pl » s'en sert.
#
# POURQUOI UN ANALYSEUR ET PAS UNE EXPRESSION REGULIERE. Presque toute
# l'interface du jeu est fabriquee par des gabarits `comme ceci`, ou le
# texte fixe alterne avec du code entre ${...}. Or une expression
# reguliere ne sait pas compter les accolades : des que le code contient
# un objet, une fonction ou un autre gabarit — et il en contient — elle
# se perd, decoupe au mauvais endroit, et rend du code pour du texte.
# C'est arrive : « 20?"#D08A2A" : "var(--rge)"; » s'est retrouve dans la
# liste a traduire. Une seule chaine de ce genre, traduite, casse le jeu.
#
# UNE SEULE PILE. Premiere version, l'etat etait tenu dans deux tableaux
# paralleles — les gabarits ouverts d'un cote, la profondeur des
# expressions de l'autre — et un gabarit imbrique dans une expression
# etait alors pris pour du code. L'etat courant est le sommet d'une pile
# unique, dont chaque etage est soit un gabarit, soit une expression.
#
# Ce qui ressort : les morceaux de TEXTE FIXE des gabarits, chacun avec
# sa position absolue dans le fichier.
use strict; use warnings; use utf8;

# morceaux($js, $base) -> ([position, texte], ...)
sub morceaux {
  my ($js, $base) = @_;
  my (@sortie, @pile);
  my $i = 0;
  my $n = length $js;

  while($i < $n){
    my $c = substr($js, $i, 1);
    my $suiv = $i+1 < $n ? substr($js, $i+1, 1) : "";
    my $haut = @pile ? $pile[-1] : undef;

    if($c eq "\\"){ $i += 2; next }          # un antislash echappe la suite

    # ---- sommet de pile : un gabarit, hors expression ----------------
    if($haut && $haut->{quoi} eq "gab"){
      if($c eq "`"){                          # le gabarit se ferme
        push @sortie, [ $base + $haut->{deb},
                        substr($js, $haut->{deb}, $i - $haut->{deb}) ];
        pop @pile; $i++; next;
      }
      if($c eq "\$" && $suiv eq "{"){         # une expression commence
        push @sortie, [ $base + $haut->{deb},
                        substr($js, $haut->{deb}, $i - $haut->{deb}) ];
        push @pile, { quoi=>"expr", prof=>1 };
        $i += 2; next;
      }
      $i++; next;
    }

    # ---- sommet de pile : une expression, ou du code ordinaire -------
    if($c eq "`"){                            # un gabarit s'ouvre
      push @pile, { quoi=>"gab", deb=>$i+1 };
      $i++; next;
    }
    if($c eq '"' || $c eq "'"){               # une chaine : on la saute
      my $q = $c; $i++;
      while($i < $n){
        my $d = substr($js, $i, 1);
        last if $d eq $q;
        $i += ($d eq "\\") ? 2 : 1;
      }
      $i++; next;
    }
    if($c eq "/" && $suiv eq "*"){            # un commentaire en bloc
      my $j = index($js, "*/", $i+2);
      $i = $j < 0 ? $n : $j + 2; next;
    }
    if($c eq "/" && $suiv eq "/"){            # un commentaire de ligne
      my $j = index($js, "\n", $i+2);
      $i = $j < 0 ? $n : $j + 1; next;
    }
    if($haut && $haut->{quoi} eq "expr"){
      if($c eq "{"){ $haut->{prof}++; $i++; next }
      if($c eq "}"){
        if(--$haut->{prof} == 0){             # l'expression se referme
          pop @pile;
          # le texte fixe du gabarit qui l'entoure reprend ici
          $pile[-1]{deb} = $i+1 if @pile && $pile[-1]{quoi} eq "gab";
        }
        $i++; next;
      }
    }
    $i++;
  }
  # Un gabarit non ferme trahirait une lecture fausse : mieux vaut le
  # dire que de rendre un morceau douteux.
  die "ARRET : " . scalar(@pile) . " etage(s) non ferme(s) - lecture douteuse\n" if @pile;
  return grep { length $_->[1] } @sortie;
}

1;

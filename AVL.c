#include <stdio.h>
#include <stdlib.h>
#include "ABR.c"

int hauteurS(pArbre a) {
    if(estVide(a)) {
        return -1;
    }
    if(existeFilsDroit(a)) {
        if ( existeFilsGauche(a)) {
            return max(a->fd->h,a->fg->h)+1;
        }
        return a->fd->h+1;
    }
    if ( existeFilsGauche(a)) {
        return a->fg->h+1;
    }
    return 0;
}

pArbre rotationGauche(pArbre A) {
    if(existeFilsDroit(A)) {
        //rotation de l'abre
        pArbre pivot = A->fd;
        A->fd = pivot->fg;
        pivot->fd = A;
        //changement de l'equilibre
        A->eq = 1 - pivot->eq;
        pivot->eq = - A->eq;
        //changement de hauteur 
        A->h = hauteurS(A);
        pivot->h = hauteurS(pivot);
        return pivot;
    }
    return A;
}

pArbre rotationDroit(pArbre A) {
    if(existeFilsGauche(A)) {
        //rotation de l'abre
        pArbre pivot=A->fg;
        A->fg=pivot->fd;
        pivot->fg=A;
        //changement de l'equilibre
        A->eq= -1 - pivot->eq;
        pivot->eq = - A->eq;
        //changement de hauteur
        A->h = hauteurS(A);
        pivot->h = hauteurS(pivot);
        return pivot;
    }
    return A;
}
pArbre doubleRotationDroit(pArbre A) {
    if(existeFilsGauche(A)) {
        A->fg=rotationGauche(A->fg);
        A=rotationDroit(A);
    }
    return A;
}
pArbre doubleRotationGauche(pArbre A) {
    if(existeFilsDroit(A)) {
        A->fd=rotationDroit(A->fd);
        A=rotationGauche(A);
    }
    return A;
}
pArbre equilibrerAVL(pArbre a) {
    if(a->eq==2) {
        if(a->fd->eq==-1) {
            return doubleRotationGauche(a);
        }
        return rotationGauche(a);
    }
    if(a->eq==-2) {
        if(a->fd->eq==1) {
            return doubleRotationDroit(a);
        }
        return rotationDroit(a);

    }
    return a;
}
pArbre insertAVL(pArbre a, int e) {
  if(estVide(a)) {
    return creerArbre(e);
  }
  if(a->val==e) {
    return a;
  }
  if (a->val>e) {
    a->fg=insertAVL(a->fg,e);
  } else {
    a->fd=insertAVL(a->fd,e);
  }
  a->eq = hauteurS(a->fd)-hauteurS(a->fg);
  a = equilibrerAVL(a);
  a->h = hauteurS(a);
  //ajouteeq(a);
  return a;
}

Arbre balance(Arbre a) {
    if(a->eq >= 2) {
        if(a->fd->eq >= 0) {
            return rotationGauche(a);
        } else {
            return doubleRotationGauche(a);
        }
    } else if(a->eq <= 2) {
        if(a->fg->eq <= 0) {
            return rotationDroit(a);
        } else {
            return doubleRotationDroit(a);
        }
 }

void main() {
    
    //prAbre a=oldMain2();
    pArbre b=NULL;
    int tab[3]={1, 2, 3};
    for(int i=0;i<3;i++) {
        b=insertAVL(b,tab[i]);
    }
    //parcoursInfixe(b);
    //printf("%d",b->val);
    pArbre c=NULL;
    tab[0]=3;
    tab[2]=1;
    for(int j=0;j<3;j++) {
        c=insertAVL(c,tab[j]);
    }
    //c=doubleRotationDroit(c);
    parcoursInfixe(c);
}

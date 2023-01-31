#include <stdio.h>
#include <stdlib.h>
#include "ABR.c"

pArbre rotationGauche(pArbre A) {
    if(existeFilsDroit(A)) {
        //rotation de l'abre
        pArbre pivot = A->fd;
        A->fd = pivot->fg;
        pivot->fg = A;
        //changement de l'equilibre
        A->eq = 1 - pivot->eq;
        pivot->eq = -1 + pivot->eq;

        return pivot;
    }
    return A;
}

pArbre rotationDroit(pArbre A) {
    if(existeFilsGauche(A)) {
        //rotation de l'abre
        pArbre pivot=A->fg;
        A->fg=pivot->fd;
        pivot->fd=A;
        //changement de l'equilibre
        A->eq = -1 - pivot->eq;
        pivot->eq = 1 + pivot->eq;

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
    if(a->eq>=2) {
        if(a->fd->eq==-1) {
            return doubleRotationGauche(a);
        }
        return rotationGauche(a);
    }
    if(a->eq<=-2) {
        if(a->fd->eq==1) {
            return doubleRotationDroit(a);
        }
        return rotationDroit(a);

    }
    return a;
}
pArbre insertAVL(pArbre a, int e,int*h) {
    if(estVide(a)) {
        *h=1;
        return creerArbre(e);
    }
    if (a->val>e) {
        a->fg=insertAVL(a->fg,e,h);
        *h=-*h
    } else if (a->val<e) {
     a->fd=insertAVL(a->fd,e,h);
    } else {
        *h=0;
        return a;
    }

    if(*h != 0) {
        a->eq = a->eq + *h;
        a = equilibrerAVL(a);
        if (a->eq == 0) {
            *h=0;
        } else {
            *h=1;
        }
    }
    return a;
}

void main() {
    
    //prAbre a=oldMain2();
    pArbre b=NULL;
    int tab[3]={1, 2, 3};
    int h=0;
    for(int i=0;i<3;i++) {
        b=insertAVL(b,tab[i],&h);
    }
    //parcoursInfixe(b);
    //printf("%d",b->val);
    pArbre c=NULL;
    tab[0]=3;
    tab[2]=1;
    for(int j=0;j<3;j++) {
        c=insertAVL(c,tab[j],&h);
    }
    //c=doubleRotationDroit(c);
    parcoursInfixe(c);
}

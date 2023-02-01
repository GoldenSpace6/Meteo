#include <stdio.h>
#include <stdlib.h>
#include "ABR.c"

int eq(pArbre a) {
    if(a==NULL) {
        return 0;
    }
    return a->eq;
}

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
        if(eq(a->fd)==-1) {
            return doubleRotationGauche(a);
        }
        return rotationGauche(a);
    }
    if(a->eq<=-2) {
        if(eq(a->fd)==1) {
            return doubleRotationDroit(a);
        }
        return rotationDroit(a);

    }
    return a;
}
pArbre insertAVL(pArbre a, long e, char* line, int*h) {
    if(estVide(a)) {
        *h=1;
        return creerArbre(e,line);
    }
    if (a->val>e) {
        a->fg=insertAVL(a->fg,e,line,h);
        *h=-*h;
    } else if (a->val<e) {
     a->fd=insertAVL(a->fd,e,line,h);
    } else {
        a->fm=insertAVL(a->fm,e,line,h);
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

void TEST() {
    //prAbre a=oldMain2();
    pArbre b=NULL;
    int tab[100]={ 90, 74, 38, 50, 1, 82, 70, 76, 98, 93, 42, 75, 39, 59, 2, 22, 43, 99, 5, 92, 27, 17, 15, 83, 87, 58, 69, 6, 100, 53, 40, 26, 68, 33, 56, 21, 28, 16, 67, 24, 80, 49, 35, 97, 95, 47, 65, 14, 61, 25, 8, 85, 12, 23, 64, 89, 54, 77, 79, 19, 62, 84, 32, 52, 72, 3, 11, 86, 71, 10, 94, 57, 45, 20, 46, 51, 44, 30, 60, 91, 36, 18, 13, 55, 48, 73, 81, 7, 4, 66, 31, 29, 37, 96, 9, 41, 78, 88, 34, 63};
    int h=0;
    char* l=NULL;
    for(int i=0;i<3;i++) {
        b=insertAVL(b,tab[i],l,&h);
    }
    //parcoursInfixe(b);
}

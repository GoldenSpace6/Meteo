#include <stdio.h>
#include <stdlib.h>
#include "AVL.h"
//#include "ABR.c"

int eq(pArbre a) {
    if(a==NULL) {
        return 0;
    }
    return a->eq;
}

pArbre lelftRotation(pArbre A) {
    if(isRightChild(A)) {
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

pArbre rightRotation(pArbre A) {
    if(isLeftChild(A)) {
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
pArbre doublerightRotation(pArbre A) {
    if(isLeftChild(A)) {
        A->fg=lelftRotation(A->fg);
        A=rightRotation(A);
    }
    return A;
}
pArbre doublelelftRotation(pArbre A) {
    if(isRightChild(A)) {
        A->fd=rightRotation(A->fd);
        A=lelftRotation(A);
    }
    return A;
}
pArbre equilibrerAVL(pArbre a) {
    if(a->eq>=2) {
        if(eq(a->fd)==-1) {
            return doublelelftRotation(a);
        }
        return lelftRotation(a);
    }
    if(a->eq<=-2) {
        if(eq(a->fd)==1) {
            return doublerightRotation(a);
        }
        return rightRotation(a);

    }
    return a;
}
pArbre insertAVL(pArbre a, long e, char* line, int*h) {
    if(a==NULL) {
        *h=1;
        return createTree(e,line);
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

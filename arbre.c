#include <stdio.h>
#include <stdlib.h>
#include <time.h>
typedef struct arbre {
  int val;
  int eq;
  char** line;
  struct arbre* fg;
  struct arbre* fd;
}Arbre;
typedef Arbre * pArbre;
//ARBRE
pArbre creerArbre(int a) {
  pArbre c=malloc(sizeof(Arbre));
  if(c==NULL){
    printf("erreur malloc creerArbre()");
    exit(1);
  }
  c->val=a;
  c->eq=0;
  c->fg=NULL;
  c->fd=NULL;
  return c;
}

int estVide(pArbre a) {
  return a==NULL;
}
int estFeuille(pArbre a) {
  if(estVide(a)==1) {
    return 0;
  }
  if(a->fg==NULL && a->fd==NULL) {
    return 1;
  }
  return 0;
}


int element(pArbre a) {
  if(estVide(a)) {
    return -1;
  }
  return a->val;
}
int existeFilsGauche(pArbre a) {
  if(estVide(a)==1) {
    return 0;
  }
  if(a->fg==NULL) {
    return 0;
  }
  return 1;
}
int existeFilsDroit(pArbre a) {
  if(estVide(a)==1) {
    return 0;
  }
  if(a->fd==NULL) {
    return 0;
  }
  return 1;
}
int ajouteFilsGauche(pArbre a, int e) {
  if(existeFilsGauche(a)) {
    return -1;
  }
  pArbre pfg =creerArbre(e);
  a->fg=pfg;
  return 1;
}
int ajouteFilsDroit(pArbre a, int e) {
  if(existeFilsDroit(a)) {
    return -1;
  }
  pArbre pfd =creerArbre(e);
  a->fd=pfd;
  return 1;
}
void traiter(pArbre a) {
  if(estVide(a)) {
    printf("a est vide");
  } else {
    printf("%d",a->val);
  }
}
void parcoursPrefixe(pArbre a) {
  if(estVide(a)==0) {
    traiter(a);
    printf(",");
    parcoursPrefixe(a->fg);
    parcoursPrefixe(a->fd);
  }
}
void parcoursInfixe(pArbre a) {
  if(estVide(a)==0) {
    parcoursInfixe(a->fg);
    traiter(a);
    printf(",");
    parcoursInfixe(a->fd);
  }
}

void supprimerRacine(pArbre a) {
  if(estVide(a)==0) {
    supprimerRacine(a->fg);
    supprimerRacine(a->fd);
    free(a);
  }
}

int nmbFeuille(pArbre a) {
  if(estVide(a)) {
    return 0;
  }
  if(estFeuille(a)) {
    return 1;
  }
  return nmbFeuille(a->fg)+nmbFeuille(a->fd);
}
int max(int a, int b) {
  if(a>b) {
    return a;
  }
  return b;
}
int tailleArbre(pArbre a) {
    if(estVide(a)) {
    return 0;
  }
  if(estFeuille(a)) {
    return 0;
  }
  return tailleArbre(a->fg)+tailleArbre(a->fd)+1;
}
int hauteur(pArbre a) {
    if(estVide(a)) {
    return -1;
  }
  return max(hauteur(a->fg),hauteur(a->fd))+1;
}

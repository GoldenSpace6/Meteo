#include <stdio.h>
#include <stdlib.h>
#include <time.h>
typedef struct arbre {
  long val;
  int eq;
  char* line;
  struct arbre* fg;
  struct arbre* fd;
  struct arbre* fm;
}Arbre;
typedef Arbre * pArbre;
//ARBRE
pArbre creerArbre(long a, char* line) {
  pArbre c=malloc(sizeof(Arbre));
  if(c==NULL){
    printf("erreur malloc creerArbre()");
    exit(1);
  }
  c->val=a;
  c->line=line;
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

void traiter(pArbre a,FILE* out) {
  if(estVide(a)) {
    printf("a est vide");
    exit(4);
  } else {
    fputs(a->line,out);
  }
}
void parcoursPrefixe(pArbre a) {
  if(estVide(a)==0) {
    printf("%ld,",a->val);
    parcoursPrefixe(a->fg);
    parcoursPrefixe(a->fd);
  }
}

void fputsInfixeAcs(pArbre a,FILE* out) {
  if(estVide(a)==0) {
    fputsInfixeAcs(a->fg, out);
    traiter(a,out);
    fputsInfixeAcs(a->fm, out);
    fputsInfixeAcs(a->fd, out);
  }
}
void fputsInfixeDes(pArbre a,FILE* out) {
  if(estVide(a)==0) {
    fputsInfixeDes(a->fg, out);
    fputsInfixeDes(a->fm, out);
    traiter(a,out);
    fputsInfixeDes(a->fd, out);
  }
}

void supprimerRacine(pArbre a) {
  if(estVide(a)==0) {
    supprimerRacine(a->fg);
    supprimerRacine(a->fd);
    free(a->line);
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

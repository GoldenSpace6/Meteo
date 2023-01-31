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
//FILE
typedef struct chainon{
  pArbre nb;
  struct chainon *suiv;
}Chainon;
typedef struct fileDyn{
  struct chainon *tete;
  struct chainon *queue;
}FileDyn;
FileDyn enfilerDyn(pArbre nb,FileDyn pfile){
  Chainon* c = malloc(sizeof(Chainon));
  if(c==NULL){
    printf("erreur malloc enfilerDyn()");
    exit(1);
  }
  c->nb=nb;
  c->suiv=NULL;
  if(pfile.queue==NULL) {
    pfile.queue=c;
    pfile.tete=c;
  } else {
    pfile.queue->suiv=c;
    pfile.queue=c;
  }
  return pfile;
}
FileDyn defilerDyn(FileDyn pfile,pArbre *a) {
  if(pfile.tete!=NULL) {
    if(a!=NULL) {
      *a=pfile.tete->nb;
    }
    if(pfile.tete==pfile.queue) {
      pfile.queue=NULL;
    }
    Chainon * temp;
    temp = pfile.tete->suiv;
    free(pfile.tete);
    pfile.tete=temp;
    return pfile;
  }
}
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
void parcoursPostfixe(pArbre a) {
  if(estVide(a)==0) {
    parcoursPostfixe(a->fg);
    parcoursPostfixe(a->fd);
    traiter(a);
    printf(",");
  }
}
void parcourslargeur(pArbre a) {
  FileDyn f1= (FileDyn) {NULL, NULL};
  f1=enfilerDyn(a,f1);
  while(f1.tete!=NULL) {
    f1=defilerDyn(f1,&a);
    traiter(a);
    printf(",");
    if(existeFilsGauche(a)) {
      f1=enfilerDyn(a->fg,f1);
    }
    if(existeFilsDroit(a)) {
      f1=enfilerDyn(a->fd,f1);
    }
  }
}
pArbre modifierRacine(pArbre a,int e) {
  if(estVide(a)) {
    return NULL;
  }
  a->val =e;
  return a;
}
void supprimerRacine(pArbre a) {
  if(estVide(a)==0) {
    supprimerRacine(a->fg);
    supprimerRacine(a->fd);
    free(a);
  }
}
pArbre supprimerFilsGauche(pArbre a) {
  if(existeFilsGauche(a)) {
    supprimerRacine(a->fg);
    a->fg=NULL;
  }
  return a;
}
pArbre supprimerFilsDroit(pArbre a) {
  if(existeFilsDroit(a)) {
    supprimerRacine(a->fd);
    a->fd=NULL;
  }
  return a;
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

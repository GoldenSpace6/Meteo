#include <stdio.h>
#include <stdlib.h>
#include "arbre.c"
int recherche(pArbre a, int e) {
  if(estVide(a)) {
    return 0;
  }
  if(a->val==e) {
    return 1;
  }
  if (a->val>e) {
    return recherche(a->fg,e);
  } else {
    return recherche(a->fd,e);
  }
}
//AVL "/!\"
void ajouteeq(pArbre a) {
  if(estVide(a)==0) {
    a->eq=hauteur(a->fd)-hauteur(a->fg);
    ajouteeq(a->fg);
    ajouteeq(a->fd);
  }
}
//AVL "/!\"
pArbre insertABR(pArbre a, int e, char* line) {
  if(estVide(a)) {
    return creerArbre(e,line);
  }
  if(a->val==e) {
    return a;
  }
  if (a->val>e) {
    a->fg=insertABR(a->fg,e,line);
  } else {
    a->fd=insertABR(a->fd,e,line);
  }
  return a;
}
pArbre remplacerRacine(pArbre a) {
  pArbre tempPere=a;
  pArbre temp=a->fg;
  while(existeFilsDroit(temp)) {
    tempPere=temp;
    temp=temp->fd;
  }
  if(tempPere!=a) {
    tempPere->fd=temp->fg;
    temp->fg=a->fg;
  }
 temp->fd=a->fd;
  return temp;
}
pArbre suppressionRacine(pArbre a) {
  pArbre ret=NULL;
  if(estFeuille(a)) {
    ret= NULL;
  }else if(existeFilsDroit(a) && existeFilsGauche(a)==0) {
    ret=a->fd;
  }else if(existeFilsDroit(a)==0 && existeFilsGauche(a)) {
    ret=a->fg;
  }else {
    ret = remplacerRacine(a);
  }
  //ret->eq=hauteur(ret->fd)-hauteur(ret->fg);

  ajouteeq(ret);
  free(a);
  return ret;
}
pArbre suppressionElmt(pArbre a,int e) {
  if(estVide(a)) {
    return NULL;
  }
  if(a->val==e) {
    return suppressionRacine(a);
  }
  if (a->val>e) {
    a->fg=suppressionElmt(a->fg,e);
  } else {
    a->fd=suppressionElmt(a->fd,e);
  }
  ajouteeq(a);
  return a;

}

pArbre oldMain2() {
  //oldMain();
  pArbre temp = NULL;
  int tab[9]={10, 3, 5, 15, 20, 12, 7, 45, 9};
  for(int i=0;i<9;i++) {
    temp=insertABR(temp,tab[i],NULL);
  }
  //suppressionElmt(temp,15);
  parcoursInfixe(temp);
}

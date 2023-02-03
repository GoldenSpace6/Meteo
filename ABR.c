#include <stdio.h>
#include <stdlib.h>
#include <time.h>
//#include "ABR.h"
typedef struct arbre {
  long val;
  int eq;
  char* line;
  struct arbre* fg;
  struct arbre* fd;
  struct arbre* fm;
}Arbre;
typedef Arbre * pArbre;
//TREE
pArbre createTree(long a, char* line) {
  pArbre c=malloc(sizeof(Arbre));
  if(c==NULL){
    printf("erreur malloc createTree()");
    exit(1);
  }
  c->val=a;
  c->line=line;
  c->eq=0;
  c->fg=NULL;
  c->fd=NULL;
  return c;
}
typedef Arbre * pArbre;

int isLeftChild(pArbre a) {
  if(a==NULL) {
    return 0;
  }
  if(a->fg==NULL) {
    return 0;
  }
  return 1;
}
int isRightChild(pArbre a) {
  if(a==NULL) {
    return 0;
  }
  if(a->fd==NULL) {
    return 0;
  }
  return 1;
}

void process(pArbre a,FILE* out) {
  if(a==NULL) {
    printf("a est vide");
    exit(4);
  } else {
    fputs(a->line,out);
  }
}

void fputsInfixeAcs(pArbre a,FILE* out) {
  if(a!=NULL) {
    fputsInfixeAcs(a->fg, out);
    process(a,out);
    fputsInfixeAcs(a->fm, out);
    fputsInfixeAcs(a->fd, out);
  }
}
void fputsInfixeDes(pArbre a,FILE* out) {
  if(a!=NULL) {
    fputsInfixeDes(a->fg, out);
    fputsInfixeDes(a->fm, out);
    process(a,out);
    fputsInfixeDes(a->fd, out);
  }
}
// ABR
int search(pArbre a, int e) {
  if(a==NULL) {
    return 0;
  }
  if(a->val==e) {
    return 1;
  }
  if (a->val>e) {
    return search(a->fg,e);
  } else {
    return search(a->fd,e);
  }
}
pArbre insertABR(pArbre a, long e, char* line) {
  if(a==NULL) {
    return createTree(e,line);
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


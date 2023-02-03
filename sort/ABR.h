#ifndef ABR
#define ABR

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

Arbre * createTree(long a, char* line);

int isLeftChild(pArbre a);
int isRightChild(pArbre a);
void process(pArbre a,FILE* out);
void fputsInfixeAcs(pArbre a,FILE* out);
void fputsInfixeDes(pArbre a,FILE* out);
// ABR
int search(pArbre a, int e);
pArbre insertABR(pArbre a, long e, char* line);
#endif

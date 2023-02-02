#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "AVL.c"
//Greater than longest line
#define MAX_LINE_LEN 1024

int main(int argc, char *argv[]) {
char *input_file = NULL;
char *output_file = NULL;
int descending = 0;
int sorting =0;
int i;

// Parse command line arguments
for (i = 1; i < argc; i++) {
    if (strcmp(argv[i], "-f") == 0) {
        if (i + 1 < argc) {
	    i+=1;
	    input_file = argv[i];
        } else {
            fprintf(stderr, "Error: missing file name after -f option\n");
            return 1;
        }
    } else if (strcmp(argv[i], "-o") == 0) {
        if (i + 1 < argc) {
			i+=1;
            output_file = argv[i];
        } else {
            fprintf(stderr, "Error: missing file name after -o option\n");
            return 1;
        }
    } else if (strcmp(argv[i], "-r") == 0) {
        descending = 1;
    } else if (strcmp(argv[i], "--tab") == 0) {
        sorting = 2;
    } else if (strcmp(argv[i], "--abr") == 0) {
        sorting = 1;
    } else if (strcmp(argv[i], "--avl") == 0) {
        sorting = 0;
    } else {
        fprintf(stderr, "Error: unrecognized option %s\n", argv[i]);
        return 1;
    }
}

// Check that input and output files are specified
if (input_file == NULL || output_file == NULL) {
    fprintf(stderr, "Error: input and output files must be specified with -f and -o options\n");
    return 1;
}

// Open input and output files
FILE* in = fopen(input_file, "r");
if (in == NULL) {
    fprintf(stderr, "Error: unable to open input file %s\n", input_file);
    return 2;
}
FILE* out = fopen(output_file, "w");
if (out == NULL) {
    fprintf(stderr, "Error: unable to open output file %s\n", output_file);
    return 3;
}
/*
// Read the lines of the input file into an array
char **lines = NULL;
int n_lines = 0;
char line[MAX_LINE_LEN];
while (fgets(line, MAX_LINE_LEN, in) != NULL) {
    lines = realloc(lines, (n_lines + 1) * sizeof(char *));
    lines[n_lines] = malloc(strlen(line) + 1);
    strcpy(lines[n_lines], line);
    n_lines++;
}

*/
// ---------------------------------------------
// Read the lines of the input file into an array
pArbre A=NULL;
char line[MAX_LINE_LEN]="";
int h=0;
char* temp;
char* temp2;
long val;
while (fgets(line, MAX_LINE_LEN, in) != NULL) {
    temp = malloc( (strlen(line) + 1)*sizeof(char) );
    //temp2 = malloc( (strlen(line) + 1)*sizeof(char) );
    strcpy(temp,line);
    //strcpy(temp2,line);
    //printf("%s\n", temp);
    temp2=strchr(temp,';');
    *temp2='\0';
    val=atoi(temp);
    *temp2=';';
    if(sorting==0) {
        A=insertAVL(A,val,temp,&h);
    } else if(sorting==1) {
        A=insertABR(A,val,temp);
    }
}
/* ---------------------------------------------
// Read the lines of the input file into an array
pArbre AVL=NULL;
char line=NULL;
int* h=0;

size_t len = 0;
ssize_t read;
while ((read = getline(&line, &len, in)) != -1) {
    printf("Retrieved line of length %zu:\n", read);
    printf("%s", line);
    //insertAVL(AVL,5,line,h);
}

// --------------------------------------------- */

// Write the sorted lines to the output file
if(descending==0) {
    fputsInfixeAcs(A,out);
} else {
    fputsInfixeDes(A,out);
}

// Close the files and free memory
fclose(in);
fclose(out);

return 0;}

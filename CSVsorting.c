#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "abr.c"
#define MAX_LINE_LEN 1024

int main(int argc, char *argv[])
{
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
    else if (strcmp(argv[i], "--tab") == 0) {
        sorting = 2;
    }else if (strcmp(argv[i], "--abr") == 0) {
        sorting = 1;
    }else if (strcmp(argv[i], "--avl") == 0) {
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
FILE *in = fopen(input_file, "r");
if (in == NULL) {
    fprintf(stderr, "Error: unable to open input file %s\n", input_file);
    return 2;
}
FILE *out = fopen(output_file, "w");
if (out == NULL) {
    fprintf(stderr, "Error: unable to open output file %s\n", output_file);
    return 3;
}

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

// Sort the lines


// If descending order is requested, reverse the sorted array
if (descending) {
  for (i = 0; i < n_lines / 2; i++) {
        char *temp = lines[i];
        lines[i] = lines[n_lines - i - 1];
        lines[n_lines - i - 1] = temp;
  }
}
// Write the sorted lines to the output file
for (i = 0; i < n_lines; i++) {
    fputs(lines[i], out);
}

// Close the files and free memory
fclose(in);
fclose(out);
for (i = 0; i < n_lines; i++) {
    free(lines[i]);
}
free(lines);

return 0;}

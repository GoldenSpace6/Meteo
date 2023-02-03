CC=gcc
OPTION=-Wall -lm
RM=rm -rf	# force la suppression
SRC=$(wildcard *.c) # fichiers source par wildcard dans srcdir
HEAD=$(wildcard *.h) # fichiers d'entete idem
OBJ=$(SRC:.c=.o)  # fichiers objet par récupération des .c 
				  # et placement dans les bon répertoires
PROG=abr # exécutables

all : $(PROG)		# target principal

$(PROG) : $(OBJ) 	# compilation du programme
	$(CC) $^ -o $@ $(OPTION)

%.o : %.c		# compilation des objets
	$(CC) -c $^ -o $@ $(OPTION)

.PHONY : clean mrproper print	# cibles sans dépendances à toujours executer

clean :	# nettoyage des fichiers objets pour recompilation totale
	$(RM) $(OBJ)

mrproper :	# nettoyage de tout fichier compilé
	$(RM) $(PROG) $(OBJ)

print :		# validation des variables par affichage
	@echo "SRC= $(SRC)"
	@echo "HEAD= $(HEAD)"
	@echo "OBJ= $(OBJ)"


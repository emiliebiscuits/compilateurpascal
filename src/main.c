#include <cstdlib>
#include <cstddef>
#include <cstdio>
#include <iostream>
#include <vector>
#include "tableident.h"
#include "tablesymbole.h"

extern int yyparse ();
extern int yylex ();
extern FILE* yyin;
TableIdent tableId ;
extern TableSymbole tableSymbole ;
extern std::vector<TableSymbole*> tablesSymboles ;


int main ( int argc, char** argv )
{
	/* Gestion de la ligne de commande */
    FILE *fileToProceed ;
    fileToProceed = fopen(argv[1],"r");

    if(fileToProceed == NULL)
    {
        printf("Erreur ouverture fichier, lecture sur l'entrée standard.\n");
    } else
    {
        yyin = fileToProceed ;
    }
	/* Initialisation des données du compilateur */
    /* phases d'analyse */
    yyparse ();
	/* traitements post analyse */
	/* sauvegarde des resultats */
    tableId.afficherTableIdent(std::cout);
    for(auto table : tablesSymboles)
    {
        table->afficher();
    }
    printf("\n\n------------------------------------------\nVous pouvez consulter le code 3@ dans le fichier code_3_a.txt a la racine du projet.\n");
}

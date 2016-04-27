//
//  tablesymbole.h
//  
//
//  Created by Emilie LIU on 23/10/2015.
//
//
#include "symbole.h"
#include "tableident.h"
#include <map>
using namespace std;

#ifndef _tablesymbole_h
#define _tablesymbole_h
class TableSymbole{
    map<int, Symbole*> symboles ;
    ///Reference on theparent context
    TableSymbole *parent;

public :
    TableSymbole(TableSymbole* parent);
    ~TableSymbole();
    /** Method to add a symbole to the table, if there is already a
     * symbole with the same identifier, the compilation exits brutaly
     * @param ident the unique ident number of the identifier corresponding to the symbole
     * @param symbole the symbole to add in the map
     */
    void addSymbole(int ident, Symbole *symbole);
    /** Method to verify if an ident number is already present in the table, if yes,
     * it prints an error on cout stream
     * @param id the ident number we want to look for
     * @return true if the ident number is already present in the table, false if not.
     */
    bool hasAlreadyIdent(int id) const;
    /** Method to print on cout the content of the table
     */
    void afficher() const ;
};

#endif

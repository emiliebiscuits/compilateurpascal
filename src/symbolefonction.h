#ifndef SYMBOLEFONCTION_H
#define SYMBOLEFONCTION_H

#include "symbole.h"
#include "type.h"
#include "tablesymbole.h"
#include "symboleargument.h"
#include <vector>

class SymboleFonction : public Symbole
{
    Type *typeDeRetour ;
    vector<SymboleArgument*> args ;
    TableSymbole* tableSymbole ;

    string parameterString() const ;
public:
    SymboleFonction(
            Type *typeDeRetour,
            TableSymbole *tableParent,
            vector<SymboleArgument*> args);
    ~SymboleFonction();
    string toString() const ;
    void addParametre(SymboleArgument *newParam);
    TableSymbole *getTableSymbole() ;
};

#endif // SYMBOLEFONCTION_H

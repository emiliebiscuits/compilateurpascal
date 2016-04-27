
#ifndef SYMBOLEPROCEDURE_H
#define	SYMBOLEPROCEDURE_H

#include "symbole.h"
#include "tablesymbole.h"
#include "symboleargument.h"
#include <vector>

class SymboleProcedure: public Symbole
{
        vector<SymboleArgument*> args ;
        TableSymbole* tableSymbole ;
        string parameterString() const ;
    public:
        SymboleProcedure(
                TableSymbole *tableParent,
                vector<SymboleArgument*> args);
        ~SymboleProcedure();
         string toString() const ;
        void addParametre(SymboleArgument *newParam);
        TableSymbole *getTableSymbole() ;
};



#endif	/* SYMBOLEPROCEDURE_H */


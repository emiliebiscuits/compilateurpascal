#ifndef _SYMBOLEARGUMENT_H
#define _SYMBOLEARGUMENT_H

#include "symbole.h"

class SymboleArgument : public Symbole
{
    
    bool isReference ;
    /*son type*/
    Type *type;
    /*id parent de la fonction ou procedure dans la table ident*/
    unsigned int idparent;
public:
    SymboleArgument(bool isRef, Type* typeArg);
    string toString() const ;
};

#endif

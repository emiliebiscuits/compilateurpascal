//
//  variable.h
//  
//
//  Created by Emilie LIU on 23/10/2015.
//
//
#include "symbole.h"
using namespace std;

#ifndef _symbolevariable_h
#define _symbolevariable_h
class SymboleVariable : public Symbole
{
protected:
    Type *type;
public :
    SymboleVariable(Type*);
    ~SymboleVariable();
    string toString() const ;
};

#endif

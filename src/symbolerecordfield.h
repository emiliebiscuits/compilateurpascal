#ifndef SYMBOLERECORDFIELD_H
#define SYMBOLERECORDFIELD_H
#include "type.h"
#include "symbole.h"

class SymboleRecordField : public Symbole
{
    Type* type ;
    unsigned int idparent ;
public:
    SymboleRecordField(Type *, unsigned int);
    ~SymboleRecordField();
    string toString() const ;
};

#endif // SYMBOLERECORDFIELD_H

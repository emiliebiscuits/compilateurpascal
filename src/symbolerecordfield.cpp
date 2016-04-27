#include "symbolerecordfield.h"

SymboleRecordField::SymboleRecordField(Type *type , unsigned int idparent) :
    type(type),idparent(idparent)
{
}

SymboleRecordField::~SymboleRecordField()
{}

string SymboleRecordField::toString() const
{
    return "Symbole RecordField ident : "+
            to_string(ident) +
            " idparent "+
            to_string(idparent) +
            " of type : " +
            type->getName() ;
}

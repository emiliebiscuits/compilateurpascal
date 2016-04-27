#include "symboleenumfield.h"
SymboleEnumField::SymboleEnumField(unsigned int idparent,unsigned int index):
idparent(idparent),index(index)
{
    
}
SymboleEnumField::~SymboleEnumField(){
    
}

string SymboleEnumField::toString() const{
    return "Symbole EnumField ident : " +
            to_string(this->getIdent()) +
            " idparent : " +
            to_string(this->idparent) +
            " index : " +
            to_string(this->index) ;
}

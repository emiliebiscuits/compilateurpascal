
#include "symbolevariable.h"
using namespace std;

 SymboleVariable::SymboleVariable(Type *type):
    type(type)
 {
     
 }

 SymboleVariable::~SymboleVariable()
 {
     delete this->type ;
 }

 string SymboleVariable::toString() const
 {
     return  "Symbole Variable : " + std::to_string(this->ident)+ " of type : "+ this->type->getName() ;
 }

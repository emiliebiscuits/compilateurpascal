#include "symboletype.h"
using namespace std;

SymboleType::SymboleType(Type* type):
 type(type)
{
    
}

SymboleType::~SymboleType()
{
    delete this->type ;
}

string SymboleType::toString() const
{
    return "Symbole Decl Type with ident : " + std::to_string(this->ident)+" corresponding to : "+this->type->getName() ;
}

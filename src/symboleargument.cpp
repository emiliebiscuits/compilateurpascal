#include "symboleargument.h"

SymboleArgument::SymboleArgument(bool isRef, Type *typeArg) :
    isReference(isRef), type(typeArg)
{

}

string SymboleArgument::toString() const
{
    return "Argument ident : " + to_string(getIdent()) + " of type : " + type->getName() + "\n";
}

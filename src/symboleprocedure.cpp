#include <iostream>
#include "symboleprocedure.h"
using namespace std ;

SymboleProcedure::SymboleProcedure(TableSymbole* tableParent, vector<SymboleArgument*> args){
    this->tableSymbole = new TableSymbole(tableParent);
    for(SymboleArgument* arg : args)
    {
        this->args.push_back(arg);
        this->tableSymbole->addSymbole(arg->getIdent(), arg);
    }
}

SymboleProcedure::~SymboleProcedure(){
    this->args.clear();
    delete this->tableSymbole;
}

void SymboleProcedure::addParametre(SymboleArgument *newParam)
{
    this->args.push_back(newParam);
}

TableSymbole *SymboleProcedure::getTableSymbole()
{
    return this->tableSymbole ;
}

string SymboleProcedure::toString() const
{
    return "Symbole Precedure ident : " + std::to_string(this->ident) +"\n  Arguments :\n"+ parameterString();
}

string SymboleProcedure::parameterString() const
{
    string patate ;
    for(SymboleArgument* arg : args)
    {
        patate.append("\t");
        patate.append(arg->toString()) ;
    }
    return patate ;
}

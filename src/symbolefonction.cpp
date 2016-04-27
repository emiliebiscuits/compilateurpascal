#include "symbolefonction.h"
#include <iostream>

using namespace std ;

string SymboleFonction::parameterString() const
{
    string patate ;
    for(SymboleArgument* arg : args)
    {
        patate.append("\t");
        patate.append(arg->toString()) ;
    }
    return patate ;
}

SymboleFonction::SymboleFonction(Type *typeDeRetour, TableSymbole* tableParent,vector<SymboleArgument*> args) :
    typeDeRetour(typeDeRetour)
{
    this->tableSymbole = new TableSymbole(tableParent);
    for(SymboleArgument* arg : args)
    {
        this->args.push_back(arg);
        this->tableSymbole->addSymbole(arg->getIdent(), arg);
    }
}

SymboleFonction::~SymboleFonction()
{
    delete this->typeDeRetour ;
    this->args.clear();
    delete this->tableSymbole;
}

string SymboleFonction::toString() const
{
    return "Symbole Fonction ident : " + std::to_string(this->ident) + " type de retour : " + this->typeDeRetour->getName() +"\n  Arguments :\n"+ parameterString();
}

void SymboleFonction::addParametre(SymboleArgument *newParam)
{
    this->args.push_back(newParam);
}

TableSymbole *SymboleFonction::getTableSymbole()
{
    return this->tableSymbole ;
}


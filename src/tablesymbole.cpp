#include "tablesymbole.h"
#include "symbole.h"
#include <iostream>
#include <stdlib.h>

using namespace std ;

TableSymbole::TableSymbole(TableSymbole *parent) :
    parent(parent)
{}

TableSymbole::~TableSymbole()
{
    symboles.clear();
}

void TableSymbole::addSymbole(int ident, Symbole *symbole)
{
    if(hasAlreadyIdent(ident))
    {
        exit(1);
    } else {
        symboles[ident] = symbole ;
        symbole->setIdent(ident);
    }

}

bool TableSymbole::hasAlreadyIdent(int id) const
{
    if(symboles.find(id) != symboles.end())
    {
        cout << "Symbole " << id << " déja déclaré dans ce contexte." << endl ;
        return true ;
    } else if (parent != nullptr)
    {
        return parent->hasAlreadyIdent(id);
    }

    return false ;
}

void TableSymbole::afficher() const
{
    std::cout << "__________" << std::endl ;
    for(auto sym : symboles)
    {
        std::cout << sym.second->toString() << std::endl ;
    }
}


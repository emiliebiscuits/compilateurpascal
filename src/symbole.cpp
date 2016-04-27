#include "symbole.h"

Symbole::Symbole()
{}

void Symbole::setIdent(int id)
{
    ident = id ;
}

int Symbole::getIdent() const
{
    return this->ident;
}

Symbole::~Symbole()
{
}

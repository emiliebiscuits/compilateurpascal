#include"symboletemporaire.h"


SymboleTemporaire::SymboleTemporaire(std::string value) :
   value(value)
{

}


const std::string& SymboleTemporaire::getValue() const
{
    return value ;
}


std::string SymboleTemporaire::toString() const
{
    return "Symbole Temporaire : "+value ;
}

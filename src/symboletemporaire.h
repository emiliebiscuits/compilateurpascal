#ifndef SYMBOLETEMPORAIRE
#define SYMBOLETEMPORAIRE
#include<string>
#include "symbole.h"
using namespace std;
class SymboleTemporaire:public Symbole
{
   string value;
   public:
    SymboleTemporaire(string value);
    const string &getValue() const;
    string toString() const ;
};

#endif // TEMPORAIRE


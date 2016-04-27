

#ifndef _Symbole_h
#define _Symbole_h
#include "type.h"
class Symbole{
protected:
    int ident ;
public:
    Symbole();
    virtual ~Symbole();
    virtual string toString() const =0;
    void setIdent(int id);
    int getIdent() const ;
};

#endif

/* 
 * File:   symboletype.h
 * Author: Emilie
 *
 * Created on 30 octobre 2015, 16:48
 */
#include "symbole.h"
using namespace std;

#ifndef SYMBOLETYPE_H
#define	SYMBOLETYPE_H
class SymboleType:public Symbole
{
    Type *type;
    public:
    SymboleType(Type *);
    ~SymboleType();
    string toString() const ;
};


#endif	/* SYMBOLETYPE_H */


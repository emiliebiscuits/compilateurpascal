/* 
 * File:   symboleenumfield.h
 * Author: Emilie
 *
 * Created on 12 novembre 2015, 14:20
 */

#ifndef SYMBOLEENUMFIELD_H
#define	SYMBOLEENUMFIELD_H
#include"symbole.h"
class SymboleEnumField: public Symbole
{
    private:
        /*id parent(enum) dans la tableident*/
        unsigned int idparent;
        /*nieme champs dans l'enum*/
        unsigned int index;
    public:
         SymboleEnumField(unsigned int,unsigned int);
         ~SymboleEnumField();
         string toString() const ;
         
};

#endif	/* SYMBOLEENUMFIELD_H */


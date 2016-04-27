/* 
 * File:   tabletype.h
 * Author: Emilie
 *
 * Created on 11 novembre 2015, 14:16
 */

#ifndef TABLETYPE_H
#define	TABLETYPE_H
#include<iostream>
using namespace std;
#include "type.h"
#include<map>
#include<string>
class TableType{
    private :
    map<int, Type*> table ;
    public:
        TableType();
        ~TableType();
        void addType(int, Type *);
        Type *getTypeByIdent(int);
        map<int, Type *> getTable();
        void afficher() const ;
};


#endif	/* TABLETYPE_H */


#include <iostream>
#include <stdlib.h>
#include "tabletype.h"
using namespace std ;

TableType::TableType(){
    
}
TableType::~TableType(){
    this->table.clear();
}

void TableType::addType(int s, Type *t){
    this->table[s] = t ;
}

Type* TableType::getTypeByIdent(int s){
    return table[s];
}

map<int, Type *> TableType::getTable()
{
    return this->table ;
}

void TableType::afficher() const
{
    for(auto paire : table)
    {
        std::cout << paire.first <<" : "<< paire.second->getName() << std::endl ;
    }
}

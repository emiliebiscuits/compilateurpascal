#ifndef ARRAY_H
#define ARRAY_H

#include "type.h"
#include "arrayindex.h"
class Array : public Type
{
private:
    Type* type ;
    ArrayIndex index;
public:
    Array(Type*, ArrayIndex);
    ~Array();
    string getArrayType() const ;
};

#endif // ARRAY_H

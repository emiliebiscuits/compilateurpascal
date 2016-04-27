#include "array.h"

Array::Array(Type *type, ArrayIndex index) :
    type(type),index(index)
{
    this->name = "array";
}

Array::~Array()
{
    delete this->type ;
}

string Array::getArrayType() const
{
    return this->type->getName() ;
}


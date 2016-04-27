#include "element.h"

Element::Element()
{
}

void Element::setRes(const string &res)
{
    this->res = res ;
}

void Element::setCode(const string &code)
{
    this->code = code ;
}

string Element::getRes() const
{
    return res ;
}

string Element::getCode() const
{
    return code ;
}

void Element::addCode(const string &code)
{
    this->code.append(code);
}

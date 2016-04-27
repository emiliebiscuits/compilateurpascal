#ifndef ELEMENT_H
#define ELEMENT_H

#include <string>
using namespace std ;

class Element
{
    string res ;
    string code ;
public:
    Element();
    void setRes(const string& res);
    void setCode(const string& code);

    string getRes() const ;
    string getCode() const ;

    void addCode(const string& code);
};

#endif // ELEMENT_H

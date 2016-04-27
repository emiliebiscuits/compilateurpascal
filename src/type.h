#include<string>
using namespace std;

#ifndef _type_h
#define _type_h
class Type
{
protected :
    string name ;
public :
    Type() ;
    virtual ~Type()= 0 ;
    const string& getName() const ;
};

#endif



#ifndef _ENUM_H
#define _ENUM_H

#include "type.h"
#include <vector>
#include <string>
class Enum : public Type
{
    private:
        vector<int> fields;
    public:
    Enum();
    ~Enum();
    void addField(int);
    vector<int> getFields();
};

#endif

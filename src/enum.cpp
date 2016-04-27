#include "enum.h"

Enum :: Enum()
{
    this->name = "enum";
}
Enum :: ~Enum()
{
    this->fields.clear();
}
void Enum ::addField(int s)
{
    this->fields.push_back(s);
}
vector<int> Enum::getFields(){
    return this->fields;
}

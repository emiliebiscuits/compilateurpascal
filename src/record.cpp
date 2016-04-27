#include "record.h"
#include <map>
#include <string>

Record :: Record()
{
    this->name = "record";
}
Record :: ~Record()
{
    this->fields.clear();
}

void Record::addField(int s, Type *t)
{
   fields.insert(pair<int,Type *>(s, t)) ;
}

std::map<int, Type *> Record::getFields()
{
    return this->fields ;
}

/* 
 * File:   record.h
 * Author: Emilie
 *
 * Created on 11 novembre 2015, 18:31
 */

#ifndef RECORD_H
#define	RECORD_H
#include "type.h"
#include <map>
#include <string>
#include <symbolevariable.h>

class Record: public Type{
    private :
        std::map<int,Type*> fields ;
    public:
        Record();
        ~Record();
        std::map<int,Type*>  getFields();
        void addField(int,Type*);

};
#endif	/* RECORD_H */


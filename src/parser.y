%{

#include <cstddef>
#include <stdio.h>
#include <iostream>
#include "type.h"
#include "integer.h"
#include "bool.h"
#include "char.h"
#include "my_string.h"
#include "real.h"
#include "void.h"
#include "array.h"
#include "arrayindex.h"
#include "enum.h"
#include "record.h"
#include "tableident.h"
#include "tablesymbole.h"
#include "tabletype.h"
#include "symbolevariable.h"
#include "symboleprogramme.h"
#include "symboletype.h"
#include "symbolefonction.h"
#include "symboleprocedure.h"
#include "symboleargument.h"
#include "symboleenumfield.h"
#include "symbolerecordfield.h"
#include "symboletemporaire.h"
#include "element.h"
#include <vector>
#include <string>
#include <deque>
#include <fstream>

using namespace std;

extern int yyerror ( char* );
extern int yylex ();
extern TableIdent tableId ;

TableSymbole tableSymbole(nullptr) ;
TableSymbole *currentTableSymbole = &tableSymbole ;
TableType tableType ;

std::vector<int> multipleVarDecl ;
std::vector<SymboleArgument*> currentArgs ;
std::map<int, Type*> recordFields ;
std::vector<TableSymbole*> tablesSymboles ;
std::deque<int> enumfields;
std::vector<Element*> currentListExpr ;
std::vector<Element*> listInstr ;

ofstream codeFile ;

int label = 0 ;
int currentFunctionIdent = -1 ;

%}


%union{
const char * string;
Type *type;
ArrayIndex *index;
int numIdent;
std::string *cppstring;
Element *element;
}



%type <type> BaseType
%type <type> SimpleType
%type <type> Type
%type <type> UserType
%type <type> DeclType
%type <numIdent> InterBase
%type <type> ArrayType
%type <index> ArrayIndex
%type <type> EnumType
%type <index> InterType
%type <type> RecordType
%type <type> FuncResult
%type <numIdent> FuncIdent
%type <numIdent> ProcIdent
%type <numIdent> ProgramHeader
%type <numIdent> ProcHeader
%type <numIdent> FuncHeader
%type <element> AtomExpr
%type <element> VarExpr
%type <element> MathExpr
%type <element> Expression
%type <element> Instr
%type <element> CompExpr
%type <element> BoolExpr

%token KW_PROGRAM
%token KW_CONST
%token KW_TYPE
%token KW_VAR
%token KW_ARRAY
%token KW_OF
%token KW_RECORD
%token KW_BEGIN
%token KW_END
%token KW_DIV
%token KW_MOD
%token KW_AND
%token KW_OR
%token KW_XOR
%token KW_NOT
%token KW_IF
%token KW_THEN
%token KW_ELSE
%token KW_WHILE
%token KW_DO
%token KW_REPEAT
%token KW_UNTIL
%token KW_FOR
%token KW_TO
%token KW_DOWNTO
%token KW_PROC
%token KW_FUNC
%token KW_INTEGER
%token KW_REAL
%token KW_BOOLEAN
%token KW_CHAR
%token KW_STRING

%token KW_WRITE
%token KW_WRITELN
%token KW_READ

%token SEP_SCOL
%token SEP_DOT
%token SEP_DOTS
%token SEP_DOTDOT
%token SEP_COMMA
%token SEP_CO
%token SEP_CF
%token SEP_PO
%token SEP_PF

%token OP_EQ
%token OP_NEQ
%token OP_LT
%token OP_LTE
%token OP_GT
%token OP_GTE
%token OP_ADD
%token OP_SUB
%token OP_MUL
%token OP_SLASH
%token OP_EXP
%token OP_AFFECT

%token <numIdent> TOK_IDENT
%token <string> TOK_INTEGER
%token <string>TOK_REAL
%token <string>TOK_BOOLEAN
%token <string> TOK_CHAR
%token <string> TOK_STRING

%start Program

%nonassoc OP_EQ OP_NEQ OP_GT OP_LT OP_GTE OP_LTE
%left OP_ADD OP_SUB KW_OR KW_XOR
%left OP_MUL OP_SLASH KW_AND KW_DIV KW_MOD
%right KW_NOT OP_NEG OP_POS
%left OP_EXP
%nonassoc OP_PTR
%nonassoc OP_DOT
%left SEP_CO

%nonassoc KW_IFX
%nonassoc KW_ELSE

%%

Program				:	ProgramHeader SEP_SCOL Block SEP_DOT
                                        {

                                                codeFile << string(tableId.getNom($1)) << " :\t nop\n" ;
                                                for(Element *e : listInstr) {
                                                    codeFile << e->getCode() ;
                                                }

                                                codeFile.close();
                                        }
                                            ;

ProgramHeader		:	KW_PROGRAM TOK_IDENT
                    {

                        codeFile.open("code_3_a.txt");
                        tablesSymboles.push_back(&tableSymbole);
                        tableSymbole.addSymbole($2, new SymboleProgramme());
                        $$=$2;
                    }
                                        ;

Block				:	BlockDeclConst BlockDeclType BlockDeclVar BlockDeclFunc BlockCode;



BlockSimple		:	BlockDeclConst BlockDeclType BlockDeclVar BlockCode;

BlockDeclConst		:	KW_CONST ListDeclConst
                    |
                    ;

ListDeclConst		:	ListDeclConst DeclConst
                    |	DeclConst
                    ;

DeclConst			:	TOK_IDENT OP_EQ Expression SEP_SCOL
                    |	TOK_IDENT SEP_DOTS BaseType OP_EQ Expression SEP_SCOL
                    ;

BlockDeclType		:	KW_TYPE ListDeclType
                    |
                    ;

ListDeclType		:	ListDeclType DeclType
                    |	DeclType
                    ;

DeclType			:	TOK_IDENT OP_EQ Type SEP_SCOL
                        {
                            std::cout<<"Declaration de type avec : "<<$3->getName()<<std::endl;
                            tableSymbole.addSymbole($1, new SymboleType($3));
                            tableType.addType($1, $3);
                                                        if($3->getName()=="enum")
                                                        {
                                                                int j = 0;
                                                                for(auto i : enumfields)
                                                                {
                                                                    tableSymbole.addSymbole(i, new SymboleEnumField($1,j));
                                                                    j+=1;
                                                                }
                                                                enumfields.clear() ;
                                                        }
                            if($3->getName()=="record")
                            {
                                for(auto field : recordFields)
                                {
                                    tableSymbole.addSymbole(field.first, new SymboleRecordField(field.second, $1));
                                }
                                recordFields.clear();
                            }

                        }
                    ;

Type				:	UserType{$$=$1;}
                    |	SimpleType{$$=$1;}
                    ;

UserType			:	EnumType{
                                                    $$=$1;
                                                }
                    |	InterType{$$=$1;}
                    |	ArrayType{$$=$1;}
                    |	RecordType{$$=$1;}
                    ;

SimpleType			:	BaseType {$$ = $1;}
                    |	TOK_IDENT {$$ = tableType.getTypeByIdent($1);}
                    ;

BaseType			:	KW_INTEGER {$$ = new Integer();}
                    |	KW_REAL {$$ = new Real();}
                    |	KW_BOOLEAN {$$ = new Bool();}
                    |	KW_CHAR {$$ = new Char();}
                    |	KW_STRING {$$ = new String();}
                    ;

EnumType			:	SEP_PO ListEnumValue SEP_PF{
                                                                    Enum *e = new Enum();
                                                                    for(auto i : enumfields)
                                                                    {
                                                                        e->addField(i);
                                                                    }
                                                                    $$=e;
                                                                    std::cout<<"Type de la déclaration : "<<$$->getName()<<std::endl;
                                                    }
                    ;

ListEnumValue		:	ListEnumValue SEP_COMMA TOK_IDENT{enumfields.push_front($3);}
                    |	TOK_IDENT{enumfields.push_front($1);}
                    ;

InterType			:	InterBase SEP_DOTDOT InterBase { $$ = new ArrayIndex($1,$3) ;}
                    ;

InterBase			:	TOK_IDENT
                    |	TOK_INTEGER {
                                                                $$ = stoi(string($1));
                                                            }
                    |	TOK_CHAR {
                                                             $$ =(int)(string($1).at(1));
                                                        }
                    ;

ArrayType			:	KW_ARRAY SEP_CO ArrayIndex SEP_CF KW_OF SimpleType { $$ = new Array($6, *$3) ; std::cout << "Tableau de " << $6->getName() << std::endl ;}
                    ;

ArrayIndex			:	TOK_IDENT  {$$ = (ArrayIndex*)tableType.getTypeByIdent($1);}
                    |	InterType { $$ = $1; }
                    ;

RecordType			:	KW_RECORD RecordFields KW_END
                        {
                            Record *rec = new Record();
                            for(auto field : recordFields)
                            {
                                rec->addField(field.first, field.second) ;
                            }
                            $$ = rec ;
                        }
                    ;

RecordFields		:	RecordFields SEP_SCOL RecordField
                    |	RecordField
                    ;

RecordField			:	ListIdent SEP_DOTS SimpleType
                                        {
                        for(int ident : multipleVarDecl)
                        {
                            recordFields[ident] = $3 ;
                        }
                        multipleVarDecl.clear();
                                        }
                    ;

BlockDeclVar		:	KW_VAR ListDeclVar
                    |
                    ;

ListDeclVar			:	ListDeclVar DeclVar
                    |	DeclVar
                    ;

DeclVar				:	ListIdent SEP_DOTS SimpleType SEP_SCOL
                            {
                                std::cout << "Type de la déclaration : " << $3->getName() << std::endl ;
                                for(int i : multipleVarDecl)
                                {
                                    currentTableSymbole->addSymbole(i, new SymboleVariable($3)) ;
                                }
                                multipleVarDecl.clear();
                                //tableSymbole.addSymbole(new SymboleVariable($3)) ;
                            }
                    ;

ListIdent			:	ListIdent SEP_COMMA TOK_IDENT
                            {
                                multipleVarDecl.push_back($3);
                            }
                    |	TOK_IDENT
                            {
                                multipleVarDecl.push_back($1);
                            }
                    ;

BlockDeclFunc		:	ListDeclFunc SEP_SCOL
                    |
                    ;

ListDeclFunc		:	ListDeclFunc SEP_SCOL DeclFunc
                    |	DeclFunc
                    ;

DeclFunc			:	ProcDecl
                    |	FuncDecl
                    ;

ProcDecl			:	ProcHeader SEP_SCOL BlockSimple
                        {
                            codeFile << string(tableId.getNom($1)) << " :\t nop\n" ;
                            for(Element *e : listInstr) {
                                codeFile << e->getCode() ;
                            }
                            codeFile << "\t\t\tretourner\n" ;
                            listInstr.clear();
                            tablesSymboles.push_back(currentTableSymbole);
                            currentTableSymbole = &tableSymbole ;
                        }
                    ;

ProcHeader			:	ProcIdent
                        {
                            SymboleProcedure *fonction = new SymboleProcedure(&tableSymbole, currentArgs) ;
                            tableSymbole.addSymbole($1, fonction) ;
                            currentArgs.clear();
                            currentTableSymbole = fonction->getTableSymbole() ;
                            $$=$1;
                        }
                    |	ProcIdent FormalArgs
                            {
                                SymboleProcedure * fonction = new SymboleProcedure(&tableSymbole, currentArgs) ;
                                tableSymbole.addSymbole($1, fonction) ;
                                currentArgs.clear();
                                currentTableSymbole = fonction->getTableSymbole() ;
                                $$=$1;
                            }
                    ;

ProcIdent			:	KW_PROC TOK_IDENT
                        {
                            $$ = $2 ;
                        }
                    ;

FormalArgs			:	SEP_PO ListFormalArgs SEP_PF
                    ;

ListFormalArgs		:	ListFormalArgs SEP_SCOL FormalArg
                    |	FormalArg
                    ;

FormalArg			:	ValFormalArg
                    |	VarFormalArg
                    ;

ValFormalArg		:	ListIdent SEP_DOTS SimpleType
                        {
                            for(auto i : multipleVarDecl)
                            {
                                SymboleArgument * argument = new SymboleArgument(false, $3) ;
                                argument->setIdent(i);
                                //tableSymbole.addSymbole(i, argument);
                                currentArgs.push_back(argument);
                                Element *elem = new Element() ;
                                elem->addCode("\t\t\tdepiler "+string(tableId.getNom(i))+"\n");
                                listInstr.push_back(elem);
                            }
                            multipleVarDecl.clear() ;
                        }
                    ;

VarFormalArg		:	KW_VAR ListIdent SEP_DOTS SimpleType
                        {
                            for(auto i : multipleVarDecl)
                            {
                                SymboleArgument * argument = new SymboleArgument(true, $4) ;
                                argument->setIdent(i);
                                //tableSymbole.addSymbole(i, argument);
                                currentArgs.push_back(argument);
                                Element *elem = new Element() ;
                                elem->addCode("\t\t\tdepiler "+string(tableId.getNom(i))+"\n");
                                listInstr.push_back(elem);
                            }
                            multipleVarDecl.clear() ;
                        }
                    ;

FuncDecl			:	FuncHeader SEP_SCOL BlockSimple
                        {
                            codeFile << string(tableId.getNom($1)) << " :\t nop\n" ;
                            for(Element *e : listInstr) {
                                codeFile << e->getCode() ;
                            }
                            codeFile << "\t\t\tretourner\n" ;
                            listInstr.clear();
                            tablesSymboles.push_back(currentTableSymbole);
                            currentTableSymbole = &tableSymbole ;
                            currentFunctionIdent = -1 ;
                        }
                    ;

FuncHeader			:	FuncIdent FuncResult
                        {
                            SymboleFonction *fonction = new SymboleFonction($2, &tableSymbole, currentArgs) ;
                            tableSymbole.addSymbole($1, fonction) ;
                            currentArgs.clear();
                            currentTableSymbole = fonction->getTableSymbole() ;
                            currentFunctionIdent = $1 ;
                            $$=$1;
                        }
                    |	FuncIdent FormalArgs FuncResult
                        {
                            SymboleFonction * fonction = new SymboleFonction($3, &tableSymbole, currentArgs) ;
                            tableSymbole.addSymbole($1, fonction) ;
                            currentArgs.clear();
                            currentTableSymbole = fonction->getTableSymbole() ;
                            currentFunctionIdent = $1 ;
                            $$=$1;
                        }
                    ;

FuncIdent			:	KW_FUNC TOK_IDENT
                        {
                            $$ = $2 ;
                        }
                    ;

FuncResult			:	SEP_DOTS SimpleType
                        {
                            $$ = $2 ;
                        }
                    ;

BlockCode			:	KW_BEGIN ListInstr KW_END{


                                                  }
                    |	KW_BEGIN ListInstr SEP_SCOL KW_END
                    |	KW_BEGIN KW_END
                    ;

ListInstr			:	ListInstr SEP_SCOL Instr{
                                                    listInstr.push_back($3);
                                                     }
                    |	Instr{
                               listInstr.push_back($1);
                                }
                    ;

Instr				:	KW_WHILE Expression KW_DO Instr{
                                                            Element *e = new Element();
                                                            e->addCode("etiquette"+to_string(label)+" : nop");
                                                            e->addCode($2->getCode());
                                                            e->addCode("\t\t\tif "+$2->getRes()+" aller a ");
                                                            e->addCode("etiquette"+to_string(label+1)+'\n');
                                                            e->addCode("\t\t\taller a etiquette"+to_string(label+2)+'\n');
                                                            e->addCode("etiquette"+to_string(label+1)+" : nop");
                                                            e->addCode($4->getCode());
                                                            e->addCode("\t\t\taller a etiquette"+to_string(label));
                                                            e->addCode("etiquette"+to_string(label+2)+" : nop");
                                                            e->setRes("instruction while "+to_string(label));
                                                            label+=3;
                                                            $$=e;
                                                            cout<<e->getCode()<<endl;

                                                        }
                    |	KW_REPEAT ListInstr KW_UNTIL Expression{
                                                                    Element *e = new Element();
                                                                    e->addCode("etiquette"+to_string(label)+" : nop");
                                                                    e->addCode($4->getCode());
                                                                    e->addCode("\t\t\tif "+$4->getRes()+" aller a ");
                                                                    e->addCode("etiquette"+to_string(label+1)+'\n');
                                                                    e->addCode("\t\t\taller a etiquette"+to_string(label+2)+'\n');
                                                                    e->addCode("etiquette"+to_string(label+1)+" : nop");
                                                                    for(Element *elem : listInstr) {
                                                                        e->addCode(elem->getCode()) ;
                                                                    }
                                                                    listInstr.clear();
                                                                    e->addCode("\t\t\taller a etiquette"+to_string(label));
                                                                    e->addCode("etiquette"+to_string(label+2)+" : nop");
                                                                    e->setRes("instruction while "+to_string(label));
                                                                    label+=3;
                                                                    $$=e;
                                                                    cout<<e->getCode()<<endl;
                                                                    }
                    |	KW_FOR TOK_IDENT OP_AFFECT Expression ForDirection Expression KW_DO Instr {
                                                                    Element *e = new Element();
                                                                    e->addCode($4->getCode());
                                                                    e->addCode("\t\t\t"+string(tableId.getNom($2))+" := "+$4->getRes()+"\n");
                                                                    e->addCode("etiquette"+to_string(label)+" : nop\n");
                                                                    int taille = tableId.getTaille()+1;
                                                                    string *s = new string("temp"+to_string(taille));
                                                                    tableId.ajoutIdentificateur(s);
                                                                    SymboleTemporaire *st = new SymboleTemporaire(string(tableId.getNom($2))+">"+$6->getRes());
                                                                    e->addCode($6->getCode());
                                                                    e->addCode("\t\t\t"+*s+":="+string(tableId.getNom($2))+">"+$6->getRes()+'\n');
                                                                    e->addCode("\t\t\tif "+*s+ " aller a etiquette"+to_string(label+1)+'\n');
                                                                    e->addCode("\t\t\taller a etiquette"+to_string(label+2)+'\n');
                                                                    e->addCode("etiquette"+to_string(label+1)+" : nop\n");
                                                                    e->addCode($8->getCode());
                                                                    string *s2 = new string("temp"+to_string(taille));
                                                                    tableId.ajoutIdentificateur(s2);
                                                                    SymboleTemporaire *st2 = new SymboleTemporaire(string(tableId.getNom($2))+"+1");
                                                                    e->addCode("\t\t\t"+string(tableId.getNom($2))+":="+*s2+'\n');
                                                                    e->addCode("\t\t\taller a etiquette"+to_string(label)+'\n');
                                                                    e->addCode("etiquette"+to_string(label+2)+": nop\n");
                                                                    e->setRes("instruction for "+to_string(label));
                                                                    label+=3;
                                                                    $$=e;
                                                                    }

                    |	KW_IF Expression KW_THEN Instr %prec KW_IFX
                    |	KW_IF Expression KW_THEN Instr KW_ELSE Instr {
                    	

					Element *e = new Element();
					e->addCode($2->getCode());
                    e->addCode("\t\t\tif "+$2->getRes()+" aller a ");
                                        e->addCode("etiquette"+to_string(label)+'\n');
					e->addCode($6->getCode());
                    e->addCode("\t\t\taller a etiquette"+to_string(label+1)+"\n");
                                        e->addCode("etiquette"+to_string(label)+": nop\n");
					e->addCode($4->getCode());
                    e->addCode("etiquette"+to_string(label+1)+" : nop \n");
					e->setRes("instruction if "+to_string(label));
                    label+=2;
					$$=e;
					cout << e->getCode() << endl ;

                    		}
                    |	VarExpr OP_AFFECT Expression{
                    					Element *elem = new Element();
                                                        string *s= new string("");
                                                        string res = $1->getRes() ;
                                                        if(currentFunctionIdent != -1 && string(tableId.getNom(currentFunctionIdent)) == res)
                                                        {
                                                            *s = "renvoyer "+$3->getRes()+"\n";
                                                        } else
                                                        {
                                                            *s = *s +$1->getRes()+":=";
                                                            *s= *s +$3->getRes();
                                                            *s = *s +"\n";
                                                            elem->addCode($3->getCode());
                                                        }
                                                        elem->addCode("\t\t\t"+*s);
							elem->setRes(res);
                                                        $$=elem;
                                                     }
                    |	TOK_IDENT SEP_PO ListeExpr SEP_PF   {
                                                                Element *elem = new Element();
                                                                for(auto i: currentListExpr){
                                                                    elem->addCode(i->getCode());
                                                                }
                                                                //temporaire dans lequel on met le resultat
                                                                int taille = tableId.getTaille()+1;
                                                                string *s = new string("temp"+to_string(taille));
                                                                tableId.ajoutIdentificateur(s);

                                                                elem->addCode("\t\t\tempiler "+*s+"\n");

                                                                for(auto i : currentListExpr){
                                                                    elem->addCode("\t\t\tempiler "+i->getRes()+"\n");
                                                                }
                                                                currentListExpr.clear();

                                                                elem->addCode("\t\t\tappeler "+string(tableId.getNom($1))+"\n");
                                                                elem->setRes(*s);
                                                                $$ = elem ;

                                                            }
                    |	TOK_IDENT
                    |	KW_WRITE SEP_PO ListeExpr SEP_PF {
				        //iterer sur currentListExpr
					Element *elem = new Element();
					for(auto i: currentListExpr){
				            elem->addCode(i->getCode());
				        }
				        for(auto i: currentListExpr){
                                            elem->addCode("\t\t\tecrire "+i->getRes()+"\n");
				        }
					elem->setRes("Res de Write");
				        $$=elem;
				        currentListExpr.clear();
				                }
                    |	KW_WRITELN SEP_PO ListeExpr SEP_PF{
				        //iterer sur currentListExpr
					Element *elem = new Element();
					for(auto i: currentListExpr){
				            elem->addCode(i->getCode());
				        }
				        for(auto i: currentListExpr){
                                            elem->addCode("\t\t\tecrire "+i->getRes()+"\n");
				        }
                                        elem->addCode("\t\t\tsautdeligne\n");
					elem->setRes("Res de Writeln");
				        $$=elem;
				        currentListExpr.clear();
                                }
                    |	KW_READ SEP_PO VarExpr SEP_PF{
					Element* elem = new Element();
                                        elem->addCode("\t\t\tlire "+$3->getRes()+'\n');
					elem->setRes("Res de Read");
                        		$$=elem;
                                }
                    |	BlockCode
                    ;

ForDirection		:	KW_TO
                    |	KW_DOWNTO
                    ;

Expression			:	MathExpr
                    |	CompExpr{$$=$1;}
                    |	BoolExpr{$$=$1;}
                    |	AtomExpr{$$=$1;}
                    |	VarExpr{$$=$1;}
                    |	TOK_IDENT SEP_PO ListeExpr SEP_PF{
                                                            //COPIER-COLLER de Instr-Fonction
                                                            Element *elem = new Element();
                                                            for(auto i: currentListExpr){
                                                                elem->addCode(i->getCode());
                                                            }
                                                            //temporaire dans lequel on met le resultat
                                                            int taille = tableId.getTaille()+1;
                                                            string *s = new string("temp"+to_string(taille));
                                                            tableId.ajoutIdentificateur(s);

                                                            elem->addCode("\t\t\tempiler "+*s+"\n");

                                                            for(auto i : currentListExpr){
                                                                elem->addCode("\t\t\tempiler "+i->getRes()+"\n");
                                                            }
                                                            currentListExpr.clear();

                                                            elem->addCode("\t\t\tappeler "+string(tableId.getNom($1))+"\n");
                                                            elem->setRes(*s);
                                                            $$ = elem ;

                                                        }
                    ;

MathExpr			:	Expression OP_ADD Expression{   //creer un nouveau temp, ajouter dans tabId
							Element * elem = new Element() ;
                                                        int taille = tableId.getTaille()+1;
                                                        string *s = new string("temp"+to_string(taille));
                                                        tableId.ajoutIdentificateur(s);
                                                        //temp=$1+'+'+$3
                                                        Symbole *st = new SymboleTemporaire($1->getRes()+'+'+$3->getRes());
							elem->addCode($1->getCode());
							elem->addCode($3->getCode());
                                                        elem->addCode(string("\t\t\t")+*s+":="+$1->getRes()+'+'+$3->getRes()+'\n');
							elem->setRes(*s);
                                                        //ajouter dans tabSymbole
                                                        currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s), st);
                                                        //remonter ce temp
                                                        $$=elem;

                                                     }
                    |	Expression OP_SUB Expression{   //creer un nouveau temp, ajouter dans tabId
							Element * elem = new Element() ;
                                                        int taille = tableId.getTaille()+1;
                                                        string *s = new string("temp"+to_string(taille));
                                                        tableId.ajoutIdentificateur(s);
                                                        //temp=$1+'-'+$3
                                                        SymboleTemporaire *st = new SymboleTemporaire($1->getRes()+'-'+$3->getRes());
							elem->addCode($1->getCode());
							elem->addCode($3->getCode());
                                                        elem->addCode(string("\t\t\t")+*s+":="+$1->getRes()+'-'+$3->getRes()+'\n');
							elem->setRes(*s);
                                                        //ajouter dans tabSymbole
                                                        currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s), st);
                                                        //remonter ce temp
                                                        $$=elem;
                                                     }
                    |	Expression OP_MUL Expression{
							Element * elem = new Element() ;
                                                        int taille = tableId.getTaille()+1;
                                                        string *s = new string("temp"+to_string(taille));
                                                        tableId.ajoutIdentificateur(s);
                                                        SymboleTemporaire *st = new SymboleTemporaire($1->getRes()+'*'+$3->getRes());
							elem->addCode($1->getCode());
							elem->addCode($3->getCode());
                                                        elem->addCode(string("\t\t\t")+*s+":="+$1->getRes()+'*'+$3->getRes()+'\n');
							elem->setRes(*s);
                                                        currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s), st);
                                                        $$=elem;
                                                     }
                    |	Expression OP_SLASH Expression{
							   Element * elem = new Element() ;
                                                           int taille = tableId.getTaille()+1;
                                                           string *s = new string("temp"+to_string(taille));
                                                           tableId.ajoutIdentificateur(s);
                                                           SymboleTemporaire *st = new SymboleTemporaire($1->getRes()+'/'+$3->getRes());
							   elem->addCode($1->getCode());
							   elem->addCode($3->getCode());
                                                           elem->addCode(string("\t\t\t")+*s+":="+$1->getRes()+'/'+$3->getRes()+'\n');
							   elem->setRes(*s);
                                                           currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s),st);
                                                           $$=elem;
                                                        }
                    |	Expression KW_DIV Expression
			 		|	Expression KW_MOD Expression
			 		|	Expression OP_EXP Expression
			 		|	OP_SUB Expression %prec OP_NEG
			 		|	OP_ADD Expression %prec OP_POS
			 		;

CompExpr			:	Expression OP_EQ Expression{
                                                        int taille = tableId.getTaille()+1;
                                                        string *s = new string("temp"+to_string(taille));
                                                        tableId.ajoutIdentificateur(s);
                                                        SymboleTemporaire *st = new SymboleTemporaire($1->getRes()+"=="+$3->getRes());
                                                        currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s),st);
                                                        Element *e = new Element();
                                                        e->addCode($1->getCode());
                                                        e->addCode($3->getCode());
                                                        e->addCode(string("\t\t\t")+*s+":="+$1->getRes()+"=="+$3->getRes()+'\n');
                                                        e->setRes(*s);
                                                        $$=e;
                                                    }
                    |	Expression OP_NEQ Expression{
                                                        int taille = tableId.getTaille()+1;
                                                        string *s = new string("temp"+to_string(taille));
                                                        tableId.ajoutIdentificateur(s);
                                                        SymboleTemporaire *st = new SymboleTemporaire($1->getRes()+"!="+$3->getRes());
                                                        currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s),st);
                                                        Element *e = new Element();
                                                        e->addCode($1->getCode());
                                                        e->addCode($3->getCode());
                                                        e->addCode(string("\t\t\t")+*s+":="+$1->getRes()+"!="+$3->getRes()+'\n');
                                                        e->setRes(*s);
                                                        $$=e;
                                                    }
                    |	Expression OP_LT Expression{
                                                        int taille = tableId.getTaille()+1;
                                                        string *s = new string("temp"+to_string(taille));
                                                        tableId.ajoutIdentificateur(s);
                                                        SymboleTemporaire *st = new SymboleTemporaire($1->getRes()+"<"+$3->getRes());
                                                        currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s),st);
                                                        Element *e = new Element();
                                                        e->addCode($1->getCode());
                                                        e->addCode($3->getCode());
                                                        e->addCode(string("\t\t\t")+*s+":="+$1->getRes()+"<"+$3->getRes()+'\n');
                                                        e->setRes(*s);
                                                        $$=e;
                                                    }
                    |	Expression OP_LTE Expression{
                                                        int taille = tableId.getTaille()+1;
                                                        string *s = new string("temp"+to_string(taille));
                                                        tableId.ajoutIdentificateur(s);
                                                        SymboleTemporaire *st = new SymboleTemporaire($1->getRes()+"<="+$3->getRes());
                                                        currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s),st);
                                                        Element *e = new Element();
                                                        e->addCode($1->getCode());
                                                        e->addCode($3->getCode());
                                                        e->addCode(string("\t\t\t")+*s+":="+$1->getRes()+"<="+$3->getRes()+'\n');
                                                        e->setRes(*s);
                                                        $$=e;
                                                    }
                    |	Expression OP_GT Expression{
                                                        int taille = tableId.getTaille()+1;
                                                        string *s = new string("temp"+to_string(taille));
                                                        tableId.ajoutIdentificateur(s);
                                                        SymboleTemporaire *st = new SymboleTemporaire($1->getRes()+">"+$3->getRes());
                                                        currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s),st);
                                                        Element *e = new Element();
                                                        e->addCode($1->getCode());
                                                        e->addCode($3->getCode());
                                                        e->addCode(string("\t\t\t")+*s+":="+$1->getRes()+">"+$3->getRes()+'\n');
                                                        e->setRes(*s);
                                                        $$=e;
                                                    }
                    |	Expression OP_GTE Expression{
                                                        int taille = tableId.getTaille()+1;
                                                        string *s = new string("temp"+to_string(taille));
                                                        tableId.ajoutIdentificateur(s);
                                                        SymboleTemporaire *st = new SymboleTemporaire($1->getRes()+">="+$3->getRes());
                                                        currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s),st);
                                                        Element *e = new Element();
                                                        e->addCode($1->getCode());
                                                        e->addCode($3->getCode());
                                                        e->addCode(string("\t\t\t")+*s+":="+$1->getRes()+">="+$3->getRes()+'\n');
                                                        e->setRes(*s);
                                                        $$=e;
                                                    }
                    ;

BoolExpr			:	Expression KW_AND Expression{
                                                        int taille = tableId.getTaille()+1;
                                                        string *s = new string("temp"+to_string(taille));
                                                        tableId.ajoutIdentificateur(s);
                                                        SymboleTemporaire *st = new SymboleTemporaire($1->getRes()+"&"+$3->getRes());
                                                        currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s), st);
                                                        Element *e = new Element();
                                                        e->addCode($1->getCode());
                                                        e->addCode($3->getCode());
                                                        e->addCode(string("\t\t\t")+*s+":="+$1->getRes()+"&"+$3->getRes()+'\n');
                                                        e->setRes(*s);
                                                        $$=e;
                                                    }
                    |	Expression KW_OR Expression{
                                                        int taille = tableId.getTaille()+1;
                                                        string *s = new string("temp"+to_string(taille));
                                                        tableId.ajoutIdentificateur(s);
                                                        SymboleTemporaire *st = new SymboleTemporaire($1->getRes()+"|"+$3->getRes());
                                                        currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s), st);
                                                        Element *e = new Element();
                                                        e->addCode($1->getCode());
                                                        e->addCode($3->getCode());
                                                        e->addCode(string("\t\t\t")+*s+":="+$1->getRes()+"|"+$3->getRes()+'\n');
                                                        e->setRes(*s);
                                                        $$=e;
                                                    }
                    |	Expression KW_XOR Expression
                    |	KW_NOT Expression{
                                                int taille = tableId.getTaille()+1;
                                                string *s = new string("temp"+to_string(taille));
                                                tableId.ajoutIdentificateur(s);
                                                SymboleTemporaire *st = new SymboleTemporaire('!'+$2->getRes());
                                                currentTableSymbole->addSymbole(tableId.ajoutIdentificateur(s), st);
                                                Element *e = new Element();
                                                e->addCode($2->getCode());
                                                e->addCode(string("\t\t\t")+*s+":="+"!"+$2->getRes()+'\n');
                                                e->setRes(*s);
                                                $$=e;
                                            }
                        ;

AtomExpr			:	SEP_PO Expression SEP_PF {$$ = $2;}
                    |	TOK_INTEGER{
                            Element * elem = new Element();
                    elem->setRes(string($1));
                    elem->setCode("");
                            $$=elem;
                    }
                    |	TOK_REAL{
                            Element * elem = new Element();
                    elem->setRes(string($1));
                    elem->setCode("");
                            $$=elem;
                    }
                    |	TOK_BOOLEAN{
                            Element * elem = new Element();
                    elem->setRes(string($1));
                    elem->setCode("");
                            $$=elem;
                    }
                    |	TOK_CHAR{
                            Element * elem = new Element();
                    elem->setRes(string($1));
                    elem->setCode("");
                            $$=elem;
                    }
                    |	TOK_STRING{
                            Element * elem = new Element();
                    elem->setRes(string($1));
                    elem->setCode("");
                            $$=elem;
                    }
                    ;

VarExpr				:	TOK_IDENT{
							Element * elem = new Element();
                                                        elem->setCode("");
							elem->setRes(string(tableId.getNom($1)));
							$$=elem;
						}
					|	VarExpr SEP_CO Expression SEP_CF
					|	VarExpr SEP_DOT TOK_IDENT %prec OP_DOT
					;

ListeExpr			:	ListeExpr SEP_COMMA Expression {
                                    currentListExpr.push_back($3);
                                }
                    |	Expression {
                            currentListExpr.push_back($1);
                        }
                    ;

%%

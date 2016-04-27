SRCD = src
INCD = include
OBJD = obj
BIND = bin

EXEC = ppc

OBJFILES = parser.o lexer.o main.o tableident.o type.o integer.o bool.o char.o my_string.o real.o void.o arrayindex.o array.o enum.o record.o tabletype.o symbole.o tablesymbole.o symboleprogramme.o symbolevariable.o symboletype.o symbolefonction.o symboleprocedure.o symboleargument.o symboleenumfield.o symbolerecordfield.o symboletemporaire.o element.o
OBJS = $(OBJFILES:%.o=$(OBJD)/%.o)

default: $(BIND)/$(EXEC)

$(BIND)/$(EXEC): $(OBJS)
	@g++ -std=c++0x -Wall -o $@ $^ -ll -g

$(OBJD)/%.o: $(SRCD)/%.c
	@g++ -std=c++0x -fpermissive -Wall -o $@ -c $< -I$(INCD) -I$(SRCD) -g

$(OBJD)/%.o: $(SRCD)/%.cpp
	@g++ -std=c++0x -Wall -o $@ -c $< -I$(INCD) -I$(SRCD) -g

$(SRCD)/parser.c: $(SRCD)/parser.y
	@bison -d -o $@ $<

$(SRCD)/lexer.c: $(SRCD)/lexer.l
	@flex -o $@ $<

clean:
	@rm -f $(OBJD)/*.o
	@rm -f $(SRCD)/parser.[hc]
	@rm -f $(SRCD)/lexer.[hc]

mrproper: clean
	@rm -f $(BIND)/$(EXEC)

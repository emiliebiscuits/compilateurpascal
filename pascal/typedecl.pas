program hello;
type toto    = integer ;
   titi	     = array [ 1 .. 10 ] of integer ;
   tata	     = ( id1 , id2 ) ;
   pointgeom = record  abs : integer ; ord : integer  end ;
   tutu	     =  tata ;

var name, tagada : String;

begin
	write ('Please tell me your name: ');
	readln (name);
	writeln ('Hello, ',name,'!');
end.

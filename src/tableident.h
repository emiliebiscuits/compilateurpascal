#ifndef TABLEIDENT_H
#define TABLEIDENT_H

#include<map>
#include<string>

class TableIdent
{
 
private :
  std::map<std::string, unsigned int> tableIdent ;

public:
  TableIdent();
  
  
  /*
  ajoute un identificateur a la table
  renvoie le numero unique associe
  si il est deja present , ne fait que renvoyer son numero
  */
  unsigned int ajoutIdentificateur( const char * ) ;

  unsigned int ajoutIdentificateur(std::string * ) ;
  /*
  recupere le nom associe a un numero unique
  */
  const char * getNom ( const unsigned int ) ;
  /*
  affiche la table sur la sortie standard
  */
  void afficherTableIdent (std::ostream &) ;
  /*
  sauvegarde la table dans un fichier
  le nom du fichier est passe en argument
  */
  void sauvegarderTableIdent( const char * ) ;
  /*
  renvoie le nombre d'éléments dans la table des ident
  */
  int getTaille() const ;
};

#endif // TABLEIDENT_H


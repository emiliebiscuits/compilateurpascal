#include "tableident.h"
#include<map>
#include<string>
#include<iostream>
#include<fstream> 
#include<algorithm>

using namespace std ;

TableIdent::TableIdent()
{
}
  
/*
ajoute un identificateur a la table
renvoie le numero unique associe
si il est deja present , ne fait que renvoyer son numero
*/
unsigned int TableIdent::ajoutIdentificateur( const char * ident)
{
  std::string identificateur = ident ;
  
  std::transform(identificateur.begin(), identificateur.end(), identificateur.begin(), ::tolower);

  if(tableIdent.find(ident) != tableIdent.end())
  {
      return tableIdent[ident];
  }

  unsigned int num_unique = tableIdent.size() + 1 ;
  tableIdent.insert(std::pair<std::string,int>(identificateur, num_unique)) ;
  
  return num_unique ;
}

unsigned int TableIdent::ajoutIdentificateur(string *ident)
{
    return ajoutIdentificateur(ident->c_str());
}

/*
recupere le nom associe a un numero unique
*/
const char * TableIdent::getNom ( const unsigned int mysteryNumber)
{
  std::string returnValue = "unknown";
  for(std::map<std::string,unsigned int>::iterator it = tableIdent.begin() ; it!=tableIdent.end() ; ++it)
  {
    if(it->second == mysteryNumber)
    {
      returnValue = it->first ;
    }
  }
  
  return returnValue.c_str() ;
}

void TableIdent::afficherTableIdent(std::ostream& output)
    {
        for(std::map<string,unsigned int>::iterator it = this->tableIdent.begin(); it!=this->tableIdent.end(); it++)
        {
            output<<"Identifiant : "<<it->first<<" Numéro : "<< it->second<<std::endl;
        }

    }

/*
sauvegarde la table dans un fichier
le nom du fichier est passe en argument
*/
void TableIdent::sauvegarderTableIdent( const char * nom)
{
  std::ofstream fichier ;
  fichier.open(nom, ios::out | ios::trunc);  // ouverture en écriture avec effacement du fichier ouvert

  if(fichier)
  {
	  afficherTableIdent(fichier);
	  fichier.close();
  }
  else
	  std::cerr << "Impossible d'ouvrir le fichier !" << std::endl;

}

int TableIdent::getTaille() const
{
    return tableIdent.size();
}



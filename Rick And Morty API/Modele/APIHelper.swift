//
//  APIHelper.swift
//  Rick And Morty API
//
//  Created by Macinstosh on 09/01/2019.
//  Copyright © 2019 ozvassilius. All rights reserved.
//

import Foundation

// le typealias nous permet dans notre URLSession.shared.datatask
// d'etre utilisé comme completion, parametre asynchrone
// qui resoud le probleme de lapse de temps de reponse de notre requete
typealias ApiCompletion = (
    _ next : String?, // page suivant
    _ personnages : [Personnage]?,
    _ errorString : String?
) -> Void

class APIHelper {
   
    private let _baseUrl = "https://rickandmortyapi.com/api/"
   
    var urlPersonnages : String {
        return _baseUrl + "character/"
    }
    
    func getPersos(_ string: String, completion: ApiCompletion?){
        // on crée une constante url qui recupere le parametre de type String de la fonction
        // dans ce cas qui correspond a l'url de l'ap pour avoir les personnages
        // si on a cette url on debut notre logique:
        if let url = URL(string: string) { // si on a bien une URL
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    // print(error!.localizedDescription) } remplacé par
                    completion?(nil,nil,error!.localizedDescription)
                }
                if data != nil {
                    // convertir notre data en JSON
                    // on doit dabord preparer une struc pour recup nos donnees
                    do {
                        let reponseJSON = try JSONDecoder().decode(APIResult.self, from: data!)
                        completion?(reponseJSON.info.next, reponseJSON.results, nil)
                        // test console:
                        for perso in reponseJSON.results {
                            print("je m'appelle \(perso.name) et je suis un \(perso.species) !")
                        }
                    } catch {
                        completion?(nil,nil,error.localizedDescription)
                    }
                } else {
                    completion?(nil,nil,"aucune data dispo")
                    }
                }.resume()
           
        } else {
            // si on a pas d'url
             completion?(nil,nil,"URL invalide")
        }
    }
}

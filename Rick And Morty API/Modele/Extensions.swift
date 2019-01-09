//
//  Extensions.swift
//  Rick And Morty API
//
//  Created by Macinstosh on 09/01/2019.
//  Copyright © 2019 ozvassilius. All rights reserved.
//

import UIKit

// on crée une extension car on sera surement amené a telecharger une image plusieurs donc plutot que de creer une fonction que l'on va dupliquer plusieurs fois, on crée une seule fonction dans l'extension qu'on pourra utiliser de partout

extension UIImageView {
    
    func download(_ urlString: String) {
        guard let url = URL(string: urlString) else {return} // on verifie si on a une url
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // on verifie si on a une data et si avec on peut construire une image
            guard let imageData = data, let image = UIImage(data: imageData ) else {return}
            
            // quand on fait une URLSession ou une completion on est pas dans la queue principale
            // on est en asychrone
            // pour mettre a jour le UI (l'interface) on doit revenir dans la queue principale sinon erreurs
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

//
//  ViewController.swift
//  Rick And Morty API
//
//  Created by Macinstosh on 09/01/2019.
//  Copyright © 2019 ozvassilius. All rights reserved.
//

import UIKit

class CharactersController: UIViewController {
    
    var pageSuivante = ""
    var personnages: [Personnage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // GET sur les personnages
        getPersos()
    }

    func getPersos() {
        APIHelper().getPersos(APIHelper().urlPersonnages) { (pageSuivante, listePersos, erreurString) in
            if pageSuivante != nil {
                print(pageSuivante!)
                self.pageSuivante = pageSuivante!
            }
            
            if listePersos != nil {
                self.personnages.append(contentsOf: listePersos!)
                print(self.personnages.count)
            }
            
            if erreurString != nil {
                
            }
        }
    }
}


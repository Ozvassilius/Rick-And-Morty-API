//
//  PersoCell.swift
//  Rick And Morty API
//
//  Created by Macinstosh on 09/01/2019.
//  Copyright © 2019 ozvassilius. All rights reserved.
//

import UIKit

class PersoCell: UICollectionViewCell {

    @IBOutlet weak var persoIV: UIImageView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nameLbl: UILabel!

    var perso: Personnage!

    func setupCell(_ perso: Personnage) {
        self.perso = perso
        self.nameLbl.text = self.perso.name

        // pour l'image on créé une extension (dans modele)
        self.persoIV.download(self.perso.image)
        holderView.layer.cornerRadius = 25 // arrondi des angles
        holderView.clipsToBounds = true
        // sans ca il n'y a que le haut avec le label d'arrondi
        // car l'image n'est pas arrondi, on force que la holdiew soit donc arrondie
    }
}

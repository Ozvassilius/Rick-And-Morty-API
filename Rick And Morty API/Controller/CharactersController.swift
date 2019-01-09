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
    
    // pour l'animation
    var cellImageFrame = CGRect() // si on met rien c'est 0 0 0 0
    var detailImageFrame = CGRect()
    var imageDeTransition = UIImageView()
    
    
    @IBOutlet weak var detailView: DetailView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup des delegate et datasource
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // GET sur les personnages
        getPersos(string: APIHelper().urlPersonnages)
        detailView.alpha = 0 // caché des le debut
        NotificationCenter.default.addObserver(self, selector: #selector(animateOut), name: Notification.Name("close"), object: nil)
    }
    
    func animateIn(personnage : Personnage){
        // animation
        detailImageFrame = detailView.persoIV.convert(detailView.persoIV.bounds, to: view)
        
        detailView.setup(personnage)
        
        // animation
        imageDeTransition = UIImageView(frame: cellImageFrame)
        imageDeTransition.download(personnage.image)
        imageDeTransition.layer.cornerRadius = 25
        imageDeTransition.contentMode = .scaleAspectFill
        imageDeTransition.clipsToBounds = true
        view.addSubview(imageDeTransition)
        UIView.animate(withDuration: 0.5, animations: {
            self.imageDeTransition.frame = self.detailImageFrame
            self.imageDeTransition.layer.cornerRadius = self.detailImageFrame.height / 2
            self.collectionView.alpha = 0
        }) { (success) in
            self.detailView.alpha = 1
        }
        
        collectionView.alpha = 0
        detailView.alpha = 1
    }
    
    @objc func animateOut(){
        UIView.animate(withDuration: 0.5, animations: {
            self.imageDeTransition.frame = self.cellImageFrame
            self.imageDeTransition.layer.cornerRadius = 25
            self.collectionView.alpha = 1
            self.detailView.alpha = 0
        }) { (success) in
            self.imageDeTransition.removeFromSuperview()
        }
        
        
    
        
    }

    func getPersos(string : String) {
        APIHelper().getPersos(string) { (pageSuivante, listePersos, erreurString) in
            if pageSuivante != nil {
                print(pageSuivante!)
                self.pageSuivante = pageSuivante!
            }
            
            if listePersos != nil {
                self.personnages.append(contentsOf: listePersos!)
                print(self.personnages.count)
                // dans les tableView on avait besoin de faire un reloadData
                // ici on peut retourner dans la queue principale pour reload
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
            
            if erreurString != nil {
                
            }
        }
    }
}


extension CharactersController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personnages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let personnage = personnages[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersoCell", for: indexPath) as? PersoCell {
            cell.setupCell(perso: personnage)
            return cell
        }
        return UICollectionViewCell()
    }
    
    // optionnelle ( si on a besoin d'avoir plusieurs sections )
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let taille = collectionView.frame.width / 2 - 10
        return CGSize(width: taille, height: taille)
    }
    
    
    // pour determiner si on est en bas de notre page (pour afficher la suite)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item  == personnages.count - 1 {
            // si on est au dernier personnage
            // on va telecharger
            
            // on verifie dabord si la pageSuivante existe
             print("Telecharger")
            if pageSuivante != "" {
                getPersos(string: pageSuivante)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // avant tout on verifie que le layout correspond a celui de ma cell
        guard let layout = collectionView.layoutAttributesForItem(at: indexPath) else {return}
        let frame = collectionView.convert(layout.frame, to: collectionView.superview)
        cellImageFrame = CGRect(x: frame.minX, y: frame.minY + 50, width: frame.width, height: frame.height - 50)
        // les 50 a cause du label qui vaut 50
        
        let personnage = personnages[indexPath.item]
        animateIn(personnage: personnage)
        
    }
}

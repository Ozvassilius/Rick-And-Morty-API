//
//  ViewController.swift
//  Rick And Morty API
//
//  Created by Macinstosh on 09/01/2019.
//  Copyright © 2019 ozvassilius. All rights reserved.
//

import UIKit

// pour le segmented control
enum TypeQuery {
    case all
    case query
}

class CharactersController: UIViewController {

    var pageSuivante = ""
    var personnages: [Personnage] = []

    // pour notre filtre query
    var pageSuivanteQuery = ""
    var personnagesQuery: [Personnage] = []

    // pour l'animation
    var cellImageFrame = CGRect() // si on met rien c'est 0 0 0 0
    var detailImageFrame = CGRect()
    var imageDeTransition = UIImageView()

    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var detailView: DetailView!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // setup des delegate et datasource
        collectionView.delegate = self
        collectionView.dataSource = self

        // GET sur les personnages
        getPersos(string: APIHelper().urlPersonnages, type: .all)
        detailView.alpha = 0 // caché des le debut
        NotificationCenter.default.addObserver(self, selector: #selector(animateOut),
                                               name: Notification.Name("close"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageSuivanteQuery = ""
        personnagesQuery = []
        getPersos(string: APIHelper().urlAvecParam(), type: .query  )
    }

    func animateIn(personnage: Personnage) {
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
    }

    @objc func animateOut() {
        UIView.animate(withDuration: 0.5, animations: {
            self.imageDeTransition.frame = self.cellImageFrame
            self.imageDeTransition.layer.cornerRadius = 25
            self.collectionView.alpha = 1
            self.detailView.alpha = 0
        }) { (success) in
            self.imageDeTransition.removeFromSuperview()
        }
    }

    func getPersos(string: String, type: TypeQuery) {
        APIHelper().getPersos(string) { (pageSuivante, listePersos, erreurString) in
            if pageSuivante != nil {
                print(pageSuivante!)
                switch type {
                case .all: self.pageSuivante = pageSuivante!
                case .query: self.pageSuivanteQuery = pageSuivante!
                }
            }

            if listePersos != nil {
                switch type {
                case .all: self.personnages.append(contentsOf: listePersos!)
                case .query: self.personnagesQuery.append(contentsOf: listePersos!)
                }

                // dans les tableView on avait besoin de faire un reloadData
                // ici on peut retourner dans la queue principale pour reload
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }

            if erreurString != nil {
                print(erreurString!)
            }
        }
    }

    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        collectionView.reloadData() // on reload selon si on a demandé all ou query
    }
}

extension CharactersController: UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmented.selectedSegmentIndex == 0 {
            return personnages.count
        }
        return personnagesQuery.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let personnage = segmented.selectedSegmentIndex == 0 ?
            personnages[indexPath.item] : personnagesQuery[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersoCell",
                                                         for: indexPath) as? PersoCell {
            cell.setupCell(personnage)
            return cell
        }
        return UICollectionViewCell()
    }

    // optionnelle ( si on a besoin d'avoir plusieurs sections )
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let taille = collectionView.frame.width / 2 - 10
        return CGSize(width: taille, height: taille)
    }

    // pour determiner si on est en bas de notre page (pour afficher la suite)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        let count = segmented.selectedSegmentIndex == 0 ? personnages.count : personnagesQuery.count
        if indexPath.item  ==  count - 1 {
            // si on est au dernier personnage
            // on va telecharger

            // on verifie dabord si la pageSuivante existe
             print("Telecharger")

            if segmented.selectedSegmentIndex == 0 && pageSuivante != "" {
                getPersos(string: pageSuivante, type: .all)
            }
            if segmented.selectedSegmentIndex == 1 && pageSuivante != "" {
                getPersos(string: pageSuivanteQuery, type: .query)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // avant tout on verifie que le layout correspond a celui de ma cell
        guard let layout = collectionView.layoutAttributesForItem(at: indexPath) else {return}
        let frame = collectionView.convert(layout.frame, to: collectionView.superview)
        cellImageFrame = CGRect(x: frame.minX, y: frame.minY + 50, width: frame.width, height: frame.height - 50)
        // les 50 a cause du label qui vaut 50

        switch segmented.selectedSegmentIndex {
        case 0: animateIn(personnage: personnages[indexPath.item])
        case 1: animateIn(personnage: personnagesQuery[indexPath.item])
        default:
            break
        }
    }
}

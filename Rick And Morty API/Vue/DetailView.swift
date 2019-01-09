//
//  DetailView.swift
//  Rick And Morty API
//
//  Created by Macinstosh on 09/01/2019.
//  Copyright © 2019 ozvassilius. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    var view : UIView?
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var persoIV: UIImageView!
    
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var genderLbl: UILabel!
    
    @IBOutlet weak var specieLbl: UILabel!
    
    @IBOutlet weak var originLbl: UILabel!
    
    @IBOutlet weak var locationLbl: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib() {
        let bundle = Bundle(for: type(of: self))
        if  let xib = type(of: self).description().components(separatedBy: ".").last {
            let nib = UINib(nibName: xib, bundle: bundle)
            if let v = nib.instantiate(withOwner: self, options: nil).first as? UIView {
                view = v
                view?.frame = bounds
                if view != nil {
                    addSubview(view!)
                    view?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
                    view?.backgroundColor = .white
                    view?.layer.cornerRadius = 25
                }
            }
        }
    }

    @IBAction func closeAction(_ sender: UIButton) {
        
        // on post une notif pour dire qu'on ferme la page Detail
        NotificationCenter.default.post(name: Notification.Name("close"), object: nil)
        
    }
}

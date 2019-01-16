//
//  SettingsController.swift
//  Rick And Morty API
//
//  Created by Macinstosh on 10/01/2019.
//  Copyright © 2019 ozvassilius. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwitch()
        setupNameLabel()

    }

    func setupSwitch() {
        statusSwitch.setOn(UserDefaultsHelper().getStatus(), animated: true)
        statusLbl.text = "Status: " + UserDefaultsHelper().getStatusString()
    }

    func setupNameLabel() {
        let name = UserDefaultsHelper().getName()
        if name == "" {
            nameTF.placeholder = "Entrez un prénom"
        } else {
            nameTF.text = name
        }
    }

    @IBAction func switchChanged(_ sender: UISwitch) {
        UserDefaultsHelper().setStatus(bool: sender.isOn)
        setupSwitch()
    }

    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        UserDefaultsHelper().setName(string: nameTF.text)
        navigationController?.popViewController(animated: true)
    }
}

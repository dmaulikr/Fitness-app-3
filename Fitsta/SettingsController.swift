//
//  SettingsController.swift
//  Fitsta
//
//  Created by Jesse Cohen on 14/12/2016.
//  Copyright © 2016 Man Cave Interactive. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
// MARK: - OUTLETS
    
    @IBOutlet weak var settingsTitle: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTitle.addTextSpacing(4.5)
    }

   
// MARK: - BUTTON ACTIONS
    
    @IBAction func saveSettings(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    

    

}

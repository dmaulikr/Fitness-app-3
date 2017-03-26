//
//  NavigationController.swift
//  Fitsta
//
//  Created by Jesse Cohen on 07/12/2016.
//  Copyright © 2016 Man Cave Interactive. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        let titleLabel = UILabel()
        let colour = UIColor.white
        let attributes: [NSString : AnyObject] = [NSForegroundColorAttributeName as NSString: colour, NSKernAttributeName as NSString : 4.5 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "FITSTA", attributes: attributes as [String : Any]?)
        titleLabel.sizeToFit()
        titleLabel.font = UIFont(name: "Anton", size: 18)
        self.navigationItem.titleView = titleLabel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove navigation controller shadow
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

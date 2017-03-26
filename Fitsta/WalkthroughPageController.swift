//
//  WalkthroughPageController.swift
//  Fitsta
//
//  Created by Jesse Cohen on 06/12/2016.
//  Copyright © 2016 Man Cave Interactive. All rights reserved.
//

import UIKit
import BWWalkthrough

class WalkthroughPageController: BWWalkthroughPageViewController {
    
    @IBOutlet var backgroundView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        view.layer.zPosition = -1000
        view.layer.isDoubleSided = false
        self.backgroundView.layer.masksToBounds = false
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func walkthroughDidScroll(to position: CGFloat, offset: CGFloat) {
        var tr = CATransform3DIdentity
        tr.m34 = -1/1000.0
        view.layer.transform = CATransform3DRotate(tr, CGFloat(M_PI)  * (1.0 - offset), 0.5,1, 0.2)
    }
}

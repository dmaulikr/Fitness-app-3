//
//  HomeExtension.swift
//  Fitsta
//
//  Created by Jesse Cohen on 08/12/2016.
//  Copyright © 2016 Man Cave Interactive. All rights reserved.
//

import Foundation

extension HomeController {
    
// MARK: - WALKTHROUGH
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        if (self.walkthrough.numberOfPages - 1) == pageNumber{
            self.walkthrough.closeButton?.isHidden = false
        }else{
            self.walkthrough.closeButton?.isHidden = true
            
        }
    }
    
}


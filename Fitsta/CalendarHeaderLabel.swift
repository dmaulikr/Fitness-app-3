//
//  CalendarHeaderLabel.swift
//  Fitsta
//
//  Created by Jesse Cohen on 08/12/2016.
//  Copyright © 2016 Man Cave Interactive. All rights reserved.
//

import UIKit

class CalendarHeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.addTextSpacing(2)
    }
    
    
}

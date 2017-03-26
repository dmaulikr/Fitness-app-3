//
//  WorkoutTableCell.swift
//  Fitsta
//
//  Created by Jesse Cohen on 09/12/2016.
//  Copyright © 2016 Man Cave Interactive. All rights reserved.
//

import UIKit
import Cosmos

class WorkoutTableCell: UITableViewCell  {
    
    // Side Date time box
    @IBOutlet weak var workoutTimeStartedNumber: UILabel!
    @IBOutlet weak var workoutTimeStartedSuffix: UILabel!
    
    
    // Main row
    @IBOutlet weak var workoutMinText: UILabel!
    @IBOutlet weak var workoutTypeText: UILabel!
    @IBOutlet weak var workoutMotivationText: UILabel!
    
    @IBOutlet weak var workoutLength: UILabel!
    @IBOutlet weak var workoutType: UILabel!
    @IBOutlet weak var starRating: CosmosView!
    
}

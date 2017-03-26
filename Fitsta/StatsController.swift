//
//  StatsController.swift
//  Fitsta
//
//  Created by Jesse Cohen on 07/12/2016.
//  Copyright © 2016 Man Cave Interactive. All rights reserved.
//

import UIKit
import Cosmos
import MKUnits

class StatsController: UIViewController {
    
// MARK: - CLASS INCLUSION
    
    
// MARK: - OUTLETS
    
    @IBOutlet weak var statsTitle: UILabel!
    
    @IBOutlet weak var startDay: UILabel!
    @IBOutlet weak var startMonth: UILabel!
    
    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var currentMonth: UILabel!
    
    @IBOutlet weak var calorieCount: UILabel!
    @IBOutlet weak var weightCount: UILabel!
    @IBOutlet weak var motivationCount: CosmosView!
    @IBOutlet weak var favouriteExercise: UILabel!
    
    // Label text formatting
    @IBOutlet var labelSpacing: [UILabel]!
    @IBOutlet var outputSpacing: [UILabel]!
    
    
    
// MARK: - VARIABLES + LETS
    
    // DATE HANDLING
    let dateFormatter = DateFormatter()
    var selectedDate: Date!
    
    // USER DEFAULTS
    let user = UserDefaults.standard.object(forKey: "AppStartDate") as? String
    
    
// MARK: - APPEARING VIEWS
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Cell text spacing
        for label in labelSpacing {
            label.addTextSpacing(1.5)
        }
        // Output text spacing
        for output in outputSpacing {
            output.addTextSpacing(1)
        }
        statsTitle.addTextSpacing(2)
        startMonth.addTextSpacing(2)
        currentMonth.addTextSpacing(2)
        
        // function calls
        displayCurrentDay()
        displayCurrentMonth()
        
    
        weightCalculate()
        
    }
    
    
// MARK: - FUNCTIONS
    
    private func displayCurrentDay() {
        dateFormatter.dateFormat = "d"
        currentDay.text = dateFormatter.string(from: Date())
    }
    
    private func displayCurrentMonth() {
        dateFormatter.dateFormat = "MMM"
        currentMonth.text = dateFormatter.string(from: Date()).uppercased()
    }
    
    private func displayAppStartDay() {
        if user != nil {
            
        } else {
            print("APP: Couldn't get user defaults")
        }
    }
    
    private func displayAppStartMonth() {
        
    }
    
    private func weightCalculate() {
        if (UserDefaults.standard.object(forKey: "AppWeight") as? String) != nil {
            
            if let weightFormatOld = UserDefaults.standard.object(forKey: "AppWeightOld") as? String {
                
                let weightConverted =  1.0
                // 1kg = 2.20462lbs
                
                if weightFormatOld == "KG" {
                    let conv = weightConverted * 2.20
                    weightCount.text = "\(conv.pound())"
                } else {
                    weightCount.text = "\(weightConverted.kilogram())"
                }
                
                
            }
            
        }
        
    }
    
    
    
    
}

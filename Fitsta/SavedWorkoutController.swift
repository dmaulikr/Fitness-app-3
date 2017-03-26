//
//  SavedWorkoutController.swift
//  Fitsta
//
//  Created by Jesse Cohen on 07/12/2016.
//  Copyright © 2016 Man Cave Interactive. All rights reserved.
//

import UIKit
import Cosmos

class SavedWorkoutController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
// MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var workoutDayTitle: UILabel!
    @IBOutlet var labelSpacing: [UILabel]!
    
    // Share view
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var shareView: UIView!
    @IBOutlet weak var shareMinCount: UILabel!
    @IBOutlet weak var shareStarRating: CosmosView!
    @IBOutlet weak var shareTitle: UILabel!
    
    
    
// MARK: - VARIABLES + LETS
    
    
// MARK: - COREDATA
    
    var deleteExerciseIndexPath: NSIndexPath? = nil
    //var exerciseItems = [NSManagedObject]()
    var exerciseItems = ["1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3"]
    
    
    // MARK: - APPEARING VIEWS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Add share view to the controller
        view.addSubview(shareView)
        shareView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height:220)
        
        // Label spacing
        workoutDayTitle.addTextSpacing(2)
        shareTitle.addTextSpacing(2)
        for label in labelSpacing {
            label.addTextSpacing(1)
        }
        
    }
    
    // MARK: - TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedWorkoutCell", for: indexPath) as! SavedWorkoutTableCell
        
        
        if indexPath.row < 9 {
            cell.cellNumber.text = "0\(indexPath.row + 1)"
        } else {
            cell.cellNumber.text = "\(indexPath.row + 1)"
        }
        
        starRating.rating = 3
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
   
    
    
    
    // MARK: - FUNCTIONS
    
    func displayShareSheet() {
        self.shareMinCount.text = "39"
        self.shareStarRating.rating = 5
        
        backgroundView.isHidden = false
        shareView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0.9
            self.shareView.alpha = 1
        }, completion: { (complete: Bool) in
            
            // Share image view handling
            let renderer = UIGraphicsImageRenderer(size: self.shareView.bounds.size)
            
            let shareImage = renderer.image { ctx in
                self.shareView.drawHierarchy(in: self.shareView.bounds, afterScreenUpdates: true)
            }
            
            let activityViewController = UIActivityViewController(activityItems: [shareImage as UIImage], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
            
            activityViewController.completionWithItemsHandler = {
                (s, ok, items, error) in
                
                self.doneSharing()
                
            }
            
        })
    
    }
    
    func doneSharing() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0
            self.shareView.alpha = 0
        }, completion: { (complete: Bool) in
            self.backgroundView.isHidden = true
            self.shareView.isHidden = true
        })
    }
    
    
    
// MARK: - BUTTON ACTIONS
    
    @IBAction func shareWorkoutButton(_ sender: UIButton) {
        displayShareSheet()
    }
    
    
    
    
    
    
}

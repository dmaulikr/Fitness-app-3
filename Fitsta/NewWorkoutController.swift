//
//  NewWorkoutController.swift
//  Fitsta
//
//  Created by Jesse Cohen on 07/12/2016.
//  Copyright © 2016 Man Cave Interactive. All rights reserved.
//

import UIKit
import CoreData
import Cosmos

class NewWorkoutController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
// MARK: - OUTLETS
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var addNewExerciseView: UIView!
    @IBOutlet weak var endWorkoutView: UIView!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var addExerciseButtonOutlet: UIButton!
    
    @IBOutlet weak var exerciseName: UITextField!
    @IBOutlet weak var exerciseCount: UITextField!
    @IBOutlet weak var exerciseNumber: UILabel!
    @IBOutlet weak var exerciseSetCount: UITextField!
    
    @IBOutlet weak var workoutDayLabel: UILabel!
    @IBOutlet var labelSpacing: [UILabel]!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var weightOrCardioLabel: UILabel!
    @IBOutlet weak var cardioButtonOutlet: UIButton!
    @IBOutlet weak var weightButtonOutlet: UIButton!
    
    
    
// MARK: - CORE DATA
    var deleteExerciseIndexPath: NSIndexPath? = nil
    var exerciseItems = [NSManagedObject]()
    var workoutID = NSManagedObjectID()
    //var exerciseItems = ["1", "2"]
    
    
    // Test Data
    func testExercise() {
        
        // if exercise items == 0 then create the workout adding date now, then add the exercise and add in the reference to the workout ID
        
        // add to entity exercise under workout id?
        
        // add to exercise entity
        
        // Create the Workout Object
        let newWorkout = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: context)
        
        if exerciseItems.count == 0 {
            
            newWorkout.setValue(Date(), forKey: "time")
            
            do {
                try context.save()
                workoutID = newWorkout.objectID
                print("APP: Saved new workout")
                
            } catch {
                print("ERROR: Workout could not be saved - \(error.localizedDescription)")
            }
            
            
        }
        
        // Create new exercise item from textField inputs
        let newExercise = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: newWorkout.managedObjectContext!)
        newExercise.setValue(50, forKey: "count")
        newExercise.setValue("Lat Pull Down", forKey: "name")
        newExercise.setValue(1, forKey: "set")
        newExercise.setValue("weight", forKey: "type")
        //newExercise.setValue(newWorkout.objectID, forKey: "workoutID")
        
        do {
            try context.save()
            print("APP: Saved new exercise - \(newExercise)")
            exerciseItems.append(newExercise)
            
            
        } catch {
            print("ERROR: Exercise could not be saved - \(error.localizedDescription)")
        }
       
        tableView.reloadData()
        
    }
    
    private func getExerciseItems(_ context: NSManagedObjectContext) {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        
        request.returnsObjectsAsFaults = false
        
        do {
            
            let items = try context.fetch(request)
            
            if items.count > 0 {
                
                exerciseItems = items as! [NSManagedObject]
                self.tableView.reloadData()
                
            }
            
        } catch {
            
            createAlert("Error!", message: "Could not get list items from database")
            
        }
        
    }

    
    
    
    
    
    
// MARK: - VARIABLES + LETS
    let appColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
    let greyColor = UIColor(red: 176/255, green: 176/255, blue: 176/255, alpha: 1)

    var exerciseType = ""
    
// MARK: - APPEARING VIEWS
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundView.alpha = 0
        addNewExerciseView.alpha = 0
        endWorkoutView.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        workoutDayLabel.addTextSpacing(2)
        for label in labelSpacing {
            label.addTextSpacing(1)
        }
        
    }
    

// MARK: - BUTTON ACTIONS
    
  
    @IBAction func addNewExerciseButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.backgroundView.alpha = 0.85
            self.addNewExerciseView.alpha = 1
        }, completion: nil)
        exerciseName.becomeFirstResponder()
    
        
        // Add tap recognizer to backgroundView
//        let viewTapped = UITapGestureRecognizer(target: self, action: #selector(NewWorkoutController.backgroundViewTapped))
//        backgroundView.addGestureRecognizer(viewTapped)
        
        // Add number to exercise number
        if exerciseItems.count < 10 {
            exerciseNumber.text = "0\(exerciseItems.count + 1)"
        } else {
            exerciseNumber.text = "\(exerciseItems.count + 1)"
        }
        
    }
    
    @IBAction func cancelNewExerciseButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.backgroundView.alpha = 0
            self.addNewExerciseView.alpha = 0
        }, completion: nil)
        exerciseName.resignFirstResponder()
    }
    
    @IBAction func addExerciseToDatabase(_ sender: UIButton) {
        // TODO: - ADD EXERCISE 
        print("APP: Add exercise clicked")
        testExercise()
        
        let whitespaceSet = NSCharacterSet.whitespaces
        
        if exerciseName.text! == "" || exerciseName.text == " " || (exerciseName.text?.trimmingCharacters(in: whitespaceSet).isEmpty)! {
            
            createAlert("Empty Exercise!", message: "Please enter an exercise.")
            
        } else {
            
            if exerciseType == "" {
                createAlert("Empty Type", message: "Choose either Cardio or Weight.")
            } else if (exerciseSetCount.text == "") {
                createAlert("Empty Sets", message: "Please enter a set amount")
            } else if (exerciseCount.text == "") {
                createAlert("Empty amount", message: "Please enter a weight or cardio amount.")
            } else {
                
                // Validation successful, proceed with storing of data
                
                // Trim the text for whitespaces
                let trimmedExerciseTitle = exerciseName.text?.trimmingCharacters(in: whitespaceSet)
                
                let workoutID = 1
                
                // Get the other text fields
                saveWorkoutToCoreData(exerciseName: trimmedExerciseTitle!, exerciseType: exerciseType, exerciseSets: exerciseSetCount.text!, exerciseCount: exerciseCount.text!, workoutID: workoutID)
                
                // Create the entity inside the database
                
            }
            
        }
        
    }
    
    @IBAction func endWorkoutButton(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0.85
            self.addNewExerciseView.alpha = 0
            self.endWorkoutView.alpha = 1
        }, completion: nil)
        closeKeyboard()
    }
    
    @IBAction func cancelWorkoutComplete(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.endWorkoutView.alpha = 0
            self.backgroundView.alpha = 0
        }, completion: nil)
        
    }
    
    @IBAction func workoutCompleteButton(_ sender: UIButton) {
        //saveWorkoutToCoreData()
        print("APP: Complete Tapped")
    }
    
    
    // Handle exercise type selection
    @IBAction func cardioExerciseSelected(_ sender: UIButton) {
        sender.setTitleColor(appColor, for: .normal)
        weightButtonOutlet.setTitleColor(greyColor, for: .normal)
        weightOrCardioLabel.text = "MINS"
        exerciseType = "CARDIO"
        print("APP: \(exerciseType) exercise selected")
    }
    
    @IBAction func weightExerciseSelected(_ sender: UIButton) {
        sender.setTitleColor(appColor, for: .normal)
        cardioButtonOutlet.setTitleColor(greyColor, for: .normal)
        weightOrCardioLabel.text = "WEIGHT"
        exerciseType = "WEIGHT"
        print("APP: \(exerciseType) exercise selected")
    }
    

    

// MARK: - FUNCTIONS
    
    private func createAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Save workout to coreData
    func saveWorkoutToCoreData(exerciseName: String, exerciseType: String, exerciseSets: String, exerciseCount: String, workoutID: Int) {
        //TODO: - SAVE TO CORE DATA FUNCTION
    }
    
    func backgroundViewTapped(sender: UITapGestureRecognizer) {
        closeKeyboard()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        closeKeyboard()
//        
//    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.addNewExerciseView.alpha = 0
        }, completion: nil)
    }
    
    func confirmDelete(id: NSManagedObject) {
        let alert = UIAlertController(title: "Delete Workout", message: "Are you sure you want to permanently delete this workout?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteWorkout)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteWorkout)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.height / 2)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteWorkout(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteExerciseIndexPath {
            tableView.beginUpdates()
            
            exerciseItems.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            
            deleteExerciseIndexPath = nil
            
            // Delete from coreData
            tableView.reloadData()
            
            tableView.endUpdates()
            
        }
    }
    
    func cancelDeleteWorkout(alertAction: UIAlertAction!) {
        deleteExerciseIndexPath = nil
    }

    
    
// MARK: - TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if exerciseItems.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No exercises added"
            emptyLabel.textColor = UIColor.white
            emptyLabel.font = UIFont(name: "Avenir-Book", size: 14)
            emptyLabel.addTextSpacing(1)
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            // NEED TO TEST THIS FIRST THING
            navigationItem.rightBarButtonItem?.isEnabled = false
            return 0
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            return exerciseItems.count
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newWorkoutCell", for: indexPath) as! NewWorkoutTableViewCell
        if indexPath.row < 9 {
          cell.cellCount.text = "0\(indexPath.row + 1)"
        } else {
            cell.cellCount.text = "\(indexPath.row + 1)"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            self.deleteExerciseIndexPath = indexPath as NSIndexPath?
            let exerciseToDelete = self.exerciseItems[indexPath.row]
            self.confirmDelete(id: exerciseToDelete)
            
            print("APP: Swipe to delete workout - \(exerciseToDelete)")
            
            
        }
        delete.backgroundColor = UIColor(patternImage: UIImage(named: "Delete-Button")!)
        
        return [delete]
    }

    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        addExerciseButtonOutlet.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.addExerciseButtonOutlet.alpha = 0.3
        }, completion: nil)
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        addExerciseButtonOutlet.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.addExerciseButtonOutlet.alpha = 1
        }, completion: nil)
    }
    
    
    
}

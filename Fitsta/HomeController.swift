//
//  HomeController.swift
//  Fitsta
//
//  Created by Jesse Cohen on 06/12/2016.
//  Copyright © 2016 Man Cave Interactive. All rights reserved.
//

// TODO: - Link calendar view to table view
// TODO: - v1.2  - Get User settings color

// TODO: - CoreData - create test data object 
// TODO: - CoreData - create add exercise function
// TODO: - Empty table view on iphone 5

// TODO: - WorkOutItems is 42 and incrementing by 1 each date selection

import UIKit
import JTAppleCalendar
import BWWalkthrough
import Cosmos
import CoreData

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate, BWWalkthroughViewControllerDelegate {

// MARK: - OUTLETS
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    @IBOutlet var calendarDayLabels: [UILabel]!
    @IBOutlet var buttonLabels: [UIButton]!
    @IBOutlet weak var statsLabel: UIBarButtonItem!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var settingsView: UIView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var lbsButtonOutlet: UIButton!
    @IBOutlet weak var kgButtonOutlet: UIButton!
    
    
// MARK: - VARIABLES + LETS
    
    // APP FIRST RUN
    var calendarStartDate: String!
    var walkthrough:BWWalkthroughViewController!
    
    let white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    let grey = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
    let SelectedBlue  = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
    let calendarBackground = UIColor(red: 14/255, green: 14/255, blue: 14/255, alpha: 1)
    let cellBackground = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1)
    let cellBackgroundAlternate = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
    
    
    // DATE HANDLING
    let dateFormatter = DateFormatter()
    var selectedDate: Date!
    
    // TABLE VIEW
    @IBOutlet weak var tableView: UITableView!
    

// MARK: - CORE DATA
    var deleteWorkoutIndexPath: NSIndexPath? = nil
    var workOutItems = [Workout]()
    
    let workout = Workout(context: context)
    
    func deleteAllData(entity: String)
    {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
    }
    
    
    private func getWorkouts(date: Date!) {
        // Get the workout for the selected date and populate workout items 
        do {
            
            let result = try context.fetch(Workout.fetchRequest())
            
            let workouts = result as! [Workout]
            
            
            print("Workout Count: \(workouts.count)")
            //print(workouts)
            
            if workouts.count > 0 {
                
                for workout in workouts {
                    
                    workOutItems.removeAll()
                    
                    if date != nil {
                        // Filter the array
                       // print("Date selected")
                    } else {
                        // show current day workouts
                        
                        workOutItems.append(workout)
                    }
                    
                }
                
            } else {
                print("APP: No workouts for this day")
            }
            
        } catch  {
            print("APP: Couldn't get any workouts")
        }
    }
    


// MARK: - APPEARING VIEWS
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for button in buttonLabels {
            button.addTextSpacing(1.7)
        }
        settingsLabel.addTextSpacing(1)
        settingsView.alpha = 0
        backgroundView.alpha = 0
        backgroundView.isHidden = true
        
        if DeviceType.IS_IPHONE_5 {
            calendarViewHeight.constant = 310
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        if UserDefaults.standard.object(forKey: "walkthroughComplete") as? Bool != false {
            self.presentWalkthrough()
        }
        view.addSubview(settingsView)
       
        
        // Set initial conversion weight
        if let weightFormatSet = UserDefaults.standard.object(forKey: "AppWeight") as? String {
            print("APP: \(weightFormatSet) App weight stored")
            if weightFormatSet == "KG" {
                kgButtonOutlet.backgroundColor = calendarBackground
                kgButtonOutlet.setTitleColor(white, for: .normal)
                lbsButtonOutlet.backgroundColor = white
                lbsButtonOutlet.setTitleColor(calendarBackground, for: .normal)
            } else {
                kgButtonOutlet.backgroundColor = white
                kgButtonOutlet.setTitleColor(calendarBackground, for: .normal)
                lbsButtonOutlet.backgroundColor = calendarBackground
                lbsButtonOutlet.setTitleColor(white, for: .normal)
            }
        } else {
            UserDefaults.standard.set("KG", forKey: "AppWeight")
            UserDefaults.standard.set("LBS", forKey: "AppWeightOld")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialiser functions
        calendarInit()
        
        print(workOutItems.count)
        
        //workoutInit(date: nil)
        
        // Remove navigation controller shadow
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Background view tap gesture to close the settings view
        let viewTapped = UITapGestureRecognizer(target: self, action: #selector(HomeController.backgroundViewTapped))
        backgroundView.addGestureRecognizer(viewTapped)
        
    }
    
    func backgroundViewTapped(gesture:UIGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.settingsView.alpha = 0
            self.backgroundView.alpha = 0
        }, completion: { (complete: Bool) in
            self.backgroundView.isHidden = true
        })
    }
    
    
// MARK: - BUTTON ACTIONS
    @IBAction func next(_ sender: UIButton) {
        self.calendarView.scrollToSegment(.next)
    }
    
    @IBAction func previous(_ sender: UIButton) {
        self.calendarView.scrollToSegment(.previous)
    }
    
    
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
        print("APP: Settings button tapped")
        backgroundView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0.85
            self.settingsView.alpha = 1
        }, completion: nil)
    
    }
    
    
    @IBAction func lbsButton(_ sender: UIButton) {
        print("APP: lbs button tapped")
        UserDefaults.standard.set("LBS", forKey: "AppWeight")
        UserDefaults.standard.set("KG", forKey: "AppWeightOld")
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0
            self.settingsView.alpha = 0
        }, completion: { (complete: Bool) in
            self.hideBackground()
            return
        })
        lbsButtonOutlet.backgroundColor = calendarBackground
        lbsButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        kgButtonOutlet.backgroundColor = UIColor.clear
        kgButtonOutlet.setTitleColor(calendarBackground, for: .normal)
        
    }
    
    
    @IBAction func kgButton(_ sender: UIButton) {
        print("APP: KG button tapped")
        UserDefaults.standard.set("KG", forKey: "AppWeight")
        UserDefaults.standard.set("LBS", forKey: "AppWeightOld")
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0
            self.settingsView.alpha = 0
        }, completion: { (complete: Bool) in
            self.hideBackground()
            return
        })
        kgButtonOutlet.backgroundColor = calendarBackground
        kgButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        lbsButtonOutlet.backgroundColor = UIColor.clear
        lbsButtonOutlet.setTitleColor(calendarBackground, for: .normal)
    }
    
    
    
 

    
// MARK: - FUNCTIONS
    
    func hideBackground() {
        backgroundView.isHidden = true
    }
    
    @IBAction func presentWalkthrough() {
        
        print("APP: Walkthrough called")
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        walkthrough = stb.instantiateViewController(withIdentifier: "walkthroughContainer") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewController(withIdentifier: "Page1")
        let page_two = stb.instantiateViewController(withIdentifier: "Page2")
        let page_three = stb.instantiateViewController(withIdentifier: "Page3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController: page_one)
        walkthrough.add(viewController: page_two)
        walkthrough.add(viewController: page_three)
        
        self.present(walkthrough, animated: true) {
            ()->() in
            UserDefaults.standard.set(false, forKey: "walkthroughComplete")
        }
        
    }
    
    
    func confirmDelete(id: Workout) {
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
        if let indexPath = deleteWorkoutIndexPath {
            tableView.beginUpdates()
            
            workOutItems.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            
            deleteWorkoutIndexPath = nil
            
            // Delete from coreData
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteWorkout(alertAction: UIAlertAction!) {
        deleteWorkoutIndexPath = nil
    }
    

    
// MARK: - CALENDAR
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        if let AppStartDate = UserDefaults.standard.object(forKey: "AppStartDate") as? String {
            calendarStartDate = AppStartDate
            
        } else {
            dateFormatter.dateFormat = "yyyy MM dd"
            let currentDateString = dateFormatter.string(from: Date())
            calendarStartDate = currentDateString
            UserDefaults.standard.set(calendarStartDate, forKey: "AppStartDate")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: calendarStartDate)!
        let endDate = formatter.date(from: "2020 01 01")!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .monday)
        return parameters
    }

    
    func calendarInit() {
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.registerCellViewXib(file: "CalendarCellView")
        calendarView.cellInset = CGPoint(x: 1, y: 1)
        calendarView.backgroundColor = UIColor(red: 14/255, green: 14/255, blue: 14/255, alpha: 1)
        
        // Calendar header view
        calendarView.registerHeaderView(xibFileNames: ["CalendarHeaderView"])
        
        // Calendar Day Labels
        for label in self.calendarDayLabels {
            label.addTextSpacing(1)
        }
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let calendarCell = cell as! CalendarCell
        
        
        // Setup Cell text
        calendarCell.dayLabel.text = cellState.text
        
        handleCellTextColor(cell, cellState: cellState)
        handleCellSelection(cell, cellState: cellState)
        
        // Deselectable previous and next months cells
        if cellState.dateBelongsTo == .thisMonth {
            calendarCell.isUserInteractionEnabled = true
            
        } else {
            calendarCell.isUserInteractionEnabled = false
        }
        
        // Highlight current date
        dateFormatter.dateFormat = "yyyy MM dd"
        let currentDateString = dateFormatter.string(from: Date())
        let cellStateDateString = dateFormatter.string(from: cellState.date)
        
        if currentDateString == cellStateDateString {
            calendarCell.dayLabel.textColor = SelectedBlue
        } else {
            calendarCell.dayLabel.textColor = white
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(cell, cellState: cellState)
        handleCellTextColor(cell, cellState: cellState)
        
        // Gets the workouts by the selected date
        selectedDate = date
        getWorkouts(date: date)

        // Update the tableView
        tableView.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(cell, cellState: cellState)
        handleCellTextColor(cell, cellState: cellState)
        
    }
    
    func handleCellTextColor(_ view: JTAppleDayCellView?, cellState: CellState) {
        
        guard let cell = view as? CalendarCell else {
            return
        }
        
        if cellState.isSelected {
            dateFormatter.dateFormat = "yyyy MM dd"
            let currentDateString = dateFormatter.string(from: Date())
            let cellStateDateString = dateFormatter.string(from: cellState.date)
            
            if currentDateString == cellStateDateString {
                cell.dayLabel.textColor = SelectedBlue
            } else {
                cell.dayLabel.textColor = white
            }

        } else {
            if cellState.dateBelongsTo == .thisMonth {
                dateFormatter.dateFormat = "yyyy MM dd"
                let currentDateString = dateFormatter.string(from: Date())
                let cellStateDateString = dateFormatter.string(from: cellState.date)
                
                if currentDateString == cellStateDateString {
                    cell.dayLabel.textColor = SelectedBlue
                } else {
                    cell.dayLabel.textColor = white
                }

                cell.backgroundColor = cellBackground
            } else {
                cell.dayLabel.textColor = grey
                cell.backgroundColor = cellBackgroundAlternate
            }
        }
        
        
    }
    
    func handleCellSelection(_ view: JTAppleDayCellView?, cellState: CellState) {
        guard let selectedCell = view as? CalendarCell  else {
            return
        }
        if cellState.isSelected {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                selectedCell.selectedView.alpha = 1
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                selectedCell.selectedView.alpha = 0
            }, completion: nil)
            
        }

    }
    
    // Calendar header view setup
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 59)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        let startDate = range.start
        let month = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        let year = Calendar.current.component(.year, from: startDate)
        let headerCell = header as? CalendarHeaderView
        headerCell?.monthTitle.text = monthName.uppercased()
        headerCell?.monthTitle.addTextSpacing(2)
        headerCell?.yearTitle.text = "\(year)"
        headerCell?.yearTitle.addTextSpacing(1.5)
    }
    
    
    private func workoutInit(date: Date!) {
        // May throw an error if date is not set
        getWorkouts(date: date)
    
    }
    
    
// MARK: - TABLE VIEW

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if workOutItems.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No workouts added"
            emptyLabel.textColor = UIColor.white
            emptyLabel.font = UIFont(name: "Avenir-Book", size: 14)
            emptyLabel.addTextSpacing(1)
            emptyLabel.textAlignment = NSTextAlignment.center
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        } else {
            print("WORKOUTS JESSE: \(workOutItems.count)")
            return workOutItems.count
            
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! WorkoutTableCell
        
        cell.starRating.rating = 2
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
         
            self.deleteWorkoutIndexPath = indexPath as NSIndexPath?
            let workoutToDelete = self.workOutItems[indexPath.row]
            self.confirmDelete(id: workoutToDelete)
            
            print("APP: Swipe to delete workout")

            
        }
        delete.backgroundColor = UIColor(patternImage: UIImage(named: "Delete-Button")!)
        
        return [delete]
    }
    
    
    
// MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backImage = UIImage(named: "Back-Icon")
        
        let navCon = self.navigationController?.navigationBar
        navCon?.backIndicatorImage = backImage
        navCon?.backIndicatorTransitionMaskImage = backImage
        navCon?.tintColor = UIColor.white
        
        /*** If needed Assign Title Here ***/
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
    }
    
    

}






//
//  LogDataViewController.swift
//  Printing-Log-3D
//
//  Created by XCodeClub on 2021-09-03.
//

import UIKit
import Firebase

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    // TODO: Change the dateFormatter to DD/MM/YYYY
    // TODO: Change the timeFormatter to HH:MM:SS
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
//    dateFormatter.dateFormat = "MMM dd yyyy hh:mm a" // remove hh:mm a if using day only
    return dateFormatter
}()

class LogDataViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    var logs: Logs!
    var log: Log!
    //var setting: Setting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logs = Logs()
        if log == nil {
            log = Log()
        }
        tableView.delegate = self
        tableView.dataSource = self
        configSegmentedControl()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logs.loadData {
            self.sortBasedOnSegmentPressed() // data is sorted before the view appears
            self.tableView.reloadData()
        }
    }
   
    func configSegmentedControl() {
        // set font colors for segmentedControl
        let orangeFontColor = [NSAttributedString.Key.foregroundColor: UIColor(named: "PrimaryColor") ?? UIColor.orange]
        let whiteFontColor = [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColor") ?? UIColor.white]
        sortSegmentedControl.setTitleTextAttributes(orangeFontColor, for: .selected)
        sortSegmentedControl.setTitleTextAttributes(whiteFontColor, for: .normal)
        // add white border to segmentedControl
        sortSegmentedControl.layer.borderColor = UIColor.white.cgColor
        sortSegmentedControl.layer.borderWidth = 1.0
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! LogDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.log = logs.logArray[selectedIndexPath.row]
            //destination.settings = setting[selectedIndexPath.row]
        }
    }
    func sortBasedOnSegmentPressed() {
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0:
            logs.logArray.sort(by: {$0.modelName < $1.modelName})
        case 1:
            // TODO: Make sure dates are added and shown properly on both ViewControllers
            logs.logArray.sort(by: {$0.date < $1.date})
            print("Sorting by date")
        case 2:
            // TODO: need to add code to sort by printer name
            logs.logArray.sort(by: {$0.printerName < $1.printerName})
            print("Sorting by printer name...")
        default:
            print("Hey! You should have reached this point. Check the segmented control for an error.")
        }
        tableView.reloadData()
    }

    @IBAction func sortSegmentControlPressed(_ sender: UISegmentedControl) {
        //TODO: Add some functionality to allow the text in the segmented control to sort by specific filament type: ex. PETG
        // sender.setTitle(<#T##title: String?##String?#>, forSegmentAt: <#T##Int#>)
        sortBasedOnSegmentPressed()
    }
}

extension LogDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.logArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LogDataTableViewCell
        cell.modelLabel!.text = logs.logArray[indexPath.row].modelName
        cell.printerLabel!.text = logs.logArray[indexPath.row].printerName
        cell.datePrinted!.text = dateFormatter.string(from: logs.logArray[indexPath.row].date)
        print("Date Label: \(cell.datePrinted.text!)")
        return cell
    }
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        } // end of else statement
    }
    // TODO: Need to add code to remove data when delete is pressed after "Edit"
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedIndexPath = self.tableView.indexPathForSelectedRow!
            //            logs.logArray.remove(at: selectedIndexPath.row)
            
            print("Current documentID location: (logs.logArray[indexPath.row].documentID)")
//            logs.deleteData(log: logs) { (success) in
//                if success {
//                    if tableView.isEditing {
//                        tableView.setEditing(true, animated: true)
//                        self.editBarButton.title = "Edit"
//                        self.addBarButton.isEnabled = true
//                    } else {
//                        tableView.setEditing(false, animated: true)
//                        self.editBarButton.title = "Done"
//                        self.addBarButton.isEnabled = false
//                    }
//                }
//            }
            
            print("Data at \(selectedIndexPath.row) has been deleted")
            tableView.reloadData()
            print("ViewController at indexPath \(selectedIndexPath.row) set to delete mode")
        } else {
            print("ERROR: Unsuccessful Deleting Data")
        }
    }
    

        //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //        let swipeConfig = UISwipeActionsConfiguration()
        //        swipeConfig.actions.
            
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
//    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//        <#code#>
//    }
}

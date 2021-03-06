//
//  LogDataViewController.swift
//  Printing-Log-3D
//
//  Created by Rich St.Onge on 2021-09-03.
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
extension UIWindow {
    static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isLandscape ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
}


class LogDataViewController: UIViewController, UIToolbarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    var logs: Logs!
    var log: Log!
    var selection: Bool!
    var selectedIndexPath: Int?
    var notifyOnce = false
    
    var hideStatusBar: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
//    let statusBarBackgroundColor = UIColor(named: "PrimaryColor")
//    self.view.layer.backgroundColor = statusBarBackgroundColor.cgColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Printing Frame Height: \(self.view.layer.frame.height)")
        self.navigationController?.toolbar.backgroundColor = UIColor(named: "PrimaryColor") ?? UIColor.orange
        
        logs = Logs()
//        overrideUserInterfaceStyle
        //let tableSwipe = UIContextualAction(style: <#T##UIContextualAction.Style#>, title: <#T##String?#>, handler: <#T##UIContextualAction.Handler##UIContextualAction.Handler##(UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void#>)
        // = false
        if log == nil {
            log = Log()
        }
        tableView.delegate = self
        tableView.dataSource = self
        configSegmentedControl()
    }
    //TODO: Use this code to make the nav bar clear self.navigationController.navigationBar.translucent = YES
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let frameHeight = self.view.layer.frame.height
        let frameWidth = self.view.layer.frame.width
        let portraitMode: Bool
        if frameHeight < frameWidth {
            print("We are in Portrait Mode!!!!")
            portraitMode = true
        } else {
            print("We are in Landscape Mode!!!!")
            portraitMode = false
        }
        if portraitMode {
            self.navigationController?.setStatusBar(backgroundColor: UIColor(named: "PrimaryColor") ?? UIColor.orange)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "3D Printing Log"
        logs.loadData {
            self.sortBasedOnSegmentPressed() // data is sorted before the view appears
            self.tableView.reloadData()
        }
    }
    func deleteData() {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("???? ERROR: Could not save data because we don't have a valid postingUserID")
            return
        }
        
        print("log documentID contents before modification: \(self.logs.logArray[selectedIndexPath!].documentID)")
        // if we have saved a record, we'll have an ID otherwise .addDocument will create one
        if logs.logArray[selectedIndexPath!].documentID != nil { // need to create a new document if it doesn't exist
            var ref: DocumentReference? = nil
            db.collection("Log").document(postingUserID).collection("Log").document(logs.logArray[selectedIndexPath!].documentID).delete()
            
            print("Deleted document \(self.logs.logArray[self.selectedIndexPath!].documentID)") // it worked
            //print("Comparing ref.documentID \(ref!.documentID) to self.documentID \(self.logs.logArray[selectedIndexPath!].documentID)")
            
        } else { // handle error in documentID here
            print("???? ERROR: Don't have a valid documentID and cannot delete")
            
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
        self.tableView.reloadData()
    }

    @IBAction func sortSegmentControlPressed(_ sender: UISegmentedControl) {
        //TODO: Add some functionality to allow the text in the segmented control to sort by specific filament type: ex. PETG
        // sender.setTitle(<#T##title: String?##String?#>, forSegmentAt: <#T##Int#>)
        sortBasedOnSegmentPressed()
    }
}

extension LogDataViewController: UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.logArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LogDataTableViewCell
        cell.modelLabel!.text = logs.logArray[indexPath.row].modelName
        cell.printerLabel!.text = logs.logArray[indexPath.row].printerName
        cell.datePrinted!.text = dateFormatter.string(from: logs.logArray[indexPath.row].date)
//        print("Date Label: \(cell.datePrinted.text!)")
        return cell
    }
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            print("Currently in Edit Mode")
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            print("Currently NOT in Edit Mode")
            if notifyOnce == false {
            self.oneButtonAlert(title: "Delete Confirmation", message: "Are you sure that you want to delete your data? ????????????WARNING????????????: Data cannot be recovered!!!")
                notifyOnce = true
            }
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        } // end of else statement
    }
// TODO: Need to use escaping completion to send result back to function

    //TODO: Remove extra arguments in oneButtonAction
    //TODO: Issue warning when entering <<<EDIT MODE>>>
    
//    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
//        // TODO: Deselect rows
//        if oneButtonAction(title: "Delete Confirmation", message: "Are you sure that you want to delete your data? ????WARNING????: Data cannot be recovered!!!") {
//            selection = true
//        } else {
//           selection = false
//        }
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
    // TODO: Need to add code to remove data when delete is pressed after "Edit"
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            self.selectedIndexPath = indexPath.row
            self.deleteData()
            tableView.reloadData()
                print("Data has been deleted ????????????")
             //            }
        } else {
            print("ERROR: Unsuccessful Deleting Data")
        }
    }
    
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
//    func tableView.separatorColor = .systemBlue
//    func tableView.separatorStyle = .singleLine
//    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//        <#code#>
//    }
}

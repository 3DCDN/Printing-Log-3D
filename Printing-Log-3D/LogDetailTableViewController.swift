//
//  LogDetailTableViewController.swift
//  Printing-Log-3D
//
//  Created by Rich St.Onge on 2021-09-06.
//

import UIKit
// may need to move this to a separate class
private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    // TODO: Change the dateFormatter to DD/MM/YYYY
    // TODO: Change the timeFormatter to HH:MM:SS
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
//    dateFormatter.dateFormat = "MMM dd yyyy hh:mm a" // remove hh:mm a if using day only
    return dateFormatter
}()

class LogDetailTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var printerNameTextField: UITextField!
    @IBOutlet weak var datePrintedLabel: UILabel!
    @IBOutlet weak var datePickerSelection: UIDatePicker!
    @IBOutlet weak var hotEndTempTextField: UITextField!
    @IBOutlet weak var bedTempTextField: UITextField!
    @IBOutlet weak var retractionTextField: UITextField!
    @IBOutlet weak var layerHeightTextField: UITextField!
    @IBOutlet weak var printSpeedTextField: UITextField!
    @IBOutlet weak var fillDensityTextField: UITextField!
    @IBOutlet weak var wallThicknessTextField: UITextField!
    @IBOutlet weak var filamentType: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var switchSet: UISwitch!
    
    var log: Log!
    var notifyOnce = false
    
    let datePickerIndexPath = IndexPath(row: 1, section: 2)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 4)
    //TODO: how to set range to settings value??
    let settingsViewIndexPath = IndexPath(row: 0, section: 4)
    let notesRowHeight: CGFloat = 200
    let defaultRowHeight: CGFloat = 44
    let datePickerHeight: CGFloat = 80
    let settingsViewHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.setStatusBar(backgroundColor: UIColor(named: "PrimaryColor") ?? UIColor.orange)
//        self.navigationController?.toolbar.backgroundColor = UIColor(named: "PrimaryColor") ?? UIColor.orange
        self.navigationItem.title = "Add Parameters"
        tableView.delegate = self
        tableView.dataSource = self
        setupTextFieldDelegates()
        let tap = UIGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        if log == nil {
            log = Log()
        }
        updateUserInterface()
    }
    func setupTextFieldDelegates() {
        modelTextField.delegate = self
        printerNameTextField.delegate = self
        hotEndTempTextField.delegate = self
        bedTempTextField.delegate = self
        retractionTextField.delegate = self
        layerHeightTextField.delegate = self
        printSpeedTextField.delegate = self
        fillDensityTextField.delegate = self
        wallThicknessTextField.delegate = self
        filamentType.delegate = self
        notesTextView.delegate = self
    }
    func updateUserInterface() {
        modelTextField.text = log.modelName
        printerNameTextField.text = log.printerName
//        // TODO: Add a DateFormatter so that the date can be displayed accordingly
//        // Convert date interval number to a printable string may not just be the date formatted to suit
        datePrintedLabel.text = "Date Printed: \(dateFormatter.string(from: log?.date ?? Date()))"
        datePickerSelection.date = log?.date ?? Date()
        hotEndTempTextField.text = String(log.hotEndTemp)
        print("The Bed Temp after updateUserInterface is: \(log.bedTemp)")
        bedTempTextField.text = String(log.bedTemp)
        retractionTextField.text = String(log.retraction)
        layerHeightTextField.text = String(log.layerHeight)
        printSpeedTextField.text = String(log.printSpeed)
        fillDensityTextField.text = String(log.fillDensity)
        wallThicknessTextField.text = String(log.wallThickness)
        filamentType.text = log.filamentType
        notesTextView.text = log.notes
        switchSet.isOn = log.completed
    }
    func updateFromUserInterface() {
        log.modelName = modelTextField.text!
        log.printerName = printerNameTextField.text!
        // TODO: get date from UIDatePicker change datePrintedLabel
        // ADD didSet to equation
        // removed: log.date = dateFormatter.date(from: datePrintedLabel.text!) ?? Date()
        log.date = datePickerSelection.date
        log.notes = notesTextView.text
        log.filamentType = filamentType?.text ?? "PLA"
        log.hotEndTemp = (Int(hotEndTempTextField.text!) ?? 0)
        log.bedTemp = Int(bedTempTextField.text!) ?? 0
        log.retraction = Float(retractionTextField.text ?? "0.0")!
        log.layerHeight = Float(layerHeightTextField.text ?? "0.0")!
        log.printSpeed = Int(printSpeedTextField.text ?? "0")!
        log.fillDensity = Int(fillDensityTextField.text ?? "0")!
        log.wallThickness = Float(wallThicknessTextField.text ?? "0")!
        log.completed = switchSet?.isOn ?? false
    }

    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func modelNameChanged(_ sender: UITextField) {
        let noSpacews = modelTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                if noSpacews != "" {
                    saveBarButton.isEnabled = true
                } else {
                    if notifyOnce == false {
                        self.oneButtonAlert(title: "Model Name Empty", message: "The model name needs to filled in order to save")
                        notifyOnce = true
                    }
                    saveBarButton.isEnabled = false
                }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        // TODO: Need to add warning if trying to save with log.filamentType == nil
 
        log.saveData { (success) in
            if success {
                print("Log Data has been saved")
                print("Log documentID: \(self.log.documentID)")
                self.leaveViewController() // cannot leave controller when all data is saved
            } else {
                self.oneButtonAlert(title: "Save Log Failed", message: "For some reason, the log data would not save to the cloud")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        datePrintedLabel?.text = dateFormatter.string(from: sender.date)
        log.date = sender.date // update date anytime it changes
    }
}

extension LogDetailTableViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Not Used: self.view.becomeFirstResponder()
        // Line 1: noteView.becomeFirstResponder()
        // check if tag > 9 if so then resign
        switch textField {
        case modelTextField:
            printerNameTextField.becomeFirstResponder()
        case printerNameTextField:
            hotEndTempTextField.becomeFirstResponder()
        case hotEndTempTextField:
            bedTempTextField?.becomeFirstResponder()
        case bedTempTextField:
            retractionTextField?.becomeFirstResponder()
        case retractionTextField:
            layerHeightTextField?.becomeFirstResponder()
        case layerHeightTextField:
            printSpeedTextField?.becomeFirstResponder()
        case printSpeedTextField:
            fillDensityTextField?.becomeFirstResponder()
        case fillDensityTextField:
            wallThicknessTextField?.becomeFirstResponder()
        case wallThicknessTextField:
            filamentType.becomeFirstResponder()
        case filamentType:
            notesTextView.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        let nextTag = textField.tag + 1
        textField.returnKeyType = (nextTag < 10) ? .next : .default
//        print("Current textField tag: \(textField.tag)")
//        print("TextField returntype is:\(textField.returnKeyType)")
        if let nextResponder = textField.superview?.viewWithTag(nextTag) as? UITextField {
            nextResponder.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
            
        }
        // originally return true
        return false
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return datePickerHeight
        case notesTextViewIndexPath:
            return notesRowHeight  // height set to 200
        case settingsViewIndexPath:
            return settingsViewHeight
        default:
            return defaultRowHeight // default height set to 44
        }
    }

}

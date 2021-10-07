//
//  Log.swift
//  Printing-Log-3D
//
//  Created by Rich St.Onge on 2021-09-08.
//

import UIKit
import Firebase

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    // TODO: Change the dateFormatter to DD/MM/YYYY
    // TODO: Change the timeFormatter to HH:MM:SS
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
//    dateFormatter.dateFormat = "MMM dd yyyy hh:mm a" // remove hh:mm a if using day only
    return dateFormatter
}()

class Log {
    var modelName: String
    var date: Date
    var notes: String
    var printerName: String
    var filamentType: String // starting from here
    var hotEndTemp: Int
    var bedTemp: Int
    var layerHeight: Float
    var retraction: Float
    var fillDensity: Int
    var printSpeed: Int
    var wallThickness: Float
    var completed: Bool
    var documentID: String
    
    // will not see any data initially if changing the construct until new data is saved
    // dictionary does not store any values but matches the data types to keys
    // dictionary used when saving data
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return["modelName": modelName, "date": timeIntervalDate, "notes": notes, "printerName": printerName, "filamentType": filamentType, "hotEndTemp": hotEndTemp, "bedTemp": bedTemp, "layerHeight": layerHeight, "retraction": retraction, "fillDensity": fillDensity, "printSpeed": printSpeed, "wallThickness": wallThickness, "completed": completed]
    }
    
    init(modelName: String, date: Date, notes: String, printerName: String, filamentType: String, hotEndTemp: Int, bedTemp: Int, layerHeight: Float, retraction: Float, fillDensity: Int, printSpeed: Int, wallThickness: Float, completed: Bool, documentID: String) {
        self.modelName = modelName
        self.date = date
        self.notes = notes
        self.printerName = printerName
        self.filamentType = filamentType
        self.hotEndTemp = hotEndTemp
        self.bedTemp = bedTemp
        self.layerHeight = layerHeight
        self.retraction = retraction
        self.fillDensity = fillDensity
        self.printSpeed = printSpeed
        self.wallThickness = wallThickness
        self.completed = completed
        //self.postingUserID = postingUserID
        self.documentID = documentID
    }
    // create default values for all the variables when Log is nil or has no values (i.e. initialize the array)
    convenience init() {
        // let postingUserID = Auth.auth().currentUser?.uid ?? ""
        self.init(modelName: "", date: Date(), notes: "", printerName: "", filamentType: "PLA", hotEndTemp: 0, bedTemp: 0, layerHeight: 0.0, retraction: 0.0, fillDensity: 20, printSpeed: 0, wallThickness: 0.0, completed: true, documentID: "")
    }
    // used when loading data into the array
    // convert dictionary key value pairs into values for variables in the array.
    convenience init(dictionary: [String: Any]) {
        // dictionary key is String and Key value is Any i.e. could be Int, Double, etc. and needs to be defined (downcast)
        let modelName = dictionary["modelName"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval() // date is stored as TimeIntervalSince1970
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let notes = dictionary["notes"] as! String? ?? ""
        //let reminderSet = dictionary["reminderSet"] as! Bool? ?? false
        let printerName = dictionary["printerName"] as! String? ?? ""
        let filamentType = dictionary["filamentType"] as! String? ?? "PLA"
        let hotEndTemp = dictionary["hotEndTemp"] as! Int? ?? 0
        let bedTemp = dictionary["bedTemp"] as! Int? ?? 0
        let layerHeight = dictionary["layerHeight"] as! Float? ?? 0.0
        let retraction = dictionary["retraction"] as! Float? ?? 0.0
        let fillDensity = dictionary["fillDensity"] as! Int? ?? 0
        let printSpeed = dictionary["printSpeed"] as! Int? ?? 0
        let wallThickness = dictionary["wallThickness"] as! Float? ?? 0.0
        let completed = dictionary["completed"] as! Bool? ?? true
        // let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        // Not Used: let documentID = dictionary["documentID"] as! String? ?? ""
        
        self.init(modelName: modelName, date: date, notes: notes, printerName: printerName, filamentType: filamentType, hotEndTemp: hotEndTemp, bedTemp: bedTemp, layerHeight: layerHeight, retraction: retraction, fillDensity: fillDensity, printSpeed: printSpeed, wallThickness: wallThickness, completed: completed, documentID: "")
        // documentID is not saved as part of the dictionary which is why it is left as empty string
    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
    
        // Grab the user ID
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("😡 ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        // NOTE: commented from original (removed) self.postingUserID = postingUserID
        //TODO: Need to add dateFormatter in order to convert date to String
        let dataToSave: [String: Any] = self.dictionary

        print("log documentID contents before modification: \(self.documentID)")
        // if we have saved a record, we'll have an ID otherwise .addDocument will create one
        if self.documentID == "" { // need to create a new document if it doesn't exist
            var ref: DocumentReference? = nil
            ref = db.collection("Log").document(postingUserID).collection("Log").addDocument(data: dataToSave) { (error) in
                guard error == nil else {
                    print("😡 ERROR: Adding Log document \(error!.localizedDescription)")
                    return completion(false)
                }
                //  08/22/21 original: self.documentID = postingUserID
                self.documentID = ref!.documentID
                // NOTE: commented from original (removed) self.documentID = ref!.documentID
                // print("Added document \(self.documentID)") // it worked
                print("Added document \(self.documentID)") // it worked
                print("Comparing ref.documentID \(ref!.documentID) to self.documentID \(self.documentID)")
                return completion(true)
            }
        } else { // else save data to existing documentID using .setData
            let ref = db.collection("Log").document(postingUserID).collection("Log").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("😡 ERROR: Updating Log document \(String(describing: error?.localizedDescription))")
                    return completion(false)
                }
                print("Saved Log document: \(self.documentID)") // it worked
                return completion(true)
                
            }
        }
    }
    
    
}

//
//  Logs.swift
//  Printing-Log-3D
//
//  Created by Rich St.Onge on 2021-09-10.
//

import Foundation
import Firebase

class Logs {
    var logArray: [Log] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    func loadData(completed: @escaping () -> ()){
        //TODO: Add code to check when there are any changes to the Log->User->ModelName document
        //TODO: Make sure there is text in the modelName otherwise disallow saving (disable save button)
        // guard statement to check for uid
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("😡 ERROR: Could not save data because we don't have a valid postingUserID")
            return completed()
        }        // verify with Review.swift file before deleting
        //db.collection("spots").document(spot.documentID).addSnapshotListener
        db.collection("Log").document(postingUserID).collection("Log").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("😡 ERROR: adding snapshot listener \(String(describing: error?.localizedDescription))")
                return completed()
            }
            self.logArray = [] // clean out existing data in array since new data will load
            // there are querySnapshot.document.count documents in the snapshot
            for document in querySnapshot!.documents {
                // you'll have to make sure you have a dictionary initializer in the singular class
                let log = Log(dictionary: document.data())
                log.documentID = document.documentID
                // TODO: Verify the string value being passed for log.projectIDString
                // log.projectIDString = document.dictionaryWithValues(forKeys: [log.projectIDString: Any]) as! String? ?? "Project1"
                self.logArray.append(log)
                
            }
            completed()
        }
    }
    func deleteData(log: Log, completion: @escaping (Bool) -> ()) {
        var log:Log!
        let db = Firestore.firestore()
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("😡 ERROR: Could not delete data because we don't have a valid postingUserID")
            return completion(false)
        }
        db.collection("Log").document(postingUserID).collection("Log").document(log.documentID).delete { (error) in
            if let error = error {
                print("ERROR: Deleting document ID \(log.documentID) with error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Successfully deleted document \(log.documentID)")
                completion(true)
            }
        }
        
    }
}

//
//  UIViewController+TwoButtonAlert.swift
//  Printing-Log-3D
//
//  Created by Richard St. Onge on 2021-11-12.
//

import Foundation

import UIKit

extension UIViewController {
    func twoButtonAlert(title: String,message: String) -> Bool {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        alertController.addAction(defaultAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
        if alertController.actions.contains(where: { deleteAction in
            deleteAction.isEnabled
        }){
            if deleteAction.isEnabled {
                return true
            }
        }
        return false
    }

}

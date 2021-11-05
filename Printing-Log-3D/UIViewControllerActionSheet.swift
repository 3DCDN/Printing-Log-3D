//
//  UIViewControllerActionSheet.swift
//  Printing-Log-3D
//
//  Created by Richard St. Onge on 2021-10-25.
//

import Foundation

import UIKit

extension UIViewController: UIAlertViewDelegate {
    func oneButtonAction(title: String,message: String) -> Bool {
        let actionController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        actionController.addAction(cancelAction)
        actionController.addAction(deleteAction)
        if deleteAction.isEnabled {
            print("Delete action is enabled")
        }
        self.present(actionController, animated: true, completion: nil)
        print(deleteAction)
        // TODO: Add parameter to function to send back result from delete confirmation or cancel
        return deleteAction.isEnabled
    }

}
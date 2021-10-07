//
//  UIViewController+alert.swift
//  Printing-Log-DB
//
//  Created by Rich St.Onge on 2021-07-25.
//

import UIKit

extension UIViewController {
    func oneButtonAlert(title: String,message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

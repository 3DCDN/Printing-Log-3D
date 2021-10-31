//
//  NavControllerOverride.swift
//  Printing-Log-3D
//
//  Created by Richard St. Onge on 2021-10-31.
//

import Foundation
import UIKit
extension UINavigationController: UINavigationControllerDelegate {
    
        open override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    func setStatusBar(backgroundColor: UIColor) {
            let statusBarFrame: CGRect
            if #available(iOS 13.0, *) {
                statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
            } else {
                statusBarFrame = UIApplication.shared.statusBarFrame
            }
            let statusBarView = UIView(frame: statusBarFrame)
            statusBarView.backgroundColor = backgroundColor
            view.addSubview(statusBarView)
        }
    }

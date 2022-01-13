//
//  LoginViewController.swift
//  Printing-Log-3D
//
//  Created by Rich St.Onge on 2021-08-31.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseOAuthUI
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import AuthenticationServices
import GoogleSignIn

class LoginViewController: UIViewController {
    
    var authUI: FUIAuth!
    var logs: Logs!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logs = Logs()
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            //          FUIGoogleAuth(),
            FUIOAuth.appleAuthProvider(),
            FUIGoogleAuth.init(authUI: authUI)
        ]
        
        if authUI.auth?.currentUser == nil { // user has not signed in
            self.authUI.providers = providers // show providers named after let providers: above
            let authViewController = authUI.authViewController()
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
        } else { // user is already logged in
            //perform(<#T##Selector#>, with: <#T##Any?#>, afterDelay: <#T##TimeInterval#>)
            performSegue(withIdentifier: "FirstShowSegue", sender: nil)
        }
    }
    
    func signOut() {
        do {
            try authUI!.signOut()
        } catch {
            print("😡 ERROR: couldn't sign out")
            performSegue(withIdentifier: "FirstShowSegue", sender: nil)
        }
    }
    
    @IBAction func unwindSignOutPressed(segue: UIStoryboardSegue) {
        if segue.identifier == "SignOutUnwind" {
            signOut()
        }
    }
}

extension LoginViewController: FUIAuthDelegate {
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let marginInsets: CGFloat = 16.0 // amount to indent UIImageView on each side
        let topSafeArea = self.view.safeAreaInsets.top + 64
        
        // Create an instance of the FirebaseAuth login view controller
        let authViewController = FUIAuthPickerViewController(authUI: authUI)
        // Set background color to white
        authViewController.view.backgroundColor = UIColor.systemGray5
        // Subviews were determined by Prof. John Gallaugher
        authViewController.view.subviews[0].backgroundColor = UIColor.clear
        authViewController.view.subviews[0].subviews[0].backgroundColor = UIColor.clear
        //TODO: How to get view height from NSLayoutDimension
//        let testy = CGRect(from: NSLayoutDimension(coder: authViewController.view.heightAnchor) as! Decoder)
        //TODO: When view rotates needs to update frame again

        // Create a frame for a UIImageView to hold our logo
        let x = marginInsets
        let y = topSafeArea
        let width = self.view.frame.width - (marginInsets * 2)
        //        //        let height = loginViewController.view.subviews[0].frame.height - (topSafeArea) - (marginInsets * 2)
        //MARK: Original height declaration statement      let height = UIScreen.main.bounds.height - (topSafeArea+120) - (marginInsets*1)
        let height = UIScreen.main.bounds.height - 216 - topSafeArea - (marginInsets * 2)
        let logoFrame = CGRect(x: x, y: y, width: width, height: height)
        
        //        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        authViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return authViewController
    }
}

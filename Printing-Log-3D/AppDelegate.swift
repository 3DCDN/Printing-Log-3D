//
//  AppDelegate.swift
//  Printing-Log-3D
//
//  Created by Rich St.Onge on 2021-08-31.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Initialize Firebase
        FirebaseApp.configure()
        //Change the appearance for all Navigation Controllers
        //UINavigationBar.appearance().barStyle = UIBarStyle.black
        //UIScrollView.scrollRectToVisible(<#T##self: UIScrollView##UIScrollView#>)
        //UITableView.appearance().backgroundColor = UIColor.white
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


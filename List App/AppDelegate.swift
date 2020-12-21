//
//  AppDelegate.swift
//  List App
//
//  Created by Elina Mansurova on 2020-12-15.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm, \(error)")
        }
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

        let docsDir = dirPaths[0]

        print(docsDir)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
     return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}


//
//  AppDelegate.swift
//  ToDoey
//
//  Created by Apple on 2018. 10. 01..
//  Copyright © 2018. Kovacs Marcell Imre. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//  Első sor ami elindul a programban
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // print(Realm.Configuration.defaultConfiguration.fileURL)

        do{
            _ = try Realm()
        }catch {
            print("Error init new realm, \(error)")
        }
        
        
        
        return true
    }

}





//
//  AppDelegate.swift
//  Todoey
//
//  Created by Mate Toth on 12/20/18.
//  Copyright © 2018 Mate Toth. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL)      //file path to realm database
        
        do{
            _ = try Realm()
        }catch{
            print("Error initialising new Realm \(error)")
        }
        
        return true
    }
}


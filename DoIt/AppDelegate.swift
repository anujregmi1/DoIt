//
//  AppDelegate.swift
//  DoIt
//
//  Created by Anuj Regmi on 12/25/19.
//  Copyright © 2019 Anuj Regmi. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //first thing that gets called.
        
        
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
    
    // MARK: - Core Data stack
        
    //lazy: it is a variable that gets loaded with value only when it is needed. When this variable is used then only it gets a value. Memory efficient.
    
        lazy var persistentContainer: NSPersistentContainer = {
            
            //we create a new NSPersistentContainer using our own data model called "DataModel"
            // this is a SQLite database that we will be saving our data to.
            let container = NSPersistentContainer(name: "DataModel")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                    
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            })
            return container
        }()

        // MARK: - Core Data Saving support

        func saveContext () {
            // and then we have a context area where we modify and play around with the data before saving it ot the database
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()    // finally save the data
                } catch {
                    
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

}






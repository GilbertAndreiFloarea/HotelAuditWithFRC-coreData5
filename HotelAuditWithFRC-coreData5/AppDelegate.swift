//
//  AppDelegate.swift
//  HotelAuditWithFRC-coreData5
//
//  Created by Gilbert Andrei Floarea on 30/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var  coreDataStack = CoreDataStack(modelName: "HotelAudit")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        populateCoreDataFromJSONIfNeeded()
        
        guard let navController = window?.rootViewController as? UINavigationController,
            let viewController = navController.topViewController as? ViewController else {
                return true
        }
        
        viewController.coreDataStack = coreDataStack
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        coreDataStack.saveContext()
    }

}

extension AppDelegate {
    func populateCoreDataFromJSONIfNeeded() {
        
        let fetchRequest: NSFetchRequest<Thing> = Thing.fetchRequest()
        let countInCoreData = try? coreDataStack.managedContext.count(for: fetchRequest)
        
        guard let count = countInCoreData,
            count == 0 else {
                return
        }
        populateCoreDataFromLocalJSON()
    }
    
    func populateCoreDataFromLocalJSON() {
        
        let jsonURL = Bundle.main.url(forResource: "hotel", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonURL)
        
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [[String: Any]]
            
            for jsonDictionary in jsonArray {
                let brand = jsonDictionary["brand"] as! String
                let category = jsonDictionary["category"] as! String
                let count = jsonDictionary["count"] as! NSNumber
                let imageName = jsonDictionary["imageName"] as! String
                
                let thing = Thing(context: coreDataStack.managedContext)
                thing.brand = brand
                thing.category = category
                thing.count = count.int32Value
                thing.imageName = imageName
            }
            
            coreDataStack.saveContext()
            print("I've imported \(jsonArray.count) Things")
            
        } catch let error as NSError {
            print("Error importing things: \(error)")
        }
    }
}

//
//  AppDelegate.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/9/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import OneSignal


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let APP_ID = "50C735CF-BB09-69E9-FF72-95EF17ECBD00"
    let API_KEY = "5791D825-4D89-CE8A-FF8E-C3AF8828F200"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        backEndless!.initApp(APP_ID, apiKey: API_KEY)
        OneSignal.initWithLaunchOptions(launchOptions, appId: kONESIGNALID, handleNotificationReceived: nil, handleNotificationAction: nil, settings: nil)
        
        //checks if user is online/logged in
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                if (UserDefaults.standard.object(forKey: kCURRENTUSER) != nil){
                    
                    DispatchQueue.main.async {
                       //notifies the notification center that a user logged in and with what id
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogInNotification"), object: nil, userInfo: [ "userId" : FUser.currentId() ])
                    }
                }
            }
        }
        
        func onUserDidLogin(userId: String){
            
            //Start "One Signal" -everytime a user logs in, this starts our one signal and receive our user ID from it
            startOneSignal()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UserDidLogInNotification"), object: nil, queue: nil) { (notification) in
            
             let userId = notification.userInfo!["userId"] as! String
            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.synchronize()
            
            onUserDidLogin(userId: userId)
            }
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { (granted, error) in
            })
            application.registerForRemoteNotifications()
            }
        
        return true
    }
    
    
    //MARK: -push notification functions
    
    //check if the application was registered for remote notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        // .sand = sandbox
        // .prod = production
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        //else this is not a fire base notification
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("failed to register for user notification")
    }
    
    //MARK: -One Signal
    
    func startOneSignal(){
        
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        // 'one signal' is returning the user is od our user
        let userID = status.subscriptionStatus.userId
        let pushToken = status.subscriptionStatus.pushToken
        
        if pushToken != nil {
            if let playerId = userID {
                
                
                UserDefaults.standard.setValue(playerId, forKey: "OneSignalId")
            } else {
                
                UserDefaults.standard.removeObject(forKey: "OneSignalId")
            }
        }
       //save to our user object(update my user object)
        updateOneSignalId()
        
    }
    
    
    
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        // Saves changes in the application's managed object context before the application terminates.
//        self.saveContext()
//    }
//
//    // MARK: - Core Data stack
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "NOTES_EcommerceApp")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}


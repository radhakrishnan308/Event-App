//
//  AppDelegate.swift
//  Events App
//
//  Created by radhakrishnan on 13/05/20.
//  Copyright © 2020 radhakrishnan. All rights reserved.
//

import UIKit
import UserNotifications
import CleverTapSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var cleverTapAdditionalInstance: CleverTap = {
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        let ctConfig = CleverTapInstanceConfig.init(accountId: Constants.kAccountID, accountToken: Constants.kAccountToken)
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        return CleverTap.instance(with: ctConfig)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // register for push notifications
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)

        registerForPush()

//        CleverTap.autoIntegrate()
    
        NSLog("additional CleverTap instance created for accountID: %@", cleverTapAdditionalInstance.config.accountId)
        
        return true
    }
    
    // MARK: - Setup Push Notifications
    
    func registerForPush() {
        // Register for Push notifications
        UNUserNotificationCenter.current().delegate = self
        // request Permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: {granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })
    }
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
           print("this will return '32 bytes' in iOS 13+ rather than the token \(tokenString)")
        cleverTapAdditionalInstance.setPushToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        cleverTapAdditionalInstance.handleNotification(withData: userInfo)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        cleverTapAdditionalInstance.handleNotification(withData: notification)
    }
    
  
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        cleverTapAdditionalInstance.handleNotification(withData: notification)
        completionHandler()
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        cleverTapAdditionalInstance.handleNotification(withData: userInfo)
        completionHandler()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        cleverTapAdditionalInstance.handleNotification(withData: userInfo)
        
        let state : UIApplication.State = application.applicationState
        if (state == .inactive || state == .background) {
            // go to screen relevant to Notification content
        } else {
            // App is in UIApplicationStateActive (running in foreground)
            if let aps = userInfo["aps"] as?  [AnyHashable : Any] {
                showAlert(title: "Push Notification", message: aps["alert"] as! String)
            }
        }
        
        
        completionHandler(.noData)
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

    //Show alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive , handler:nil))
        
        //To get to window
        if (UIApplication.shared.windows.first?.isKeyWindow) != nil{
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }

}


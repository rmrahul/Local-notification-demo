//
//  ViewController.swift
//  LocalNotificationCheck
//
//  Created by Rahul Mane on 09/05/17.
//  Copyright © 2017 Rahul Mane. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button actions
    
    @IBAction func scheduleUsingUserNotification(_ sender: Any) {
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                switch notificationSettings.authorizationStatus {
                case .notDetermined:
                    self.requestAuthorizationForiOS10AndAbove(completionHandler: { (success) in
                        guard success else {return}
                        
                        self.scheduleLocalNotificationForiOS10AndAbove()
                    })
                case .authorized:
                    self.scheduleLocalNotificationForiOS10AndAbove()
                case .denied:
                    //do some error handling
                    print("do some error handling")
                }
            }
        }
        else{
            print("This button action is not available for current os version")
        }
        
        let some = NSMutableURLRequest(url: URL(string :"as")!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 12)
        
    }
    
    
    @IBAction func scheduleUsingUILocalNotification(_ sender: Any) {
        requestAuthorizationForiOS9AndBelow()
        scheduleLocalNotificationForiOS9AndBelow()
    }
    
    
    // MARK: - Private Methods
    // MARK: - iOS 9 and below
    /*
     Request for authorization for iOS 9 and below devices.
     */
    private func requestAuthorizationForiOS9AndBelow(){
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings) //No need to register settings everytime. We can move this code to App delegate but just want to add all code in single file
    }
    
    /*
     Schedule local notification for iOS 9 and below devices using UILocalNotification. Time duration to schedule is 5 sec.
     */
    private func scheduleLocalNotificationForiOS9AndBelow(){
        let notification = UILocalNotification()
        notification.alertTitle = "Using UILocalNotification"
        notification.alertBody = "We haven't register for push notification"
        notification.alertAction = "open"
        notification.fireDate = Date(timeIntervalSinceNow: 5)
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    // MARK: - iOS 10 and above
    /*
     Request for authorization for iOS 10 and above devices.
     */
    private func requestAuthorizationForiOS10AndAbove(completionHandler: @escaping (_ success: Bool) -> ()) {
        if #available(iOS 10.0, *){
            
            // Request Authorization
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
                if let error = error {
                    print("Request Authorization Failed (\(error), \(error.localizedDescription))")
                }
                
                completionHandler(success)
            }
        }
    }
    
    /*
     Schedule local notification for iOS 10 and above devices using UNMutableNotificationContent. Time duration to schedule is 5 sec.
     */
    private func scheduleLocalNotificationForiOS10AndAbove() {
        if #available(iOS 10.0, *){
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Using UNMutableNotificationContent"
            notificationContent.body = "We haven't register for push notification"
            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
            let notificationRequest = UNNotificationRequest(identifier: "my_local_notification", content: notificationContent, trigger: notificationTrigger)
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
        }
    }
}


extension ViewController: UNUserNotificationCenterDelegate {
    
    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}




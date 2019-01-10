//
//  AppDelegate+Notification.swift
//  OnDemandApp
//  Created by Arvind Singh on 17/05/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UserNotifications

extension AppDelegate {
    
    struct Keys {
        static let deviceToken = "deviceToken"
    }
    
    // MARK: - UIApplicationDelegate Methods
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        LogManager.logDebug("Device Push Token \(String(describing: String(data: deviceToken, encoding: String.Encoding.utf8)))")
        // Prepare the Device Token for Registration (remove spaces and < >)
        
        self.setDeviceTokenString(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        LogManager.logError(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        self.recievedRemoteNotification(userInfo as NSDictionary)
        
    }
    
    
    // MARK: - Private Methods
    /**
     Register remote notification to send notifications
     */
    func registerRemoteNotification () {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    /**
     Deregister remote notification
     */
    func deregisterRemoteNotification () {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func setDeviceToken (_ token: Data) {
        let deviceToken = token.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        UserDefaults.setObject(deviceToken as AnyObject?, forKey: Keys.deviceToken)
    }
    
    func setDeviceTokenString (_ deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        LogManager.logDebug("Device Push Token \(deviceTokenString)")
        UserDefaults.setObject(deviceTokenString as AnyObject?, forKey: Keys.deviceToken)
        UIPasteboard.general.string = deviceTokenString

        /*let alertController = UIAlertController(title: "Destructive", message: deviceTokenString, preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)*/
    }
    
    func deviceToken () -> String {
        let deviceToken: String? = UserDefaults.objectForKey(Keys.deviceToken) as? String
        
        if isObjectInitialized(deviceToken as AnyObject?) {
            return deviceToken!
        }
        
        return ""
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    /**
     Receive information from remote notification. Parse response.
     
     - parameter userInfo: Response from server
     */
    func recievedRemoteNotification (_ userInfo: NSDictionary) {
        
        let dictioaryUserInfo: NSDictionary = userInfo["aps"] as! NSDictionary
        if UserManager.sharedManager().isUserLoggedIn() {
            
            let user = UserManager.sharedManager().activeUser
            if user?.unReadCount != nil {
                let val = user?.unReadCount?.intValue
                user?.unReadCount =  NSNumber(value: (val! + 1) )
                if (user?.unReadCount?.intValue)! > 99 {
                    
                    NotificationCenter.default.post(name: Constants.NOTIFICATION_UNREAD_COUNT, object: self, userInfo: ["unreadCount":"99+"])
                    
                }else{
                    
                    NotificationCenter.default.post(name: Constants.NOTIFICATION_UNREAD_COUNT, object: self, userInfo: ["unreadCount":"\((user?.unReadCount!)!)"])
                }
                
                
            }
        }
        
        if UIApplication.shared.applicationState == UIApplicationState.active {
            
//            let alertView = PushAlertView.init(frame: CGRect.zero)
//            if let messageStr  = dictioaryUserInfo["alert"] as? String {
//                alertView.showPushAlertWithMessage(message: messageStr) { (clicked) -> (Void) in
//                }
//            }
            if let messageStr  = dictioaryUserInfo["alert"] as? String {
                let topC = self.topViewController()
                topC?.showBRYXBanner("", messageStr, nil)
            }
            if let dict =  userInfo["data"] as? NSDictionary {
            
                if let notification_details = self.convertToDictionary(text: (dict["notification_details"]) as! String) {
                
                    if let type = notification_details["type"] as? NSNumber{
                    
                        if type.intValue == 6 {
                            
                            if let topController = self.topViewController() as? ChatViewController {
                                if(topController.isKind(of:ChatViewController.self)){
                                    topController.chatMsgReceived(dict: userInfo as! Dictionary<String, Any>)
                                }
                            }
                        }
                        
                        if ((type.intValue == 4) || (type.intValue == 3) || (type.intValue == 2))  { //feedback
                            
                            if isFeedbackProcessing == false {
                                isFeedbackProcessing = true
                                self.getFeedbackList()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                LogManager.logDebug(error.localizedDescription)
            }
        }
        return nil
    }
}

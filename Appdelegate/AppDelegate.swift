//
//  AppDelegate.swift
//  E3malApp
//
//  Created by Arvind Singh on 03/02/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Google
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import SDWebImage
// OLD API Endpoint : https://staging.e3mal.co/api/v1
enum RootViewControllerIdentifier {
    case forLoggedInUser
    case toShowLoginScreen
    case fromLogin
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var settings:SettingsVC?
    var profileVC:APProfileViewController?
    var pendingFeedbacks : [AnyObject]?
    var feedBackView : FeedBackHireView?
    var feedBackHireView : FeedBackView?
    var isFeedbackProcessing = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NSSetUncaughtExceptionHandler { (exception) in
            print("CRASH: \(exception)")
            print("Stack Trace: \(exception.callStackSymbols)")
        }
        
        // Setup Logger
        self.setupLogger()
        
        // Register device to receive push notification
        self.registerRemoteNotification()
        
        // Enable inputAccessoryView for all the textfields
        self.enableInputAccessoryView()
        
        // Enable crashlytics and twitter
        AppDelegate.configureTwitter()
        
        // Configure Navigation Itmes
        self.configureNavigationItems()
        
        // Setup Preferred Language
        self.languageSetup()
        
        //Set the correct root to start with
        AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.forLoggedInUser)
        AnalyticsManager.platformType = .appsee
        // Initialize event tracker
        AnalyticsManager.initializeTracker()
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.logout(_:)), name: Constants.NOTIFICATION_LOGOUT, object: nil)
        self.configureImageDownloader()
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        
        LogManager.logDebug(url.absoluteString)
        
        if url.scheme?.localizedCaseInsensitiveCompare(Config.schemeURL) == .orderedSame {
            // Send notification to handle result in the view controller.
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)
            return true
        }
        
        
        if LISDKCallbackHandler.shouldHandle(url) {
            if #available(iOS 9.0, *) {
                return LISDKCallbackHandler.application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            } else {
                // Fallback on earlier versions
            };
        }
        
        if #available(iOS 9.0, *) {
            return (GIDSignIn.sharedInstance().handle(url,
                                                      sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                      annotation: options[UIApplicationOpenURLOptionsKey.annotation]))
        } else {
            // Fallback on earlier versions
        }
        
        
       
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if LISDKCallbackHandler.shouldHandle(url) {
            return LISDKCallbackHandler.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation);
        }
        
        return (GIDSignIn.sharedInstance().handle(url,
                                                  sourceApplication: sourceApplication,
                                                  annotation: annotation))
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        if (UserManager.sharedManager().isUserLoggedIn()) {
            UserManager.sharedManager().getUnreadNotificationCount(completion: {(success, error) -> Void in
                self.getFeedbackList()
            })
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //App activation code
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    func logout(_ notification: NSNotification) {
        
        // Delay 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            
            if let topController = self.topViewController() as? ChatViewController {
                if(topController.isKind(of:ChatViewController.self)){
                    topController.dismiss(animated: false, completion: nil)
                }
            }
            UserManager.sharedManager().deleteActiveUser()
            APGoogleManager.sharedManager().logout()
            AppDelegate.presentRootViewController(false, rootViewIdentifier: .toShowLoginScreen)
        }
        
    }
    
    // MARK: - App Delegate Ref
    class func delegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func switchAppToStoryboard(_ name: String, storyboardId: String) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: storyboardId)
    }
    
    // MARK: - Root View Controller
    class func presentRootViewController(_ animated: Bool = false , rootViewIdentifier : RootViewControllerIdentifier) {
        
        if (animated) {
            let animation:CATransition = CATransition()
            animation.duration = CFTimeInterval(0.5)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = kCATransitionMoveIn
            animation.subtype = kCATransitionFromTop
            animation.fillMode = kCAFillModeForwards
            AppDelegate.delegate().window?.layer.add(animation, forKey: "animation")
        }
        
        switch rootViewIdentifier{
        case .forLoggedInUser:
            AppDelegate.delegate().window?.rootViewController = AppDelegate.rootViewControllerToShowLandingScreen()
            break
        case .fromLogin:
            
            if  !UserDefaults.standard.bool(forKey: Constants.kShowBoardingForFirstTime) {
                UserDefaults.standard.set(true, forKey: Constants.kShowBoardingForFirstTime)
                UserDefaults.standard.synchronize()
            }
            
            // hide loader
            DispatchQueue.main.async {
                AppDelegate.delegate().window?.rootViewController = AppDelegate.rootViewControllerAfterLogin()
            }
            
           
        case .toShowLoginScreen:
            AppDelegate.delegate().window?.rootViewController = AppDelegate.showLoginViewController()
            
        }
    }
    
    
    fileprivate class func rootViewControllerToShowLandingScreen() -> UIViewController! {
        
        if (UserManager.sharedManager().isUserLoggedIn()) {
            
            if(UserManager.sharedManager().userType == .userTypeProvider)
            {
                
                if ConfigurationManager.sharedManager().isOtpEnabled() == true && ConfigurationManager.sharedManager().isMultiService() == true && ConfigurationManager.sharedManager().isStoreLocationRequired() == true
                {
                    
                    if UserManager.sharedManager().activeUser.isPhoneVerified!.boolValue && UserManager.sharedManager().activeUser.isCategorySaved!.boolValue && UserManager.sharedManager().activeUser.isServicesSaved!.boolValue && UserManager.sharedManager().activeUser.permanentLatitude! != ""
                    {
                        return self.rootControllerForLoggenInUser()
                    }
                    else
                    {
                        return self.showLoginViewController()
                    }
                }
                else if ConfigurationManager.sharedManager().isOtpEnabled() == false && ConfigurationManager.sharedManager().isMultiService() == true && ConfigurationManager.sharedManager().isStoreLocationRequired() == true
                {
                    
                    if  UserManager.sharedManager().activeUser.isCategorySaved!.boolValue && UserManager.sharedManager().activeUser.isServicesSaved!.boolValue && UserManager.sharedManager().activeUser.permanentLatitude! != ""
                    {
                        return self.rootControllerForLoggenInUser()
                    }
                    else
                    {
                        return self.showLoginViewController()
                    }
                }
                else if ConfigurationManager.sharedManager().isOtpEnabled() == true && ConfigurationManager.sharedManager().isMultiService() == false && ConfigurationManager.sharedManager().isStoreLocationRequired() == true
                {
                    
                    if UserManager.sharedManager().activeUser.isPhoneVerified!.boolValue && UserManager.sharedManager().activeUser.isServicesSaved!.boolValue && UserManager.sharedManager().activeUser.permanentLatitude! != ""
                    {
                        return self.rootControllerForLoggenInUser()
                    }
                    else
                    {
                        return self.showLoginViewController()
                    }
                }
                else if ConfigurationManager.sharedManager().isOtpEnabled() == true && ConfigurationManager.sharedManager().isMultiService() == true && ConfigurationManager.sharedManager().isStoreLocationRequired() == false
                {
                    
                    if UserManager.sharedManager().activeUser.isPhoneVerified!.boolValue && UserManager.sharedManager().activeUser.isCategorySaved!.boolValue && UserManager.sharedManager().activeUser.isServicesSaved!.boolValue
                    {
                        return self.rootControllerForLoggenInUser()
                    }
                    else
                    {
                        return self.showLoginViewController()
                    }
                }
                else if ConfigurationManager.sharedManager().isOtpEnabled() == true && ConfigurationManager.sharedManager().isMultiService() == false && ConfigurationManager.sharedManager().isStoreLocationRequired() == false
                {
                    
                    if UserManager.sharedManager().activeUser.isPhoneVerified!.boolValue && UserManager.sharedManager().activeUser.isServicesSaved!.boolValue
                    {
                        return self.rootControllerForLoggenInUser()
                    }
                    else
                    {
                        return self.showLoginViewController()
                    }
                }
                else if ConfigurationManager.sharedManager().isOtpEnabled() == false && ConfigurationManager.sharedManager().isMultiService() == false && ConfigurationManager.sharedManager().isStoreLocationRequired() == false
                {
                    
                    if UserManager.sharedManager().activeUser.isServicesSaved!.boolValue
                    {
                        return self.rootControllerForLoggenInUser()
                    }
                    else
                    {
                        return self.showLoginViewController()
                    }
                }
                else
                {
                    return self.rootControllerForLoggenInUser()
                }
                
            }
            else
            {
                if ConfigurationManager.sharedManager().isOtpEnabled() == true
                {
                    if UserManager.sharedManager().activeUser.isPhoneVerified!.boolValue
                    {
                        return self.rootControllerForLoggenInUser()
                    }
                    else
                    {
                        return self.showLoginViewController()
                    }
                }
                else
                {
                    return self.rootControllerForLoggenInUser()
                }
            }
        }
        else
        {
            return self.showLoginViewController()
        }
    }
    
    fileprivate class func rootViewControllerAfterLogin() -> UIViewController! {
        
       if (UserManager.sharedManager().isUserLoggedIn()) {
            return self.rootControllerForLoggenInUser()
       }
       else if (UserManager.sharedManager().isGuestUser()) {
           return self.rootControllerForGuestInUser()
       }
       else
       {
            return self.showLoginViewController()
       }
    }
    
    class func rootControllerForGuestInUser() -> UIViewController {
        let tabBarStoryboard  = UIStoryboard(name: "TabbarController", bundle: nil)
        let tabBarVC = tabBarStoryboard.instantiateViewController(withIdentifier: "TabBarController")
        let navigationController = UINavigationController(rootViewController: tabBarVC)
        navigationController.isNavigationBarHidden = true
        return navigationController

    }
    
    class func rootControllerForLoggenInUser() -> UIViewController {
        
        let user = UserManager.sharedManager().activeUser
        
        if user?.profileStatus == 0 {
            
            let postSignUpProfile  = UIStoryboard(name: "PostSignUpProfile", bundle: nil)
            let postSignUpProfileVC = postSignUpProfile.instantiateViewController(withIdentifier: "PostSignUpProfile") as! APPostSignupProfileViewController
            
            postSignUpProfileVC.email = user?.email
            postSignUpProfileVC.name = user?.name
            
            if user?.profileImage != nil && user?.profileImage != "" {
                postSignUpProfileVC.profilePicPath = user?.profileImage
            }
            postSignUpProfileVC.bio = ""
            return postSignUpProfileVC
            
        }else if user?.profileStatus == 1 {
            
            if user?.roleType == 2{ // hire
                
                let tabBarStoryboard  = UIStoryboard(name: "TabbarController", bundle: nil)
                let tabBarVC = tabBarStoryboard.instantiateViewController(withIdentifier: "TabBarController")
                let navigationController = UINavigationController(rootViewController: tabBarVC)
                navigationController.isNavigationBarHidden = true
                return navigationController
                
                
            }else{
                
                // work choose Category
                
                let categoryStoryboard  = UIStoryboard(name: "Category", bundle: nil)
                let workCategoriesVC = categoryStoryboard.instantiateViewController(withIdentifier: "WorkCategoriesVC")
                let navigationController = UINavigationController(rootViewController: workCategoriesVC)
                navigationController.isNavigationBarHidden = true
                return navigationController
            }
            
        }else if user?.profileStatus == 2 {
            
            if user?.flagBankDetails?.intValue == 1 {
                user?.flagBankDetails = NSNumber(value: 2)
                LogManager.logEntry()
                let navigationController = UINavigationController(rootViewController: UIStoryboard.bankDetailVC()!)
                navigationController.isNavigationBarHidden = true
                return navigationController
                
            }else{
                
                let tabBarStoryboard  = UIStoryboard(name: "TabbarController", bundle: nil)
                let tabBarVC = tabBarStoryboard.instantiateViewController(withIdentifier: "TabBarController")
                let navigationController = UINavigationController(rootViewController: tabBarVC)
                navigationController.isNavigationBarHidden = true
                return navigationController
            }
        }else{
            
            let tabBarStoryboard  = UIStoryboard(name: "TabbarController", bundle: nil)
            let tabBarVC = tabBarStoryboard.instantiateViewController(withIdentifier: "TabBarController")
            let navigationController = UINavigationController(rootViewController: tabBarVC)
            navigationController.isNavigationBarHidden = true
            return navigationController
        }
    }
    
    
    class func showLoginViewController() -> UIViewController {
        //login screen
        if UserDefaults.standard.bool(forKey: Constants.kShowBoardingForFirstTime) && !UserManager.sharedManager().isGuestUser() {
            let storyboard = UIStoryboard.mainStoryboard()
            let navController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "PersonaSelectionContainer") as! UINavigationController
            self.clearLoggedInUserDetails()
            return navController
        }
        else if UserManager.sharedManager().isGuestUser() {
            UserDefaults.removeObjectForKey(GUEST_USER_KEY)
            let navController: UINavigationController = UINavigationController(rootViewController: UIStoryboard.APLoginViewController())
            navController.navigationBar.isHidden = true
            navController.navigationBar.isOpaque = true
            return navController
        }
        else {
            UserDefaults.standard.set(true, forKey: Constants.kShowBoardingForFirstTime)
            let navController: UINavigationController = UINavigationController(rootViewController: UIStoryboard.tutorialVC())
            return navController
        }
    }
    
    class func clearLoggedInUserDetails() {
        // perform clean up
        UserManager.sharedManager().deleteActiveUser()
        APGoogleManager.sharedManager().logout()
    }
    
    
    
    // MARK: - Configure IQKeyboardManager
    fileprivate func enableInputAccessoryView() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().toolbarTintColor = UIColor().appTortoiseColor()
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    
    // MARK: - Setup Logger
    fileprivate func setupLogger() {
        #if DEBUG
            LogManager.setup(.debug)
        #else
            LogManager.setup(.error)
        #endif
    }
    
    
    //MARK: - Configure Navigation items
    func configureNavigationItems(){
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default)
    }
    
    func languageSetup() {
        
        if Localisator.sharedInstance.currentLanguage == "en" || Localisator.sharedInstance.currentLanguage == "DeviceLanguage"{
            
            if #available(iOS 9.0, *) {
                UIView.appearance().semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
            } else {
                // Fallback on earlier versions
            }
            
            if SetLanguage("en") {
                
            }
        } else {
            if #available(iOS 9.0, *) {
                UIView.appearance().semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
            } else {
                // Fallback on earlier versions
            }
            
            if SetLanguage("ar") {
                
            }
        }
        
        // Set text direction
        SetTextDirection()
    }
    
    func configureImageDownloader() {
        SDImageCache.shared().shouldCacheImagesInMemory = false
        SDImageCache.shared().shouldDecompressImages = false
        SDWebImageDownloader.shared().shouldDecompressImages = false
    }
    
}


extension AppDelegate: APUpdatedCategoryAndTags {
    
    func update(category: String, tags: String) {
        settings?.update(category: category, tags: tags)
    }
    
    
}


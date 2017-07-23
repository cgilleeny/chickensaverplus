//
//  AppDelegate.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 1/10/16.
//  Copyright © 2016 Caroline Gilleeny. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications


struct SettingsConstants {
    static let pushMode = "PushMode"
}

struct AppColor {
    static let bars = UIColor(red: 0x37/0xFF, green: 0x69/0xFF, blue: 0x99/0xFF, alpha: 1)
    static let controls = UIColor(red: 0x1B/0xFF, green: 0x46/0xFF, blue: 0x72/0xFF, alpha: 1)
    static let button = UIColor(red: 0x2C/0xFF, green: 0x2C/0xFF, blue: 0x2C/0xFF, alpha: 1)
    static let textBoxGrey = UIColor(red: 0xF5/0xFF, green: 0xF5/0xFF, blue: 0xF5/0xFF, alpha: 1)
    static let lightTextColor = UIColor.init(colorLiteralRed: 43/255.0, green: 170/255.0, blue: 226/255.0, alpha: 0.4)
    static let darkTextColor = UIColor.init(colorLiteralRed: 43/255.0, green: 170/255.0, blue: 226/255.0, alpha: 1.0)
    static let darkerTextColor = UIColor.init(colorLiteralRed: 0x22/255.0, green: 0x88/255.0, blue: 0xB5/255.0, alpha: 1.0)
    static let darkestTextColor = UIColor.init(colorLiteralRed: 0x1B/255.0, green: 0x6D/255.0, blue: 0x91/255.0, alpha: 1.0)
    static let darkerYetTextColor = UIColor.init(colorLiteralRed: 0x16/255.0, green: 0x57/255.0, blue: 0x74/255.0, alpha: 1.0)
    static let goldColor = UIColor.init(colorLiteralRed: 0xFF/255.0, green: 0xD6/255.0, blue: 0x2F/255.0, alpha: 1.0)
    static let lightGoldColor = UIColor.init(colorLiteralRed: 0xFF/255.0, green: 0xE2/255.0, blue: 0x6C/255.0, alpha: 1.0)
    static let paleGoldColor = UIColor.init(colorLiteralRed: 0xFF/255.0, green: 0xED/255.0, blue: 0xA3/255.0, alpha: 1.0)
    static let paleBlueColor = UIColor.init(colorLiteralRed: 0xB9/255.0, green: 0xE4/255.0, blue: 0xF6/255.0, alpha: 1.0)
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, RestfulServicesDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager = CLLocationManager()
    var location: CLLocation?
    var coopLocation: CLLocation?
    var token: String?
    var skip: Int = 4
    var restfulServices = RestfulServices()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        registerDefaultsFromSettingsBundle()
        getStoredDefaults()

        if coopLocation == nil  {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
                locationManager.startUpdatingLocation()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }
        
        if let tabBarVC = self.window!.rootViewController as? UITabBarController {
            if let tabBarViewControllers = tabBarVC.viewControllers as [UIViewController]! {
                print("tabBarViewControllers.count: \(tabBarViewControllers.count)")
                for vc in tabBarViewControllers {
                    if let navigationController = vc as? UINavigationController {
                        /*if let viewController = navigationController.topViewController as? ViewController {
                            viewController.moc = managedObjectContext
                        } else*/ if let breedsVC = navigationController.topViewController as? BreedsVC {
                            breedsVC.moc = managedObjectContext
                        } else if let mapVC = navigationController.topViewController as? MapVC {
                            mapVC.moc = managedObjectContext
                        }
                    } 
                }
            }
        }
        
        customizeAppearance()
        registerForRemoteNotifications()
        return true
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.

        storeDefaults()
        self.saveContext()
    }

    
    // MARK: - Register Defaults
    
    func customizeAppearance() {
        //UINavigationBar.appearance().barTintColor = AppColor.darkerTextColor
        UINavigationBar.appearance().barTintColor = AppColor.darkTextColor
        UINavigationBar.appearance().isTranslucent = false;

        //UINavigationBar.appearance().tintColor = AppColor.bars
        UINavigationBar.appearance().tintColor = UIColor.white
        if let font = UIFont(name: "Noteworthy-Bold", size: 17.0), let smallFont = UIFont(name: "Noteworthy-Bold", size: 10.0) {
            //UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:AppColor.textBoxGrey]
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white /*AppColor.darkerYetTextColor*/]
            UISegmentedControl.appearance().setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
            UISegmentedControl.appearance().setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.selected)
            UILabel.appearance().font = font
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: smallFont, NSForegroundColorAttributeName : AppColor.darkestTextColor], for: UIControlState.normal)
            UITabBar.appearance().tintColor = AppColor.darkestTextColor
            UIButton.appearance().titleLabel?.font = font
        } else {
            //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:AppColor.textBoxGrey]
        }
        UITableViewCell.appearance().tintColor = AppColor.lightGoldColor

        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:AppColor.textBoxGrey]
        //UINavigationBar.appearance().tintColor = AppColor.textBoxGrey
        UISearchBar.appearance().barTintColor = UIColor.red
        UISegmentedControl.appearance().tintAdjustmentMode = .normal
        UISegmentedControl.appearance().tintColor = AppColor.darkerYetTextColor

        UIBarButtonItem.appearance().tintColor = AppColor.darkestTextColor
        //window!.tintColor = AppColor.button

    }

    func getStoredDefaults() {
        let standardUserDefaults = Foundation.UserDefaults.standard
        
        let latitude = standardUserDefaults.double(forKey: "latitude")
        let longitude = standardUserDefaults.double(forKey: "longitude")
        
        if latitude != 0 && longitude != 0 {
            coopLocation = CLLocation(latitude: latitude, longitude: longitude)
        }
        
        token = standardUserDefaults.string(forKey: "token")
    }
    
    
    func storeDefaults() {
        let standardUserDefaults = Foundation.UserDefaults.standard
        
        if let coopLocation = coopLocation as CLLocation? {
            standardUserDefaults.set(coopLocation.coordinate.latitude, forKey: "latitude")
            standardUserDefaults.set(coopLocation.coordinate.longitude, forKey: "longitude")
        }
        
        if let token = token as String? {
            standardUserDefaults.set(token, forKey: "token")
        }
    }
    
    
    func registerDefaultsFromSettingsBundle() {
        if let settingsBundleURL = Bundle.main.url(forResource: "Settings", withExtension: "bundle") {
            if let rootDict = NSDictionary(contentsOf: settingsBundleURL.appendingPathComponent("Root.plist")) {
                if let preferences = rootDict.object(forKey: "PreferenceSpecifiers") as? NSArray {
                    var defaultsToRegister = Dictionary<String,AnyObject>()
                    //let defaults = NSUserDefaults.standardUserDefaults()
                    for prefSpecification in preferences {
                        if ((prefSpecification as AnyObject).object(forKey: "Key") != nil) {
                            if let key = (prefSpecification as AnyObject).object(forKey: "Key") as? String {
                                if key != "" {
                                    let currentObject: AnyObject? = UserDefaults.standard.object(forKey: key) as AnyObject?
                                    if currentObject == nil {
                                        let objectToSet = ((prefSpecification) as AnyObject).object(forKey: "DefaultValue")
                                        if objectToSet != nil {
                                            defaultsToRegister[key] = objectToSet! as AnyObject?
                                            //NSLog("Setting object \(objectToSet) for key \(key)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    //print("defaultsToRegister: \(defaultsToRegister)")
                    UserDefaults.standard.register(defaults: defaultsToRegister)
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    

    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Com.CGilleeny.Chicken_Saver_Plus" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Chicken_Saver_Plus", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    
    
    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    // MARK: - location services
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLLocationManager: didFailWithError: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if skip > 0 {
                skip -= 1
                print("skipped longitude: \(locations[locations.count - 1].coordinate.longitude), latitude: \(locations[locations.count - 1].coordinate.latitude)")
            } else {
                location = locations[locations.count - 1]
                print("longitude: \(location!.coordinate.longitude), latitude: \(location!.coordinate.latitude)")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationUpdate"), object: nil, userInfo:["latitude": location!.coordinate.latitude, "longitude": location!.coordinate.longitude])
            }
        }
    }
    
    // "LocationAuthorizationDenied"
    
    // authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //print("CLLocationManager: didChangeAuthorizationStatus")
        switch status {
        case CLAuthorizationStatus.restricted:
            print("Restricted location status")
            //locationStatus = status
            locationManager.stopUpdatingLocation()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationAuthorizationDenied"), object: nil, userInfo:["status": status])
        case CLAuthorizationStatus.denied:
            print("User denied location status")
            //locationStatus = status
            locationManager.stopUpdatingLocation()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationAuthorizationDenied"), object: nil, userInfo:["status": status])
        case CLAuthorizationStatus.notDetermined:
            print("Not determined location status")
        //locationStatus = status
        case CLAuthorizationStatus.authorizedWhenInUse:
            //print("Authorized when in use location status")
            //locationStatus = status
            // Start location services
            locationManager.startUpdatingLocation()
        case CLAuthorizationStatus.authorizedAlways:
            print("Authorized always location status")
            //locationStatus = status
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: - notification delegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.identifier .contains("sunsetRequest") {
            completionHandler([.alert, .sound])
        } else {
            completionHandler([])
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(String.localizedStringWithFormat("notification caused app to launch: %@", response.notification.request.content.body))
        if response.actionIdentifier == "repeat5" {
            UNUserNotificationCenter.current().add(buildNotificationRequest(delay: 1, sound: response.notification.request.content.sound!)) { error in
                UNUserNotificationCenter.current().delegate = self
                if let error = error {
                    print(error.localizedDescription)
                }
                completionHandler()
            }
        } else if response.actionIdentifier == "repeat15" {
            UNUserNotificationCenter.current().add(buildNotificationRequest(delay: 5, sound: response.notification.request.content.sound!)) { error in
                UNUserNotificationCenter.current().delegate = self
                if let error = error {
                    print(error.localizedDescription)
                }
                completionHandler()
            }
        } else if response.actionIdentifier == "repeat30" {
            UNUserNotificationCenter.current().add(buildNotificationRequest(delay: 10, sound: response.notification.request.content.sound!)) { error in
                UNUserNotificationCenter.current().delegate = self
                if let error = error {
                    print(error.localizedDescription)
                }
                completionHandler()
            }
        } else if response.actionIdentifier == "" {
            completionHandler()
        } else {
            completionHandler()
        }
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //print(userInfo[AnyHashable("aps")] ?? "default value")

        if let sunset = userInfo["sunset"] as? String, let daylength = userInfo["daylength"] as? Int {
            print(daylength)
            print(sunset)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
            dateFormatter.timeZone = TimeZone(identifier: "GMT")
            if let sunsetTime = dateFormatter.date(from: sunset) {
                print(sunsetTime)
                print(sunsetTime.description)
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: sunsetTime)
                print("dateComponents - year: \(String(describing: dateComponents.year)), month: \(String(describing: dateComponents.month)), day: \(String(describing: dateComponents.day)), hour: \(String(describing: dateComponents.hour)), minute: \(String(describing: dateComponents.minute))")
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alarm")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "offset", ascending: true)]
                
                var alarms: [Alarm]?
                do {
                    alarms = try self.managedObjectContext.fetch(fetchRequest) as? [Alarm]
                } catch  {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "AlarmRetrievalFailed"), object: nil, userInfo:["error": error])
                    completionHandler(UIBackgroundFetchResult.noData)
                    return
                }
                for alarm in alarms! {
                    let alarmTime = sunsetTime.addingTimeInterval(alarm.offset!.doubleValue * 60.0)
                    print("alarm.offset!.doubleValue: \(alarm.offset!.doubleValue), alarmTime: \(alarmTime)")
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alarmTime)
                    UNUserNotificationCenter.current().add(self.buildNotificationRequest(sunset: dateComponents, daylength: daylength, sound: alarm.sound!)) { error in
                        UNUserNotificationCenter.current().delegate = self
                        if let error = error {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "BuildNotificationFailed"), object: nil, userInfo:["error": error])
                            print(error.localizedDescription)
                        }
                    }
                }
                completionHandler(UIBackgroundFetchResult.noData)
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("device token: \(deviceToken)\n")
        //let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("token: \(token!)")
        UNUserNotificationCenter.current().getNotificationSettings{ settings in
            self.updateForRemoteNotifications()
            
            /*
            let device = UIDevice()
            let deviceName = device.name
            let deviceModel = device.model
            let systemVersion = device.systemVersion
            let deviceId = device.identifierForVendor!.uuidString
            
            var appName: String?
            
            if let appDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String? {
                appName = appDisplayName
            } else {
                appName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String?
            }
            
            let appVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String?
            if let token = self.token as String? {
                let postDictionary = ["appname":appName as AnyObject,
                                      "appversion":appVersion as AnyObject,
                                      "deviceuid":deviceId as AnyObject,
                                      "devicename":deviceName as AnyObject,
                                      "devicetoken":token as AnyObject,
                                      "devicemodel":deviceModel as AnyObject,
                                      "deviceversion":systemVersion as AnyObject,
                                      "pushbadge":(settings.badgeSetting == UNNotificationSetting.enabled ? "enabled" : "disabled") as AnyObject,
                                      "pushalert":(settings.alertSetting == UNNotificationSetting.enabled ? "enabled" : "disabled") as AnyObject,
                                      "pushsound":(settings.soundSetting == UNNotificationSetting.enabled ? "enabled" : "disabled") as AnyObject,
                                      "development":UserDefaults.standard.string(forKey: SettingsConstants.pushMode) as AnyObject,
                                      "latitude": (self.coopLocation == nil ? 0 : self.coopLocation!.coordinate.latitude) as AnyObject,
                                      "longitude":(self.coopLocation == nil ? 0 : self.coopLocation!.coordinate.longitude) as AnyObject,
                                      ]
                print(postDictionary)
                self.restfulServices.postJSON(servlet: "Register", withDictionary: postDictionary)
            }
            */
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "RemoteNotificationRegistrationError"), object: nil, userInfo:["error": error])
    }
    
    
    
    public func updateForRemoteNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings{ settings in
            
            let device = UIDevice()
            let deviceName = device.name
            let deviceModel = device.model
            let systemVersion = device.systemVersion
            let deviceId = device.identifierForVendor!.uuidString
            
            var appName: String?
            
            if let appDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String? {
                appName = appDisplayName
            } else {
                appName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String?
            }
            
            let appVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String?
            if let token = self.token as String? {
                (UIApplication.shared.delegate as! AppDelegate).restfulServices.delegate = self
                let postDictionary = ["appname":appName as AnyObject,
                                      "appversion":appVersion as AnyObject,
                                      "deviceuid":deviceId as AnyObject,
                                      "devicename":deviceName as AnyObject,
                                      "devicetoken":token as AnyObject,
                                      "devicemodel":deviceModel as AnyObject,
                                      "deviceversion":systemVersion as AnyObject,
                                      "pushbadge":(settings.badgeSetting == UNNotificationSetting.enabled ? "enabled" : "disabled") as AnyObject,
                                      "pushalert":(settings.alertSetting == UNNotificationSetting.enabled ? "enabled" : "disabled") as AnyObject,
                                      "pushsound":(settings.soundSetting == UNNotificationSetting.enabled ? "enabled" : "disabled") as AnyObject,
                                      "development":UserDefaults.standard.string(forKey: SettingsConstants.pushMode) as AnyObject,
                                      "latitude": (self.coopLocation == nil ? 0 : self.coopLocation!.coordinate.latitude) as AnyObject,
                                      "longitude":(self.coopLocation == nil ? 0 : self.coopLocation!.coordinate.longitude) as AnyObject,
                                      ]
                print(postDictionary)
                self.restfulServices.postJSON(servlet: "Register", withDictionary: postDictionary)
            }
        }
    }
    
    func registerForRemoteNotifications() {
        //NotificationCenter.default.addObserver(self, selector: #selector(MapVC.remoteNotificationAuthorizationFailed(_:)), name:NSNotification.Name(rawValue: "RemoteNotificationRegistrationError"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(NotificationOptionsVC.remoteNotificationAuthorizationFailed(_:)), name:NSNotification.Name(rawValue: "RemoteNotificationRegistrationError"), object: nil)
        (UIApplication.shared.delegate as! AppDelegate).restfulServices.delegate = self
        let center = UNUserNotificationCenter.current()
        
        let repeat5 = UNNotificationAction(identifier: "repeat5", title: String.localizedStringWithFormat("Repeat In %d Minutes", 5), options: [])
        let repeat15 = UNNotificationAction(identifier: "repeat15", title: String.localizedStringWithFormat("Repeat In %d Minutes", 15), options: [])
        let repeat30 = UNNotificationAction(identifier: "repeat30", title: String.localizedStringWithFormat("Repeat In %d Minutes", 30), options: [])
        let category = UNNotificationCategory(identifier: "repeatCategory", actions: [repeat5, repeat15, repeat30], intentIdentifiers: [], options: [.customDismissAction])
        
        center.setNotificationCategories([category])
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationAuthorizationDenied"), object: nil, userInfo:["error": error.localizedDescription])
            } else {
                if !granted
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationAuthorizationDenied"), object: nil, userInfo:["reason": "Permission Not Granted"])
                }
                else
                {
                    print("Allow")
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func buildNotificationRequest(sunset: DateComponents, daylength: Int, sound: String) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Sunset Alert", comment: "")
        content.subtitle = String.localizedStringWithFormat("Sunset time: %@", sunset.description)
        content.body = NSLocalizedString("Time to put the chickens away!", comment: "")
        
        switch sound {
        case "Clucking":
            content.sound = UNNotificationSound(named: "Clucking.wav")
        case "Crowing":
            content.sound = UNNotificationSound(named: "Crowing.wav")
        default:
            content.sound = UNNotificationSound(named: sound)
        }

        content.categoryIdentifier = "repeatCategory"

        
        if daylength < (12*60*60) { // 60 secs per min, 60 minutes per hour 12 hours minimum daylight for laying
            if let image = UIImage(named: "light.jpg"), let url = image.saveToURL(name: "light") {
                let attachment = try? UNNotificationAttachment(identifier: "imageIdentifier",
                                                               url: url,
                                                               options: [:])
                if let attachment = attachment {
                    content.attachments.append(attachment)
                }
            }
        } else {
            if let image = UIImage(named: "fox.jpg"), let url = image.saveToURL(name: "fox") {
                let attachment = try? UNNotificationAttachment(identifier: "imageIdentifier",
                                                               url: url,
                                                               options: [:])
                
                if let attachment = attachment {
                    content.attachments.append(attachment)
                }
            }
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: sunset, repeats: false)
        print(String(format: "sunsetRequest-%02d:%02d", sunset.hour!, sunset.minute!))
        return UNNotificationRequest(identifier: String(format: "sunsetRequest-%02d:%02d", sunset.hour!, sunset.minute!), content: content, trigger: trigger)
    }
    
    
    func buildNotificationRequest(delay: Double, sound: UNNotificationSound) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Sunset Repeat Alert", comment: "")
        content.body = NSLocalizedString("Past time to put the chickens away!", comment: "")
        content.sound = sound
        content.categoryIdentifier = "repeatCategory"

        if let url = Bundle.main.url(forResource: "peckingRooster", withExtension: "gif") {
            let attachment = try? UNNotificationAttachment(identifier: "imageIdentifier",
                                                           url: url,
                                                           options: [:])
            
            if let attachment = attachment {
                content.attachments.append(attachment)
            }
        } else if let image = UIImage(named: "fox.jpg"), let url = image.saveToURL(name: "fox") {
            let attachment = try? UNNotificationAttachment(identifier: "imageIdentifier",
                                                           url: url,
                                                           options: [:])
            
            if let attachment = attachment {
                content.attachments.append(attachment)
            }
            
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(60*delay), repeats: false)
        
        return UNNotificationRequest(identifier: "sunsetRequest", content: content, trigger: trigger)
    }
    
    // MARK: - Restfull Services Protocol
    
    func didFinishPostWithError(errorMessage:String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SunsetAlertServerInitFailed"), object: nil, userInfo:["error": errorMessage])
    }
    
    
    func didFinishPost(jsonData:Dictionary<String, AnyObject>?) {
        if let jsonData = jsonData {
            if let status = jsonData["status"] as? String {
                if status == "OK" {
                    print("OK")
                } else {
                    print(status)
                }
            }
        }
    }

}

extension UIImage {
    
    func saveToURL(name: String) -> URL? {
        let imageData = UIImageJPEGRepresentation(self, 1.0)
        
        //let imageData = UIImagePNGRepresentation(self)
        let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        do {
            let imageURL = documentsURL.appendingPathComponent("\(name).jpg")
            _ = try imageData?.write(to: imageURL)
            return imageURL
        } catch {
            return nil
        }
    }

}

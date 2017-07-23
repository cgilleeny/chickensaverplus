//
//  NotificationOptionsVC.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/21/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//
/*
import UIKit
import UserNotifications
import CoreLocation

class NotificationOptionsVC: UIViewController, RestfulServicesDelegate {

    var location: CLLocation!
    
    // MARK: - View Controller Lifecycle Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Control Handlers
    
    @IBAction func finishBarButtonHandler(_ sender: UIBarButtonItem) {
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationOptionsVC.remoteNotificationAuthorizationFailed(_:)), name:NSNotification.Name(rawValue: "RemoteNotificationRegistrationError"), object: nil)
        (UIApplication.shared.delegate as! AppDelegate).coopLocation = location
        (UIApplication.shared.delegate as! AppDelegate).restfulServices.delegate = self
        let center = UNUserNotificationCenter.current()
        
        let repeat5 = UNNotificationAction(identifier: "repeat5", title: String.localizedStringWithFormat("Repeat In %d Minutes", 5), options: [])
        let repeat15 = UNNotificationAction(identifier: "repeat15", title: String.localizedStringWithFormat("Repeat In %d Minutes", 15), options: [])
        let repeat30 = UNNotificationAction(identifier: "repeat30", title: String.localizedStringWithFormat("Repeat In %d Minutes", 30), options: [])
        let category = UNNotificationCategory(identifier: "repeatCategory", actions: [repeat5, repeat15, repeat30], intentIdentifiers: [], options: [.customDismissAction])

        center.setNotificationCategories([category])
        center.requestAuthorization(options: []) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: NSLocalizedString("Remote Notification Authorization Error", comment: ""), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Button"), style: UIAlertActionStyle.cancel, handler:nil))
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })
            } else {
                if granted == true
                {
                    print("Allow")
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else
                {
                    let alert = UIAlertController(title: NSLocalizedString("Remote Notification Authorization", comment: ""), message: NSLocalizedString("Not Granted", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Button"), style: UIAlertActionStyle.cancel, handler:nil))
                    DispatchQueue.main.async(execute: {
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }
        }
    }

    // MARK: Notification Handlers
    
    @objc func remoteNotificationAuthorizationFailed(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "RemoteNotificationRegistrationError"), object: nil)
        if let error = notification.userInfo!["error"] as? NSError {
            let alert = UIAlertController(title: NSLocalizedString("Remote Notification Authorization Error", comment: ""), message: error.localizedDescription,
                preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Button"), style: UIAlertActionStyle.cancel, handler:nil))
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })
        }
    }

    // MARK: Restfull Services Protocol
    
    func didFinishPostWithError(errorMessage:String) {
        print(errorMessage)
        let alert = UIAlertController(title: NSLocalizedString("Sunset Alert Server Initialization Failed", comment: ""), message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Button"), style: UIAlertActionStyle.cancel, handler:nil))
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    
    func didFinishPost(jsonData:Dictionary<String, AnyObject>?) {
        if let jsonData = jsonData {
            if let status = jsonData["status"] as? String {
                if status == "OK" {
                    print("OK")
                } else {
                    print(status)
                    /*
                     let alert = UIAlertController(title: "API Request Failure", message: String.localizedStringWithFormat("%@ Status", status), preferredStyle: UIAlertControllerStyle.alert)
                     alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close Button"), style: UIAlertActionStyle.cancel, handler:nil))
                     DispatchQueue.main.async( execute:  {
                     self.present(alert, animated: true, completion: nil)
                     })
                     */
                }
            }
        }
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
*/

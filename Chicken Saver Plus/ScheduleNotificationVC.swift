//
//  ScheduleNotificationVC.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 1/18/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications
import UserNotificationsUI


class ScheduleNotificationVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationTypeSegmentedControl: UISegmentedControl!
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveNotification(_ sender: UIBarButtonItem) {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        
        switch notificationTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            let content = UNMutableNotificationContent()
            content.title = "It's Sunset!"
            content.subtitle = "Chicken Saver Plus presents"
            content.body = "Rich Notifications"
            content.sound = UNNotificationSound.default()

            let request = UNNotificationRequest(identifier: "requestIdentifier", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                UNUserNotificationCenter.current().delegate = self
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        case 1:
            let content = UNMutableNotificationContent()
            content.title = "It's Sunset!"
            content.subtitle = "Chicken Saver Plus presents"
            content.body = "Actionable Notifications"
            content.sound = UNNotificationSound.default()
        
            
            content.categoryIdentifier = "catgeoryIdentifier"
            let request = UNNotificationRequest(identifier: "requestIdentifier", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                UNUserNotificationCenter.current().delegate = self
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        case 2:
            let content = UNMutableNotificationContent()
            content.title = "It's Sunset!"
            content.subtitle = "Chicken Saver Plus presents"
            content.body = "Media Notifications"
            content.sound = UNNotificationSound.default()
            
            guard let url = saveImage(name: "fox.jpg") else {
                return
            }
            
            let attachment = try? UNNotificationAttachment(identifier: "imageIdentifier",
                                                           url: url,
                                                           options: [:])
            
            if let attachment = attachment {
                content.attachments.append(attachment)
            }
            let request = UNNotificationRequest(identifier: "requestIdentifier", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                UNUserNotificationCenter.current().delegate = self
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        case 3:
            let content = UNMutableNotificationContent()
            content.title = "It's Sunset!"
            content.subtitle = "Chicken Saver Plus presents"
            content.body = "Custom Notifications"
            content.sound = UNNotificationSound.default()
            
            content.categoryIdentifier = "customContentIdentifier"
            
            let request = UNNotificationRequest(identifier: "requestIdentifier", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                UNUserNotificationCenter.current().delegate = self
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"

        if let notificationDate = Calendar.current.date(from: dateComponents) {
            notificationLabel.text = String.localizedStringWithFormat("Notification Scheduled: %@", dateFormatter.string(from: notificationDate))
        }
        
    }
    
    func saveImage(name: String) -> URL? {
        
        guard let image = UIImage(named: name) else {
            return nil
        }
        
        let imageData = UIImagePNGRepresentation(image)
        let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        do {
            let imageURL = documentsURL.appendingPathComponent("\(name).png")
            _ = try imageData?.write(to: imageURL)
            return imageURL
        } catch {
            return nil
        }
    }

    
    // MARK: - UNUserNotificationDelegateProtocol
    /*
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        notificationLabel.text = "Sound is Coming!"
        completionHandler(UNNotificationPresentationOptions.sound)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "SNOOZE_ACTION" {
            notificationLabel.text = "Snoozing!"
            playSound(name: "Clucking", ext: "wav")
        } else if response.actionIdentifier == "Stopping!" {
            notificationLabel.text = "Stopping!"
            playSound(name: "Crowing", ext: "wav")
        }
    }
    */
    
    func playSound(name: String, ext: String) {
        let url = Bundle.main.url(forResource: name, withExtension: ext)!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
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

extension UIViewController: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler( [.alert, .badge, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print("Tapped in notification")
        switch response.actionIdentifier {
        case "replyIdentifier":
            print("replyIndentifier")
        default:
            print("default")
        }
    }
}

//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by Caroline Gilleeny on 1/20/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var eventImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let filePath = Bundle.main.path(forResource: "matrix", ofType: "gif")
        let gif = NSData(contentsOfFile: filePath!)!
        webView.load(gif as Data, mimeType: "image/gif", textEncodingName: String(), baseURL: URL(string: filePath!)!)
        webView.isUserInteractionEnabled = false;
        */
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        
        if let attachment = content.attachments.first {
            if attachment.url.startAccessingSecurityScopedResource() {
                eventImage.image = UIImage(contentsOfFile: attachment.url.path)
                attachment.url.stopAccessingSecurityScopedResource()
            }
        }
    }

}

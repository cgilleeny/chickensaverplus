//
//  ManageNotificationsVC.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/3/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//
/*
import UIKit
import UserNotifications

class ManageNotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var notificationRequests = [UNNotificationRequest]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ManageNotificationsVC.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            self.notificationRequests = requests.filter() {$0.identifier .contains("sunsetRequest")}
            DispatchQueue.main.async( execute:  {
                self.tableView.reloadData()
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            self.notificationRequests = requests.filter() {$0.identifier .contains("sunsetRequest")}
            refreshControl.endRefreshing()
            DispatchQueue.main.async( execute:  {
                self.tableView.reloadData()
            })
        })
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = AppColor.darkTextColor
        if let font = UIFont(name: "Noteworthy-Bold", size: 19.0) {
            (view as! UITableViewHeaderFooterView).textLabel?.font = font
            (view as! UITableViewHeaderFooterView).textLabel?.textColor = AppColor.darkestTextColor
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Future Local Notifications"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationRequestCell", for: indexPath)
        
        let notificationRequest = notificationRequests[indexPath.row]
        cell.textLabel?.text = notificationRequest.identifier
        cell.textLabel?.textColor = AppColor.darkestTextColor
        if let trigger = notificationRequest.trigger as? UNCalendarNotificationTrigger {
            if let nextTriggerDate = trigger.nextTriggerDate() as Date? {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
                cell.detailTextLabel?.text = dateFormatter.string(from: nextTriggerDate)
                cell.detailTextLabel?.textColor = AppColor.darkestTextColor
            }
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.notificationRequests[indexPath.row].identifier])
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
                self.notificationRequests = requests.filter() {$0.identifier .contains("sunsetRequest")}
                DispatchQueue.main.async( execute:  {
                    self.tableView.reloadData()
                })
            })
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

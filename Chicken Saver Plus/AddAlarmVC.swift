//
//  AddAlarmVC.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/25/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import Alamofire
import UserNotifications

class AddAlarmVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    ///The directories where we will first start looking for files as well as sub directories.
    //let rootSoundDirectories: [String] = ["/Library/Ringtones", "/System/Library/Audio/UISounds"]
    
    /*
    lazy var soundDirectories: [NSMutableDictionary] = {
        var directories = [NSMutableDictionary]()
        for directory in self.rootSoundDirectories { //seed the directories we know about.
            let newDirectory: NSMutableDictionary = [
                "path" : directory,
                "files" : []
            ]
            directories.append(newDirectory)
            let directoryURL: URL = URL(fileURLWithPath: directory, isDirectory: true)
            do {
                var URLs: [URL]?
                URLs = try FileManager().contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: FileManager.DirectoryEnumerationOptions())
                for url in URLs! {
                    //print("url.path: \(url.path)")

                    if FileManager().fileExists(atPath: url.path) {
                        let attribs: NSDictionary =
                            try FileManager().attributesOfItem(atPath: url.path) as NSDictionary
                        let fileType = attribs["NSFileType"] as! FileAttributeType
                        
                        //print("File type \(fileType)")
                        if fileType == FileAttributeType.typeDirectory {
                            let directory: String = "\(url.relativePath)"
                            let newDirectory: NSMutableDictionary = [
                                "path" : directory,
                                "files" : []
                            ]
                            directories.append(newDirectory)
                        }
                    }
                }
            } catch {
                print("failed")
            }
        }
        
        for directory in directories {
            let directoryURL: URL = URL(fileURLWithPath: directory["path"] as! String, isDirectory: true)
            do {
                var URLs: [URL]?
                URLs = try FileManager().contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: FileManager.DirectoryEnumerationOptions())
                var soundPaths: [String] = []
                for url in URLs! {
                    if FileManager().fileExists(atPath: url.path) {
                        let attribs: NSDictionary =
                            try FileManager().attributesOfItem(atPath: url.path) as NSDictionary
                        let fileType = attribs["NSFileType"] as! FileAttributeType
                        
                        //print("File type \(fileType)")
                        if fileType == FileAttributeType.typeRegular {
                            soundPaths.append(url.lastPathComponent)
                        }
                    }
                }
                directory["files"] = soundPaths
            } catch {
                print("failed")
            }

        }

        return directories
    }()
    */
    
    
    var moc: NSManagedObjectContext!
    let offsetStrings = [NSLocalizedString("30 minutes before sunset", comment: ""),
                      NSLocalizedString("25 minutes before sunset", comment: ""),
                      NSLocalizedString("20 minutes before sunset", comment: ""),
                      NSLocalizedString("15 minutes before sunset", comment: ""),
                      NSLocalizedString("10 minutes before sunset", comment: ""),
                      NSLocalizedString("5 minutes before sunset", comment: ""),
                      NSLocalizedString("Sunset", comment: ""),
                      NSLocalizedString("5 minutes after sunset", comment: ""),
                      NSLocalizedString("10 minutes after sunset", comment: ""),
                      NSLocalizedString("15 minutes after sunset", comment: ""),NSLocalizedString("20 minutes after sunset", comment: ""),NSLocalizedString("25 minutes after sunset", comment: ""),NSLocalizedString("30 minutes after sunset", comment: "")]
    
    let offsets: [Int16] = [-30, -25, -20, -15, -10, -5, 0, 5, 10, 15, 20, 25, 30]
    //var section: Int = 0
    var row: Int = 0
    var player: AVAudioPlayer?
    var alarm: Alarm?
    
    // MARK: - View Controller Lifecycle Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        for soundDirectory in soundDirectories {
            let path = soundDirectory["path"] as! String
            let files = soundDirectory["files"] as! [String]
            print("path: \(path)")
            for file in files {
                print("file: \(file)")
            }
        }
        */
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("AddAlarmVC viewWillAppear")
        if let alarm = alarm as Alarm? {
            if let index = offsets.index(of: alarm.offset!.int16Value) {
                pickerView.selectRow(index, inComponent: 0, animated: true)
            }
            if let sound = alarm.sound as String? {
                if sound == "Clucking.wav" {
                    row = 0
                } else if sound == "Crowing.wav" {
                    row = 1
                } else {
                    row = 2
                }
            }
        } else {
            pickerView.selectRow(6, inComponent: 0, animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("AddAlarmVC viewWillDisappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Control Handlers
    
    @IBAction func saveBarButtonHandler(_ sender: UIBarButtonItem) {
        do {
            var sound: String?

            switch row {
            case 0:
                sound = "Clucking.wav"
            case 1:
                sound = "Crowing.wav"
            case 2:
                sound = "Default"
            default:
                sound = "Default"
            }
            let offset = offsets[pickerView.selectedRow(inComponent: 0)] as NSNumber
            if let alarmWithOffset = try Alarm.withOffset(moc, offset: Int(offset)) {
                if let alarm = alarm as Alarm?, alarmWithOffset === alarm {
                    self.updateAlarm(parameters: ["id": Int(alarm.id!), "offset":offset, "sound":sound!, "deviceuid": UIDevice().identifierForVendor!.uuidString, "status":"active"], alarm: alarm)
                } else {
                    let title = NSLocalizedString("Duplicate Alarm Creation Error", comment: "CoreData Error")
                    let message = String.localizedStringWithFormat(NSLocalizedString("There is already an alarm set for: %@", comment: ""),  offsetStrings[pickerView.selectedRow(inComponent: 0)])
                    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close Button"), style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
                        return
                    }))
                    DispatchQueue.main.async(execute: {
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            } else {
                if let alarm = alarm as Alarm?,
                    let id = alarm.id as NSNumber? {
                    self.updateAlarm(parameters: ["id": Int(id), "offset":offset, "sound":sound!, "deviceuid": UIDevice().identifierForVendor!.uuidString, "status":"active"], alarm: alarm)
                } else {
                    self.insertAlarm(parameters:  ["offset": offset, "sound":sound!, "deviceuid": UIDevice().identifierForVendor!.uuidString, "status":"active"])
                }
            }
            
            /*
            print("offsets[pickerView.selectedRow(inComponent: 0)]: \(offsets[pickerView.selectedRow(inComponent: 0)])")
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alarm")
            
            if let alarms = try moc.fetch(fetchRequest) as? [Alarm] {
                
                if let alarmWithOffset = alarms.first(where: {$0.offset == offset}) {
                    if let alarm = alarm as Alarm? {
                        if alarmWithOffset === alarm /*, let id = alarm.id as NSNumber?*/  {
                            self.updateAlarm(parameters: ["id": Int(alarm.id!), "offset":offset, "sound":sound!, "deviceuid": UIDevice().identifierForVendor!.uuidString, "status":"active"], alarm: alarm)
                            //alarm.sound = sound
                            //try self.moc.save()
                            //DispatchQueue.main.async(execute: {
                            //    _ = self.navigationController?.popViewController(animated: true)
                            //})
                        } else {
                            let title = NSLocalizedString("Duplicate Alarm Creation Error", comment: "CoreData Error")
                            let message = String.localizedStringWithFormat(NSLocalizedString("There is already an alarm set for: %@", comment: ""),  offsetStrings[pickerView.selectedRow(inComponent: 0)])
                            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close Button"), style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
                                return
                            }))
                            DispatchQueue.main.async(execute: {
                                self.present(alert, animated: true, completion: nil)
                            })
                        }
                    }
                } else {
                    if let alarm = alarm as Alarm?,
                        let id = alarm.id as NSNumber? {
                        self.updateAlarm(parameters: ["id": Int(id), "offset":offset, "sound":sound!, "deviceuid": UIDevice().identifierForVendor!.uuidString, "status":"active"], alarm: alarm)
                        //alarm.offset = offset
                        //alarm.sound = sound
                        //try self.moc.save()
                    } else {
                        self.insertAlarm(parameters:  ["offset": offset, "sound":sound!, "deviceuid": UIDevice().identifierForVendor!.uuidString, "status":"active"])
                        //try Alarm.create(self.moc, offset: offset, sound: sound!)
                    }
                    //DispatchQueue.main.async(execute: {
                    //    _ = self.navigationController?.popViewController(animated: true)
                    //})
                }
            }
            */
        } catch {
            let title = NSLocalizedString("CoreData Error", comment: "CoreData Error")
            let message = String.localizedStringWithFormat(NSLocalizedString("fetchedResultsController.performFetch for Alarm failed: %@", comment: "fetchedResultsController.performFetch error"), "\(error)")
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close Button"), style: UIAlertActionStyle.cancel, handler:{ [weak self] (UIAlertAction)in
                DispatchQueue.main.async(execute: {
                    _ = self?.navigationController?.popViewController(animated: true)
                })
                
            }))

            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })
        }
    }

    
    // MARK: - Utilities
    
    
    public func insertAlarm(parameters: [String: Any]) {
        let path = String(format: "%@Alarms", host)
        activityIndicator.startAnimating()
        Alamofire.request(URL(string: path)!,
                          method: .post, parameters: parameters)
            .responseJSON { response in
                self.activityIndicator.stopAnimating()
                guard response.result.isSuccess else {
                    self.didFinishInsertAlarmWithError(errorMessage: String(describing: response.result.error?.localizedDescription ?? "Unknown Error"), parameters: parameters)
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: Any] else {
                    self.didFinishInsertAlarmWithError(errorMessage: NSLocalizedString("Error parsing JSON response", comment: ""), parameters: parameters)
                    return
                }
                
                if let status = responseJSON["status"] as? String {
                    if status != "OK" {
                        print(status)
                        self.didFinishInsertAlarmWithError(errorMessage: status, parameters: parameters)
                    } else {
                        if let result = responseJSON["result"] as? Int {
                            do {
                                try Alarm.create(self.moc, id: result, dictionary: parameters)
                                DispatchQueue.main.async(execute: {
                                    _ = self.navigationController?.popViewController(animated: true)
                                })
                            } catch {
                                self.didFinishInsertAlarmWithError(errorMessage: NSLocalizedString("Error creating CoreData Alarm entity", comment: ""), parameters: parameters)
                            }
                        } else {
                            self.didFinishInsertAlarmWithError(errorMessage: NSLocalizedString("Missing 'result' in json response: ", comment: ""), parameters: parameters)
                        }
                    }
                } else {
                    self.didFinishInsertAlarmWithError(errorMessage: NSLocalizedString("Missing 'status' in json response: ", comment: ""), parameters: parameters)
                }
        }
    }
    
    public func updateAlarm(parameters: [String: Any], alarm: Alarm) {
        let path = String(format: "%@Alarms", host)
        activityIndicator.startAnimating()
        Alamofire.request(URL(string: path)!,
                          method: .post, parameters: parameters)
            .responseJSON { response in
                self.activityIndicator.stopAnimating()
                guard response.result.isSuccess else {
                    self.didFinishUpdateAlarmWithError(errorMessage: String(describing: response.result.error?.localizedDescription ?? "Unknown Error"), parameters: parameters, alarm: alarm)
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: Any] else {
                    self.didFinishUpdateAlarmWithError(errorMessage: NSLocalizedString("Error parsing JSON response", comment: ""), parameters: parameters, alarm: alarm)
                    return
                }
                
                if let status = responseJSON["status"] as? String {
                    if status != "OK" {
                        print(status)
                        self.didFinishUpdateAlarmWithError(errorMessage: status, parameters: parameters, alarm: alarm)
                    } else {
                        if let result = responseJSON["result"] as? Int {
                            do {
                                if let sound = parameters["sound"] as! String?,
                                    let offset = parameters["offset"] as! Int? {
                                    alarm.id = NSNumber(value: result)
                                    alarm.offset = NSNumber(value: offset)
                                    alarm.sound = sound
                                    try self.moc.save()
                                    DispatchQueue.main.async(execute: {
                                        _ = self.navigationController?.popViewController(animated: true)
                                    })
                                }
                            } catch {
                                self.didFinishUpdateAlarmWithError(errorMessage: NSLocalizedString("Error updating CoreData Alarm entity", comment: ""), parameters: parameters, alarm: alarm)
                            }
                        } else {
                            self.didFinishUpdateAlarmWithError(errorMessage: NSLocalizedString("Missing 'result' in json response: ", comment: ""), parameters: parameters, alarm: alarm)
                        }
                    }
                } else {
                    self.didFinishUpdateAlarmWithError(errorMessage: NSLocalizedString("Missing 'status' in json response: ", comment: ""), parameters: parameters, alarm: alarm)
                }
        }
    }
    
    func playSound(url: URL) {
        do {
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
            let alert = UIAlertController(title: NSLocalizedString("Audio Player Error", comment: ""), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Button"), style: UIAlertActionStyle.cancel, handler:nil))
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })
        }
    }

    // MARK: - Alamofire Protocol
    
    func didFinishInsertAlarmWithError(errorMessage:String, parameters: [String:Any]) {
        let alert = UIAlertController(title: NSLocalizedString("Error Creating Server Alarm Record", comment: ""), message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertActionStyle.cancel, handler:nil))
        print("Contact management")
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: UIAlertActionStyle.default, handler:{(alert: UIAlertAction!) in
            self.insertAlarm(parameters: parameters)
        }))
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    
    func didFinishUpdateAlarmWithError(errorMessage:String, parameters: [String:Any], alarm: Alarm) {
        let alert = UIAlertController(title: NSLocalizedString("Error Updating Server Alarm Record", comment: ""), message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertActionStyle.cancel, handler:nil))
        print("Contact management")
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: UIAlertActionStyle.default, handler:{(alert: UIAlertAction!) in
            self.updateAlarm(parameters: parameters, alarm: alarm)
        }))
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    // MARK: - pickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return offsetStrings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return offsetStrings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        if let font = UIFont(name: "Noteworthy-Bold", size: 19.0) {
            label?.font = font
        }
        label?.textColor = AppColor.darkerYetTextColor
        label?.text =  offsetStrings[row]
        label?.textAlignment = .center
        return label!
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
 
        return 66.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Alarm Sounds"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = AppColor.paleGoldColor
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell", for: indexPath)
        cell.tintColor = AppColor.darkerYetTextColor
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Clucking"
        case 1:
            cell.textLabel?.text = "Crowing"
        case 2:
            cell.textLabel?.text = "Default Notification Sound"
        default:
            cell.textLabel?.text = "Unknown Sound"
        }
        if indexPath.row == row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        let previousCell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
        previousCell?.accessoryType = .none
        row = indexPath.row
        switch indexPath.row {
        case 0:
            if let url = Bundle.main.url(forResource: "Clucking", withExtension: "wav") as URL? {
                playSound(url: url)
            }
        case 1:
            if let url = Bundle.main.url(forResource: "Crowing", withExtension: "wav") as URL? {
                playSound(url: url)
            }
        case 2:
            // can't play the defaul user notification system sound
            break
        default:
            break
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

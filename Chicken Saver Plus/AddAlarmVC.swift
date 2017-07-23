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
import UserNotifications

class AddAlarmVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    ///The directories where we will first start looking for files as well as sub directories.
    let rootSoundDirectories: [String] = ["/Library/Ringtones", "/System/Library/Audio/UISounds"]
    
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
    var section: Int = 0
    var row: Int = 0
    var player: AVAudioPlayer?
    var alarm: Alarm?
    
    // MARK: - View Controller Lifecycle Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for soundDirectory in soundDirectories {
            let path = soundDirectory["path"] as! String
            let files = soundDirectory["files"] as! [String]
            print("path: \(path)")
            for file in files {
                print("file: \(file)")
            }
        }
        
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
                if sound == "Clucking" {
                    section = 0
                    row = 0
                } else if sound == "Crowing" {
                    section = 0
                    row = 1
                } else {
                    for index in 0..<soundDirectories.count {
                        let directory = soundDirectories[index]
                        let files = directory["files"] as! [String]
                        if files.contains(sound) {
                            section = index + 1
                            row = files.index(of: sound)!
                            break
                        }
                    }
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
            //var ext: String?
            
            if section == 0 {
                if row == 0 {
                    sound = "Clucking"
                    //ext = "ext"
                } else {
                    sound = "Crowing"
                    //ext = "ext"
                }
            } else {
                let directory = soundDirectories[section - 1]
                let files = directory["files"] as! [String]
                let path = directory["path"] as! String
                let filePath: String = String(format: "%@/%@", path, files[row])
                let url: URL = URL(fileURLWithPath: filePath)
                sound = filePath
                //sound = files[row]
            }
            print("offsets[pickerView.selectedRow(inComponent: 0)]: \(offsets[pickerView.selectedRow(inComponent: 0)])")
            if let alarm = alarm as Alarm? {
                alarm.offset = offsets[pickerView.selectedRow(inComponent: 0)] as NSNumber?
                alarm.sound = sound
                try self.moc.save()
            } else {
                try Alarm.create(self.moc, offset: offsets[pickerView.selectedRow(inComponent: 0)], sound: sound!)
            }

            DispatchQueue.main.async(execute: {
                _ = self.navigationController?.popViewController(animated: true)
            })
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
        if section == 0 {
            return "Chicken Sounds"
        }
        let directory = soundDirectories[section - 1]
        return directory["path"] as? String
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = AppColor.paleGoldColor
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let soundDirectories = soundDirectories as [NSMutableDictionary]? {
            return soundDirectories.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        if let directory = soundDirectories[section - 1] as NSMutableDictionary? {
            if let files = directory["files"] as! [String]? {
                return files.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell", for: indexPath)
        cell.tintColor = AppColor.darkerYetTextColor
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Clucking"
            } else {
                cell.textLabel?.text = "Crowing"
            }
        } else {
            let directory = soundDirectories[indexPath.section - 1]
            let files = directory["files"] as! [String]
            cell.textLabel?.text = files[indexPath.row]
        }
        if indexPath.section == section && indexPath.row == row {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        let previousCell = tableView.cellForRow(at: IndexPath(row: row, section: section))
        previousCell?.accessoryType = .none
        row = indexPath.row
        section = indexPath.section
        if section == 0 {
            if row == 0 {
                if let url = Bundle.main.url(forResource: "Clucking", withExtension: "wav") as URL? {
                    playSound(url: url)
                }
            } else {
                if let url = Bundle.main.url(forResource: "Crowing", withExtension: "wav") as URL? {
                    playSound(url: url)
                }
            }
        } else {
            let directory = soundDirectories[section - 1]
            let path = directory["path"] as! String
            let files = directory["files"] as! [String]
            let filePath: String = String(format: "%@/%@", path, files[row])
            let url: URL = URL(fileURLWithPath: filePath)
            playSound(url: url)
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

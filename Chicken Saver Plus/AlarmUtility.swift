//
//  AlarmUtility.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 2/12/21.
//  Copyright © 2021 Caroline Gilleeny. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire


protocol AlarmUtilityDelegate: class {
  func didFinishInsertAlarm(didInsert:Bool, id:Int, parameters:[String: Any])
  func didFinishUpdateAlarm(didUpdate:Bool, id:Int, parameters:[String: Any], alarm: Alarm)
  func didFinishDeleteAlarm(didDelete:Bool, alarm:Alarm)
}

public class AlarmUtility {
  
  var activityIndicator: UIActivityIndicatorView?
  var parentVC:UIViewController?
  var moc: NSManagedObjectContext?
  weak var delegate:AlarmUtilityDelegate?
  
  public func insertAlarm(parameters: [String: Any]) {
      let path = String(format: "%@Alarms", host)
      activityIndicator?.startAnimating()
      Alamofire.request(URL(string: path)!,
                        method: .post, parameters: parameters)
          .responseJSON { response in
              self.activityIndicator?.stopAnimating()
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
                        self.delegate?.didFinishInsertAlarm(didInsert:true, id: result, parameters: parameters)
//                          do {
//                              try Alarm.create(self.moc, id: result, dictionary: parameters)
//                              DispatchQueue.main.async(execute: {
//                                _ = self.parentVC?.navigationController?.popViewController(animated: true)
//                              })
//                          } catch {
//                              self.didFinishInsertAlarmWithError(errorMessage: NSLocalizedString("Error creating CoreData Alarm entity", comment: ""), parameters: parameters)
//                          }
                      } else {
                          self.didFinishInsertAlarmWithError(errorMessage: NSLocalizedString("Missing 'result' in json response: ", comment: ""), parameters: parameters)
                      }
                  }
              } else {
                  self.didFinishInsertAlarmWithError(errorMessage: NSLocalizedString("Missing 'status' in json response: ", comment: ""), parameters: parameters)
              }
      }
  }
  
  public func updateAlarm(alarm: Alarm) {
    if let id = alarm.id,
       let offset = alarm.offset,
       let sound = alarm.sound,
       let identifierForVendor = UIDevice().identifierForVendor {
        let parameters = ["id": Int(truncating: id), "offset":Int(truncating: offset), "sound":sound, "deviceuid": identifierForVendor.uuidString, "status":"active"] as [String : Any]
        let path = String(format: "%@Alarms", host)
        activityIndicator?.startAnimating()
        Alamofire.request(URL(string: path)!,
                        method: .post, parameters: parameters)
          .responseJSON { response in
              self.activityIndicator?.stopAnimating()
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
                      self.delegate?.didFinishUpdateAlarm(didUpdate: true, id: result, parameters: parameters, alarm: alarm)
                    }
                  }
              } else {
                  self.didFinishUpdateAlarmWithError(errorMessage: NSLocalizedString("Missing 'status' in json response: ", comment: ""), parameters: parameters, alarm: alarm)
              }
          }
      }
  }
  
  public func updateAlarm(parameters: [String: Any], alarm: Alarm) {
      let path = String(format: "%@Alarms", host)
      activityIndicator?.startAnimating()
      Alamofire.request(URL(string: path)!,
                        method: .post, parameters: parameters)
          .responseJSON { response in
              self.activityIndicator?.stopAnimating()
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
                        self.delegate?.didFinishUpdateAlarm(didUpdate: true, id: result, parameters: parameters, alarm: alarm)
//                          do {
//                              if let sound = parameters["sound"] as! String?,
//                                  let offset = parameters["offset"] as! Int? {
//                                  alarm.id = NSNumber(value: result)
//                                  alarm.offset = NSNumber(value: offset)
//                                  alarm.sound = sound
//                                  try self.moc.save()
//                                  DispatchQueue.main.async(execute: {
//                                    _ = self.parentVC?.navigationController?.popViewController(animated: true)
//                                  })
//                              }
//                          } catch {
//                              self.didFinishUpdateAlarmWithError(errorMessage: NSLocalizedString("Error updating CoreData Alarm entity", comment: ""), parameters: parameters, alarm: alarm)
//                          }
                      } else {
                          self.didFinishUpdateAlarmWithError(errorMessage: NSLocalizedString("Missing 'result' in json response: ", comment: ""), parameters: parameters, alarm: alarm)
                      }
                  }
              } else {
                  self.didFinishUpdateAlarmWithError(errorMessage: NSLocalizedString("Missing 'status' in json response: ", comment: ""), parameters: parameters, alarm: alarm)
              }
      }
  }
  
  public func deleteAlarm(alarm: Alarm) {
    let parameters = ["id": Int(truncating: alarm.id!), "offset":Int(truncating: alarm.offset!), "sound":alarm.sound!, "deviceuid": UIDevice().identifierForVendor!.uuidString, "status":"inactive"] as [String : Any]
      let path = String(format: "%@Alarms", host)
      activityIndicator?.startAnimating()
      Alamofire.request(URL(string: path)!,
                        method: .post, parameters: parameters)
          .responseJSON { response in
              self.activityIndicator?.stopAnimating()
              guard response.result.isSuccess else {
                  self.didFinishDeleteAlarmWithError(errorMessage: String(describing: response.result.error?.localizedDescription ?? "Unknown Error"), alarm: alarm)
                  return
              }
              
              guard let responseJSON = response.result.value as? [String: Any] else {
                  self.didFinishDeleteAlarmWithError(errorMessage: NSLocalizedString("Error parsing JSON response", comment: ""), alarm: alarm)
                  return
              }
              
              if let status = responseJSON["status"] as? String {
                  if status != "OK" {
                      print(status)
                      self.didFinishDeleteAlarmWithError(errorMessage: status, alarm: alarm)
                  } else {
                      if let _ = responseJSON["result"] as? Int {
                        self.delegate?.didFinishDeleteAlarm(didDelete: true, alarm: alarm)
//                          do {
//                              self.moc.delete(alarm)
//                              try self.moc.save()
//                              self.tableView.reloadData()
//                          } catch {
//                              self.didFinishDeleteAlarmWithError(errorMessage: NSLocalizedString("Error updating CoreData Alarm entity", comment: ""), alarm: alarm)
//                          }
                      } else {
                          self.didFinishDeleteAlarmWithError(errorMessage: NSLocalizedString("Missing 'result' in json response: ", comment: ""), alarm: alarm)
                      }
                  }
              } else {
                  self.didFinishDeleteAlarmWithError(errorMessage: NSLocalizedString("Missing 'status' in json response: ", comment: ""), alarm: alarm)
              }
      }
  }
  
  // MARK: - Alamofire Protocol
  
  func didFinishInsertAlarmWithError(errorMessage:String, parameters: [String:Any]) {
    let alert = UIAlertController(title: NSLocalizedString("Error Creating Server Alarm Record", comment: ""), message: errorMessage, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertAction.Style.cancel, handler:{(alert: UIAlertAction!) in
      self.delegate?.didFinishInsertAlarm(didInsert: false, id: 0, parameters: parameters)
  }))
      print("Contact management")
      
    alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: UIAlertAction.Style.default, handler:{(alert: UIAlertAction!) in
      self.insertAlarm(parameters: parameters)
      }))
      DispatchQueue.main.async(execute: {
        self.parentVC?.present(alert, animated: true, completion: nil)
      })
  }
  
  
  func didFinishUpdateAlarmWithError(errorMessage:String, parameters: [String:Any], alarm: Alarm) {
    let alert = UIAlertController(title: NSLocalizedString("Error Updating Server Alarm Record", comment: ""), message: errorMessage, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertAction.Style.cancel, handler:{(alert: UIAlertAction!) in
      self.delegate?.didFinishUpdateAlarm(didUpdate: false, id: 0, parameters: parameters, alarm: alarm)
  }))
      
    alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: UIAlertAction.Style.default, handler:{(alert: UIAlertAction!) in
          self.updateAlarm(parameters: parameters, alarm: alarm)
      }))
      DispatchQueue.main.async(execute: {
        self.parentVC?.present(alert, animated: true, completion: nil)
      })
  }
  
  
  func didFinishDeleteAlarmWithError(errorMessage:String, alarm: Alarm) {
    let alert = UIAlertController(title: NSLocalizedString("Error Deleting Server Alarm Record", comment: ""), message: errorMessage, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertAction.Style.cancel, handler:{(alert: UIAlertAction!) in
      self.delegate?.didFinishDeleteAlarm(didDelete: false, alarm: alarm)
  }))
      
    alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: UIAlertAction.Style.default, handler:{(alert: UIAlertAction!) in
          self.deleteAlarm(alarm: alarm)
      }))
      DispatchQueue.main.async(execute: {
          self.parentVC?.present(alert, animated: true, completion: nil)
      })
  }
}

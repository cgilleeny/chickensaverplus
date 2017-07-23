//
//  APIHelper.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 1/17/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//
/*
import Foundation

class APIHelper:AnyObject, RestfulServicesGetDelegate {
    
    var restfulServices = RestfulServices()
    
    // MARK: - RestfulServicesGetDelegate
    
    func didFinishGet(jsonData:Dictionary<String, AnyObject>) {
        DispatchQueue.main.async( execute:  {
            //self.activityIndicator.stopAnimating()
        })
        if let status = jsonData["status"] as? String {
            if status == "OK" {
                if let results = jsonData["results"] as? Dictionary<String, AnyObject> {
                    do {
                        try Day.create(self.moc, date: Date(), dictionary: results)
                    } catch let error as NSError{
                        let alert = UIAlertController(title: "CoreData Failure", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close Button"), style: UIAlertActionStyle.cancel, handler:nil))
                        DispatchQueue.main.async( execute:  {
                            self.present(alert, animated: true, completion: nil)
                        })
                        
                    }
                }
            } else {
                let alert = UIAlertController(title: "API Request Failure", message: String.localizedStringWithFormat("%@ Status", status), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close Button"), style: UIAlertActionStyle.cancel, handler:nil))
                DispatchQueue.main.async( execute:  {
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    func didFinishGetWithError(errorMessage:String) {
        let alert = UIAlertController(title: "API Request Failure", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close Button"), style: UIAlertActionStyle.cancel, handler:nil))
        DispatchQueue.main.async( execute:  {
            self.present(alert, animated: true, completion: nil)
        })
    }

}
*/

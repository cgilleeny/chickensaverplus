//
//  ViewController.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 1/10/16.
//  Copyright © 2016 Caroline Gilleeny. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ViewController: UIViewController, RestfulServicesDelegate {

    var moc: NSManagedObjectContext!
    var restfulServices = RestfulServices()
    
    /*
    lazy var breeds: [Breed] = {
        var chickenBreeds = [Breed]()
        var error: NSError?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Breed")
        let count = try! self.moc.count(for: fetchRequest)
        if count == 0
        {
            if let path = Bundle.main.path(forResource: "breed", ofType: "plist") {
                if let chickens = NSArray(contentsOfFile: path) as? [[String:AnyObject]] {
                    for chicken in chickens {
                        do {
                            try Breed.create(self.moc, dictionary: chicken)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
        var fetchedResults = try! self.moc.fetch(fetchRequest) as? [Breed]
        if let results = fetchedResults {
            chickenBreeds = results
        }
        return chickenBreeds
    }()
    */
    
    lazy var eggspressions: [String] = {
        var strings = [String]()
        if let path = Bundle.main.path(forResource: "expressions", ofType: "plist") {
            if let expressions = NSArray(contentsOfFile: path) as? [String] {
                strings = expressions
            }
        }
        return strings
    }()
    
    lazy var trivia: [String] = {
        var strings = [String]()
        if let path = Bundle.main.path(forResource: "trivia", ofType: "plist") {
            if let chickenTrivia = NSArray(contentsOfFile: path) as? [String] {
                strings = chickenTrivia
            }
        }
        return strings
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restfulServices.delegate = self

        for str in trivia {
            print(str)
        }
        
        for str in eggspressions {
            print(str)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    @IBAction func buttonHandler(_ sender: UIButton) {
        for breed in breeds {
            //print(breed.name!)
            print(breed.name!)
            if let varieties = breed.varieties!.allObjects as? [Variety] {
                for variety in varieties {
                    print(" \(variety.name!)")
                }
            }
            if let eggColors = breed.eggColors!.allObjects as? [EggColor] {
                for eggColor in eggColors {
                    print(" \(eggColor.color!)")
                }
            }
            if let specialAttributes = breed.specialAttributes!.allObjects as? [SpecialAttribute] {
                for specialAttribute in specialAttributes {
                    print(" \(specialAttribute.attribute!)")
                }
            }
        }
    }
    */
    //
    @IBAction func GetGoogleTimeZone(_ sender: Any) {
        if let location = (UIApplication.shared.delegate as! AppDelegate).location {
            let timeZoneRequest = String.localizedStringWithFormat("https://maps.googleapis.com/maps/api/timezone/json?location=%f,%f&timestamp=%@&key=%@", location.coordinate.latitude, location.coordinate.longitude, Date().timeIntervalSince1970.description, GoogleAPIKey)
            print(timeZoneRequest)
            restfulServices.get(timeZoneRequest)
        }
    }
    
    @IBAction func ApiTestHandler(_ sender: UIButton) {
        
        
        //https://maps.googleapis.com/maps/api/timezone/json?location=39.6034810,-119.6822510&timestamp=1331161200&key=YOUR_API_KEY
        
        
        let APIRequest = "http://api.sunrise-sunset.org/json?lat=48.0&lng=-123.0&date=2016-06-24&formatted=0"

        restfulServices.get(APIRequest)
    }
    
    @IBAction func ScheduleA(_ sender: UIButton) {
    }

    // MARK: - RestfulServicesGetDelegate
    
    func didFinishGet(jsonData:Dictionary<String, AnyObject>) {
        //DispatchQueue.main.async( execute:  {
            //self.activityIndicator.stopAnimating()
        //})
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

    
    @IBAction func tomcatFileUploadTestHandler(_ sender: UIButton) {
        let request = "https://IBAF.avalancheevantage.com/MobileProService/OrderFunnel?Json={\"distributorId\":\"TC\",\"orderNo\":\"FAC0000014\"}"
        //let request = "http://10.0.1.88:8080/MobileProService/OrderFunnel?Json={\"distributorId\":\"Test\",\"orderNo\":\"FAC0000014\"}"
        let xml = "<?xml version = '1.0'?><ORDER><H><H1>MA00041269</H1><H2>02/03/2016</H2><H3></H3><H4></H4><H5></H5><H6>Yo momma</H6><H7>FAC0000014</H7><H8></H8><H9></H9><H10>FAC0000014</H10><H11></H11><H12></H12><H13></H13><H14></H14><H15></H15><H16></H16><R><R1>84135323</R1><R2></R2><R3></R3><R4></R4><R5>1</R5><R6>0</R6><R7>0</R7><R8>0</R8><R9></R9></R><R><R1>84139983</R1><R2></R2><R3></R3><R4></R4><R5>1</R5><R6>0</R6><R7>0</R7><R8>0</R8><R9></R9></R><R><R1>84116546</R1><R2></R2><R3></R3><R4></R4><R5>1</R5><R6>0</R6><R7>0</R7><R8>0</R8><R9></R9></R><R><R1>84139982</R1><R2></R2><R3></R3><R4></R4><R5>1</R5><R6>0</R6><R7>0</R7><R8>0</R8><R9></R9></R></H></ORDER>"
        if let data = xml.data(using: String.Encoding.utf8) as Data? {
            restfulServices.xmlDataUpload(request, withXMLData: data, completion: {(result: [String:AnyObject]?, error: NSError?) -> Void in
                if let error = error as NSError? {
                    print(error)
                } else {
                    print(result ?? "result is nil")
                }

            })
        }
    }
}


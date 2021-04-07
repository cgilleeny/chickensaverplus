//
//  MapVC.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/20/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import UserNotifications
import CoreData



class MapVC: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, AlamofireDelegate, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let infoText = ["Coop location required for sunset alerts.  Long press the map to drop a pin within 25 miles of your coop location.", "Coop location required for sunset alerts.  Long press the map to drop a pin at a better location if the current location is off by more than 25 miles."]
    var moc: NSManagedObjectContext!
    var annotation: MKPointAnnotation?
    var coopAnnotation: CoopAnnotation?
    weak var delegate:AlamofireDelegate?
    var infoBarButtonItem: UIBarButtonItem?
    var showDetailCallout: Bool = false
    
    
    lazy var fetchedResultsController : NSFetchedResultsController<Alarm> = {
        var frc : NSFetchedResultsController<Alarm> = NSFetchedResultsController()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alarm")

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "offset", ascending: true)]
        frc = NSFetchedResultsController(fetchRequest: fetchRequest as! NSFetchRequest<Alarm>, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
            let sectionInfo = frc.sections![0]
            if sectionInfo.numberOfObjects == 0 {
                self.insertAlarm(parameters: ["offset": 0, "sound":"Clucking.wav", "deviceuid": UIDevice().identifierForVendor!.uuidString, "status":"active"])
                //try Alarm.create(self.moc, offset: 0, sound: "Clucking")
            } else {
                if let alarms = frc.fetchedObjects {
                    for alarm in alarms {
                        self.updateAlarm(alarm: alarm)
                    }
                }
            }
        } catch {
            let title = NSLocalizedString("CoreData Error", comment: "CoreData Error")
            let message = String.localizedStringWithFormat(NSLocalizedString("fetchedResultsController.performFetch for Alarm failed: %@", comment: "fetchedResultsController.performFetch error"), "\(error)")
          let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close Button"), style: UIAlertAction.Style.cancel, handler:nil))
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })
        }
        
        return frc
    }()
    
    // MARK: - View Controller Lifecycle Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(MapVC.infoBarButtonHandler(_:)), for: .touchUpInside)
        infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.leftBarButtonItem = infoBarButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapVC.locationUpdate(_:)), name:NSNotification.Name(rawValue: "LocationUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapVC.remoteNotificationAuthorizationFailed(_:)), name:NSNotification.Name(rawValue: "RemoteNotificationRegistrationError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapVC.sunsetAlertServerInitFailed(_:)), name:NSNotification.Name(rawValue: "SunsetAlertServerInitFailed"), object: nil)

        if let coopLocation = (UIApplication.shared.delegate as! AppDelegate).coopLocation as CLLocation? {
            addPin(location: coopLocation)
        } else if !CLLocationManager.locationServicesEnabled() || (CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted) {
            performSegue(withIdentifier: "InfoAlertSegue", sender: self)
        } else if let location = (UIApplication.shared.delegate as! AppDelegate).location {
            (UIApplication.shared.delegate as! AppDelegate).coopLocation = location
            addPin(location: location)
            
            if let _ = (UIApplication.shared.delegate as! AppDelegate).token as String? {
                (UIApplication.shared.delegate as! AppDelegate).updateForRemoteNotifications()
            }
            
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(MapVC.locationUpdate(_:)), name:NSNotification.Name(rawValue: "LocationUpdate"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(MapVC.locationAuthorizationDenied(_:)), name:NSNotification.Name(rawValue: "LocationAuthorizationDenied"), object: nil)
            activityIndicator.startAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
        mapView.setNeedsDisplay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("MapVC viewWillDisappear")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "RemoteNotificationRegistrationError"), object: nil)
        NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "SunsetAlertServerInitFailed"), object: nil)
    }

    // MARK: - Control Handlers
    
    @IBAction func infoBarButtonHandler(_ sender: UIBarButtonItem) {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let infoVC = storyboard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
        infoVC.info = (UIApplication.shared.delegate as! AppDelegate).coopLocation == nil ? infoText[0] : infoText[1]
        infoVC.modalPresentationStyle = .popover
        infoVC.preferredContentSize = CGSize(width: 275, height: 250)
        
        let popoverInfoVC = infoVC.popoverPresentationController
        
        popoverInfoVC?.delegate = self
        popoverInfoVC?.barButtonItem = infoBarButtonItem
        DispatchQueue.main.async(execute: {
            self.present(
                infoVC,
                animated: true,
                completion: nil)
        })

    }
    
    
    @IBAction func infoCalloutButtonHandler(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let infoVC = storyboard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
        infoVC.info = infoText[1]
        infoVC.modalPresentationStyle = .popover
        infoVC.preferredContentSize = CGSize(width: 275, height: 250)
        
        let popoverInfoVC = infoVC.popoverPresentationController
        
        popoverInfoVC?.delegate = self
        popoverInfoVC?.sourceRect = sender.bounds

        DispatchQueue.main.async(execute: {
            self.present(
                infoVC,
                animated: true,
                completion: nil)
        })
    }
    

    
    @IBAction func longPressGestureHandler(_ sender: UILongPressGestureRecognizer) {
      if sender.state == UIGestureRecognizer.State.ended {
            NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "LocationUpdate"), object: nil)
            NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "LocationAuthorizationDenied"), object: nil)
            activityIndicator.stopAnimating()
            let point = sender.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            (UIApplication.shared.delegate as! AppDelegate).coopLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

            if let _ = (UIApplication.shared.delegate as! AppDelegate).token as String? {
                (UIApplication.shared.delegate as! AppDelegate).updateForRemoteNotifications()
            }

            if let annotation = annotation as MKPointAnnotation? {
                annotation.coordinate = coordinate
                mapView.showAnnotations([self.annotation!], animated: true)
            } else {
                addPin(location: (UIApplication.shared.delegate as! AppDelegate).coopLocation!)
            }
            print("pressing here: \(point), coordinate: \(coordinate)")
        }
    }
    
    // MARK: - Notification Handlers
    
    @objc func locationUpdate(_ notification: Notification) {
        if let latitude = notification.userInfo!["latitude"] as? Double, let longitude = notification.userInfo!["longitude"] as? Double {
            NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "LocationUpdate"), object: nil)
            NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "LocationAuthorizationDenied"), object: nil)
            activityIndicator.stopAnimating()
            (UIApplication.shared.delegate as! AppDelegate).coopLocation = CLLocation(latitude: latitude, longitude: longitude)

            addPin(location: (UIApplication.shared.delegate as! AppDelegate).coopLocation!)

            if let _ = (UIApplication.shared.delegate as! AppDelegate).token as String? {
                (UIApplication.shared.delegate as! AppDelegate).updateForRemoteNotifications()
            }
        }
    }
    
    
    @objc func locationAuthorizationDenied(_ notification: Notification) {
        if let status = notification.userInfo!["status"] as? CLAuthorizationStatus {
            NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "LocationUpdate"), object: nil)
            NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "LocationAuthorizationDenied"), object: nil)
            activityIndicator.stopAnimating()
            let alert = UIAlertController(title: String(format: "Location Services %@", status == CLAuthorizationStatus.denied ? "Denied" : "Restricted"), message: "Coop location required for sunset alerts.  Long press the map to drop a pin at your coop location.",
                                          preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Button"), style: UIAlertAction.Style.cancel, handler:nil))
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    @objc func remoteNotificationAuthorizationFailed(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "RemoteNotificationRegistrationError"), object: nil)
        if let error = notification.userInfo!["error"] as? NSError {
            let alert = UIAlertController(title: NSLocalizedString("Remote Notification Authorization Error", comment: ""), message: error.localizedDescription,
                                          preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Button"), style: UIAlertAction.Style.cancel, handler:nil))
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    @objc func sunsetAlertServerInitFailed(_ notification: Notification) {
        if let errorMessage = notification.userInfo!["errorMessage"] as? String {
            let alert = UIAlertController(title: NSLocalizedString("Device Initialization Failed", comment: ""), message: errorMessage,
                                          preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Button"), style: UIAlertAction.Style.cancel, handler:nil))
          alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: UIAlertAction.Style.default, handler:{(alert: UIAlertAction!) in
                (UIApplication.shared.delegate as! AppDelegate).updateForRemoteNotifications()
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
    
    
    public func deleteAlarm(alarm: Alarm) {
      let parameters = ["id": Int(truncating: alarm.id!), "offset":Int(truncating: alarm.offset!), "sound":alarm.sound!, "deviceuid": UIDevice().identifierForVendor!.uuidString, "status":"inactive"] as [String : Any]
        let path = String(format: "%@Alarms", host)
        activityIndicator.startAnimating()
        Alamofire.request(URL(string: path)!,
                          method: .post, parameters: parameters)
            .responseJSON { response in
                self.activityIndicator.stopAnimating()
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
                            do {
                                self.moc.delete(alarm)
                                try self.moc.save()
                                self.tableView.reloadData()
                            } catch {
                                self.didFinishDeleteAlarmWithError(errorMessage: NSLocalizedString("Error updating CoreData Alarm entity", comment: ""), alarm: alarm)
                            }
                        } else {
                            self.didFinishDeleteAlarmWithError(errorMessage: NSLocalizedString("Missing 'result' in json response: ", comment: ""), alarm: alarm)
                        }
                    }
                } else {
                    self.didFinishDeleteAlarmWithError(errorMessage: NSLocalizedString("Missing 'status' in json response: ", comment: ""), alarm: alarm)
                }
        }
    }

    
    public func updateAlarm(alarm: Alarm) {
      let parameters = ["id": Int(truncating: alarm.id!), "offset":Int(truncating: alarm.offset!), "sound":alarm.sound!, "deviceuid": UIDevice().identifierForVendor!.uuidString, "status":"active"] as [String : Any]
        let path = String(format: "%@Alarms", host)
        activityIndicator.startAnimating()
        Alamofire.request(URL(string: path)!,
                          method: .post, parameters: parameters)
            .responseJSON { response in
                self.activityIndicator.stopAnimating()
                guard response.result.isSuccess else {
                    self.didFinishUpdateAlarmWithError(errorMessage: String(describing: response.result.error?.localizedDescription ?? "Unknown Error"), alarm: alarm)
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: Any] else {
                    self.didFinishUpdateAlarmWithError(errorMessage: NSLocalizedString("Error parsing JSON response", comment: ""), alarm: alarm)
                    return
                }
                
                if let status = responseJSON["status"] as? String {
                    if status != "OK" {
                        print(status)
                        self.didFinishUpdateAlarmWithError(errorMessage: status, alarm: alarm)
                    }
                } else {
                    self.didFinishUpdateAlarmWithError(errorMessage: NSLocalizedString("Missing 'status' in json response: ", comment: ""), alarm: alarm)
                }
        }
    }
    
    func showInfo(infoText: String, anchorView: UIView) {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let infoVC = storyboard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
        infoVC.info = infoText
        infoVC.modalPresentationStyle = .popover
        infoVC.preferredContentSize = CGSize(width: 275, height: 250)
        
        let popoverInfoVC = infoVC.popoverPresentationController
        
        popoverInfoVC?.delegate = self
        if anchorView.isKind(of: UIBarButtonItem.self) {
            popoverInfoVC?.barButtonItem = infoBarButtonItem
        } else {
            
        }
        DispatchQueue.main.async(execute: {
            self.present(
                infoVC,
                animated: true,
                completion: nil)
        })
    }

    func addPin(location: CLLocation) {
        annotation = MKPointAnnotation()
        annotation!.coordinate = location.coordinate
        annotation!.title = "Your chickens live here?"
        mapView.addAnnotation(annotation!)
        mapView.showAnnotations([annotation!], animated: true)
        mapView.selectedAnnotations = [annotation!]
        focusMapView(location: location)
    }
    
    func focusMapView(location: CLLocation) {
      let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
      let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.region = region
    }
    
    
    // MARK: - Alamofire Protocol
    
    func didFinishGetWithError(errorMessage:String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SunsetAlertServerInitFailed"), object: nil, userInfo:["errorMessage": errorMessage])
    }
    
    func didFinishInsertAlarmWithError(errorMessage:String, parameters: [String:Any]) {
      let alert = UIAlertController(title: NSLocalizedString("Error Creating Server Alarm Record", comment: ""), message: errorMessage, preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertAction.Style.cancel, handler:nil))
        print("Contact management")
        
      alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: UIAlertAction.Style.default, handler:{(alert: UIAlertAction!) in
            self.insertAlarm(parameters: parameters)
        }))
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func didFinishUpdateAlarmWithError(errorMessage:String, alarm: Alarm) {
      let alert = UIAlertController(title: NSLocalizedString("Error Updating Server Alarm Record", comment: ""), message: errorMessage, preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertAction.Style.cancel, handler:nil))
        print("Contact management")
        
      alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: UIAlertAction.Style.default, handler:{(alert: UIAlertAction!) in
            self.updateAlarm(alarm: alarm)
        }))
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    
    func didFinishDeleteAlarmWithError(errorMessage:String, alarm: Alarm) {
      let alert = UIAlertController(title: NSLocalizedString("Error Deleting Server Alarm Record", comment: ""), message: errorMessage, preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertAction.Style.cancel, handler:nil))
        print("Contact management")
        
      alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: UIAlertAction.Style.default, handler:{(alert: UIAlertAction!) in
            self.deleteAlarm(alarm: alarm)
        }))
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    // MARK: - MapView Delegate
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("mapView viewFor annotation")

        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotation")
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
            annotationView?.canShowCallout = true
        }else{
            annotationView?.annotation = annotation
        }

        configureDetailView(annotationView: annotationView!)
        configureleftCalloutView(annotationView: annotationView!)

        return annotationView
    }

    
    func configureleftCalloutView(annotationView: MKAnnotationView) {
        let width = 75
        //let height = 125
        let height = 100
        let leftView = UIView()
        let views = ["leftView": leftView]
        leftView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[leftView(75)]", options: [], metrics: nil, views: views))
        //leftView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[leftView(125)]", options: [], metrics: nil, views: views))
        leftView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[leftView(100)]", options: [], metrics: nil, views: views))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.image = UIImage(named: "coop.png")
        leftView.addSubview(imageView)
        
        annotationView.leftCalloutAccessoryView = imageView
    }
    

    
    func configureDetailView(annotationView: MKAnnotationView) {
        //let width = 250
        //let height = 125
        let width = 265
        let height = 100
        
        let detailView = UIView()
        let views = ["detailView": detailView]
        //detailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[detailView(250)]", options: [], metrics: nil, views: views))
        //detailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[detailView(125)]", options: [], metrics: nil, views: views))
        
        detailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[detailView(265)]", options: [], metrics: nil, views: views))
        detailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[detailView(100)]", options: [], metrics: nil, views: views))
        
        let labelView = UILabel(frame:  CGRect(x: 0, y: 0, width: width, height: height))
        labelView.lineBreakMode = .byWordWrapping
        labelView.numberOfLines = 0
        labelView.text = infoText[1]
        if let font = UIFont(name: "Noteworthy-Bold", size: 15.0) {
            labelView.font = font
        }
        labelView.textColor = AppColor.darkerYetTextColor
        detailView.addSubview(labelView)
        annotationView.detailCalloutAccessoryView = detailView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("accessory button pressed")
        showDetailCallout = !showDetailCallout
        
        DispatchQueue.main.async(execute: {
            self.mapView.removeAnnotation(self.annotation!)
            
            if let annotation = self.annotation as MKAnnotation? {
                self.mapView.addAnnotation(annotation)
            }
            
        })
    }
    
    // MARK: - popoverViewController
    
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
        print("willRepositionPopoverToRect")
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    
    // MARK: - FetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    // MARK: - tableView
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Alarms"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = AppColor.paleGoldColor
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    func numberOfSections
        (in tableView: UITableView) -> Int {
        if let frc = fetchedResultsController as NSFetchedResultsController? {
            return frc.sections!.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let frc = fetchedResultsController as NSFetchedResultsController? {
            return frc.sections![section].numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath)
        cell.tintColor = AppColor.darkerYetTextColor
        let alarm = fetchedResultsController.object(at: indexPath) 
        if alarm.offset == 0 {
            cell.textLabel?.text = NSLocalizedString("Alarm: At Sunset", comment: "")
        } else if alarm.offset!.int16Value < 0 {
            cell.textLabel?.text = String.localizedStringWithFormat("Alarm: %d Minutes Before Sunset", abs(alarm.offset!.int16Value))
        } else {
            cell.textLabel?.text = String.localizedStringWithFormat("Alarm: %d Minutes After Sunset", alarm.offset!.int16Value)
        }
        if let sound = alarm.sound {
            switch sound {
            case "Clucking.wav":
                cell.detailTextLabel?.text = NSLocalizedString("Sound: Clucking", comment: "")
            case "Crowing.wav":
                cell.detailTextLabel?.text = NSLocalizedString("Sound: Crowing", comment: "")
            default:
                cell.detailTextLabel?.text = NSLocalizedString("Sound: Default Notification Sound", comment: "")
            }
        }
        return cell
    }
    
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCell.EditingStyle.delete {
            let alarm = fetchedResultsController.object(at: indexPath)
            self.deleteAlarm(alarm: alarm)
            //self.updateAlarm(parameters: ["id": Int(alarm.id!), "offset":Int(alarm.offset!), "sound":alarm.sound!, "deviceuid": UIDevice().identifierForVendor!.uuidString, "status":"inactive"], alarm: alarm)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditAlarmSegue", sender: indexPath.row)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "AddAlarmSegue" {
            if let addAlarmVC = segue.destination as? AddAlarmVC {
                addAlarmVC.moc = moc
            }
        } else if segue.identifier == "EditAlarmSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let alarm = fetchedResultsController.object(at: indexPath)
                if let addAlarmVC = segue.destination as? AddAlarmVC {
                    addAlarmVC.alarm = alarm
                    addAlarmVC.moc = moc
                }
            }
            
        }
    }
    


}

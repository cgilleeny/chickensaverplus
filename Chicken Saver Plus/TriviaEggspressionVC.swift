//
//  TriviaEggspressionVC.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 4/1/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit
import GameplayKit

class TriviaEggspressionVC: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet var swipeLeftGesture: UISwipeGestureRecognizer!
    @IBOutlet var swipeRightGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var previousBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!

    
    lazy var eggspressions: [String] = {
        var strings = [String]()
        if let path = Bundle.main.path(forResource: "expressions", ofType: "plist") {
            if let expressions = NSArray(contentsOfFile: path) as? [String] {
                strings = expressions
            }
        }
        return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: strings) as! [String]
    }()
    
    lazy var triviaStrings: [String] = {
        var strings = [String]()
        if let path = Bundle.main.path(forResource: "trivia", ofType: "plist") {
            if let chickenTrivia = NSArray(contentsOfFile: path) as? [String] {
                strings = chickenTrivia
            }
        }
        return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: strings) as! [String]
    }()
    
    var triviaIndex: Int = 0
    var eggspressionIndex: Int = 0
    //var statusBarOrientation = UIApplication.shared.statusBarOrientation
    var visibleTriviaView:TriviaView?
    var visibleEggspressionView: EggspressionView?
    var triviaViewHidden:TriviaView?
    var visibleEggView: UIImageView?
    let eggRatio: CGFloat = 1.5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.addObserver(self, selector: #selector(TriviaEggspressionVC.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        /*
        eggspressionView.eggspression = eggspressions[eggspressionIndex]
        eggspressionView.isHidden = true
        
        triviaView.trivia = triviaStrings[triviaIndex]
        triviaView.isHidden = true
        */
        
        //InitUI()
        segmentedControl.tintColor = UIColor.white
        tapGesture.addTarget(self, action: #selector(TriviaEggspressionVC.tapGestureHandler(_:)))

        self.view.addGestureRecognizer(tapGesture)
        
        swipeRightGesture.addTarget(self, action: #selector(TriviaEggspressionVC.swipeRightGestureHandler(_:)))
        self.view.addGestureRecognizer(swipeRightGesture)
        
        swipeLeftGesture.addTarget(self, action: #selector(TriviaEggspressionVC.swipeLeftGestureHandler(_:)))
        self.view.addGestureRecognizer(swipeLeftGesture)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //InitUI()
        //print("viewWillLayoutSubviews() viewDidLayoutSubviews(), backgroundView.frame: \(backgroundView.frame), backgroundView.bounds: \(backgroundView.bounds), visibleTriviaView.frame: \(visibleTriviaView!.frame)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //print("TriviaEggspressionVC viewDidLayoutSubviews(), backgroundView.frame: \(backgroundView.frame), backgroundView.bounds: \(backgroundView.bounds), visibleTriviaView.frame: \(visibleTriviaView!.frame)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.statusBarOrientation = UIApplication.shared.statusBarOrientation
        
        print("TriviaEggspressionVC viewWillAppear(), backgroundView.frame: \(backgroundView.frame), backgroundView.bounds: \(backgroundView.bounds)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        InitUI()
        print("TriviaEggspressionVC viewDidAppear(), backgroundView.frame: \(backgroundView.frame), backgroundView.bounds: \(backgroundView.bounds), visibleTriviaView.frame: \(visibleTriviaView!.frame)")
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
        

        // check if self is root view controller
        if self.tabBarController?.selectedViewController == self {
            print("vc is self")
            //the view is currently displayed
            print("viewWillTransition() - UIDevice.current.orientation.isLandscape: \(UIDevice.current.orientation.isLandscape), UIApplication.shared.statusBarOrientation.isLandscape: \(UIApplication.shared.statusBarOrientation.isLandscape),  backgroundView.frame: \(self.backgroundView.frame))")
            DispatchQueue.main.async(execute: {
                if self.visibleTriviaView != nil {
                    self.visibleTriviaView?.frame = self.backgroundView.frame
                    self.visibleTriviaView?.setNeedsDisplay()
                }
                if let visibleEggView = self.visibleEggView as UIImageView? {
                    if UIDevice.current.orientation.isLandscape {
                        let idealWidth = self.backgroundView.frame.height * self.eggRatio
                        let widthInset = (self.backgroundView.frame.width - idealWidth)/2
                        let eggRect = CGRect(x: self.backgroundView.frame.origin.x + widthInset, y: self.backgroundView.frame.origin.y, width: idealWidth, height: self.backgroundView.frame.height)
                        print("landscape backgroundView.frame: \(self.backgroundView.frame), eggRect: \(eggRect))")
                        visibleEggView.frame = eggRect
                        visibleEggView.image = #imageLiteral(resourceName: "landscapeEgg")
                    } else {
                        visibleEggView.frame = self.backgroundView.frame
                        self.visibleEggView?.image = #imageLiteral(resourceName: "egg")
                    }
                    self.visibleEggspressionView?.frame = self.insideEggRect()
                    visibleEggView.setNeedsDisplay()
                    self.visibleEggspressionView?.setNeedsDisplay()
                }
            })
        }



    }
    
    // MARK: - Notification Handlers
    
    /*
    @objc func rotated() {
        print("rotated() - isLandscape: \(self.statusBarOrientation.isLandscape), UIApplication.shared.statusBarOrientation.isLandscape: \(UIApplication.shared.statusBarOrientation.isLandscape),  backgroundView.frame: \(self.backgroundView.frame))")
        if self.statusBarOrientation != UIApplication.shared.statusBarOrientation {
           self.statusBarOrientation = UIApplication.shared.statusBarOrientation
            DispatchQueue.main.async(execute: {
                
                if self.visibleTriviaView != nil {
                    self.visibleTriviaView?.frame = self.backgroundView.frame
                    self.visibleTriviaView?.setNeedsDisplay()
                }
                if let visibleEggView = self.visibleEggView as UIImageView? {
                    if self.statusBarOrientation.isLandscape {
                        let idealWidth = self.backgroundView.frame.height * self.eggRatio
                        let widthInset = (self.backgroundView.frame.width - idealWidth)/2
                        let eggRect = CGRect(x: self.backgroundView.frame.origin.x + widthInset, y: self.backgroundView.frame.origin.y, width: idealWidth, height: self.backgroundView.frame.height)
                        print("landscape backgroundView.frame: \(self.backgroundView.frame), eggRect: \(eggRect))")
                        visibleEggView.frame = eggRect
                        visibleEggView.image = #imageLiteral(resourceName: "landscapeEgg")
                    } else {
                        visibleEggView.frame = self.backgroundView.frame
                        self.visibleEggView?.image = #imageLiteral(resourceName: "egg")
                    }
                    self.visibleEggspressionView?.frame = self.insideEggRect()
                    visibleEggView.setNeedsDisplay()
                    self.visibleEggspressionView?.setNeedsDisplay()
                }
            })
        }
    }
    */
    
    // MARK: - Control Handlers
    
    func tapGestureHandler(_ sender:UITapGestureRecognizer) {
        if segmentedControl.selectedSegmentIndex == 0 {
            segmentedControl.selectedSegmentIndex = 1
        } else {
            segmentedControl.selectedSegmentIndex = 0
        }
        flip()
    }
    
    
    func swipeRightGestureHandler(_ sender:UISwipeGestureRecognizer) {
        slideRight()
    }
    
    
    func swipeLeftGestureHandler(_ sender:UISwipeGestureRecognizer) {
        slideLeft()
    }
    
    @IBAction func segmentedControlHandler(_ sender: UISegmentedControl) {
        flip()
    }
    
    @IBAction func nextBarButtonItemHandler(_ sender: UIBarButtonItem) {
        slideLeft()
    }

    @IBAction func previousBarButtonItemHandler(_ sender: UIBarButtonItem) {
        slideRight()
    }
    
    // MARK: - Utilities
    
    func InitUI() {
        if visibleTriviaView == nil {
            print("UIDevice.current.orientation.isLandscape: \(UIDevice.current.orientation.isLandscape), UIApplication.shared.statusBarOrientation.isLandscape: \(UIApplication.shared.statusBarOrientation.isLandscape),  backgroundView.frame: \(self.backgroundView.frame))")
            visibleTriviaView = TriviaView(frame: backgroundView.frame)
            //visibleTriviaView = TriviaView()
            visibleTriviaView?.backgroundColor = UIColor.clear
            visibleTriviaView?.trivia = triviaStrings[triviaIndex]
            self.view.addSubview(visibleTriviaView!)
        }
/*
        if visibleTriviaView == nil {
            //visibleTriviaView = TriviaView(frame: backgroundView.frame)
            visibleTriviaView = TriviaView()
            visibleTriviaView?.backgroundColor = UIColor.clear
            visibleTriviaView?.trivia = triviaStrings[triviaIndex]
            self.view.addSubview(visibleTriviaView!)
            visibleTriviaView?.translatesAutoresizingMaskIntoConstraints = false
            
            view.addConstraint(NSLayoutConstraint(item: visibleTriviaView!, attribute: .top, relatedBy: .equal, toItem: self.navigationBar, attribute: .bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: visibleTriviaView!, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: visibleTriviaView!, attribute: .leadingMargin, relatedBy: .equal, toItem: self.view, attribute: .leadingMargin, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: visibleTriviaView!, attribute: .trailingMargin, relatedBy: .equal, toItem: self.view, attribute: .trailingMargin, multiplier: 1, constant: 0))
        }
 */
    }
    
    func insideEggRect() -> CGRect {
        let width: CGFloat = visibleEggView!.bounds.width * 3.0/5.0
        let height: CGFloat = visibleEggView!.bounds.height * 3.0/5.0
        
        let x = visibleEggView!.bounds.origin.x + ((visibleEggView!.bounds.width - width)/2.0)
        let y = visibleEggView!.bounds.origin.y + ((visibleEggView!.bounds.height - height)/2.0)
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    /*
    func insideEggRect() -> CGRect {
        let width: CGFloat = backgroundView.bounds.width * 3.0/5.0
        let height: CGFloat = backgroundView.bounds.height * 3.0/5.0
        
        let x = backgroundView.bounds.origin.x + ((backgroundView.bounds.width - width)/2.0)
        let y = backgroundView.bounds.origin.y + ((backgroundView.bounds.height - height)/2.0)
        return CGRect(x: x, y: y, width: width, height: height)
    }
    */
    
    func toggleControls(enabled: Bool) {
        previousBarButtonItem.isEnabled = enabled
        nextBarButtonItem.isEnabled = enabled
        swipeLeftGesture.isEnabled = enabled
        swipeRightGesture.isEnabled = enabled
        tapGesture.isEnabled = enabled
        segmentedControl.isUserInteractionEnabled = enabled
    }
    
    func flip() {
        toggleControls(enabled: false)
        if segmentedControl.selectedSegmentIndex == 0 {
            let options: UIViewAnimationOptions = [.transitionFlipFromLeft, .allowUserInteraction, .beginFromCurrentState]
            UIView.transition(from: self.visibleEggView!, to: self.visibleTriviaView!, duration: 0.5, options: options, completion: { _ in
                self.toggleControls(enabled: true)
            })
        } else {
            if self.visibleEggView == nil {
                if UIDevice.current.orientation.isLandscape {
                    let idealWidth = backgroundView.frame.height * eggRatio
                    let widthInset = (backgroundView.frame.width - idealWidth)/2
                    let eggRect = CGRect(x: backgroundView.frame.origin.x + widthInset, y: backgroundView.frame.origin.y, width: idealWidth, height: backgroundView.frame.height)
                    print("landscape backgroundView.frame: \(backgroundView.frame), eggRect: \(eggRect))")
                    visibleEggView = UIImageView(frame: eggRect)
                    visibleEggView?.image = #imageLiteral(resourceName: "landscapeEgg")
                } else {
                    print("portrait backgroundView.frame: \(backgroundView.frame)")
                    visibleEggView = UIImageView(frame: backgroundView.frame)
                    visibleEggView?.image = #imageLiteral(resourceName: "egg")
                }
                //visibleEggView?.image = UIImage(named: "egg")
                visibleEggView?.setNeedsDisplay()
                //let eggspressionViewFrame = CGRect(x: 100, y: 100, width: 100, height: 100)
                print("backgroundView.frame: \(backgroundView.frame), insideEggRect(): \(insideEggRect())")
                visibleEggspressionView = EggspressionView(frame: insideEggRect())
                visibleEggspressionView?.backgroundColor = UIColor.clear
                visibleEggspressionView?.eggspression = eggspressions[eggspressionIndex]
                visibleEggspressionView?.setNeedsDisplay()
                visibleEggView?.addSubview(visibleEggspressionView!)
            }
            let options: UIViewAnimationOptions = [.transitionFlipFromLeft, .allowUserInteraction, .beginFromCurrentState]

            UIView.transition(from: self.visibleTriviaView!, to: self.visibleEggView!, duration: 0.5, options: options, completion: { _ in
                self.toggleControls(enabled: true)
            })
        }
    }
    
    func slideRight() {
        toggleControls(enabled: false)
        if segmentedControl.selectedSegmentIndex == 0 {
            let slideInFrame = CGRect(x: visibleTriviaView!.frame.origin.x - visibleTriviaView!.frame.width, y:visibleTriviaView!.frame.origin.y , width: visibleTriviaView!.frame.width, height: visibleTriviaView!.frame.height)
            let slideInView = TriviaView(frame: slideInFrame)
            slideInView.backgroundColor = UIColor.clear
            triviaIndex -= 1
            if triviaIndex < 0 {
                triviaIndex = triviaStrings.count - 1
            }
            
            slideInView.trivia = triviaStrings[triviaIndex]
            self.view.addSubview(slideInView)
            slideInView.setNeedsDisplay()
            UIView.animate(withDuration: 0.5, animations: {
                self.visibleTriviaView!.frame.origin.x += self.view.bounds.width
                slideInView.frame.origin.x += self.view.bounds.width
            }, completion: { _ in
                self.visibleTriviaView?.removeFromSuperview()
                self.visibleTriviaView = slideInView
                self.toggleControls(enabled: true)
            })
        } else {
            let slideInFrame = CGRect(x: visibleEggView!.frame.origin.x - self.view.bounds.width, y: visibleEggView!.frame.origin.y , width: visibleEggView!.frame.width, height: visibleEggView!.frame.height)

            //let slideInFrame = CGRect(x: backgroundView.frame.origin.x - backgroundView.frame.width, y: backgroundView.frame.origin.y , width: backgroundView.frame.width, height: backgroundView.frame.height)
            let slideInView = UIImageView(frame: slideInFrame)
            if UIDevice.current.orientation.isLandscape {
                slideInView.image = #imageLiteral(resourceName: "landscapeEgg")
            } else {
                slideInView.image = #imageLiteral(resourceName: "egg")
            }
            //slideInView.image = UIImage(named: "egg")
            slideInView.setNeedsDisplay()
            let slideInEggspressionView = EggspressionView(frame: insideEggRect())
            slideInEggspressionView.backgroundColor = UIColor.clear
            //slideInEggspressionView.backgroundColor = UIColor.lightGray
            eggspressionIndex -= 1
            if eggspressionIndex < 0 {
                eggspressionIndex = eggspressions.count - 1
            }
            
            slideInEggspressionView.eggspression = eggspressions[eggspressionIndex]
            slideInEggspressionView.setNeedsDisplay()
            slideInView.addSubview(slideInEggspressionView)
            self.view.addSubview(slideInView)
            
           
            UIView.animate(withDuration: 0.5, animations: {
                 self.visibleEggView!.frame.origin.x += self.view.bounds.width
                 slideInView.frame.origin.x += self.view.bounds.width
            }, completion: { _ in
                 self.visibleEggspressionView?.removeFromSuperview()
                 self.visibleEggView?.removeFromSuperview()
                 self.visibleEggView = slideInView
                 self.visibleEggspressionView = slideInEggspressionView
                 self.toggleControls(enabled: true)
            })
        }
    }
    
    
    func slideLeft() {
        toggleControls(enabled: false)
        if segmentedControl.selectedSegmentIndex == 0 {
            let slideInFrame = CGRect(x: visibleTriviaView!.frame.origin.x + visibleTriviaView!.frame.width, y:visibleTriviaView!.frame.origin.y , width: visibleTriviaView!.frame.width, height: visibleTriviaView!.frame.height)
            let slideInView = TriviaView(frame: slideInFrame)
            slideInView.backgroundColor = UIColor.clear
            triviaIndex += 1
            if triviaIndex >= triviaStrings.count {
                triviaIndex = 0
            }
            
            slideInView.trivia = triviaStrings[triviaIndex]
            self.view.addSubview(slideInView)
            slideInView.setNeedsDisplay()
            UIView.animate(withDuration: 0.5, animations: {
                self.visibleTriviaView!.frame.origin.x -= self.view.bounds.width
                slideInView.frame.origin.x -= self.view.bounds.width
            }, completion: { _ in
                self.visibleTriviaView?.removeFromSuperview()
                self.visibleTriviaView = slideInView
                self.toggleControls(enabled: true)
            })
        } else {
            //let slideInFrame = CGRect(x: visibleEggView!.frame.origin.x + visibleEggView!.frame.width, y: visibleEggView!.frame.origin.y , width: visibleEggView!.frame.width, height: visibleEggView!.frame.height)
            let slideInFrame = CGRect(x: visibleEggView!.frame.origin.x + self.view.bounds.width, y: visibleEggView!.frame.origin.y , width: visibleEggView!.frame.width, height: visibleEggView!.frame.height)
            
            let slideInView = UIImageView(frame: slideInFrame)
            if UIDevice.current.orientation.isLandscape {
                slideInView.image = #imageLiteral(resourceName: "landscapeEgg")
            } else {
                slideInView.image = #imageLiteral(resourceName: "egg")
            }
            //slideInView.image = UIImage(named: "egg")
            slideInView.setNeedsDisplay()
            let slideInEggspressionView = EggspressionView(frame: insideEggRect())
            slideInEggspressionView.backgroundColor = UIColor.clear
            //slideInEggspressionView.backgroundColor = UIColor.lightGray
            eggspressionIndex += 1
            if eggspressionIndex >= eggspressions.count {
                eggspressionIndex = 1
            }
                
            slideInEggspressionView.eggspression = eggspressions[eggspressionIndex]
            slideInEggspressionView.setNeedsDisplay()
            slideInView.addSubview(slideInEggspressionView)
            self.view.addSubview(slideInView)
            UIView.animate(withDuration: 0.5, animations: {
                self.visibleEggView!.frame.origin.x -= self.view.bounds.width
                slideInView.frame.origin.x -= self.view.bounds.width
            }, completion: { _ in
                self.visibleEggspressionView?.removeFromSuperview()
                self.visibleEggView?.removeFromSuperview()
                self.visibleEggView = slideInView
                self.visibleEggspressionView = slideInEggspressionView
                self.toggleControls(enabled: true)
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

//
//  InfoAlertVC.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 4/7/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit

class InfoAlertVC: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var dimmedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        alertView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /*
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(1.0)
        self.dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.alertView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("InfoAlertVC viewWillDisappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonHandler(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

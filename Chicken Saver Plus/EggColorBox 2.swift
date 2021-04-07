//
//  EggColorBox.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 4/27/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit

class EggColorBox: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("ResusableEggColorView", owner: self, options: nil)
        self.addSubview(self.view)
    }
}

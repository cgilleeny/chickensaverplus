//
//  EggColorCell.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 4/21/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit

class EggColorCell: UITableViewCell {


    @IBOutlet weak var eggImageView: UIImageView!
    @IBOutlet weak var colorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func loadItem(eggColor: EggColor) {
        colorLabel.text = eggColor.color
        eggImageView.image = UIImage(named: "carton")
    }


}

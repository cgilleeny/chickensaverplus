//
//  BreedCell.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 3/9/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit
//import CoreData

class BreedCell: UITableViewCell {

    //var breed:Breed!
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UILabel.appearance().textColor = AppColor.darkestTextColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.customImageView?.frame = CGRect(x: 0, y: 0, width: 116.0, height: 87.0)
    }
    
    public func loadItem(breed: Breed) {
        self.customImageView?.backgroundColor = UIColor.black
        if let image = UIImage(named:  "\(breed.name!).jpg") as UIImage? {
            customImageView?.image = image
        } else {
            customImageView?.image = UIImage(named: "cartoonHen.jpg")
        }
        nameLabel.text = breed.name!
        purposeLabel.text = breed.purpose!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

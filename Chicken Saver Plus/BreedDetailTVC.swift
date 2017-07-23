//
//  BreedDetailTVC.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 4/26/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit

class BreedDetailTVC: UITableViewController {



    
    var breed: Breed!
    //var eggColorDataSource: EggColorDataSource!
    var featuresDataSource: FeaturesDataSource!
    var varietiesdDataSource: VarietiesDataSource!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = breed.name!
        var varieties: [Variety] = []
        var specialAttributes: [SpecialAttribute] = []
        
        if let breedSpecialAttributes = breed.specialAttributes!.allObjects as? [SpecialAttribute], let breedVarieties = breed.varieties!.allObjects as? [Variety]  {
            specialAttributes = breedSpecialAttributes
            varieties = breedVarieties
        }
        varietiesdDataSource = VarietiesDataSource()
        varietiesdDataSource.setData(varieties: varieties)

        featuresDataSource = FeaturesDataSource()
        featuresDataSource.setData(specialAttributes: specialAttributes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.width
        }
        
        if indexPath.row == 1 {
            return 247
        }
        
        if indexPath.row == 2 {
            //return 213
            return 246
        }
        
        if indexPath.row == 3 {
            return 140
        }
        
        if indexPath.row == 4 {
            return 217
        }
        
        if indexPath.row == 5 {
            return 150
        }
        
        if indexPath.row == 6 {
            return 150
        }
        
        return 400
    }

    /*
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.backgroundView==nil {
            let imageView = UIImageView(frame: cell.frame)
            imageView.image = UIImage(named: breed.name!)
            cell.backgroundView = imageView
        }
    }
    */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            print("ImageCell.frame: \(cell.frame)")
            
            if let image = UIImage(named:  "\(breed.name!).jpg") as UIImage? {
                cell.customImageView?.image = image
            } else {
                cell.customImageView?.image = UIImage(named: "cartoonHen.jpg")
            }
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EggCell", for: indexPath) as! EggCell
            
            print("EggCell.frame: \(cell.frame)")
            cell.loadItem(breed: breed)
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FactCell", for: indexPath) as! FactCell
            
            print("FactCell.frame: \(cell.frame)")
            cell.loadItem(breed: breed)
            
            return cell
        }

        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TolerantCell", for: indexPath) as! TolerantCell
            
            print("FactCell.frame: \(cell.frame)")
            cell.loadItem(breed: breed)
            return cell
        }
        
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath) as! TypeCell
            
            print("FactCell.frame: \(cell.frame)")
            cell.loadItem(breed: breed)
            return cell
        }
        
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VarietyCell", for: indexPath) as! VarietyCell
            
            print("FactCell.frame: \(cell.frame)")
            cell.tableView.delegate = varietiesdDataSource
            cell.tableView.dataSource = varietiesdDataSource
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturesCell", for: indexPath) as! FeaturesCell
        
        print("FactCell.frame: \(cell.frame)")
        cell.tableView.delegate = featuresDataSource
        cell.tableView.dataSource = featuresDataSource
        
        return cell
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class ImageCell: UITableViewCell {
    
    //var breed:Breed!
    
    @IBOutlet weak var customImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UILabel.appearance().textColor = AppColor.darkestTextColor
    }
    
    /*
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.customImageView?.frame = CGRect(x: 0, y: 0, width: 116.0, height: 87.0)
    }
 
    public func loadItem(breed: Breed) {
        self.customImageView?.backgroundColor = UIColor.black
        if let image = UIImage(named:  "\(breed.name!).jpg") as UIImage? {
            customImageView?.image = image
        } else {
            customImageView?.image = UIImage(named: "cartoonHen.jpg")
        }
    }
    */
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class EggCell: UITableViewCell {
    
    //var breed:Breed!
    
    @IBOutlet weak var productivityLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("self.frame: \(self.frame), self.center: \(self.center), prodictivityLabel.frame: \(productivityLabel.frame)")
        UILabel.appearance().textColor = AppColor.darkestTextColor
    }
    
    
    public func loadItem(breed: Breed) {
        productivityLabel.text = breed.productivity!
        sizeLabel.text = breed.eggSize!
        if let eggColors = breed.eggColors!.allObjects as? [EggColor] {
            var reusableEggColorViewFrame = CGRect(x: scrollContentView.bounds.origin.x, y: scrollContentView.bounds.origin.y, width: 154, height: 154)
            var otherEggColors = colors
            for eggColor in eggColors {
                print("eggColor: \(eggColor.color!)")
                let box = ReusableEggColorView.init(frame: reusableEggColorViewFrame)
                scrollContentView.addSubview(box)
                box.colorLabel.text = eggColor.color!
                if let image = UIImage(named: eggColor.color!) {
                    box.imageView.image = image
                } else {
                    box.imageView.image = #imageLiteral(resourceName: "carton")
                }
                reusableEggColorViewFrame = CGRect(x: reusableEggColorViewFrame.origin.x + reusableEggColorViewFrame.width, y: reusableEggColorViewFrame.origin.y, width: reusableEggColorViewFrame.width, height: reusableEggColorViewFrame.height)
                otherEggColors = otherEggColors.filter() {$0 != eggColor.color}
            }
            
            for otherEggColor in otherEggColors {
                let box = ReusableEggColorView.init(frame: reusableEggColorViewFrame)
                scrollContentView.addSubview(box)
                box.colorLabel.text = otherEggColor
                if let image = UIImage(named: otherEggColor) {
                    box.imageView.image = image
                } else {
                    box.imageView.image = #imageLiteral(resourceName: "carton")
                }
                box.shadeView.backgroundColor = UIColor.black
                box.shadeView.alpha = 0.25
                reusableEggColorViewFrame = CGRect(x: reusableEggColorViewFrame.origin.x + reusableEggColorViewFrame.width, y: reusableEggColorViewFrame.origin.y, width: reusableEggColorViewFrame.width, height: reusableEggColorViewFrame.height)
            }
            
            let constraintWidth = NSLayoutConstraint (item: scrollContentView,
                                                            attribute: NSLayoutAttribute.width,
                                                            relatedBy: NSLayoutRelation.equal,
                                                            toItem: nil,
                                                            attribute: NSLayoutAttribute.notAnAttribute,
                                                            multiplier: 1,
                                                            constant: CGFloat(colors.count * 154))
            self.scrollView.addConstraint(constraintWidth)
        }
        contentView.layoutSubviews()
        //productivityLabel.layoutIfNeeded()
        print("loadItem self.frame: \(self.frame), self.center: \(self.center), prodictivityLabel.frame: \(productivityLabel.frame)")
        //self.layoutIfNeeded()
    }
 
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class FactCell: UITableViewCell {
    
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var maturingLabel: UILabel!
    @IBOutlet weak var broodingLabel: UILabel!
    @IBOutlet weak var personalityLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var combLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UILabel.appearance().textColor = AppColor.darkestTextColor
    }
    
    
    public func loadItem(breed: Breed) {
        purposeLabel.text = breed.purpose!
        broodingLabel.text = breed.brooding!
        maturingLabel.text = breed.maturing!
        personalityLabel.text = breed.personality!
        availabilityLabel.text = breed.availability!
        combLabel.text = breed.comb!
        
        /*
        heatTolerantLabel.text = breed.heatTolerant!
        typeLabel.text = breed.type!
        fancyLabel.text = breed.fancy!
        coldTolerantLabel.text = breed.coldTolerant!
        confinementTolerantLabel.text = breed.confinement!
        */
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class TypeCell: UITableViewCell {
    
    @IBOutlet weak var fancyLabel: UILabel!
    @IBOutlet weak var standardLabel: UILabel!
    @IBOutlet weak var standardWeight: UILabel!
    @IBOutlet weak var bantamLabel: UILabel!
    @IBOutlet weak var bantamWeight: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UILabel.appearance().textColor = AppColor.darkestTextColor
    }
    
    
    public func loadItem(breed: Breed) {
        fancyLabel.text = breed.fancy!
        if let type = breed.type as String? {
            standardLabel.text = (type == "Both" || type == "Standard") ? "Yes" : "No"
            bantamLabel.text = (type == "Both" || type == "Bantam") ? "Yes" : "No"
        } else {
            standardLabel.text = "N/A"
            bantamLabel.text = "N/A"
        }
        bantamWeight.text = breed.bantamWeight!
        standardWeight.text = breed.standardWeight!
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class TolerantCell: UITableViewCell {
    
    @IBOutlet weak var confinementLabel: UILabel!
    @IBOutlet weak var coldLabel: UILabel!
    @IBOutlet weak var heatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UILabel.appearance().textColor = AppColor.darkestTextColor
    }
    
    
    public func loadItem(breed: Breed) {
        confinementLabel.text = breed.confinement!
        coldLabel.text = breed.coldTolerant!
        heatLabel.text = breed.heatTolerant!
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class VarietyCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UILabel.appearance().textColor = AppColor.darkestTextColor
    }
    
    
    public func loadItem(breed: Breed) {

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class FeaturesCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
        UILabel.appearance().textColor = AppColor.darkestTextColor
    }
    
    
    public func loadItem(breed: Breed) {
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class VarietiesDataSource: NSObject,UITableViewDataSource,UITableViewDelegate {
    

    var varieties: [Variety] = []
    
    override init(){
        super.init()
    }
    
    func setData(varieties: [Variety]){
        self.varieties = varieties
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Varieties"
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = AppColor.paleBlueColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return varieties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VarietyCell", for: indexPath)
        cell.tintColor = AppColor.darkerYetTextColor
        cell.textLabel?.tintColor = AppColor.darkerYetTextColor
        if let font = UIFont(name: "Noteworthy-Bold", size: 17.0) {
            cell.textLabel?.font = font
        }
        cell.textLabel?.text = varieties[indexPath.row].name!

        return cell
    }
}



class FeaturesDataSource: NSObject,UITableViewDataSource,UITableViewDelegate {
    
    var specialAttributes: [SpecialAttribute] = []
    
    override init(){
        super.init()
    }
    
    func setData(specialAttributes: [SpecialAttribute]){
        self.specialAttributes = specialAttributes
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Special Attributes"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = AppColor.paleBlueColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialAttributes.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath)
        cell.tintColor = AppColor.darkerYetTextColor
        if let font = UIFont(name: "Noteworthy-Bold", size: 17.0) {
            cell.textLabel?.font = font
        }
        cell.textLabel?.text = specialAttributes[indexPath.row].attribute!
        return cell
    }
}





//
//  BreedsVC.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 1/20/16.
//  Copyright © 2016 Caroline Gilleeny. All rights reserved.
//

import UIKit
import CoreData

struct BreedSortConstants {
    static let alphabeticaly: Int = 0
    static let byPurpose: Int = 1
    static let byProductivity: Int = 2
    static let byEggSize: Int = 3
}


class BreedsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortSegementControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var moc: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var breedSortType: Int = BreedSortConstants.alphabeticaly
    // MARK: - Lifecycle Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBreeds()
        tableView.reloadData()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"EggColor")
        //let predicate = NSPredicate(format: "color == %@", color)
        //fetchRequest.predicate = predicate
        do {
            if let eggColors = try moc.fetch(fetchRequest) as? [EggColor] {
                for eggColor in eggColors {
                    print(eggColor.color ?? "unknown egg color")
                }
            }
        } catch {
            print(error)
        }

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(BreedsVC.updateUI), name:Notification.Name(rawValue: "UpdateUI"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name:Notification.Name(rawValue: "UpdateUI"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notification Handlers
    
    @objc func updateUI() {
        DispatchQueue.main.async( execute:  {
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Utilities
    
    func fetchBreeds() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Breed")
        let count = try! self.moc.count(for: fetchRequest)
        if count == 0
        {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EggColor")
            let count = try! self.moc.count(for: fetchRequest)
            if count == 0 {
                do {
                    try EggColor.createAll(moc)
                } catch {
                    print("EggColor creation error")
                }
            }
            
            if let path = Bundle.main.path(forResource: "breed", ofType: "plist") {
                if let chickens = NSArray(contentsOfFile: path) as? [[String:AnyObject]] {
                    do {
                        for chicken in chickens {
                            try Breed.createWithoutSave(self.moc, dictionary: chicken)
                        }
                        try moc.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        if !searchBar.text!.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchBar.text!)
        }
        switch self.sortSegementControl.selectedSegmentIndex {
        case BreedSortConstants.alphabeticaly:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: BreedConstants.name, ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        case BreedSortConstants.byPurpose:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: BreedConstants.purpose, ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: BreedConstants.purpose, cacheName: nil)
        case BreedSortConstants.byProductivity:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: BreedConstants.productivity, ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: BreedConstants.productivity, cacheName: nil)
        case BreedSortConstants.byEggSize:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: BreedConstants.eggSize, ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: BreedConstants.eggSize, cacheName: nil)
        default:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: BreedConstants.name, ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        }
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateUI"), object: nil)
        } catch {
            print(error)
            let title = NSLocalizedString("CoreData Error", comment: "CoreData Error")
            let message = String.localizedStringWithFormat(NSLocalizedString("fetchedResultsController.performFetch for breed entities failed: %@", comment: "fetchedResultsController.performFetch error"), error.localizedDescription)
          let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close Button"), style: UIAlertAction.Style.cancel, handler:nil))
            DispatchQueue.main.async( execute:  {
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    // MARK: - Control Handlers
    
    @IBAction func sortSegmentedControlHandler(_ sender: UISegmentedControl) {
        fetchBreeds()
        //tableView.reloadData()
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sortSegementControl.selectedSegmentIndex == BreedSortConstants.alphabeticaly {
            return 0.0
        }
        return 66.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sortSegementControl.selectedSegmentIndex == BreedSortConstants.alphabeticaly {
            return nil
        }
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.name
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = AppColor.paleGoldColor
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let breed = fetchedResultsController.object(at: indexPath) as! Breed
        
        let cell: BreedCell = tableView.dequeueReusableCell(withIdentifier: "BreedCell") as! BreedCell
        
        cell.loadItem(breed: breed)
        
        return cell
    }
    
    
    
    // MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBarTextDidChange")
        fetchBreeds()
        //tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        searchBar.text = ""
        searchBar.resignFirstResponder()
        fetchBreeds()
        //tableView.reloadData()
    }
    

    // MARK: - navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue , sender: self)
        if segue.identifier == "BreedDetailTVCSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            if let breedDetailTVC = segue.destination as? BreedDetailTVC,
              let breed = fetchedResultsController.object(at: indexPath) as? Breed {
                breedDetailTVC.breed = breed
                
            }
        }
    }



}

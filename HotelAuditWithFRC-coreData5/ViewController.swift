//
//  ViewController.swift
//  HotelAuditWithFRC-coreData5
//
//  Created by Gilbert Andrei Floarea on 30/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate let thingCellIdentifier = "thingCellIdentifier"
    var coreDataStack: CoreDataStack!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Thing> = {
        let fetchRequest: NSFetchRequest<Thing> = Thing.fetchRequest()
        let categorySort = NSSortDescriptor(key: #keyPath(Thing.category), ascending: true)
        let countSort = NSSortDescriptor(key: #keyPath(Thing.count), ascending: false)
        let nameSort = NSSortDescriptor(key: #keyPath(Thing.brand), ascending: true)
        fetchRequest.sortDescriptors = [categorySort, countSort, nameSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: #keyPath(Thing.category),
            cacheName: "hotel")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var composeButton: UIBarButtonItem!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addThing(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add thing",
                                                message: "Add a new Thing in the list",
                                                preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Thing Brand"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Thing Category"
        }
        
        let saveAction = UIAlertAction(title: "Add", style: .default) { [unowned self] action in
            guard let nameTextField = alertController.textFields?.first,
                let zoneTextField = alertController.textFields?.last else {
                    return
            }
            
            let thing = Thing(context: self.coreDataStack.managedContext)
            
            thing.brand = nameTextField.text
            thing.category = zoneTextField.text
            thing.imageName = "xImage"
            self.coreDataStack.saveContext()
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
}


// MARK: - Internal
extension ViewController {
    
    func setupCell(cell: UITableViewCell, for indexPath: IndexPath) {
        
        guard let cell = cell as? ThingTableViewCell else {
            return
        }
        
        let thing = fetchedResultsController.object(at: indexPath)
        cell.brandLabel.text = thing.brand
        cell.countLabel.text = "Count: \(thing.count)"
        
        if let imageName = thing.imageName {
            cell.xImageView.image = UIImage(named: imageName)
        } else {
            cell.xImageView.image = nil
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: thingCellIdentifier, for: indexPath)
        setupCell(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.name
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thing = fetchedResultsController.object(at: indexPath)
        thing.count = thing.count + 1
        coreDataStack.saveContext()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! ThingTableViewCell
            setupCell(cell: cell, for: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}

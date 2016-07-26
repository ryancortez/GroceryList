//
//  ListTableViewController.swift
//  GroceryList
//
//  Created by Ryan Cortez on 7/21/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, AddListTableViewControllerDelegate {
    var coreDataManager: CoreDataManager!
    var managedObjectContext: NSManagedObjectContext!
    var fetchResultsController: NSFetchedResultsController!
    var managedObjects = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - FetchResultsController
    
    func initFetchResultsController() {
        let entityName = "GroceryList"
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        // Diary Entries will be display in descending order from the date created
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchResultsController.delegate = self
        
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("fetchResultsController was unable to perform fetch")
            return
        }
        guard let fetchedObjects = fetchResultsController.fetchedObjects else {
            print ("Unable to fetch objects from Entity: \(entityName)")
            return
        }
        
        managedObjects = fetchedObjects
        
    }
    
    // MARK: - Editing Database
    
    func insertNewList(title: String, items: Array<NSManagedObject>?) -> NSManagedObject {
        let list = NSEntityDescription.insertNewObjectForEntityForName("GroceryList", inManagedObjectContext: self.managedObjectContext)
        list.setValue(title, forKey: "title")
        if let array = items {
            let itemsFromList = list.mutableSetValueForKey("groceryItems")
            itemsFromList.addObjectsFromArray(array)
        }
        save()
        return list
    }
    
    func save() {
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Unable to save new list")
            return
        }
    }
    
    // MARK: - TableView Delegate

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch(type) {
        case .Insert:
            // Animate the inserting of new rows
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break
        case .Delete:
            break
        case .Update:
            break
        case .Move:
            break
        }
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return managedObjects.count
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
        
    // MARK: - Actions
    
    @IBAction func reorderButtonPressed(sender: AnyObject) {
        
    }
    
    // MARK: - Segue 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let destinationViewController = segue.destinationViewController as? AddToListTableViewController else {
            print("AddToListTableViewController was not the destinationViewController")
            return
        }
        destinationViewController.managedObjectContext = self.managedObjectContext
    }

}

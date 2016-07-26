//
//  GroceryItemTableViewController.swift
//  GroceryList
//
//  Created by Ryan Cortez on 7/21/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class GroceryItemTableViewController: ListTableViewController, AddToGroceryItemTableViewControllerDelegate {
    var list: NSManagedObject!
    var items: NSSet!
    
    // MARK: - Initial Setup
    
    override func viewWillAppear(animated: Bool) {
        
        items = list.valueForKey("groceryItems") as! NSSet
        setNavigationBarTitle()
    }
    
    func setNavigationBarTitle () {
        let key = "title"
        guard let title = list.valueForKey(key) as? String else {
            print("Did not find title in the list using the key: (\(key)) ")
            return
        }
        self.title = title
    }
    
    func fetchListItems () {
        let fetchRequest = NSFetchRequest(entityName: "GroceryItem")
        let predicate = NSPredicate(format: "groceryList.title = %@", self.title!)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchResultsController.delegate = self
        
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("Unable to fetch results from fetchResultsController")
        }
    }
    
    // MARK: - AddToGroceryItemTableViewControllerDelegate
    
    func passList(list: NSManagedObject, andItems items: Array<NSManagedObject>) {
        self.list = list
        let set = NSSet(array: items)
        self.items = set
    }
    
    func reloadTable(withItems items: NSSet) {
        self.items = items
        self.tableView.reloadData()
    }
  
    // MARK: - TableView Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groceryItemCell", forIndexPath: indexPath)
        let item = items.allObjects[indexPath.row]
        cell.textLabel?.text = item.valueForKey("title") as? String
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            guard let managedObject = items.allObjects[indexPath.row] as? NSManagedObject else {
                print("No managedObject pulled or an incorrect NSManagedObject was pulled when getting object from fetchedObjects[] ")
                return
            }
            // Remove the deleted row from CoreData
            self.managedObjectContext.deleteObject(managedObject)
            do {
                try self.managedObjectContext.save()
            } catch {
                print(CoreDataErrorType.UnableToSave.rawValue)
                return
            }
            
            let indexPaths = [indexPath]
            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        default:
            return
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "itemTableToAddItemTable") {
            guard let navigationController = segue.destinationViewController as? UINavigationController else {
                print("destinationViewController was not a UINavigationController"); return
            }
            guard let destinationViewController = navigationController.viewControllers.first as? AddToGroceryItemTableViewController else {
                print ("The first view controller in the UINavigation controller was not a AddToGroceryItemTableViewController"); return
            }
            destinationViewController.list = self.list
            destinationViewController.itemTableViewControllerDelegate = self
            destinationViewController.delegate = self
            destinationViewController.managedObjectContext = self.managedObjectContext
        }
    }
}

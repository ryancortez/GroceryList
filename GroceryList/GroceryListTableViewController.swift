//
//  GroceryListTableViewController.swift
//  GroceryList
//
//  Created by Ryan Cortez on 7/21/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class GroceryListTableViewController: ListTableViewController {
    
    // MARK: - Initial Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFetchResultsController()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
        
    // MARK: - TableView Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchResultsController.sections else {
            fatalError("No sections were found in the fetchResultsController")
        }
        return sections[section].numberOfObjects
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("groceryListCell", forIndexPath: indexPath) as? CounterTableViewCell else {
            print("Did not recieve CounterTableViewCell")
            let blankCell = tableView.dequeueReusableCellWithIdentifier("groceryListCell", forIndexPath: indexPath)
            return blankCell
        }
        guard let list = self.fetchResultsController.objectAtIndexPath(indexPath) as? NSManagedObject else {
            print("Did not find NSManagedObject")
            let blankCell = tableView.dequeueReusableCellWithIdentifier("groceryListCell", forIndexPath: indexPath)
            return blankCell
        }
        cell.label.text = list.valueForKey("title") as? String
        
        let listItems = list.mutableSetValueForKey("groceryItems")
        cell.counterView.counter = listItems.allObjects.count
        return cell
    }
    
    // MARK: - TableView Delegate

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            guard let fetchedObjects = self.fetchResultsController.fetchedObjects else {
                print("No fetchedObjects were found")
                return
            }
            guard let managedObject = fetchedObjects[indexPath.row] as? NSManagedObject else {
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
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "addList") {
            guard let navigationController = segue.destinationViewController as? UINavigationController else {
                print("segue.destintationViewController was not a GroceryItemTableViewController")
                return
            }
            guard let destinationViewController = navigationController.viewControllers.first as? AddToGroceryListTableViewController else {
                print("Did not find first viewController in the navigation controller")
                return
            }
            destinationViewController.delegate = self
            destinationViewController.managedObjectContext = self.managedObjectContext
        }
        
        if (segue.identifier == "listToListItem") {
            guard let indexPath = self.tableView.indexPathForSelectedRow else {
                print("No indexPath were selected")
                return
            }
            guard let destinationViewController = segue.destinationViewController as? GroceryItemTableViewController else {
                print("segue.destintationViewController was not a GroceryItemTableViewController")
                return
            }
            destinationViewController.list = self.fetchResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
            destinationViewController.managedObjectContext = self.managedObjectContext
        }
    }
}

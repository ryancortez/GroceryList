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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFetchResultsController()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchResultsController.sections else {
            fatalError("No sections were found in the fetchResultsController")
        }
        return sections[section].numberOfObjects
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groceryListCell", forIndexPath: indexPath)
        let listItem = self.fetchResultsController.objectAtIndexPath(indexPath)
        cell.textLabel?.text = listItem.valueForKey("title") as? String
        return cell
    }

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

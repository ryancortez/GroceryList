//
//  GroceryItemTableViewController.swift
//  GroceryList
//
//  Created by Ryan Cortez on 7/21/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class GroceryItemTableViewController: ListTableViewController {

    var list: NSManagedObject!
    var items: NSSet!
    
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
}

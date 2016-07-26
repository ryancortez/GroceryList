//
//  AddToGroceryItemTableViewController.swift
//  GroceryList
//
//  Created by Ryan Cortez on 7/21/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

protocol AddToGroceryItemTableViewControllerDelegate {
    func reloadTable(withItems items: NSSet)
    func passList(list: NSManagedObject, andItems items: Array<NSManagedObject>)
}

class AddToGroceryItemTableViewController: AddToListTableViewController {
    
    var list: NSManagedObject!
    var items: Array<NSManagedObject>!
    var delegate: AddListTableViewControllerDelegate!
    var itemTableViewControllerDelegate: AddToGroceryItemTableViewControllerDelegate!
    
    override func viewWillAppear(animated: Bool) {
        let items = list.valueForKey("groceryItems") as! NSSet
        self.items = items.allObjects as? Array<NSManagedObject>
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else if (section == 1) {
            return items.count + 1
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addGroceryItemCell", forIndexPath: indexPath) as! TextFieldTableViewCell
        let key = "title"
        if (indexPath.section == 0) {
            cell.textField.placeholder = "Add grocery list name"
            guard let string = list.valueForKey(key) as? String else {
                print("list(\(key)) didn't not return a string ")
                return cell
            }
            cell.textField.text = string
        } else if (indexPath.section == 1) {
            cell.textField.placeholder = "Add grocery item"
            if (items.count > indexPath.row) {
                let item = items[indexPath.row]
                guard let string = item.valueForKey(key) as? String else {
                    print("item(\(indexPath.row)) didn't not return a String ")
                    return cell
                }
                cell.textField.text = string
            }
        }
        return cell
    }

    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let title = getTitleFromTextFieldTableViewCell(forRow: 0, inSection: 0)
        let items = getListItemsFromTextFieldTableViewCells(inSection: 1)

        list.setValue(title, forKey: "title")
        let set = list.mutableSetValueForKey("groceryItems")
        set.removeAllObjects()
        set.addObjectsFromArray(items)
        self.items = items
        itemTableViewControllerDelegate.reloadTable(withItems: set)
        save()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

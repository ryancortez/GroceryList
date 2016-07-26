//
//  AddToGroceryListTableViewController.swift
//  GroceryList
//
//  Created by Ryan Cortez on 7/21/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

protocol AddListTableViewControllerDelegate {
    var managedObjectContext: NSManagedObjectContext! { get set }
    func insertNewList(title: String, items: Array<NSManagedObject>?) -> NSManagedObject
}

class AddToGroceryListTableViewController: AddToListTableViewController, UITextFieldDelegate {

    var delegate: AddListTableViewControllerDelegate!
    
    // MARK: - TableView Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else if (section == 1) {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addGroceryListCell", forIndexPath: indexPath) as! TextFieldTableViewCell
        
        if (indexPath.section == 0) {
            cell.textField.placeholder = "Add grocery list name"
            
        } else if (indexPath.section == 1) {
            cell.textField.placeholder = "Add grocery item"
        }
        
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        let title = getTitleFromTextFieldTableViewCell(forRow: 0, inSection: 0)
        let items = getListItemsFromTextFieldTableViewCells(inSection: 1)
    
        if (title != "") {
            delegate.insertNewList(title, items: items)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
   }

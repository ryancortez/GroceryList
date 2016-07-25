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
    func insertNewList(title: String, items: Array<NSManagedObject>?)
}

class AddToGroceryListTableViewController: AddToListTableViewController, UITextFieldDelegate {

    var delegate: AddListTableViewControllerDelegate!
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        // Get the string from the first cell displayed at the top
        let titleIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        let listTitleCell = self.tableView.cellForRowAtIndexPath(titleIndexPath) as! TextFieldTableViewCell
        guard let listItemTitle = listTitleCell.textField.text  else {
            print("No String found in titleCell.textField.text ")
            return
        }
        
        var items:Array<NSManagedObject> = []
        let section = 1
        let numberOfItemRows = self.tableView.numberOfRowsInSection(section)
        
        for rowNumber in 0...numberOfItemRows - 1 {
            
            let itemIndexPath = NSIndexPath(forRow: rowNumber, inSection: section)
            let itemCell = self.tableView.cellForRowAtIndexPath(itemIndexPath) as! TextFieldTableViewCell
            let item = NSEntityDescription.insertNewObjectForEntityForName("GroceryItem", inManagedObjectContext: delegate.managedObjectContext)
            item.setValue(itemCell.textField.text, forKey: "title")
            items.append(item)
        }
        
        if (listItemTitle != "") {
            delegate.insertNewList(listItemTitle, items: items)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

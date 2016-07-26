//
//  AddToListTableViewController.swift
//  GroceryList
//
//  Created by Ryan Cortez on 7/21/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

class AddToListTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    func save() {
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Unable to save new list")
            return
        }
    }
    
    func getTitleFromTextFieldTableViewCell(forRow row: Int, inSection section: Int) -> String {
        let indexPath = NSIndexPath(forRow: row, inSection: section)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! TextFieldTableViewCell
        guard let title = cell.textField.text  else {
            print("No String found in titleCell.textField.text")
            return ""
        }
        return title
    }
    
    func getListItemsFromTextFieldTableViewCells(inSection section: Int) -> Array<NSManagedObject> {
        var items:Array<NSManagedObject> = []
        let numberOfItemRows = self.tableView.numberOfRowsInSection(section)
        if (numberOfItemRows >= 1) {
            for rowNumber in 0...numberOfItemRows - 1 {
            let itemIndexPath = NSIndexPath(forRow: rowNumber, inSection: section)
            let itemCell = self.tableView.cellForRowAtIndexPath(itemIndexPath) as! TextFieldTableViewCell
                let item = NSEntityDescription.insertNewObjectForEntityForName("GroceryItem", inManagedObjectContext: managedObjectContext)
                if (itemCell.textField.text != "") {
                    item.setValue(itemCell.textField.text, forKey: "title")
                    items.append(item)
                }
            }
        }
        return items
    }


    // MARK: - Table view Data Source
 
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

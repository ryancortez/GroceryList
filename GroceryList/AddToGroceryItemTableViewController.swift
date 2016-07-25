//
//  AddToGroceryItemTableViewController.swift
//  GroceryList
//
//  Created by Ryan Cortez on 7/21/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

protocol AddListItemTableViewControllerDelegate {
    var list: NSManagedObject! { get set }
    func insertNewListItem(title: String, image: NSData?, price: Float?, groceryListTitle: String)
}

class AddToGroceryItemTableViewController: AddToListTableViewController {

    var delegate: AddListItemTableViewControllerDelegate!
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let titleIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        let priceIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        
        let titleCell = self.tableView(self.tableView, cellForRowAtIndexPath: titleIndexPath) as! TextFieldTableViewCell
        let priceCell = self.tableView(self.tableView, cellForRowAtIndexPath: priceIndexPath) as! TextFieldTableViewCell
        
        let listItemTitle = titleCell.textField.text
        let price = priceCell.textField.text?.floatValue
        
        let groceryListTitle = delegate.list.valueForKey("title") as! String
        delegate.insertNewListItem(listItemTitle!, image: nil, price: price, groceryListTitle: groceryListTitle)
    }
}

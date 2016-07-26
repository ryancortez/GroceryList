//
//  CounterTableViewCell.swift
//  GroceryList
//
//  Created by Ryan Cortez on 7/26/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class CounterTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var counterView: CounterView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ItemsDataSource.swift
//  split
//
//  Created by Brandon Taleisnik on 7/11/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import Foundation
import UIKit

class ItemsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
//    var items: [String] = []
    
    var items: [Item] = []
    var delegate: ItemDelegate?

    override init() {
        self.items = []
    }
    
    init(items: [Item]) {
        self.items = items
//        for item in items {
//            self.items.append(item)
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        cell.isAssigned = items[indexPath.row].isAssigned
        
        if cell.isAssigned == true {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        let priceLabel = String(format: "%.2f", arguments: [items[indexPath.row].price!])

        
        cell.itemID = items[indexPath.row].itemID
        cell.itemName.text = items[indexPath.row].name //"Brandon Taleisnik"
        cell.priceLabel.text = "$\(priceLabel)"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as! ItemTableViewCell
        
        print("\nCURRENT SELECTED CELL")
        print(currentCell.itemName.text!)
        print(currentCell.priceLabel.text!)
        //Need to figure out way to access isAssigned; maybe add Item() variable to ItemTableViewCell, and initialize itemName and priceLabel as member variables of that item, and access those member variables via cell.item.itemName
        
//        self.delegate?.didAddActivity(activity: activityDto!)
        
        //Remove $ sign, then convert to string
        var price = currentCell.priceLabel.text!
        price.remove(at: price.startIndex)

        
        let current_item = Item(name: currentCell.itemName.text, price: Double(price), itemID: currentCell.itemID)
        
        self.delegate?.didSelectItem(item: current_item)
        
        
        
    }
    
//    // Makes cells draggable in edit modehttps://github.com/nicolasgomollon/LPRTableView
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        
//        let source = items[sourceIndexPath.row]
//        let destination = items[destinationIndexPath.row]
//        items[sourceIndexPath.row] = destination
//        items[destinationIndexPath.row] = source
//    }

    
    
}
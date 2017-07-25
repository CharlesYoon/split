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
    var secondItems: [ItemDTO] = []
    var delegate: ItemDelegate?
    
    
    lazy var selectedRows:[Bool] = {
        return [Bool](repeating: false, count: self.items.count)
    }()


    override init() {
        self.items = []
    }
    
    init(items: [Item]) {
        self.items = items
//        for item in items {
//            self.items.append(item)
//        }
    }
    
    //add for ItemsDTO
    init(secondItems: [ItemDTO]) {
        self.secondItems = secondItems
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
        
        
        //if the row has been selected before, assume isAssigned == true, so add checkmark
        if selectedRows[indexPath.row] == true {
            // row has been selected, so disable user interaaction and add checkmark
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            cell.isUserInteractionEnabled = false
            cell.contentView.backgroundColor = UIColor.white
            cell.itemName.textColor = UIColor.black
            cell.priceLabel.textColor = UIColor.black
        }
        else {
            cell.accessoryType = .none
            cell.isUserInteractionEnabled = true
            cell.contentView.backgroundColor = UIColor.white
            cell.itemName.textColor = UIColor.black
            cell.priceLabel.textColor = UIColor.black
        }
        
        let priceLabel = String(format: "%.2f", arguments: [items[indexPath.row].price!])

        
        cell.itemID = items[indexPath.row].itemID
        cell.itemName.text = items[indexPath.row].name //"Brandon Taleisnik"
        cell.priceLabel.text = "$\(priceLabel)"

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! ItemTableViewCell

            currentCell.contentView.backgroundColor = UIColor.white
            currentCell.itemName.textColor = UIColor.black
            currentCell.priceLabel.textColor = UIColor.black
        
        //if item not yet assigned, user must have clicked multiple items before clicking guest, so don't disable cell yet
        if currentCell.isAssigned == false {
            selectedRows[indexPath.row] = !selectedRows[indexPath.row]
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as! ItemTableViewCell
        
        //re-format cell colors
        
        if selectedRows[indexPath.row] != true {
            currentCell.contentView.backgroundColor = UIColor(hex: "221E2B")
            currentCell.itemName?.textColor = UIColor(hex: "F7CE3E")
            currentCell.priceLabel?.textColor = UIColor(hex: "F7CE3E")
        } else {
            currentCell.contentView.backgroundColor = UIColor.white
            currentCell.itemName.textColor = UIColor.black
            currentCell.priceLabel.textColor = UIColor.black
        }
        
        print("\nCURRENT SELECTED CELL")
        print(currentCell.itemName.text!)
        print(currentCell.priceLabel.text!)
        
        //Remove $ sign, then convert to string
        var price = currentCell.priceLabel.text!
        price.remove(at: price.startIndex)

        
        let current_item = Item(name: currentCell.itemName.text, price: Double(price), itemID: currentCell.itemID)
        
        //Toggle state of accessory type for this index to correct status if assigned or not
        selectedRows[indexPath.row] = true
        
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

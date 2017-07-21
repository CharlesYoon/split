//
//  GuestsDataSource.swift
//  split
//
//  Created by Brandon Taleisnik on 7/11/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import Foundation
import UIKit

class GuestsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource, ItemDelegate {
    
    var guests: [Guest] = []
    var secondGuests: [GuestDTO] = []
    var currentItem: Item?
    
    var delegate: ItemGuestsDelegate?

    
    override init() {
        self.guests = []
    }
    
    init(guests: [Guest]) {
        self.guests = guests
    }
    
    //Realm
    init(guests: [GuestDTO]) {
        self.secondGuests = guests
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return guests.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemGuestsCell", for: indexPath) as! ItemGuestsTableViewCell
        
                
        
        //cell.guestName.text = guests[indexPath.row].name //"Brandon Taleisnik"
        cell.guestPic.image = guests[indexPath.row].profPicImage
        cell.guestPic.setRounded()
        cell.guestPic.contentMode = UIViewContentMode.scaleAspectFill
        cell.guestID = guests[indexPath.row].guestID
        
        cell.guestPic.layer.borderWidth = 2
        cell.guestPic.layer.borderColor = UIColor(hex: "F7CE3E").cgColor

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as! ItemGuestsTableViewCell
        
        currentCell.contentView.backgroundColor = UIColor(hex: "221E2B")
        
        let currentGuest = Guest(profPicImage: currentCell.guestPic.image, guestID: currentCell.guestID!)
        
        
        
        print("\nCurrent Guest: " + currentGuest.name! + " " + currentGuest.guestID!)
        print("Current Item: " + (currentItem?.name)!)
        
        delegate?.didSelectGuest(item: currentItem, guest: currentGuest)
        
    }
    
    
    
    
    
    func didSelectItem(item: Item?) {
        
        
        if item != nil {
            currentItem = item
            print("RECEIVED DATA WOO!!")
            print((currentItem?.name)!)
            print((currentItem?.price)!)
            print((currentItem?.isAssigned)!)
        }

        
    
        //call waitForGuestSelection() -> Guest  (<-- implement)
        
        //call didSelectGuest() (<-- implement)
            //inside didSelectGuest(), call DivideDelegate
            //Make DivideDelegate protocol and make DivideViewController a DivideDelegate
            //Inside Divide Controller implement DivideDelegate function which will receive the Guest and Item from the GuestsDataSource and can then update the guest current total and mark item as assigned
    }
    
}

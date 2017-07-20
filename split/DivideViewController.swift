//
//  DivideViewController.swift
//  split
//
//  Created by Brandon Taleisnik on 7/11/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class DivideViewController: UIViewController, ItemGuestsDelegate {

    @IBOutlet weak var guestsTableView: UITableView!
    @IBOutlet weak var itemsTableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var whiteBox: UIView!
    
    
    var guestsDataSource: GuestsDataSource?
    var itemsDataSource: ItemsDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //activate loading spinner
        spinner.startAnimating()
        
        guestsTableView.isScrollEnabled = false
//        guestsTableView.allowsSelection = false
        
        
        //Puts cells into edit mode so they can be dragged
        //itemsTableView.setEditing(true, animated: true)
    
        
    }
    
    


    
    
    override func viewWillAppear(_ animated: Bool) {
        itemsDataSource = ItemsDataSource()
        guestsDataSource = GuestsDataSource()
        
        itemsDataSource?.delegate = guestsDataSource
        guestsDataSource?.delegate = self

        
        getItems()
        getGuests()
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "navToPayment" {
            
            let paymentVC = segue.destination as? PaymentTableViewController
            
            paymentVC?.guestsDataSource = self.guestsDataSource
        }
    }
    
    // MARK: Delegate Function
    func didSelectGuest(item: Item?, guest: Guest?) {
        
        print((item?.name)!)
        print((item?.price)!)
        
        //update Item to be marked as "used"
        for i in (itemsDataSource?.items)! {
            if (i.itemID == item?.itemID) {
                i.isAssigned = true
                
                print("\n\nUPDATED ASSIGNMENT")
                print((i.name)!)
                print((i.isAssigned)!)
                
                updateItemData(item: i)
            }
        }
        
        //Update Guest Total with price of Item added
        for i in (guestsDataSource?.guests)! {
            if (i.guestID == guest?.guestID) {
                i.mealTotal! += (item?.price)!
                
                print("\n\nUPDATED TOTAL")
                print((i.guestID)!)
                print((i.mealTotal)!)
                
                updateGuestData(guest: i)
            }
        }
        
    }
    
    //add the RealmSwift portion here, you want to replace firebase with it

    func updateGuestData(guest: Guest?) {
        
        //finished adding Realm here
        let realm = try! Realm()
        try! realm.write(){
            print("It's sending!!!")
            let newGuest = GuestDTO()
            newGuest.guestID = guest?.guestID
            newGuest.mealTotal = (guest?.mealTotal)!
            realm.add(newGuest)
        }

        let guestURL = "https://split2-62ca2.firebaseio.com/guests/\((guest?.guestID)!).json"
        
        Alamofire.request(guestURL, method: .put, parameters: guest?.toJSON(), encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
            
            switch response.result {
            case .success:
                
                print("UPDATED:")
                print(response.result.value!)
                
                //                self.delegate?.didAddActivity(activity: activityDto!)
                //self.dismiss(animated: true, completion: nil)
                
                
                break
            case .failure:
                // TODO: Display an error dialog
                break
            }
            
        })

    }
    
    func updateItemData(item: Item?) {
        
        //Realm
        let realm = try! Realm()
        try! realm.write(){
            print("Updating Items")
            let newItems = ItemDTO.init(name: item?.name, price: item?.price)
            realm.add(newItems)
            self.itemsTableView.reloadData()
        }
    
        //firebase
        var itemURL: String = "https://split2-62ca2.firebaseio.com/items/"
        itemURL += (item?.itemID)! + ".json"
        
        Alamofire.request(itemURL, method: .put, parameters: item?.toJSON(), encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
            
            switch response.result {
            case .success:
                
                print("UPDATED:")
                print(response.result.value!)
                
                self.itemsTableView.reloadData()
                
                //                self.delegate?.didAddActivity(activity: activityDto!)
                //self.dismiss(animated: true, completion: nil)
                break
            case .failure:
                // TODO: Display an error dialog
                break
            }
            
        })
        
    }

    
    
    
    
    func getItems() {
        //Realm
        
        
        //Firebase
        Alamofire.request("https://split2-62ca2.firebaseio.com/items.json").responseJSON(completionHandler: {
            response in
            print("IMPORTING ITEMS")
            //print(response.result.value)
            
            if let itemDictionary = response.result.value as? [String: AnyObject] {
                
                self.itemsDataSource?.items = []
                
                for (key, value) in itemDictionary {
                    print("Key: \(key)")
                    print("Value: \(value)")
                    
                    if let singleItemDictionary = value as? [String: AnyObject] {
                        let item = Item(dictionary: singleItemDictionary, key: key)
                        self.itemsDataSource?.items.append(item)
                        self.itemsTableView.delegate = self.itemsDataSource
                        self.itemsTableView.dataSource = self.itemsDataSource
                        self.itemsTableView.reloadData()
                    }
                }
                
            }
        })
    }
    
    func getGuests() {
        //Realm
        var gettingGuests = try! Realm().objects(GuestDTO)
        
        
        
        //FireBase
        Alamofire.request("https://split2-62ca2.firebaseio.com/guests.json").responseJSON(completionHandler: {
            response in
            print("IMPORTING GUESTS")
            //print(response.result.value)
            
            if let guestDictionary = response.result.value as? [String: AnyObject] {
                
                self.guestsDataSource?.guests = []
                
                for (key, value) in guestDictionary {
                    print("Key: \(key)")
                    print("Value: \(value)")
                    
                    if let singleGuestDictionary = value as? [String: AnyObject] {
                        let guest = Guest(dictionary: singleGuestDictionary, key: key)
                        
                        Alamofire.request(guest.profPicURL!).responseImage(completionHandler: {
                            response in
                            
                            print("IMAGE DOWNLOADED")
                            print(response)
                            
                            guest.profPicImage = response.result.value
                            
                            self.guestsTableView.reloadData()
                        })

                        self.guestsDataSource?.guests.append(guest)
                        self.guestsTableView.delegate = self.guestsDataSource
                        self.guestsTableView.dataSource = self.guestsDataSource
                        self.guestsTableView.reloadData()
                    }
                }
                
            }
            
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.whiteBox.isHidden = true
            
            // Print Guest Keys
//            for i in (self.guestsDataSource?.guests)! {
//                print("Guest \(i.name ?? "balh") \(i.guestID ?? "stfu")")
//            }
        })

    }

}

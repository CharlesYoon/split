//
//  GuestsTableViewController.swift
//  split
//
//  Created by Brandon Taleisnik on 7/10/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Alamofire
import AlamofireImage

class GuestsTableViewController: UITableViewController, AddGuestsDelegate {
    
    var guests: [Guest] = []
    
    @IBAction func doneButton(_ sender: Any) {
        
        //reset guest mealTotals to 0 when new bill started
        for guest in self.guests {
            guest.mealTotal = 0
            resetGuestMealTotal(guest: guest)
        }
        
        performSegue(withIdentifier: "navToDivide", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //add the Realm DataBase
        
        Alamofire.request("https://split2-62ca2.firebaseio.com/guests.json").responseJSON(completionHandler: {
            response in
            //print(response.result.value)
            
            if let guestDictionary = response.result.value as? [String: AnyObject] {
                
                self.guests = []
                
                for (key, value) in guestDictionary {
                    print("Key: \(key)")
                    print("Value: \(value)")
                    
                    if let singleGuestDictionary = value as? [String: AnyObject] {
                        let guest = Guest(dictionary: singleGuestDictionary, key: key)
                        
                        //                        Alamofire.request(guest.profPicURL!).responseImage { response in
                        //                            debugPrint(response)
                        //
                        //                            print(response.request)
                        //                            print(response.response)
                        //                            debugPrint(response.result)
                        //
                        //                            if let image = response.result.value {
                        //                                print("image downloaded: \(image)")
                        //                            }
                        //                        }
                        
                        
                        // have to add the pictures here
                        
                        Alamofire.request(guest.profPicURL!).responseImage(completionHandler: {
                            response in
                            
                            print("IMAGE DOWNLOADED")
                            print(response)
                            
                            guest.profPicImage = response.result.value
                            
                            self.tableView.reloadData()
                        })
                        
                        self.guests.append(guest)
                        self.tableView.reloadData()
                    }
                }
                
            }
        })

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navToAddGuest" {
            
            let navVC = segue.destination as! UINavigationController
            let addGuestVC = navVC.topViewController as! AddGuestsViewController
            
            addGuestVC.delegate = self
        }
    }
    
    func didAddGuest(guest: Guest?) {
        self.guests.append(guest!)
        
        DispatchQueue.main.async() {
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return guests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestCell", for: indexPath) as! GuestsTableViewCell
        
        //If profile pic has loaded, hide spinner
        if let profPic = guests[indexPath.row].profPicImage {
            cell.guestImage.image = profPic
            cell.spinner.stopAnimating()
            cell.spinner.isHidden = true
        } else {
            cell.spinner.startAnimating()
            cell.spinner.isHidden = false
        }

        
        cell.guestName.text = guests[indexPath.row].name
        cell.guestVenmo.text = guests[indexPath.row].venmoName
        cell.guestImage.setRounded()
        cell.guestImage.contentMode = UIViewContentMode.scaleAspectFill


        return cell
    }
    
    func resetGuestMealTotal(guest: Guest?) {
        
        //add Realm here
        // deletes the original item prior to being updated and added back below
        // adds back the item with an updated count
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.create(GuestDTO.self, value: ["mealTotal": guest?.mealTotal], update: false)
        }
        
        
        //Firebase portion
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

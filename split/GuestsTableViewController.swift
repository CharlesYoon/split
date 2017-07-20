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

class GuestsTableViewController: UITableViewController, AddGuestsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var guests: [Guest] = []
    var secondGuests: [GuestDTO] = []
    
    let picker = UIImagePickerController()
    
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
        
        picker.delegate = self
        
        openCamera()

        //add the Realm DataBase
        //adding Guests to the database
        //MARK: ERROR
        //request all the guest's photo urls as well as ids
        
//        let tableGuests = try! Realm().objects(GuestDTO.self)
//        self.secondGuests = []
//        for tableGuest in tableGuests{
//            let guest = GuestDTO()
//            guest.profPicImage = tableGuest.profPicImage
//            self.secondGuests.append(guest)
//            self.tableView.reloadData()
//        }
    
        //fireBase portion
//        Alamofire.request("https://split2-62ca2.firebaseio.com/guests.json").responseJSON(completionHandler: {
//            response in
//            //print(response.result.value)
//            
//            if let guestDictionary = response.result.value as? [String: AnyObject] {
//                
//                self.guests = []
//                
//                for (key, value) in guestDictionary {
//                    print("Key: \(key)")
//                    print("Value: \(value)")
//                    
//                    if let singleGuestDictionary = value as? [String: AnyObject] {
//                        let guest = Guest(dictionary: singleGuestDictionary, key: key)
//                        
//                        // have to add the pictures here
//                        
//                        Alamofire.request(guest.profPicURL!).responseImage(completionHandler: {
//                            response in
//                            
//                            print("IMAGE DOWNLOADED")
//                            print(response)
//                            
//                            guest.profPicImage = response.result.value
//                            
//                            self.tableView.reloadData()
//                        })
//                        
//                        self.guests.append(guest)
//                        self.tableView.reloadData()
//                    }
//                }
//                
//            }
//        })

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navToAddGuest" {
            
            let navVC = segue.destination as! UINavigationController
            let addGuestVC = navVC.topViewController as! AddGuestsViewController
            
            addGuestVC.delegate = self
        }
    }
    
    func finishedAddingGuests() {
        dismiss(animated:false, completion: nil)
        
        self.tableView.reloadData()
        print("Added All Guests")
        //openCamera()
    }
    
    func cameraPressed() {
        
        print("CAMERA PRESSED YAY")
    }
    
    
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            
            //Add guest Button
            let testView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2))
            let button = UIButton(frame: CGRect(x: self.view.frame.width-150, y: 50, width: 150, height: 50))
            button.addTarget(self, action: #selector(finishedAddingGuests), for: .touchUpInside)
            button.layer.backgroundColor = UIColor(hex: "ffffff").cgColor
            button.setTitle("Done Adding", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            
            testView.addSubview(button)
            
//            let tap = UITapGestureRecognizer(target: self, action: #selector(cameraPressed))
//            tap.delegate = self as? UIGestureRecognizerDelegate
//            testView.addGestureRecognizer(tap)
//            testView.isUserInteractionEnabled = true
            
            picker.cameraOverlayView = testView

            
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(picker, animated: true, completion: nil)
        }
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = chosenImage
        
        guests.append(Guest(profPicImage: chosenImage))
        
        //prepare camera for next picture once an image is selected
        dismiss(animated:false, completion: nil)
        openCamera()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didAddGuest(guest: Guest?) {
        self.guests.append(guest!)
        
        DispatchQueue.main.async() {
            self.tableView.reloadData()
        }
    }
    
    func didAddGuest(guest: GuestDTO?) {
        self.secondGuests.append(guest!)
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

        
//        cell.guestName.text = guests[indexPath.row].name
//        cell.guestVenmo.text = guests[indexPath.row].venmoName
        cell.guestImage.setRounded()
        cell.guestImage.contentMode = UIViewContentMode.scaleAspectFill


        return cell
    }
    
    func resetGuestMealTotal(guest: Guest?) {
        // MARK: ERROR
        // add Realm here
        // ask Brandon about this function
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
    
}

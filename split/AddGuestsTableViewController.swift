//
//  AddGuestsTableViewController.swift
//  split
//
//  Created by Brandon Taleisnik on 7/10/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit
import Alamofire

class AddGuestsTableViewController: UITableViewController {

    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addGuestCell", for: indexPath) as! AddGuestsTableViewCell


        cell.venmoTextField.text = "@venmoooo"
        
        return cell
    }

    @IBAction func saveButton(_ sender: Any) {
        
        var guest: Guest?
        
        guest = Guest(name: "Test3", venmoName: "@test3", profPicURL: "profPic3")
        
        
        Alamofire.request("https://split-f4380.firebaseio.com/guests.json", method: .post, parameters: guest?.toJSON(), encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
            
            switch response.result {
            case .success:
//                self.delegate?.didAddActivity(activity: activityDto!)
                self.dismiss(animated: true, completion: nil)
                break
            case .failure:
                // TODO: Display an error dialog
                break
            }
            
        })
        
        
        
        
        
//        if let image = selectedImage.image {
//            // Get a reference to the storage service using the default Firebase App
//            let storage = Storage.storage()
//            
//            // Create a storage reference from our storage service
//            let storageRef = storage.reference()
//            
//            var url = ""
//            if let name = activityDto?.name {
//                url = "images/\(name).jpg"
//            } else {
//                url = "images/random.jpg"
//            }
//            
//            let imagesRef = storageRef.child(url)
//            
//            // Local file you want to upload
//            //let localFile = image. //URL(string: "path/to/image")!
//            
//            // Create the file metadata
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/jpeg"
//            
//            // Upload file and metadata to the object 'images/mountains.jpg'
//            //let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
//            let jpg = UIImageJPEGRepresentation(image, CGFloat(1))
//            let uploadTask = imagesRef.putData(jpg!)
//            
//            // Listen for state changes, errors, and completion of the upload.
//            uploadTask.observe(.resume) { snapshot in
//                // Upload resumed, also fires when the upload starts
//            }
//            
//            uploadTask.observe(.pause) { snapshot in
//                // Upload paused
//            }
//            
//            uploadTask.observe(.progress) { snapshot in
//                // Upload reported progress
//                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
//                    / Double(snapshot.progress!.totalUnitCount)
//                self.progress.progress = Float(percentComplete)
//            }
//            
//            uploadTask.observe(.success) { snapshot in
//                // Upload completed successfully
//                self.activityDto?.imageUrl = snapshot.metadata?.downloadURL()?.absoluteString
//                self.postActivity()
//            }
//            
//            uploadTask.observe(.failure) { snapshot in
//                if let error = snapshot.error as? NSError {
//                    switch (StorageErrorCode(rawValue: error.code)!) {
//                    case .objectNotFound:
//                        // File doesn't exist
//                        break
//                    case .unauthorized:
//                        // User doesn't have permission to access file
//                        break
//                    case .cancelled:
//                        // User canceled the upload
//                        break
//                        
//                        /* ... */
//                        
//                    case .unknown:
//                        // Unknown error occurred, inspect the server response
//                        break
//                    default:
//                        // A separate error occurred. This is a good place to retry the upload.
//                        break
//                    }
//                }
//            }
//        } else {
//            postActivity()
//        }

        
        
        
        
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

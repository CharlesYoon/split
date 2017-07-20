//
//  AddGuestsViewController.swift
//  split
//
//  Created by Brandon Taleisnik on 7/13/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit
import Alamofire
import Realm
import RealmSwift
import FirebaseStorage
import AlamofireImage

class AddGuestsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var venmoTextField: UITextField!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var uploadingLabel: UILabel!
    
    let picker = UIImagePickerController()
    
    var delegate: AddGuestsDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.setRounded()
        photoImageView.layer.borderWidth = 0.5
        photoImageView.layer.borderColor = UIColor.gray.cgColor
        photoImageView.backgroundColor = UIColor(hex: "E8E8E8")
        progressBar.isHidden = true
        uploadingLabel.isHidden = true

        picker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        
        //Added logic to choose from camera if available, or library if not
        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            takeCameraPhoto()
            
        } else {
            
            choosePhotoLibrary()
            
        }
        
        
    }
    
    func choosePhotoLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)

    }
    
    func takeCameraPhoto() {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = chosenImage
            photoImageView.contentMode = .scaleToFill

        } else{
            print("Something went wrong")
        }
        
        photoButton.isHidden = true

        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 5)

        
        progressBar.isHidden = false
        photoImageView.isHidden = true
        nameTextField.isHidden = true
        venmoTextField.isHidden = true
        photoButton.isHidden = true
        uploadingLabel.isHidden = false
        
        var guest: Guest?
        guest = Guest(name: nameTextField.text, venmoName: venmoTextField.text, profPicURL: "blah")
        
    
                if let image = photoImageView.image {
                    
                    guest?.profPicImage = image
                    
                    // Get a reference to the storage service using the default Firebase App
                    let storage = Storage.storage()
        
                    // Create a storage reference from our storage service
                    let storageRef = storage.reference()
        
                    var url = ""
                    if let name = guest?.name {
                        url = "images/\(name).jpg"
                    } else {
                        url = "images/random.jpg"
                    }
                    
                    

                    let imagesRef = storageRef.child(url)
        
                    // Local file you want to upload
                    //let localFile = image. //URL(string: "path/to/image")!
        
                    // Create the file metadata
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
        
                    // Upload file and metadata to the object 'images/mountains.jpg'
                    //let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
                    let jpg = UIImageJPEGRepresentation(image, CGFloat(1))
                    let uploadTask = imagesRef.putData(jpg!)
        
                    // Listen for state changes, errors, and completion of the upload.
                    uploadTask.observe(.resume) { snapshot in
                        // Upload resumed, also fires when the upload starts
                    }
        
                    uploadTask.observe(.pause) { snapshot in
                        // Upload paused
                    }
        
                    uploadTask.observe(.progress) { snapshot in
                        // Upload reported progress
                        let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                            / Double(snapshot.progress!.totalUnitCount)
                        self.progressBar.progress = Float(percentComplete)
                    }
        
                    uploadTask.observe(.success) { snapshot in
                        // Upload completed successfully
                        guest?.profPicURL = snapshot.metadata?.downloadURL()?.absoluteString
                        self.postActivity(guest: guest)
                    }
        
                    uploadTask.observe(.failure) { snapshot in
                        if let error = snapshot.error as NSError? {
                            switch (StorageErrorCode(rawValue: error.code)!) {
                            case .objectNotFound:
                                // File doesn't exist
                                break
                            case .unauthorized:
                                // User doesn't have permission to access file
                                break
                            case .cancelled:
                                // User canceled the upload
                                break
        
                                /* ... */
                                
                            case .unknown:
                                // Unknown error occurred, inspect the server response
                                break
                            default:
                                // A separate error occurred. This is a good place to retry the upload.
                                break
                            }
                        }
                    }
                } else {
                    postActivity(guest: guest)
                }
        
        
        
        
        
    }
    
    func postActivity(guest: Guest?) {
        //add Realm here
        let guests = try! Realm().objects(GuestDTO.self)
        for guest in guests{
            self.delegate?.didAddGuest(guest: guest)
            self.dismiss(animated: true, completion: nil)
        }
        
        //fireBase Here
        Alamofire.request("https://split2-62ca2.firebaseio.com/guests.json", method: .post, parameters: guest?.toJSON(), encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
            
            switch response.result {
            case .success:
                
                print(response.result.value)
                
                if let guestDictionary = response.result.value as? [String: AnyObject] {
                    
                    for (key, value) in guestDictionary {
                        print("Key: \(key)")
                        print("Value: \(value)")
                        guest?.guestID = value as! String
                    }
                }
                self.delegate?.didAddGuest(guest: guest)
                self.dismiss(animated: true, completion: nil)
                break
            case .failure:
                // TODO: Display an error dialog
                break
            }
            
        })
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

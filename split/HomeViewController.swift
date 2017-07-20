//
//  HomeViewController.swift
//  split
//
//  Created by Brandon Taleisnik on 7/10/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var splitLogo: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        picker.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }


    func noCamera() {
        let alertController = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        
        let nextSegue = UIAlertAction(title: "OK", style: .cancel, handler: { action in self.performSegue(withIdentifier: "noCameraSegue", sender: self)})
        
        alertController.addAction(nextSegue)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

   
    
    //MARK: Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        cameraImageView.contentMode = .scaleAspectFit
        cameraImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

}


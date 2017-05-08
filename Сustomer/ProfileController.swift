//
//  ViewController.swift
//  Сustomer
//
//  Created by maxik on 23.04.17.
//  Copyright © 2017 Company. All rights reserved.

import UIKit

class ProfileController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBAction func tapTap(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Choose", message: "asdsd", preferredStyle: .alert)
        
        let libraryAction = UIAlertAction(title: "Library", style: .default, handler: {action in
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.modalPresentationStyle = .popover
            self.present(self.picker, animated: true, completion: nil)
            
        })
        
        let getPhotoAction = UIAlertAction(title: "Photo", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            } else {
                self.noCamera()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        
        alert.addAction(libraryAction)
        alert.addAction(getPhotoAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
   /* @IBAction func photoFromLibrary(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    
    @IBAction func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }*/
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    var picker = UIImagePickerController()
    
    @IBOutlet weak var avatarView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage { //2
            avatarView.contentMode = .scaleAspectFit //3
            avatarView.image = chosenImage //4
        }
        else if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage { //2
            avatarView.contentMode = .scaleAspectFit //3
            avatarView.image = chosenImage
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

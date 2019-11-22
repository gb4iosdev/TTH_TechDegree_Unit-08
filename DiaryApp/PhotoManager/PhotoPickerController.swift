//
//  ViewController.swift
//
//  Attribution:  ImagePickerExample,  Created by Dennis Parussini on 29.10.19.
//  Copyright © 2019 Dennis Parussini. All rights reserved.
//

import UIKit

final class PhotoPickerController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //Set up the image picker - either showing the camera or the photo library
    var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Always make self the delegate of the image picker.
        imagePicker.delegate = self
    }

    @IBAction func showImagePickerButtonTapped(_ sender: UIButton) {
        //Present the image picker like any other view(controller)
        present(imagePicker, animated: true)
    }
}

//Need to conform to UINavigationControllerDelegate
extension PhotoPickerController: UINavigationControllerDelegate {}

//Conform to UIImagePickerControllerDelegate
extension PhotoPickerController: UIImagePickerControllerDelegate {
    //This delegate gets called when you tap the "Cancel" button in the image picker. Just dismiss the image picker then.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    //This gets called when you take a picture with the camera or choose one from the photo library.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Parse the image and typecast it to a UIImage
        guard let image = info[.originalImage] as? UIImage else { return }
        
        //Dismiss the image picker when you're done with it.
        picker.dismiss(animated: true) {
            self.imageView.image = image
        }
    }
}

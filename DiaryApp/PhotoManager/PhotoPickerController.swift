//
//  ViewController.swift
//  ImagePickerExample
//
//  Created by Dennis Parussini on 29.10.19.
//  Copyright © 2019 Dennis Parussini. All rights reserved.
//

import UIKit

final class PhotoPickerController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //Set up the image picker. In this simple example we're either showing the camera or the photo library, but in a real world app you definitely want the user to be able to choose. Also, the camera doesn't work in simulators.
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
        
        //Parse the image and typecast it to a UIImage to use somewhere else in your view controller
        guard let image = info[.originalImage] as? UIImage else { return }
        
        //Always dismiss the image picker when you're done with it. In this case I assign the image to the image view, but you can also just assign it to a property, save it in Core Data or whatever you need to do with it. This also means you can first assign the image to something and then dismiss the image picker.
        picker.dismiss(animated: true) {
            self.imageView.image = image
        }
    }
}

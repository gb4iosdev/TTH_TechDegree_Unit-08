//
//  DetailViewController.swift
//  DiaryApp
//
//  Created by Gavin Butler on 28-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var item: Item?
    var context: NSManagedObjectContext!
    
    //Set up the image picker. Either showing the camera or the photo library
    var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        return picker
    }()
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        
        //Load the item if it exists
        if let item = item {
            titleTextField.text = item.text
            
            //Load the photo if it exists
            if let _ = item.imageData {
                let image = UIImage(data: item.imageData! as Data)
                self.photoImageView.image = image
            }
        }
        
        //Always make self the delegate of the image picker.
        imagePicker.delegate = self
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true)
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let item = item, let newText = titleTextField.text {
            item.text = newText
            context.saveChanges()
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        if let item = item {
            context.delete(item)
            context.saveChanges()
            navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - Photo Picker

//Need to conform to UINavigationControllerDelegate
extension DetailViewController: UINavigationControllerDelegate {}

//Conform to UIImagePickerControllerDelegate
extension DetailViewController: UIImagePickerControllerDelegate {
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
            self.photoImageView.image = image
            self.item?.imageData = image.jpegData(compressionQuality: 1.0)! as NSData
            self.context.saveChanges()
        }
    }
}

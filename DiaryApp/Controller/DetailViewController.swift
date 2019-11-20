//
//  DetailViewController.swift
//  DiaryApp
//
//  Created by Gavin Butler on 28-10-2019.
//  Photopicker Attribution:  ImagePickerExample,  Created by Dennis Parussini on 29.10.19.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class DetailViewController: UIViewController {
    
    var item: Item?
    var context: NSManagedObjectContext!
    
    var addedImages: [UIImage] = [] //Capture added photos from the picker (for saving only if save is selected)
    var userLocation: Coordinate?   //Capture the user's location coordinate (for saving only if save is selected)
    
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
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var miniMapView: MKMapView!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    override func viewDidLoad() {
        
        if item == nil { self.deleteButton.isHidden = true }
        
        //Load the item if it exists
        if let item = item {
            titleTextField.text = item.text
            detailTextView.text = item.detailedText
            
            //Set the photo image view if one exists
            if item.photos.count > 0 {
                let image = UIImage(data: item.photos.first!.image! as Data)
                self.photoImageView.image = image
            }
            
            //Set the map if location was saved
            if let location = item.location?.asCoordinate() {
                miniMapView.isHidden = false
                adjustMap(with: location)
            }
        }
        
        //Always make self the delegate of the image picker.
        imagePicker.delegate = self
    }
    
    @IBAction func addLocationButtonPressed(_ sender: Any) {
        let mapController = self.storyboard?.instantiateViewController(withIdentifier: "LocationMapController") as! LocationMapController
        mapController.locationSaverDelegate = self
        self.navigationController?.pushViewController(mapController, animated: true)
    }
    
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true)
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        guard let titleText = titleTextField.text, !titleText.isEmpty else {
            let alertController = UIAlertController(title: "Diary title cannot be empty", message: nil, preferredStyle: .alert)
            alertController.addAction(.init(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        if self.item == nil {  //Need to create a new item
            let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: self.context) as! Item
            self.item = item
        }
        
        //Save the information to the item
        if let item = self.item {
            item.text = titleText
            item.creationDate = Date() as NSDate
            item.detailedText = Date().formattedMmmDDYYYY()
        }
        
        //Save Item photos
        for image in self.addedImages {
            //Create a Photo instance, convert image to NSData, assign image data to photo then photo to item
            let photo = NSEntityDescription.insertNewObject(forEntityName: Photo.entityName, into: self.context) as! Photo
            photo.image = image.jpegData(compressionQuality: 1.0)! as NSData
            item?.photos.insert(photo)
        }
        
        //Save Location Data
        if let coordinate = self.userLocation {
            let location = NSEntityDescription.insertNewObject(forEntityName: Location.entityName, into: self.context) as! Location
            location.latitude = coordinate.latitude
            location.longitude = coordinate.longitude
            item?.location = location
        }
        
        context.saveChanges()
        navigationController?.popViewController(animated: true)
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
            //Save to this View Controller IBOutlet
            self.photoImageView.image = image
            
            //Add to the temporary store:
            self.addedImages.append(image)
        }
    }
}

//MARK: - Location Management:

extension DetailViewController: LocationSaverDelegate {
    func saveLocation(at coordinate: Coordinate) {
        userLocation = coordinate
        miniMapView.isHidden = false
        adjustMap(with: coordinate)
    }
}

//MARK: - Segues

extension DetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoCollection" {
            if let photoCollectionController = segue.destination as? PhotoCollectionController {
                photoCollectionController.images = savedImages() + addedImages
            }
        }
    }
}

//MARK: - Helper Methods

extension DetailViewController {
    
    //Return an array of images from the saved Photos
    func savedImages() -> [UIImage] {
        
        guard let photos = item?.photos else { return [] }
        
        var images: [UIImage] = []
        
        for photo in photos {
            images.append(UIImage(data: photo.image! as Data)!)
        }
        
        return images
    }
    
    func adjustMap(with coordinate: Coordinate) {
        print("Adjusting map with coord lat: \(coordinate.latitude) & long: \(coordinate.longitude)")
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate.twoDimensional()
        pin.title = "Last Saved Location"
        
        miniMapView.setRegion(around: coordinate, withSpan: 1_000)
        miniMapView.addAnnotation(pin)
    }
}

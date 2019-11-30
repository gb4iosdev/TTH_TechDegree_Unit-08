//
//  DetailViewController.swift
//  DiaryApp
//
//  Created by Gavin Butler on 28-10-2019.
//  Photopicker Attribution:  ImagePickerExample,  Created by Dennis Parussini on 29.10.19.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class DetailViewController: UIViewController {
    
    //Assigned in from DiaryListController
    var item: Item?
    var context = CoreDataStack.shared.managedObjectContext
    
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
    
    //IBOutlet Variables
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var miniMapView: MKMapView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        
        //Hide the delete button if we are dealing with the entry of a new Item
        if item == nil { self.deleteButton.isHidden = true }
        
        //Load the item if it exists
        if let item = item {
            titleTextField.text = item.text
            detailTextView.text = item.detailedText
            dateLabel.text = item.creationDateAsDate().formattedMmmDDYYYY()
            
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
        
        //Instantiate the ViewController from the storyboard, assigned the delegate to self for later saving of user location
        let mapController = self.storyboard?.instantiateViewController(withIdentifier: "LocationMapController") as! LocationMapController
        mapController.locationSaverDelegate = self
        
        //Show view controller by pushing onto the navigation stack
        self.navigationController?.pushViewController(mapController, animated: true)
    }
    
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        
        //Simply present the image picker
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        //Display Alert to user if required information is not provided, and return back to DetailViewController
        guard let titleText = titleTextField.text, !titleText.isEmpty else {
            //In a view controller you shouldn't present the alert in a different window. Just create an alert and then present it on the view controller.
            presentAlert(with: "Diary title cannot be empty", message: nil)
            
//            AlertManager().generateSimpleAlert(withTitle: "Diary title cannot be empty", message: "")
            return
        }
        
        if self.item == nil {  //Need to create a new item
            print("self.context == nil: \(self.context == nil)")
            
            //Just using the convenience init for creating new entities here. No more string enitiy names. 🎉
            let item = Item(context: context)
            self.item = item
        }
        
        //Save the information to the item
        if let item = self.item {
            item.text = titleText
            item.creationDate = Date() as NSDate
            item.detailedText = detailTextView.text
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
        
        //Data persistence and return to DiaryListController
        context.saveChanges()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        
        //Check to see that we have a current item, then delete, persist the change & return to DiaryListController
        if let item = item {
            context.delete(item)
            context.saveChanges()
            navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - Photo Picker – needs to conform to UINavigationControllerDelegate (all protocol requirements are optional)
extension DetailViewController: UINavigationControllerDelegate {}

//Conform to UIImagePickerControllerDelegate
extension DetailViewController: UIImagePickerControllerDelegate {
    //This delegate gets called when you tap the "Cancel" button in the image picker. Just dismiss the image picker then.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    //This gets called when you take a picture with the camera or choose one from the photo library.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Parse the image and typecast it to a UIImage
        guard let image = info[.originalImage] as? UIImage else { return }
        
        //Always dismiss the image picker when you’ve finished with it. The image is assigned to the image view and also to the temporary store which is referenced if the user saves.
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
    
    //When the user selects Save on the mapController it informs it’s delegate (this ViewController) to execute the save the coordinate and show the map.
    func saveLocation(at coordinate: Coordinate) {
        userLocation = coordinate
        miniMapView.isHidden = false
        adjustMap(with: coordinate)
    }
}

//MARK: - Segues

extension DetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //When user taps on the photo, show the collection of photos saved to this item (saved images plus added images)
        if segue.identifier == "showPhotoCollection" {
            if let photoCollectionController = segue.destination as? PhotoCollectionController {
                photoCollectionController.images = savedImages() + addedImages
            }
        }
    }
}

//MARK: - Helper Methods

extension DetailViewController {
    
    //Return an array of images from the saved Photos for the photoCollectionController
    func savedImages() -> [UIImage] {
        
        guard let photos = item?.photos else { return [] }
        
        var images: [UIImage] = []
        
        for photo in photos {
            images.append(UIImage(data: photo.image! as Data)!)
        }
        
        return images
    }
    
    //Move the map to the centre at the specified co-ordinate & add pin
    func adjustMap(with coordinate: Coordinate) {
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate.twoDimensional()
        pin.title = "Last Saved Location"
        
        miniMapView.setRegion(around: coordinate, withSpan: 1_000)
        miniMapView.addAnnotation(pin)
    }
}

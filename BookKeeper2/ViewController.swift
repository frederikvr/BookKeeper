//
//  ViewController.swift
//  BookKeeper2
//
//  Created by Fred on 21/12/2019.
//  Copyright © 2019 Fred. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks
        // "self" refers to ViewController class, this works because we adopted the UITextFieldDelegate protocol in class declaration
        nameTextField.delegate = self
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method is called when the user presses Return in the textfield linked in viewDidLoad "XXX.delegate = self" in this case
        
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // this method is called after the textfield resigns it's FirstResponder status (FirstResponder means it's the main receiving object that moment)
        bookNameLabel.text = textField.text
    }
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// the info dictionary may contain multiple representations of the image. You want to use the original
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else
        {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info.description)")
        }
        // set photoImageView to display the selected image
        photoImageView.image = selectedImage
        // dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        // this code ensures that if the user taps the image view while typing in the text field, the keyboard is dismissed properly
        nameTextField.resignFirstResponder()
        
        //UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        // is a method being called on ViewController, this method is executed on an implicit self object
        // the method asks ViewController to present the view controller defined by imagePickerController
        // completion param refers to completion handler, executes after this method completes. we don't need to do anything else so completion == nil
        present(imagePickerController, animated: true, completion: nil)
    }
}


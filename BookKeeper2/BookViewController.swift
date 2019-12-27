//
//  BookViewController.swift
//  BookKeeper2
//
//  Created by Fred on 21/12/2019.
//  Copyright © 2019 Fred. All rights reserved.
//

import UIKit
import os.log

class BookViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var bookNameTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var pagesTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by 'BookTableViewController' in 'perpare(for:sender:)'
     or constructed as part of adding a new book.
     */
    var book:Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks
        // "self" refers to ViewController class, this works because we adopted the UITextFieldDelegate protocol in class declaration
        bookNameTextField.delegate = self
        authorTextField.delegate = self
 
        // Set up views if editing an existing Book.
        // if book is not nil, this code will run
        if let book = book {
            navigationItem.title = book.bookName
            bookNameTextField.text = book.bookName
            authorTextField.text = book.author
            photoImageView.image = book.photo
            ratingControl.rating = book.rating
            pagesTextField.text = String(book.pages!)
            genreTextField.text = book.genre
        }
        
        // enable the Save button only if the bookName and Author text fields have a valid Book name.
        updateSaveButtonState()
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
        updateSaveButtonState()
        if (textField == bookNameTextField)
        {
            navigationItem.title = textField.text
        }
    }
    
    // Gets called when an editigin sessions begins, or when the keyboard gets displayed
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
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
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal (= add button) or push presentation (=user tapped a table view cell), this view controller needs to be dismissed in two different ways
        
        // if the viewController is NavigationController, detail scene is presented by Add button. This is because the book detail scene is embedded in its own navigatoin controller
        let isPresentingInAddBookMode = presentingViewController is UINavigationController
        if isPresentingInAddBookMode {
            // dismisses the modal scene and animates the transition back to the previous scene
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The BookViewController is not inside a navigation controller")
        }

    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // This doesn't do anything but it's a good habit to always call super.prepare(for:sender:) wenever you override prepare(for:sender:)
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type:.debug)
            return
        }
        let bookName = bookNameTextField.text ?? ""
        let author = authorTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        let pages = Int(pagesTextField.text!) ?? 0
        let genre = genreTextField.text
        // Set the book to be passed to BookTableViewController after the unwind segue.
        book = Book(bookName: bookName, photo: photo, rating: rating, pages: pages, genre: genre, author: author)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        // this code ensures that if the user taps the image view while typing in the text field, the keyboard is dismissed properly
        bookNameTextField.resignFirstResponder()
        
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
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        let bookNameForShare = "Book name: " + (bookNameTextField.text ?? "NoBookName")
        let authorForShare = "Author: " + (authorTextField.text ?? "NoAuthor")
        let genreForShare = "Genre: " + (genreTextField.text ?? "NoGenre")
        let pagesForShare = "Pages: " + (pagesTextField.text ?? "NoPages")
        let ratingForShare = "Rating: " + getRatingAsString(bookIconCount: ratingControl.rating)
        let shareableBook = [bookNameForShare, authorForShare, genreForShare, pagesForShare, ratingForShare]
        let activityVc = UIActivityViewController(activityItems: shareableBook, applicationActivities: nil)
        activityVc.popoverPresentationController?.sourceView = self.view
        present(activityVc, animated: true, completion: nil)
        activityVc.completionWithItemsHandler = {(activityVc, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if completed {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

 
    //MARK: Private Methods
    private func updateSaveButtonState(){
        // Disable the Save button if the text field is empty
        let bookNameText = bookNameTextField.text ?? ""
        let authorText = authorTextField.text ?? ""
        if (!bookNameText.isEmpty && !authorText.isEmpty){
            saveButton.isEnabled = true
        }
        else {
            saveButton.isEnabled = false
        }
    }
    
    private func getRatingAsString(bookIconCount : Int) -> String{
        switch bookIconCount{
        case 0: return "Even the last season of Game Of Thrones was better"
        case 1: return "Worse than the new Star Wars movies"
        case 2: return "Meh"
        case 3: return "Not great, not terrible"
        case 4: return "Preeetty good"
        case 5: return "Best. Book. Ever."
        default: fatalError("Rating is not between 0-5")
        }
    }
}


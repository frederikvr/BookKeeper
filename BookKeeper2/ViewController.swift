//
//  ViewController.swift
//  BookKeeper2
//
//  Created by Fred on 21/12/2019.
//  Copyright © 2019 Fred. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bookNameLabel: UILabel!
    
    @IBOutlet weak var testTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks
        // "self" refers to ViewController class, this works because we adopted the UITextFieldDelegate protocol in class declaration
        nameTextField.delegate = self
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method is called when the user presses Return
        
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // this method is called after the textfield resigns it's FirstResponder status (FirstResponder means it's the main receiving object that moment)
        bookNameLabel.text = textField.text
    }
    //MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        bookNameLabel.text = "Default Text"
    }
}


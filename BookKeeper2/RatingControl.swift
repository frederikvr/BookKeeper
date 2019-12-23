//
//  RatingControl.swift
//  BookKeeper2
//
//  Created by Fred on 22/12/2019.
//  Copyright © 2019 Fred. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    @IBInspectable var bookIconSize: CGSize = CGSize(width:44.0, height: 44.0){
        didSet{
            setupButtons()
        }
    }
    @IBInspectable var bookIconCount: Int = 5{
        didSet{
            setupButtons()
        }
    }
    
    var rating = 0{
        didSet{
            UpdateButtonSelectionStates()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder:coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    private func setupButtons(){
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle (for:type(of:self))
        let filledBook = UIImage(named:"filledBook",in:bundle,compatibleWith: self.traitCollection)
        let emptyBook = UIImage(named:"emptyBook",in:bundle,compatibleWith: self.traitCollection)
        let highlightedBook = UIImage(named:"highlightedBook",in:bundle,compatibleWith: self.traitCollection)

        for _ in 0..<bookIconCount{
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyBook, for: .normal)
            button.setImage(filledBook, for: .selected)
            button.setImage(highlightedBook, for: .highlighted)
            button.setImage(highlightedBook, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: bookIconSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: bookIconSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            // Add the button the RatingControl stackview (as a subview to a view)
            addArrangedSubview(button)
            
            // Add the new button to the rating butotn array
            ratingButtons.append(button)
        }
        UpdateButtonSelectionStates()
    }
    private func UpdateButtonSelectionStates(){
        for (index,button) in ratingButtons.enumerated(){
            // If the index of a button is less than the rating, that button should be selected
            button.isSelected = index < rating
        }
    }
}

//
//  RatingControl.swift
//  PassengerApp
//
//  Created by Comonfort on 4/23/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {

    //MARK: Properties
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0.0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
        setupButtons()
    }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // The possible rating from 1-5, depending on which button was touched
        let selectedRating = index + 1
        
        // If the selected star is full, susbtract half a star
        if selectedRating == Int(floor(rating)) {
            rating -= 0.5
            
            print("rating: " + String(rating) + ", selectedRat: " + String(selectedRating))

        }
        else
        {
            //else, the rating is to be set directly to that number of stars
            rating = Double(selectedRating)

            print("rating: " + String(rating) + ", selectedRat: " + String(selectedRating))
        }
    }
    
    //MARK: Private Methods
    
    private func setupButtons() {
        
        // Clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)

        for _ in 0..<starCount {
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        
        //Local rating, in order to assign that amount to all buttons
        var localRating = rating
        
        //Load images for half and full star
        let bundle = Bundle(for: type(of: self))
        let halfwayFilledStar = UIImage(named:"halfwayFilledStar", in: bundle, compatibleWith: self.traitCollection)
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        
        //iterate buttons
        for (index, button) in ratingButtons.enumerated() {
            
            //If the rating is greater than 0, the button must be filled
            if localRating > 0.0 {
                
                button.isSelected = true
                
                //Fill completely if the rating allows if there is at least a value of 1
                if localRating > 1.0
                {
                    button.setImage(filledStar, for: .selected)
                    localRating -= 1.0
                }
                else //else, fill halfway through with the remaining rating
                {
                    button.setImage(halfwayFilledStar, for: .selected)
                    rating = 0.0
                    localRating = 0.0
                }
            }
            else {
                button.isSelected = false
            }
            
        }
    }
    
}

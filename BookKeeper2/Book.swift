//
//  Book.swift
//  BookKeeper2
//
//  Created by Fred on 23/12/2019.
//  Copyright © 2019 Fred. All rights reserved.
//

import UIKit

class Book{
    
    //MARK: Properties
    var bookName: String
    var author: String
    var photo: UIImage?
    var rating: Int
    var amountOfPages: Int
    var genre: String?
    
    //MARK: Initialization

    init?(bookName: String, photo:UIImage?,rating:Int, amountOfPages:Int, genre:String?, author: String) {
        // The name must not be empty
        guard !bookName.isEmpty else {
            return nil
        }
        
        guard !author.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        guard (amountOfPages >= 0) else{
            return nil
        }
        self.bookName = bookName
        self.photo = photo
        self.rating = rating
        self.genre = genre
        self.amountOfPages=amountOfPages
        self.author = author
    }
}

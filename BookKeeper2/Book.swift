//
//  Book.swift
//  BookKeeper2
//
//  Created by Fred on 23/12/2019.
//  Copyright © 2019 Fred. All rights reserved.
//

import UIKit
import os.log

class Book: NSObject, NSCoding {

    //MARK: Properties
    var bookName: String
    var author: String
    var photo: UIImage?
    var rating: Int
    var pages: Int?
    var genre: String?
    
    //MARK: Archiving paths
    // find documents directory    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("books")
    
    //MARK: Types
    // needed to be able to save to DB. Key == column
    struct PropertyKey {
        static let bookName = "name"
        static let author = "author"
        static let rating = "rating"
        static let photo = "photo"
        static let pages = "pages"
        static let genre = "genre"
    }
    
    //MARK: Initialization
    init?(bookName: String, photo:UIImage?,rating:Int, pages:Int?, genre:String?, author: String) {
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

        self.bookName = bookName
        self.photo = photo
        self.rating = rating
        self.genre = genre
        self.pages = pages
        self.author = author
    }
    
    //MARK: NSCoding
    // prepares the class information to be archived
    func encode(with aCoder: NSCoder){
        // each lines takes a different type for the first argument
        // eg. bookName: String, photo: String, pages: Int, rating: Int, ..
        aCoder.encode(bookName, forKey: PropertyKey.bookName)
        aCoder.encode(author, forKey: PropertyKey.author)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(genre, forKey: PropertyKey.genre)
        aCoder.encode(pages, forKey: PropertyKey.pages)
    }
    
    // unarchives the data when the class is created
    // the required modifier means this init must be implemented on every subclass, if the subclass defines its own init
    // convenience modifier means that this is a secondary init, and that it must call a designated init from the same class
    // question mark means it might return null
    required convenience init?(coder aDecoder: NSCoder) {
        // bookName and author are requred, if we cannot decode a bookName or Author string, the init should fail
        guard let bookName = aDecoder.decodeObject(forKey: PropertyKey.bookName) as? String else {
            os_log("Unable to decode the bookName", log: OSLog.default, type:.debug)
        return nil
        }
        guard let author = aDecoder.decodeObject(forKey: PropertyKey.author) as? String else {
            os_log("Unable to decode the autor", log: OSLog.default, type:.debug)
        return nil
        }
        
        // not optional and is always int so no need to downcast and there is no optional to unwrap
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)

        // because these fields are optional properties, use conditional cast
        // if cast fails, just set nil for the property
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let genre = aDecoder.decodeObject(forKey: PropertyKey.genre) as? String
        let pages = aDecoder.decodeObject(forKey: PropertyKey.pages) as? Int
        
        // must call designated init (create Book object with values from DB)
        self.init(bookName: bookName, photo:photo, rating:rating, pages:pages, genre:genre, author:author)
    }
}

//
//  BookKeeper2Tests.swift
//  BookKeeper2Tests
//
//  Created by Fred on 21/12/2019.
//  Copyright © 2019 Fred. All rights reserved.
//

import XCTest
@testable import BookKeeper2

class BookKeeper2Tests: XCTestCase {
    //MARK: Book Class Tests
    
    // Confirm that the Book initializer returns a Book object when passed valid parameters
    func testBookInitializationSucceeds(){
        // Zero rating
        let zeroRatingBook = Book.init(bookName:"Zero", photo:nil,rating:0,amountOfPages: 200,genre:"Genre", author:"Author")
        XCTAssertNotNil(zeroRatingBook)
        
        let positiveRatingBook = Book.init(bookName: "Positive", photo: nil, rating: 5,amountOfPages: 200,genre:"Genre", author:"Author")
        XCTAssertNotNil(positiveRatingBook)
    }
    // Confirm that the Book initializer returns nil when passed a negative rating or an empty name
    func testBookInitializationFails(){
        // Negative rating
        let negativeRatingBook = Book.init(bookName: "Negative", photo: nil, rating: -1,amountOfPages: 200,genre:"Genre", author:"Author")
        XCTAssertNil(negativeRatingBook)
        
        // Rating exceeds maximum
        let largeRatingBook = Book.init(bookName: "Large", photo: nil, rating: 6,amountOfPages: 200,genre:"Genre", author:"Author")
        XCTAssertNil(largeRatingBook)
        
        // Empty string
        let emptyStringBook = Book.init(bookName: "", photo: nil, rating: 0,amountOfPages: 200,genre:"Genre", author:"Author")
        XCTAssertNil(emptyStringBook)
    }
}

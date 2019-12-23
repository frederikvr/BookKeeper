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
        let zeroRatingBook = Book.init(name:"Zero", photo:nil,rating:0)
        XCTAssertNotNil(zeroRatingBook)
        
        let positiveRatingBook = Book.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingBook)
    }
    // Confirm that the Book initializer returns nil when passed a negative rating or an empty name
    func testBookInitializationFails(){
        // Negative rating
        let negativeRatingBook = Book.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingBook)
        
        // Rating exceeds maximum
        let largeRatingBook = Book.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingBook)
        
        // Empty string
        let emptyStringBook = Book.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringBook)
    }
}

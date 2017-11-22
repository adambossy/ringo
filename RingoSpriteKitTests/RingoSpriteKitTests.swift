//
//  RingoSpriteKitTests.swift
//  RingoSpriteKitTests
//
//  Created by Adam Bossy-Mendoza on 8/16/17.
//  Copyright © 2017 Patreon. All rights reserved.
//

import XCTest
@testable import RingoSpriteKit


class BinarySearchTests: XCTestCase {

    let array = [1, 2, 3, 5, 7, 11]
    
    func testFound() {
        XCTAssertEqual(0, binarySearch(array, key: 1, range: 0 ..< array.count))
    }

    func testNotFoundLeftInternal() {
        XCTAssertEqual(4, binarySearch(array, key: 6, range: 0 ..< array.count))
    }

    func testNotFoundLeftBoundary() {
        XCTAssertEqual(0, binarySearch(array, key: 0, range: 0 ..< array.count))
    }
    
    func testNotFoundRightBoundary() {
        XCTAssertEqual(6, binarySearch(array, key: array[array.count - 1] + 1, range: 0 ..< array.count))
    }
}

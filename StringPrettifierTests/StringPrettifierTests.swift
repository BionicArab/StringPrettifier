//
//  StringPrettifierTests.swift
//  StringPrettifierTests
//
//  Created by BionicArab G on 07.06.20.
//  Copyright © 2020 BionicArab G. All rights reserved.
//

import XCTest
@testable import StringPrettifier

class StringPrettifierTests: XCTestCase {
    let testString = "I am a test string. I have puncutaions in me. Some with spaces and others without, look I also have a link in me: www.myExampleLink.com."


    func testStringBreakLines() throws {
        XCTAssertFalse(testString.contains("I am a test string.\n\n"))
        XCTAssertFalse(testString.contains("I have puncutaions in me.\n\n"))
        let formattedString = StringPrettifier.prettify(testString)
        XCTAssert(formattedString.mutableString.contains("I am a test string.\n\n"))
        XCTAssert(formattedString.mutableString.contains("I have puncutaions in me.\n\n"))
        
    }


}

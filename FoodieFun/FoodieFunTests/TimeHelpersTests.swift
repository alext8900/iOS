//
//  TimeHelpersTests.swift
//  FoodieFunTests
//
//  Created by Vici Shaweddy on 1/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import FoodieFun

class TimeHelpersTests: XCTestCase {
    func testCalculateAm() {
        XCTAssertEqual(TimeHelpers.calculateAmPm(militaryTime: 2000), "08.00 PM")
        XCTAssertEqual(TimeHelpers.calculateAmPm(militaryTime: 30), "12.30 AM")
    }
    
    func testStringConverter() {
        XCTAssertEqual(TimeHelpers.stringConverter(number: 1030), "10.30")
    }
    
    func testSetTimeToMidnight() {
        XCTAssertEqual(TimeHelpers.setTime(number: 30), "0030")
    }
}

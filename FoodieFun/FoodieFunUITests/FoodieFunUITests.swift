//
//  FoodieFunUITests.swift
//  FoodieFunUITests
//
//  Created by Vici Shaweddy on 1/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import FoodieFun

class FoodieFunUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoggingIn() {
        
        let app = XCUIApplication()
        let textField = app.textFields["Username")
            textField.tap()
        textField.typeText("vici23")
//        app.secureTextFields["Password"].tap()
//        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
//        app.buttons["LOG IN"].tap()

    }
    
    func testAddRestaurant() {
        
        let app = XCUIApplication()
        app.textFields["Username"].tap()
        app.secureTextFields["Password"].tap()
        app.buttons["LOG IN"].tap()
        app.tabBars.buttons["Add"].tap()
        app.scrollViews.otherElements.textFields["McDonald's, PF Chang's, Red Lobster"].tap()
        app.navigationBars["Add a Restaurant"].buttons["Save"].tap()
        let alert = app.alerts["Missing some fields"]
        XCTAssert(alert.exists)
        
    }
    
    func testSignUpAlert() {
        let app = XCUIApplication()
        app.buttons["Sign Up"].tap()
        app.textFields["Username"].tap()
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        
        let confirmPasswordSecureTextField = app.secureTextFields["Confirm Password"]
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.tap()
        app.buttons["SIGN UP"].tap()
        let alert = app.alerts["Missing some fields"].scrollViews.otherElements.buttons["OK"].tap()
    }
}

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
        app.launch()
        
        let textFieldUsername = app.textFields["Username"]
        textFieldUsername.tap()
        textFieldUsername.typeText("vici23")
        
        let textFieldPassword = app.secureTextFields["Password"]
        textFieldPassword.tap()
        textFieldPassword.typeText("111")
        app.buttons["LOG IN"].tap()
        
        let title = app.navigationBars["FoodieFun"].staticTexts["FoodieFun"]
        
        XCTAssert(title.exists)
    }
    
    func testAddRestaurant() {
        
        let app = XCUIApplication()
        app.launch()
        
        let textFieldUsername = app.textFields["Username"]
        textFieldUsername.tap()
        textFieldUsername.typeText("vici23")
        
        let textFieldPassword = app.secureTextFields["Password"]
        textFieldPassword.tap()
        textFieldPassword.typeText("111")
        app.buttons["LOG IN"].tap()
        
        let add = app.tabBars.buttons["Add"]
        add.tap()
        
        let nameTextField = app.scrollViews.otherElements.textFields["McDonald's, PF Chang's, Red Lobster"]
        nameTextField.tap()
        
        let saveButton = app.navigationBars["Add a Restaurant"].buttons["Save"]
        saveButton.tap()
        
        let alert = app.alerts["Missing some fields"]
        XCTAssert(alert.exists)
    }
    
    func testSignUpAlert() {
        
        let app = XCUIApplication()
        app.launch()
        
        let signUpButton = app.buttons["Sign Up"]
        signUpButton.tap()
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        
        let createButton = app.buttons["SIGN UP"]
        createButton.tap()
        
        let alert = app.alerts["Missing some fields"]
        XCTAssert(alert.exists)
    }
}

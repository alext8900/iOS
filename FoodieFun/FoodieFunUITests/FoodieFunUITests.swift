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

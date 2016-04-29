//
//  AlphaUITests.swift
//  AlphaUITests
//
//  Created by Max Yendall on 29/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import XCTest

class AlphaUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuccessfulLogin()
    {
        let app = XCUIApplication();
        
        // Type in valid username
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("maxyendall")
        
        // Type in valid password
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("test")
        
        // Click the login button
        app.buttons["L O G I N"].tap()
        
        // Successful login
    }
    
    func testUnsuccessfulLogin()
    {
        
        let app = XCUIApplication()
        
        // Type in invalid username
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("maxyendal")
        
        // Type in valid password
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("test")
        
        // Click the login button
        app.buttons["L O G I N"].tap()
        
        // Incorrect credentials alert
        app.alerts["Incorrect Credentials"].collectionViews.buttons["Try Again"].tap()
        
        // Unsuccessful login
    }
    
    func testTabNav()
    {
        
        let app = XCUIApplication()
        
        // Login to application
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("maxyendall")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("test")
        app.buttons["L O G I N"].tap()
        
        // Query alpha, theta, alpha and then home
        let tabBarsQuery = app.tabBars
        let alphaButton = tabBarsQuery.buttons["Alpha"]
        alphaButton.tap()
        tabBarsQuery.buttons["Theta"].tap()
        alphaButton.tap()
        tabBarsQuery.buttons["Home"].tap()
        
        // Successful
    }
    
    func testGenerateAlphaSong()
    {
        
        let app = XCUIApplication()
        
        // Login successfully and move to the alpha tab
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("maxyendall")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("test")
        app.buttons["L O G I N"].tap()
        
        // Generate music to reveal the play button, then press play to play the music.
        app.tabBars.buttons["Alpha"].tap()
        app.buttons["G E N E R A T E  M U S I C"].tap()
        app.buttons["P L A Y"].tap()
        
        // Pause the currently playing song
        app.buttons["P A U S E"].tap()
        
        // Successful
    }
    
    func testQuoteImageGeneration()
    {
        
        let app = XCUIApplication()
        
        // Login successfully and move to the elevation tab
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("maxyendall")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("test")
        app.buttons["L O G I N"].tap()
        app.tabBars.buttons["Elevation"].tap()
        
        // Generate image and quote using the generate button multiple times
        let gENERATEButton = app.buttons["G E N E R A T E"]
        gENERATEButton.tap()
        gENERATEButton.tap()
        gENERATEButton.tap()
        gENERATEButton.tap()
        
        // Successful
    }
    
}

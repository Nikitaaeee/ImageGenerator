//
//  ImageGeneratorUITests.swift
//  ImageGeneratorUITests
//
//  Created by Nikita Kirshin on 04.05.2023.
//

import XCTest

final class ImageGeneratorUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testTextField() throws {
        
        // GIVEN
        let queryTextField = app.textFields["Введите запрос"]
        
        //WHEN
        queryTextField.tap()
        
        //THEN
        XCTAssertTrue(app.keyboards.count > 0, "Keyboard is not displayed")
    }
}

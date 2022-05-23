//
//  ZemogaMobileUITests.swift
//  ZemogaMobileUITests
//
//  Created by Luci on 17/5/22.
//

import XCTest

class ZemogaMobileUITests: XCTestCase {

    let application = XCUIApplication()
    
    override func setUp() {
      continueAfterFailure = false
      application.launch()
    }

    override func tearDownWithError() throws {
    }

    func testFistViewList() throws {
        let postsLabels = application.navigationBars["Posts"]
        XCTAssertTrue(postsLabels.exists)
    }
    
    func testFlowApplication() throws {
        application.tables.firstMatch.tap()
        let postLabel = application.navigationBars["Detail"]
        XCTAssertTrue(postLabel.exists)
    }
    
    func testDeleteAllPost() {
        application.buttons.staticTexts["Delete all"].tap()
        XCTAssertEqual(application.tables.firstMatch.cells.count, 0)
    }

}

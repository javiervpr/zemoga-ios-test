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
      // Put setup code here. This method is called before the invocation of each test method in the class.

      // In UI tests it is usually best to stop immediately when a failure occurs.
      continueAfterFailure = false

      // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
      application.launch()

      // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    func testSegmentFilterFavorite() {
        application.segmentedControls.firstMatch.buttons.element(boundBy: 1).tap()
        debugPrint(application.segmentedControls.firstMatch.label)
        
    }
    
    func testRefreshController() {
//        application.tables.pull
    }

}

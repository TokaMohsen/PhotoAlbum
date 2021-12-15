//
//  PhotoAlbumUITests.swift
//  PhotoAlbumUITests
//
//  Created by toka mohsen on 09/12/2021.
//

import XCTest

class PhotoAlbumUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let firstAlbum = app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        let firstPhoto = app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["accusamus beatae ad facilis cum similique qui sunt"]/*[[".cells.staticTexts[\"accusamus beatae ad facilis cum similique qui sunt\"]",".staticTexts[\"accusamus beatae ad facilis cum similique qui sunt\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        
        firstAlbum.tap()
        XCTAssertEqual(firstPhoto.isHittable, true)
    }
}

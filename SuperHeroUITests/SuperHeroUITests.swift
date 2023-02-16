//
//  SuperHeroUITests.swift
//  SuperHeroUITests
//
//  Created by Andrei on 14.02.23.
//

import XCTest

final class SuperHeroUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        let collectionViewsQuery = app.collectionViews
        let cell = collectionViewsQuery.children(matching: .cell).element(boundBy: 0)
        cell.tap()
        app.navigationBars["Superhero Details"].buttons["Heroes"].tap()
        
        let loveImage = cell.images["love"]
        loveImage.tap()
        loveImage.tap()
        loveImage.tap()
        
        app.terminate()
        app.launch()
        sleep(5)
    }
    
    func testNavBar() throws {
        let app = XCUIApplication()
        app.launch()
        let heroesNavigationBar = app.navigationBars["Heroes"]
        let enterTheMovieNameSearchField = heroesNavigationBar.searchFields["Enter the movie name"]
        enterTheMovieNameSearchField.tap()
        enterTheMovieNameSearchField.typeText("Abe")
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        app.navigationBars["Superhero Details"].buttons["Heroes"].tap()
        enterTheMovieNameSearchField.tap()
        heroesNavigationBar.buttons["Cancel"].tap()
    }
    
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

//
//  EezehRequestsTests.swift
//  EezehRequestsTests
//
//  Created by Oleg Dreyman on 02.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
import EezehRequests

class EezehRequestsTests: XCTestCase {

    let defaultError: (ErrorType -> Void) = { error in
        print(error)
        XCTFail()
    }

    let timeout = 10.0

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testJSONRequest() {
        let expectation = expectationWithDescription("Async JSON task")
        let url = NSURL(string: "http://cist.nure.ua/ias/app/tt/P_API_DEPARTMENTS_JSON?p_id_faculty=1")!
        let request = JSONRequest(.GET, url: url) { jsonRespond in
            print("Here")
            print(jsonRespond.data)
            expectation.fulfill()
        }
        request.error = defaultError
        request.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }

    func testDataRequest() {
        let expectation = expectationWithDescription("Async Data task")
        let url = NSURL(string: "https://tjournal.ru")!
        let request = DataRequest(.GET, url: url) { respond in
            print("Here")
            expectation.fulfill()
        }
        request.error = defaultError
        request.execute()
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }

}

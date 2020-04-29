//
//  MarvelClientTests.swift
//  MarvelClientTests
//
//  Created by Nico Prananta on 2020/04/27.
//  Copyright © 2020 nico.fyi. All rights reserved.
//

import XCTest
@testable import MarvelClient

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?

    override func dataTask(
        with url: URL,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error

        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}

class MarvelClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSendRequest() throws {
        let mockSession = URLSessionMock()
        mockSession.data = """
        {
            "code": "200",
            "status": "Ok",
            "data": {
                "results": {
                    "value": 10
                }
            }
        }
        """.data(using: .utf8)
        let apiClient = MarvelAPIClient(publicKey: "publickey", privateKey: "privatekey", baseEndpointUrl: "http://localhost", session: mockSession)

        struct FakeResponse: Decodable {
            var value: Int
        }
        struct FakeRequest: APIRequest {
            typealias ResponseResult = FakeResponse

            var path: String { return "fake" }
        }
        let request = FakeRequest()
        var receivedResult: FakeResponse?
        var receivedError: Error?

        let expectation = self.expectation(description: #function)

        apiClient.send(request) { (result) in
            switch result {
            case .success(let res):
                receivedResult = res
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
        XCTAssertEqual(receivedResult?.value, 10)
        XCTAssertNil(receivedError)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

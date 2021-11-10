//
//  RemotePlaceLoaderTests.swift
//  RemotePlaceLoaderTests
//
//  Created by Jose Alvarez on 11/10/21.
//

import XCTest
@testable import AllTrails

class RemotePlaceLoader {
    let client: HttpClientSpy

    init(client: HttpClientSpy) {
        self.client = client
    }
}

class RemotePlaceLoaderTests: XCTestCase {

    func test_onInit_doesNotLoadPlaces() {
        let spy = HttpClientSpy()
        _ = RemotePlaceLoader(client: spy)
        
        XCTAssertEqual(spy.requests, 0)
    }

   
}

class HttpClientSpy {
    var requests: Int = 0
}

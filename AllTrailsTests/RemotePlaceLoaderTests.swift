//
//  RemotePlaceLoaderTests.swift
//  RemotePlaceLoaderTests
//
//  Created by Jose Alvarez on 11/10/21.
//

import XCTest
@testable import AllTrails

class RemotePlaceLoader: PlaceLoader {
    let client: HttpClientSpy

    init(client: HttpClientSpy) {
        self.client = client
    }
    
    func load(with request: Request, completion: @escaping (Result<[Place], Error>) -> Void) {
        client.request()
    }
}

class RemotePlaceLoaderTests: XCTestCase {

    func test_onInit_doesNotLoadPlaces() {
        let (spy, _) = makeSUT()
        
        XCTAssertEqual(spy.requests, 0)
    }

    func test_load_requestsDataFromURL() {
        let (spy, loader) = makeSUT()

        let anyRequest = Request(keyword: nil, coordinates: LocationCoordinate(latitude: 0, longitude: 0), radius: 0, type: "a string")
        
        loader.load(with: anyRequest) { _ in}
        
        XCTAssertEqual(spy.requests, 1)
    }
    
    // MARK: - Helper Methods
    
    private func makeSUT() -> (spy: HttpClientSpy, sut: PlaceLoader) {
        let spy = HttpClientSpy()
        let sut = RemotePlaceLoader(client: spy)
        
        return (spy, sut)
    }

}

class HttpClientSpy {
    var requests: Int = 0
    
    func request() {
        requests = requests + 1
    }
}

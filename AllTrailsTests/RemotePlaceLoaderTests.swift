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
    
    enum Error: Swift.Error, Equatable {
        case networkError
        case invalidResponse
    }

    init(client: HttpClientSpy) {
        self.client = client
    }
    
    func load(with request: Request, completion: @escaping (PlaceLoader.Result) -> Void) {
        client.request { data, response, error  in
            if  error != nil {
                completion(.failure(Error.networkError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(Error.invalidResponse))
                return
            }
            
            completion(.success([]))
        }
    }
}

class RemotePlaceLoaderTests: XCTestCase {

    func test_onInit_doesNotLoadPlaces() {
        let (spy, _) = makeSUT()
        
        XCTAssertEqual(spy.requests, 0)
    }

    func test_load_requestsDataFromURL() {
        let (spy, loader) = makeSUT()

        loader.load(with: anyRequest()) { _ in}
        
        XCTAssertEqual(spy.requests, 1)
    }
    
    func test_load_twice_requestsDataFromURLTwice() {
        let (spy, loader) = makeSUT()

        loader.load(with: anyRequest()) { _ in}
        loader.load(with: anyRequest()) { _ in}

        XCTAssertEqual(spy.requests, 2)
    }
    
    func test_load_returnsErrorOnHttpClientError() {
        let (spy, loader) = makeSUT()

        expect(when: loader, toCompleteWith: .failure(RemotePlaceLoader.Error.networkError)) {
            let anyError = NSError(domain: "any-error", code: 0)
            spy.completeWithError(anyError)
        }
    }
    
    func test_load_returnsErrorOnNon200HTTPURLResponse() {
        let (spy, loader) = makeSUT()
        
        let sampleStatusCodes = [500, 400, 199, 201, 10]
        
        for (index, status) in sampleStatusCodes.enumerated() {
            expect(when: loader, toCompleteWith: .failure(RemotePlaceLoader.Error.invalidResponse)) {
                spy.completeWithStatus(code: status, at: index)
            }
        }
    }
    
    func test_load_returnsEmptyArrayOnInvalidJSON() {
        let (spy, loader) = makeSUT()

        expect(when: loader, toCompleteWith: .success([])) {
            let invalidJSON = "invalid JSON".data(using: .utf8)!
            
            spy.completeWithStatus(code: 200, data: invalidJSON)
        }
    }
    
    // MARK: - Helper Methods
    
    private func makeSUT() -> (spy: HttpClientSpy, sut: PlaceLoader) {
        let spy = HttpClientSpy()
        let sut = RemotePlaceLoader(client: spy)
        
        return (spy, sut)
    }
    
    private func anyRequest() -> Request {
        Request(keyword: nil, coordinates: LocationCoordinate(latitude: 0, longitude: 0), radius: 0, type: "a string")
    }
    
    private func expect(when sut: PlaceLoader, toCompleteWith expectedResult: RemotePlaceLoader.Result, when action: () -> Void) {
        sut.load(with: anyRequest()) { result in
            switch (result, expectedResult) {
            case (let .success(places), let .success(expectedPlaces)):
                XCTAssertEqual(places, expectedPlaces, "Expected \(expectedPlaces) but received \(places) instead")
            case (let .failure(error), let .failure(expectedError)):
                XCTAssertEqual(error as! RemotePlaceLoader.Error, expectedError as! RemotePlaceLoader.Error, "Expected \(error) but received \(expectedError) instead")
            default:
                XCTFail("Expected \(expectedResult) but received \(result) instead")
            }
        }
        
        action()
    }
}

class HttpClientSpy {
    var requests: Int {
        completions.count
    }
    
    private var completions = [(Data?, URLResponse?, Error?) -> Void]()
    
    func request(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completions.append(completion)
    }
    
    func completeWithError(_ error: NSError, at index: Int = 0) {
        completions[index](nil, nil, error)
    }
    
    func completeWithStatus(code: Int, data: Data = Data(), at index: Int = 0) {
        let anyURL = URL(string: "any-url.com")!
        let urlResponse = HTTPURLResponse(url: anyURL, statusCode: code, httpVersion: nil, headerFields: nil)
        
        completions[index](data, urlResponse, nil)
    }
}

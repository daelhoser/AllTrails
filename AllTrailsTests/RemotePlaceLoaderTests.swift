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
        client.request { _,_,error  in
            if let error = error {
                completion(.failure(Error.networkError))
            } else {
                completion(.failure(Error.invalidResponse))
            }
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

        let exp = expectation(description: "wait on load")
        var capturedError: Error?
        
        loader.load(with: anyRequest()) { result in
            switch result {
            case .success:
                XCTFail("Expected a failure, received success instead")
            case let .failure(error):
                capturedError = error
            }
            exp.fulfill()
        }
        
        let anyError = NSError(domain: "any-error", code: 0)
        spy.completeWithError(anyError)

        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(capturedError as! RemotePlaceLoader.Error, RemotePlaceLoader.Error.networkError)
    }
    
    func test_load_returnsErrorOnNon200HTTPURLResponse() {
        let (spy, loader) = makeSUT()
        
        
        let sampleStatusCodes = [500, 400, 200, 10]
        
        for (index, status) in sampleStatusCodes.enumerated() {
            let exp = expectation(description: "wait on load")
            var capturedError: Error?

            loader.load(with: anyRequest()) { result in
                switch result {
                case .success:
                    XCTFail("Expected a failure, received success instead")
                case let .failure(error):
                    capturedError = error
                }
                exp.fulfill()
            }

            spy.completeWithStatus(code: status, at: index)
            
            wait(for: [exp], timeout: 1.0)

            XCTAssertEqual(capturedError as! RemotePlaceLoader.Error, RemotePlaceLoader.Error.invalidResponse)
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
    
    func completeWithStatus(code: Int, at index: Int = 0) {
        let anyURL = URL(string: "any-url.com")!
        let urlResponse = HTTPURLResponse(url: anyURL, statusCode: code, httpVersion: nil, headerFields: nil)
        
        completions[index](nil, urlResponse, nil)
    }
}

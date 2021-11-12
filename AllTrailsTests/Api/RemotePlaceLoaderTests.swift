//
//  RemotePlaceLoaderTests.swift
//  RemotePlaceLoaderTests
//
//  Created by Jose Alvarez on 11/10/21.
//

import XCTest
@testable import AllTrails

class RemotePlaceLoaderTests: XCTestCase {

    func test_onInit_doesNotLoadPlaces() {
        let (spy, _) = makeSUT()
        
        XCTAssertEqual(spy.requests, 0)
    }

    func test_load_requestsDataFromURL() {
        let (spy, loader) = makeSUT()

        _ = loader.load(with: anyRequest()) { _ in}
        
        XCTAssertEqual(spy.requests, 1)
    }
    
    func test_load_twice_requestsDataFromURLTwice() {
        let (spy, loader) = makeSUT()

        _ = loader.load(with: anyRequest()) { _ in}
        _ = loader.load(with: anyRequest()) { _ in}

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
    
    func test_load_returnsEmptyArrayOn200HTTPURLResponseWithNonOKStatus() {
        let (spy, loader) = makeSUT()

        expect(when: loader, toCompleteWith: .success([])) {
            let dic: [String: String] = ["status": "NON_OK_STATUS"]
            let validJSON = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            
            spy.completeWithStatus(code: 200, data: validJSON)
        }
    }
    
    func test_load_returnsEmptyArrayOn200HTTPURLResponseWithEmptyArrayAndOKStatus() {
        let (spy, loader) = makeSUT()

        expect(when: loader, toCompleteWith: .success([])) {
            let dic: [String: String] = ["status": "OK", "results": "[]"]
            let validJSON = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            
            spy.completeWithStatus(code: 200, data: validJSON)
        }
    }
    
    func test_load_returnsPlacesOnValid200HTTPURLResponseWithPlaces() {
        let (spy, loader) = makeSUT()
        let place1 = createPlace(with: "1", name: "a place")
        let place2 = createPlace(with: "2", name: "another place")

        expect(when: loader, toCompleteWith: .success([place1.model, place2.model])) {
            let dic: [String: Any] = ["status": "OK", "results": [place1.dictionary, place2.dictionary]]
            let validJSON = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            
            spy.completeWithStatus(code: 200, data: validJSON)
        }
    }
    
    // MARK: - Helper Methods
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (spy: HttpClientSpy, sut: PlaceLoader) {
        let spy = HttpClientSpy()
        let sut = RemotePlaceLoader(client: spy)
        
        trackMemoryLeaks(for: spy, file: file, line: line)
        trackMemoryLeaks(for: sut, file: file, line: line)
        
        return (spy, sut)
    }
    
    private func trackMemoryLeaks(for object: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "expected nil, potential memory leak")
        }
    }
    
    private func anyRequest() -> Request {
        Request(keyword: nil, coordinates: LocationCoordinate(latitude: 0, longitude: 0), radius: 0, type: "a string")
    }
    
    private func expect(when sut: PlaceLoader, toCompleteWith expectedResult: RemotePlaceLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        _ = sut.load(with: anyRequest()) { result in
            switch (result, expectedResult) {
            case (let .success(places), let .success(expectedPlaces)):
                XCTAssertEqual(places, expectedPlaces, "Expected \(expectedPlaces) but received \(places) instead", file: file, line: line)
            case (let .failure(error), let .failure(expectedError)):
                XCTAssertEqual(error as! RemotePlaceLoader.Error, expectedError as! RemotePlaceLoader.Error, "Expected \(error) but received \(expectedError) instead", file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) but received \(result) instead", file: file, line: line)
            }
        }
        
        action()
    }
    
    private func createPlace(with id: String, name: String) -> (model: Place, dictionary: [String: Any]) {
        // NOTE: the API says all fields are optional. My assumption is because this class is used in different endpoints. I'd like to think that we ALWAYS receive these fields. I'll test this a bit more if time permits
        let place = Place(id: id, name: name, rating: 2.0, numberOfRatings: 2, iconURL: URL(string: "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png")!, priceLevel: .expensive, coordinates: LocationCoordinate(latitude: 2, longitude: 4))
        
        let location: [String: Any] = [
            "lat": place.coordinates.latitude,
            "lng": place.coordinates.longitude
        ]
        
        let dic: [String: Any] = [
            "place_id": id,
            "name": name,
            "rating": place.rating,
            "user_ratings_total": place.numberOfRatings,
            "icon": place.iconURL.absoluteString,
            "price_level": place.priceLevel.rawValue,
            "geometry": location
        ]
        
        return (place, dic)
    }
}

class HttpClientSpy: HttpClient {
    var requests: Int {
        completions.count
    }
    
    private struct Task: HTTPClientTask {
        let callback: () -> Void
        func cancel() { callback() }
    }
    
    private var completions = [(HttpClient.Result) -> Void]()
    
    func request(request: URLRequest, completion: @escaping (HttpClient.Result) -> Void) -> HTTPClientTask {
        completions.append(completion)
        
        return Task() { }
    }
    
    func completeWithError(_ error: NSError, at index: Int = 0) {
        completions[index](.failure(error))
    }
    
    func completeWithStatus(code: Int, data: Data = Data(), at index: Int = 0) {
        let anyURL = URL(string: "any-url.com")!
        let urlResponse = HTTPURLResponse(url: anyURL, statusCode: code, httpVersion: nil, headerFields: nil)!
        
        completions[index](.success((data, urlResponse)))
    }
}

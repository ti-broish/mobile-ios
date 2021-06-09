//
//  APIManagerTests.swift
//  ti-broishTests
//
//  Created by Krasimir Slavkov on 14.05.21.
//

import XCTest
@testable import ti_broish

class APIManagerTests: XCTestCase {
    
    private let defaultExpectationTimeout: TimeInterval = 2
    
    func testGetCountries() throws {
        let expectation = expectation(description: "getCountries")
        
        APIClient().getCountries(isAbroad: false) { response in
            switch response {
            case .success(let countries):
                XCTAssertTrue(countries.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    func testGetAbroadCountries() throws {
        let expectation = expectation(description: "getAbroadCountries")
        
        APIClient().getCountries(isAbroad: true) { response in
            switch response {
            case .success(let countries):
                XCTAssertTrue(countries.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    func testGetUserDetails() throws {
        let expectation = expectation(description: "getUserDetails")
        
        APIClient().getUserDetails() { response in
            switch response {
            case .success(let details):
                
                XCTAssertFalse(details.firstName.isEmpty)
                XCTAssertFalse(details.lastName.isEmpty)
                XCTAssertFalse(details.email.isEmpty)
                XCTAssertFalse(details.phone.isEmpty)
                XCTAssertFalse(details.pin.isEmpty)
                XCTAssertNotNil(details.organization)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    func testGetElectionRegions() throws {
        let expectation = expectation(description: "getElectionRegions")
        
        APIClient().getElectionRegions(isAbroad: false) { response in
            switch response {
            case .success(let data):
                XCTAssertTrue(data.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    func testGetAbroadElectionRegions() throws {
        let expectation = expectation(description: "getAbroadElectionRegions")
        
        APIClient().getElectionRegions(isAbroad: true) { response in
            switch response {
            case .success(let data):
                XCTAssertTrue(data.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    func testGetTowns() throws {
        let expectation = expectation(description: "getTowns")
        
        APIClient().getTowns(
            country: Country(code: "00", name: "", isAbroad: false),
            electionRegion: ElectionRegion(code: "01", name: "", isAbroad: false, municipalities: []),
            municipality: Municipality(code: "03", name: "")
        ) {
            response in
            switch response {
            case .success(let data):
                XCTAssertTrue(data.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    // TODO: - implement get abroad towns
    //    func testGetAbroadTowns() throws {
    //        APIClient().getTowns(
    //            country: Country(code: "00", name: "", isAbroad: true),
    //            electionRegion: ElectionRegion(code: "01", name: "", isAbroad: true, municipalities: []),
    //            municipality: Municipality(code: "03", name: "")
    //        ) {
    //            response in
    //            switch response {
    //            case .success(let data):
    //                XCTAssertTrue(data.count > 0)
    //            case .failure(let error):
    //                XCTFail(error.localizedDescription)
    //            }
    //        }
    //    }
    
    func testGetSections() throws {
        let expectation = expectation(description: "getSections")
        
        APIClient().getSections(town: Town(id: 17, name: "", cityRegions: [])) { response in
            switch response {
            case .success(let data):
                XCTAssertTrue(data.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    // TODO: - implement get abroad sections
    //    func testGetAbroadSections() throws {
    //        APIClient().getSections(town: Town(id: 17, name: "", cityRegions: [])) { response in
    //            switch response {
    //            case .success(let data):
    //                XCTAssertTrue(data.count > 0)
    //            case .failure(let error):
    //                XCTFail(error.localizedDescription)
    //            }
    //        }
    //    }
    
    func testSendViolation() throws {
        let expectation = expectation(description: "sendViolation")
        
        APIClient().sendViolation(
            town: Town(id: 17, name: "", cityRegions: []),
            pictures: [],
            description: "some violation description",
            section: nil
        ) { response in
            switch response {
            case .success(let data):
                XCTAssertFalse(data.id.isEmpty)
                XCTAssertFalse(data.description.isEmpty)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    func testGetViolations() throws {
        let expectation = expectation(description: "getViolations")
        
        APIClient().getViolations { response in
            switch response {
            case .success(let data):
                XCTAssertTrue(data.count >= 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    func testGetViolation() throws {
        let expectation = expectation(description: "getViolation")
        // TODO: - refactor get "real" violation id
        APIClient().getViolation(id: "01F5KRQ131T2MJSK5KT4C14KA8") { response in
            switch response {
            case .success(let data):
                XCTAssertFalse(data.id.isEmpty)
                XCTAssertFalse(data.description.isEmpty)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    func testGetProtocols() throws {
        let expectation = expectation(description: "getProtocols")
        
        APIClient().getProtocols { response in
            switch response {
            case .success(let data):
                XCTAssertTrue(data.count >= 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    func testGetProtocol() throws {
        let expectation = expectation(description: "getProtocol")
        // TODO: - refactor get "real" protocol id
        APIClient().getProtocol(id: "01F201PFGJ2HN570EMNEA57W34")  { response in
            switch response {
            case .success(let data):
                XCTAssertFalse(data.id.isEmpty)
                XCTAssertTrue(data.pictures.count > 0)
                XCTAssertNotNil(data.section)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
    
    func testSendProtocol() throws {
        let expectation = expectation(description: "sendProtocol")
        
        APIClient().sendProtocol(
            section: Section(id: "010300001", code: "001", place: "", name: ""),
            pictures: ["01F201PEZP2TVP3NFV0Z5JPFMW"]
        ) { response in
            switch response {
            case .success(let data):
                XCTAssertFalse(data.id.isEmpty)
                XCTAssertTrue(data.pictures.count > 0)
                XCTAssertNotNil(data.section)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: defaultExpectationTimeout) { error in
            if let error = error {
                print("APIError: \(error)")
            }
        }
    }
}

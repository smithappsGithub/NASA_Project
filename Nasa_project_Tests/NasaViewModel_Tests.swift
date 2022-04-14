//
//  NasaViewModel_Tests.swift
//  Nasa_project_Tests
//
//  Created by Justin Smith on 2022-04-11.
//

import XCTest
import Combine
@testable import Nasa_project

class NasaViewModel_Tests: XCTestCase {
    
    var viewModel: NASAViewModel?
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = NASAViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_NasaViewModel_nextPage_shouldBeFalse() {
        //Given
        let testNextPage: Bool = false
        //When
        let vm = NASAViewModel()
        
        //Then
        XCTAssertTrue(vm.nextPage == testNextPage)
    }
    
    func test_NasaViewModel_nasaItems_nasaAPIDataShouldPopulateArray() {
        
        //Given
        let apiKey = "api_key=41OqR4nzBaWLOVDzr4P6EylhQSG2RYaYEKziSFlG"
        let vm = NASAViewModel()
        let countSize = 10
        
        //When
        let expectation = XCTestExpectation(description: "async should wait 5 seconds")
        var counter = 0
        print(counter)
        NASAapi.nasaAPI(page: countSize, apiKey: apiKey)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }) { nasaWebData in
                for i in 0..<countSize{
                    let nasaItem = NASAItem(id: counter, nasaItem: nasaWebData[i], favourite: false)
                    vm.nasaItems.append(nasaItem)
                    counter = counter + 1
                }
            }
            .store(in: &subscriptions)
        
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(!(vm.nasaItems.isEmpty))
        XCTAssertGreaterThan(vm.nasaItems.count, 5)
    }
    
    func test_NasaViewModel_canLoadNextPage_shouldBeSetToTrue() {
        
        //Given
        let vm = NASAViewModel()
        
        //Then
        XCTAssertTrue(vm.state.canLoadNextPage == true)
    }
    
    func test_NasaViewModel_page_shouldBeSetToTen() {
        
        //Given
        let vm = NASAViewModel()
        
        //Then
        XCTAssertEqual(vm.state.page, 10)
    }
}


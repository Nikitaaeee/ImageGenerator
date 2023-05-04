//
//  MainScreenProviderTests.swift
//  ImageGeneratorTests
//
//  Created by Nikita Kirshin on 04.05.2023.
//

import XCTest
@testable import ImageGenerator

class FavoritesProviderTests: XCTestCase {

    // MARK: - Properties
    
    var generatedImageStorage: GeneratedImageStorageMainFunctional!
    var favoritesProvider: FavoritesProvider!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
        generatedImageStorage = GeneratedImageStorageMock()
        favoritesProvider = FavoritesProvider(generatedImageStorage: generatedImageStorage)
    }
    
    override func tearDown() {
        super.tearDown()
        
        generatedImageStorage = nil
        favoritesProvider = nil
    }
    
    // MARK: - Tests
    
    func testDeleteGeneratedImage() {
        // Given
        let expectedModels = [GeneratedImageModel(image: Data(), queryString: "query1", dateCreated: Date()),
                              GeneratedImageModel(image: Data(), queryString: "query2", dateCreated: Date())]
        generatedImageStorage.save(items: expectedModels)
        let deleteModel = FavoritesDataFlow.Request(model: expectedModels[0])
        
        // When
        favoritesProvider.deleteGeneratedImage(with: deleteModel)
        
        // Then
        let modelsAfterDeletion = generatedImageStorage.getAllItems()
        XCTAssertEqual(modelsAfterDeletion.count, 1)
        XCTAssertEqual(modelsAfterDeletion[0].queryString, "query2")
    }
}

class GeneratedImageStorageMock: GeneratedImageStorageMainFunctional {
    
    // MARK: - Properties
    
    var generatedImageList: [GeneratedImageModel] = []
    var isEmpty: Bool = true
    
    // MARK: - GeneratedImageStorageMainFunctional
    
    func getAllItems() -> [GeneratedImageModel] {
        return generatedImageList
    }
    
    func save(items: [GeneratedImageModel]) {
        generatedImageList.append(contentsOf: items)
        isEmpty = false
    }
    
    func deleteAllItems() {
        generatedImageList.removeAll()
        isEmpty = true
    }
    
    func deleteItem(_ item: GeneratedImageModel) {
        generatedImageList = generatedImageList.filter { $0.queryString != item.queryString }
    }
}


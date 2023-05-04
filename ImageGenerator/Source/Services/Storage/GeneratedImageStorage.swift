//
//  GeneratedImageStorage.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import UIKit
import CoreData

protocol GeneratedImageStorageMainFunctional: AnyObject {
    func getAllItems() -> [GeneratedImageModel]
    func save(items: [GeneratedImageModel])
    func deleteAllItems()
    func deleteItem(_ item: GeneratedImageModel)
    var isEmpty: Bool { get }
}

final class GeneratedImageStorage {
    
    // MARK: - Properties
    
    static let shared = GeneratedImageStorage()
    private var generatedImageList = [GeneratedImageModel]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

// MARK: - GeneratedImageStorageMainFunctional

extension GeneratedImageStorage: GeneratedImageStorageMainFunctional {
    func getAllItems() -> [GeneratedImageModel] {
        do {
            let list = try context.fetch(ImageEntity.fetchRequest())
            generatedImageList = list.map({mapToModel(item: $0)})
        } catch {
            print("\(Constants.fetchErrorText) \(error.localizedDescription)")
        }
        
        return generatedImageList
    }
    
    func save(items: [GeneratedImageModel]) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        let count: Int
        do {
            count = try context.count(for: request)
        } catch {
            print("\(Constants.fetchErrorText) \(error.localizedDescription)")
            return
        }
        
        // If we already have 10 or more items, delete the oldest one
        if count >= 10, let oldestItem = getAllItems().sorted(by: { $0.dateCreated < $1.dateCreated }).first {
            deleteItem(oldestItem)
        }
        
        // Save the new items
        for generatedImage in items {
            if itemExists(with: generatedImage.queryString) {
                return
            }
            let newItem = ImageEntity(context: context)
            newItem.image = generatedImage.image
            newItem.queryString = generatedImage.queryString
            newItem.dateCreated = generatedImage.dateCreated
            
            do {
                try context.save()
            } catch {
                print("\(Constants.saveErrorText) \(error.localizedDescription)")
            }
        }
    }
    
    var isEmpty: Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
            let count  = try context.count(for: request)
            
            return count == .zero
        } catch {
            return true
        }
    }
    
    func deleteAllItems() {
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: ImageEntity.fetchRequest())
        do {
            _ = try context.execute(deleteRequest)
            as? NSBatchDeleteResult
            try context.save()
        } catch {
            print("\(Constants.deleteErrorText) \(error.localizedDescription)")
        }
    }
    
    func deleteItem(_ item: GeneratedImageModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        request.predicate = NSPredicate(format: "queryString = %@", item.queryString)
        
        do {
            let result = try context.fetch(request)
            if let objectToDelete = result.first as? NSManagedObject {
                context.delete(objectToDelete)
                try context.save()
            }
        } catch {
            print("\(Constants.deleteErrorText) \(error.localizedDescription)")
        }
    }
}

// MARK: - Private

private extension GeneratedImageStorage {
    func mapToModel(item: ImageEntity) -> GeneratedImageModel {
        guard let imageData = item.image,
              let queryString = item.queryString,
              let date = item.dateCreated else { return GeneratedImageModel(
                image: Data(),
                queryString: Constants.mockText,
                dateCreated: Date())
        }
        let model = GeneratedImageModel(
            image: imageData,
            queryString: queryString,
            dateCreated: date
        )
        
        return model
    }
    
    func itemExists(with queryString: String) -> Bool {
          let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
          request.predicate = NSPredicate(format: "queryString = %@", queryString)
          
          do {
              let count = try context.count(for: request)
              return count > 0
          } catch {
              print("\(Constants.fetchErrorText) \(error.localizedDescription)")
              return false
          }
      }
      
}

// MARK: - Constants

private extension GeneratedImageStorage {
    enum Constants {
        static let entityName: String = "ImageEntity"
        static let mockText: String = ""
        static let fetchErrorText: String = "Failed to fecth list from sotrage, error:"
        static let saveErrorText: String = "Failed to save generated image list to storage, error:"
        static let deleteErrorText: String = "Failed to batch delete generated image data from storage, error:"
    }
}

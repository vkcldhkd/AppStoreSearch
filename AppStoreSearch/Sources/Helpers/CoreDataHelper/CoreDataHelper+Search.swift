//
//  CoreDataHelper+Search.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import CoreData

extension CoreDataHelper {
    struct search {
        fileprivate static let entityName: String = "KeywordHistory"
        static var entity = NSEntityDescription.entity(
            forEntityName: CoreDataHelper.search.entityName,
            in: CoreDataHelper.shared.managedObjectContext
        )
        fileprivate struct add { }
        fileprivate struct delete { }
        fileprivate struct load { }
        struct action { }
    }
}
extension CoreDataHelper.search.action {
    static func loadKeywordHistory() -> [String] {
        return CoreDataHelper.search.load.loadKeywordHistory()?
            .compactMap { $0 as? NSManagedObject }
            .compactMap { $0.value(forKey: "keyword") as? String } ?? []
    }
    
    static func addSearchKeyword(keyword: String?) {
        guard let keyword = keyword,
              keyword.isNotEmpty else { return }
        CoreDataHelper.search.add.addSearchKeyword(keyword: keyword)
    }
    
    static func deleteSearchKeyword(keyword: String?) -> Bool {
        guard let keyword = keyword,
              keyword.isNotEmpty else { return false }
        return CoreDataHelper.search.delete.deleteSearchKeyword(keyword: keyword)
    }
}

// MARK: - Add
private extension CoreDataHelper.search.add {
    static func addSearchKeyword(keyword: String) {
        let fetchRequestList = NSFetchRequest<NSFetchRequestResult>(
            entityName: CoreDataHelper.search.entityName
        )
        guard let entity = CoreDataHelper.search.entity else { return }
        fetchRequestList.entity = entity
        
        let predicate = NSPredicate(format: "keyword == %@", keyword)
        fetchRequestList.predicate = predicate
        
        do {
            let fetchResults = try CoreDataHelper.shared.managedObjectContext.fetch(fetchRequestList) as? [NSManagedObject]
            if fetchResults?.count != 0 {
                fetchResults?.first?.setValue(Date(), forKey: "date" )
                
                try CoreDataHelper.shared.managedObjectContext.save()
            } else {
                
                let recentInfo = NSManagedObject(
                    entity: entity,
                    insertInto: CoreDataHelper.shared.managedObjectContext
                )
                
                recentInfo.setValue(keyword, forKey: "keyword")
                recentInfo.setValue(Date(), forKey: "date" )
                
                try CoreDataHelper.shared.managedObjectContext.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Load
private extension CoreDataHelper.search.load {
    static func loadKeywordHistory() -> [AnyObject]? {
        let fetchRequestList = NSFetchRequest<NSFetchRequestResult>(
            entityName: CoreDataHelper.search.entityName
        )
        guard let entity = CoreDataHelper.search.entity else { return nil }
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequestList.sortDescriptors = sortDescriptors
        fetchRequestList.entity = entity
        
        do {
            return try CoreDataHelper.shared.managedObjectContext.fetch(fetchRequestList)
        } catch {
            print("coredata context saving \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: - Delete
private extension CoreDataHelper.search.delete {
    static func deleteSearchKeyword(keyword: String) -> Bool {
        let fetchRequestList = NSFetchRequest<NSFetchRequestResult>(
            entityName: CoreDataHelper.search.entityName
        )
        fetchRequestList.predicate = NSPredicate(format: "keyword == %@", keyword)
        
        guard let entity = CoreDataHelper.search.entity else { return false }
        fetchRequestList.entity = entity
        
        do {
            let context = CoreDataHelper.shared.managedObjectContext
            let results = try context.fetch(fetchRequestList)
            
            results
                .compactMap { $0 as? NSManagedObject }
                .forEach { context.delete($0) }
            
            if context.hasChanges {
                try context.save()
                print("Deleted \(results.count) item(s) with keyword: \(keyword)")
                return true
            } else {
                return false
            }
        } catch {
            print("Failed to delete keyword '\(keyword)': \(error)")
            return false
        }
    }
}

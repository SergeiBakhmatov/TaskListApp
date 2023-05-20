//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Sergei Bakhmatov on 20.05.2023.
//

import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    private lazy var viewContext = persistentContainer.viewContext
    
    private init() {}
    
    func save(task taskName: String) -> Task {
        let task = Task(context: viewContext)
        task.title = taskName
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        return task
    }

    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        var taskList: [Task] = []
        
        do {
            taskList = try viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return taskList
    }
    
    func update() {
        
    }
    
    func delete() {
        
    }
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}




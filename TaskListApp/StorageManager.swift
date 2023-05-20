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
    private let fetchRequest = Task.fetchRequest()
    private var taskList: [Task] = []
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
        
        do {
            taskList = try viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return taskList
    }
    
    func update(name title: String,_ task: Task) {
        
        let taskChange = viewContext.object(with: task.objectID) as? Task ?? Task()
        taskChange.title = title
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete() {
        do {
            taskList = try viewContext.fetch(fetchRequest)
            taskList.forEach { viewContext.delete($0) }
        } catch {
            print(error.localizedDescription)
        }
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
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




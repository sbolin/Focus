//
//  TestCoreDataController.swift
//  FocusTests
//
//  Created by Scott Bolin on 8/8/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

@testable import Focus
import Foundation
import CoreData

class TestCoreDataController: CoreDataController {
  
  override init() {
    super.init()
    
    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType
    persistentStoreDescription.url = URL(fileURLWithPath: "/dev/null")
    
    let container = NSPersistentContainer(
      name: CoreDataController.shared.modelName,
      managedObjectModel: CoreDataController.shared.model)
    container.persistentStoreDescriptions = [persistentStoreDescription]
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    self.persistentContainer = container
  }
}

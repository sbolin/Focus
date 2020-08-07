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

class TestCoreController: CoreDataController {
  override init() {
    super.init()
  }
  
  let persistentStoreDescription =
    NSPersistentStoreDescription()
  persistentStoreDescription.type = NSInMemoryStoreType
  
  let container = NSPersistentContainer(
    name: CoreDataController.modelName,
    managedObjectModel: CoreDataController.model)
  container.persistentStoreDescriptions =
  [persistentStoreDescription]
  
  container.loadPersistentStores { (_, error) in
  if let error = error as NSError? {
  fatalError(
  "Unresolved error \(error), \(error.userInfo)")
  }
  }
  
  self.storeContainer = container
}
}

}

//
//  AppContext.swift
//  SnapPlant
//
//  Created by Mohit Kumar Singh on 05/12/23.
//

import SwiftUI
import CoreData

class AppContext: ObservableObject {
    let managedObjectContext: NSManagedObjectContext

    init() {
        self.managedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
    }
}

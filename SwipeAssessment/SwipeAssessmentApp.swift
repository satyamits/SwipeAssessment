//
//  SwipeAssessmentApp.swift
//  SwipeAssessment
//
//  Created by Satyam Singh on 30/01/25.
//

import SwiftUI

@main
struct SwipeAssessmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

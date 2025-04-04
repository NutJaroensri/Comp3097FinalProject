//
//  Comp3097FinalProjectApp.swift
//  Comp3097FinalProject
//
//  Created by Nut Jaroensri on 2025-04-03.
//

import SwiftUI

@main
struct Comp3097FinalProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

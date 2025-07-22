//
//  ToDoList_EffectiveMobile_App.swift
//  ToDoList(EffectiveMobile)
//
//  Created by Rayimbek Jigitekov on 22.07.2025.
//

import SwiftUI

@main
struct ToDoList_EffectiveMobile_App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  Persistence.swift
//  ToDoList(EffectiveMobile)
//
//  Created by Rayimbek Jigitekov on 22.07.2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ToDoList_EffectiveMobile_") // <--- имя должно совпадать с .xcdatamodeld
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("Ошибка загрузки хранилища: \(error)")
            }
        }
    }
}

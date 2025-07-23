//
//  TaskEntity+CoreDataProperties.swift
//  ToDoList(EffectiveMobile)
//
//  Created by Rayimbek Jigitekov on 22.07.2025.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var details: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var completed: Bool

}

extension TaskEntity {
    func toTodo() -> Todo {
        Todo(
            id: id ?? UUID(),
            title: title ?? "Без названия",
            details: details,
            completed: completed,
            createdAt: createdAt ?? Date(),
            dueDate: dueDate
        )
    }
}


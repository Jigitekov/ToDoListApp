////
////  TaskModel.swift
////  ToDoList(EffectiveMobile)
////
////  Created by Rayimbek Jigitekov on 22.07.2025.
////
//import Foundation
//
//struct Todo: Identifiable, Decodable {
//    let id: Int
//    var todo: String
//    var details: String?
//    var completed: Bool
//    var createdAt: Date
//    var dueDate: Date?
//
//    enum CodingKeys: String, CodingKey {
//        case id, todo, completed
//    }
//
//    // Для API-данных — рандомные даты
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        todo = try container.decode(String.self, forKey: .todo)
//        completed = try container.decode(Bool.self, forKey: .completed)
//
//        // today as start, random future date as end
//        self.createdAt = Date()
//
//        let daysAhead = Int.random(in: 1...10)
//        self.dueDate = Calendar.current.date(byAdding: .day, value: daysAhead, to: Date())
//    }
//
//    // Конструктор для созданной вручную задачи
//    init(id: Int, todo: String, details: String?, completed: Bool, createdAt: Date, dueDate: Date?) {
//        self.id = id
//        self.todo = todo
//        self.details = details
//        self.completed = completed
//        self.createdAt = createdAt
//        self.dueDate = dueDate
//    }
//}
//
import Foundation

struct Todo: Identifiable, Decodable {
    let id: UUID
    var title: String
    var details: String?
    var completed: Bool
    var createdAt: Date
    var dueDate: Date?

    enum CodingKeys: String, CodingKey {
        case title = "todo"
        case completed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        completed = try container.decode(Bool.self, forKey: .completed)
        id = UUID()
        createdAt = Date()
        dueDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 1...10), to: Date())
    }

    init(id: UUID = UUID(), title: String, details: String? = nil, completed: Bool, createdAt: Date, dueDate: Date?) {
        self.id = id
        self.title = title
        self.details = details
        self.completed = completed
        self.createdAt = createdAt
        self.dueDate = dueDate
    }
}

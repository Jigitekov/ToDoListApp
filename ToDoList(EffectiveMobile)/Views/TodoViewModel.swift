////
////  TaskActionSheetView.swift
////  ToDoList(EffectiveMobile)
////
////  Created by Rayimbek Jigitekov on 22.07.2025.
////
//
//import Foundation
//import CoreData
//
//class TodoViewModel: ObservableObject {
//    @Published var todos: [Todo] = []
//
//    private let viewContext = PersistenceController.shared.container.viewContext
//
//    init() {
//        fetchTodos()
//    }
//
//    func fetchTodos() {
//        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.createdAt, ascending: true)]
//
//        do {
//            let result = try viewContext.fetch(request)
//            self.todos = result.map { task in
//                Todo(
//                    id: task.id?.hashValue ?? 0,
//                    todo: task.title ?? "",
//                    completed: task.completed,
//                    details: task.details,
//                    dueDate: task.dueDate
//                )
//            }
//        } catch {
//            print("Ошибка загрузки: \(error)")
//        }
//    }
//
//    func addTodo(_ task: TaskEntity) {
//        let newTask = TaskEntity(context: viewContext)
//        newTask.id = UUID()
//        newTask.title = task.todo
//        newTask.details = task.details
//        newTask.dueDate = task.dueDate
//        newTask.createdAt = Date()
//        newTask.completed = task.completed
//
//        saveContext()
//        fetchTodos()
//    }
//
//    func deleteTodo(_ task: TaskEntity) {
//        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", argumentArray: [UUID(uuidString: String(todo.id)) ?? UUID()])
//
//        if let task = try? viewContext.fetch(request).first {
//            viewContext.delete(task)
//            saveContext()
//            fetchTodos()
//        }
//    }
//
//    func updateTodo(_ todo: Todo) {
//        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", argumentArray: [UUID(uuidString: String(todo.id)) ?? UUID()])
//
//        if let task = try? viewContext.fetch(request).first {
//            task.title = todo.todo
//            task.taskDescription = todo.details
//            task.dueDate = todo.dueDate
//            task.completed = todo.completed
//            saveContext()
//            fetchTodos()
//        }
//    }
//
//    private func saveContext() {
//        if viewContext.hasChanges {
//            try? viewContext.save()
//        }
//    }
//}

import Foundation
import CoreData

class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    
    func fetchTodos() {
        if let url = Bundle.main.url(forResource: "todos", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let decoded = try? decoder.decode([Todo].self, from: data) {
                self.todos = decoded
            }
        }
    }
    
    func toggleCompletion(for todo: Todo) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
        
        if let task = try? context.fetch(request).first {
            task.completed.toggle()
            try? context.save()
            loadTodos()
        }
    }
    
    private let context = PersistenceController.shared.container.viewContext
    
    init() {
        loadTodos()
    }
    
    func loadTodos() {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        if let result = try? context.fetch(request) {
            todos = result.map { $0.toTodo() }
        }
        
        if todos.isEmpty {
            loadFromJSON()
        }
    }
    
    private func loadFromJSON() {
        guard let url = URL(string: "https://drive.google.com/uc?export=download&id=1MXypRbK2CS9fqPhTtPonn580h1sHUs2W") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Ошибка загрузки JSON: \(error?.localizedDescription ?? "неизвестная")")
                return
            }
            
            struct RawResponse: Decodable {
                let todos: [RawTodo]
            }
            
            struct RawTodo: Decodable {
                let id: Int
                let todo: String
                let completed: Bool
            }
            
            if let decoded = try? JSONDecoder().decode(RawResponse.self, from: data) {
                DispatchQueue.main.async {
                    for raw in decoded.todos {
                        let entity = TaskEntity(context: self.context)
                        entity.id = UUID()
                        entity.title = raw.todo
                        entity.details = ""
                        entity.completed = raw.completed
                        entity.createdAt = Date()
                        entity.dueDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 1...10), to: Date())
                    }
                    
                    try? self.context.save()
                    self.loadTodos()
                }
            } else {
                print("Ошибка парсинга JSON")
            }
            
        }.resume()
    }
}

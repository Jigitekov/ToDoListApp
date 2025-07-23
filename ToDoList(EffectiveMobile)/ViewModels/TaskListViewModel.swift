//
//  TaskListViewModel.swift
//  ToDoList(EffectiveMobile)
//
//  Created by Rayimbek Jigitekov on 22.07.2025.
//

import Foundation
import CoreData

struct InitialTask: Decodable {
    let title: String
    let details: String?
    let dueDate: Date
}

final class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskEntity] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        loadInitialTasksIfNeeded()
        fetchTasks()
    }

    func fetchTasks() {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            tasks = try context.fetch(request)
        } catch {
            print("Ошибка при загрузке задач: \(error)")
        }
    }

    // Загрузка JSON в Core Data
    private func loadInitialTasksIfNeeded() {
        let alreadyLoaded = UserDefaults.standard.bool(forKey: "didLoadInitialTasks")
        guard !alreadyLoaded else { return }

        guard let url = Bundle.main.url(forResource: "InitialTasks", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Не удалось найти InitialTasks.json")
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // ВАЖНО: формат даты должен совпадать с JSON
        guard let initialTasks = try? decoder.decode([InitialTask].self, from: data) else {
            print("Не удалось распарсить JSON")
            return
        }

        context.perform {
            for task in initialTasks {
                let entity = TaskEntity(context: self.context)
                entity.id = UUID()
                entity.title = task.title
                entity.details = task.details
                entity.dueDate = task.dueDate
                entity.createdAt = Date()
            }

            do {
                try self.context.save()
                UserDefaults.standard.set(true, forKey: "didLoadInitialTasks")
                print("Задачи загружены")
                self.fetchTasks()
            } catch {
                print("Ошибка при сохранении задач: \(error)")
            }
        }
    }
}


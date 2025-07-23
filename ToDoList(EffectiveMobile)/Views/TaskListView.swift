//
//  TaskListView.swift
//  ToDoList(EffectiveMobile)
//
//  Created by Rayimbek Jigitekov on 22.07.2025.
//
///2
//import SwiftUI
//
//struct TaskListView: View {
//    @StateObject private var viewModel = TodoViewModel()
//    @State private var searchText: String = ""
//    @State private var showAddTaskView = false
//    @State private var editingTask: Todo? = nil
//
//    
//    var body: some View {
//        NavigationView {
//            ZStack(alignment: .bottom) {
//                Color.black.ignoresSafeArea()
//                
//                VStack(alignment: .leading, spacing: 0) {
//                    // Заголовок
//                    Text("Задачи")
//                        .font(.largeTitle.bold())
//                        .foregroundColor(.white)
//                        .padding(.horizontal)
//                        .padding(.top)
//                    
//                    // Поисковая строка
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                        TextField("Search", text: $searchText)
//                            .foregroundColor(.white)
//                        Image(systemName: "mic.fill")
//                    }
//                    .padding(10)
//                    .background(Color(.systemGray5).opacity(0.2))
//                    .cornerRadius(12)
//                    .padding(.horizontal)
//                    .foregroundColor(.gray)
//                    .padding(.top, 10)
//                    
//                    // Список задач
//                    List {
//                        ForEach(viewModel.todos.filter {
//                            searchText.isEmpty || $0.todo.localizedCaseInsensitiveContains(searchText)
//                        }) { todo in
//                            NavigationLink(destination: TaskDetailView(task: todo)) {
//                                VStack(alignment: .leading, spacing: 6) {
//                                    HStack {
//                                        Button(action: {
//                                            if let index = viewModel.todos.firstIndex(where: { $0.id == todo.id }) {
//                                                viewModel.todos[index].completed.toggle()
//                                            }
//                                        }) {
//                                            Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
//                                                .foregroundColor(todo.completed ? .yellow : .gray)
//                                        }
//                                        .buttonStyle(BorderlessButtonStyle()) // чтобы не ломать NavigationLink
//
//
//                                        Text(todo.todo)
//                                            .strikethrough(todo.completed)
//                                            .foregroundColor(todo.completed ? .gray : .white)
//                                            .font(.headline)
//                                    }
//                                    .contextMenu {
//                                        Button {
//                                            editTask(todo)
//                                        } label: {
//                                            Label("Редактировать", systemImage: "square.and.pencil")
//                                        }
//
//                                        Button {
//                                            shareTask(todo)
//                                        } label: {
//                                            Label("Поделиться", systemImage: "square.and.arrow.up")
//                                        }
//
//                                        Button(role: .destructive) {
//                                            deleteTask(todo)
//                                        } label: {
//                                            Label("Удалить", systemImage: "trash")
//                                        }
//                                    }
//
//                                    if let description = todo.description {
//                                        Text(description)
//                                            .lineLimit(1)
//                                            .foregroundColor(.white.opacity(0.8))
//                                            .font(.subheadline)
//                                    }
//
//                                    if let due = todo.dueDate {
//                                        Text(format(due))
//                                            .font(.caption)
//                                            .foregroundColor(.gray)
//                                    } else {
//                                        Text(fakeDate(for: todo.id))
//                                            .font(.caption)
//                                            .foregroundColor(.gray)
//                                    }
//
//                                    Divider().background(Color.gray.opacity(0.3))
//                                }
//                            }
//                            .listRowBackground(Color.black)
//                            .listRowInsets(EdgeInsets())
//                            .padding(.vertical, 8)
//
//                            .padding(.vertical, 8)
//                            .listRowBackground(Color.black)
//                            .listRowInsets(EdgeInsets())
//                        }
//                        Section {
//                            Spacer().frame(height: 80)
//                                .listRowBackground(Color.clear)
//                        }
//
//                    }
//                    .padding(.top, 10)
//                    .scrollContentBackground(.hidden)
//                    .listStyle(.plain)
//                }
//                
//                // Нижняя панель с кнопкой и счётчиком
//                VStack(spacing: 0) {
//                    HStack {
//                        Spacer()
//                        
//                        Text("\(viewModel.todos.count) Задач")
//                            .foregroundColor(.white)
//                            .font(.subheadline)
//                        
//                        Spacer()
//                        
//                        Button(action: {
//                            showAddTaskView = true
//                        }) {
//                            Image(systemName: "square.and.pencil")
//                                .font(.system(size: 20))
//                                .padding(10)
//                                .background(Color.yellow)
//                                .foregroundColor(.black)
//                                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
//                        }.sheet(isPresented: $showAddTaskView) {
//                            TaskAddView(todos: $viewModel.todos, editingTask: editingTask)
//                        }
//
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 12)
//                    
//                    // Индикатор
//                    RoundedRectangle(cornerRadius: 3)
//                        .frame(width: 120, height: 5)
//                        .foregroundColor(.white.opacity(0.5))
//                        .padding(.top, 6)
//                        .padding(.bottom, 6)
//                    
//                }
//                .background(Color(.darkGray))
//                .ignoresSafeArea(edges: .bottom)
//            }
//            .onAppear {
//                viewModel.fetchTodos()
//            }
//        }
//    }
//
//    // Временная генерация даты из ID (для демонстрации)
//    func fakeDate(for id: Int) -> String {
//        let day = String(format: "%02d", (id % 28) + 1)
//        let month = String(format: "%02d", ((id % 12) + 1))
//        let year = "24"
//        return "\(day)/\(month)/\(year)"
//    }
//    
//    func format(_ date: Date?) -> String {
//            guard let date = date else { return "???" }
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd/MM/yy"
//            return formatter.string(from: date)
//        }
//}
//
//extension TaskListView {
//    func deleteTask(_ task: Todo) {
//        if let index = viewModel.todos.firstIndex(where: { $0.id == task.id }) {
//            viewModel.todos.remove(at: index)
//        }
//    }
//}
//
//extension TaskListView {
//    func editTask(_ task: Todo) {
//        editingTask = task
//        showAddTaskView = true
//    }
//}
//
//func shareTask(_ task: Todo) {
//    let text = "\(task.title)\n\(task.details ?? "")"
//    let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
//    
//    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//        scene.windows.first?.rootViewController?.present(av, animated: true)
//    }
//}
//
//struct TaskListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskListView()
//    }
//}

///3
import SwiftUI
import CoreData

struct TaskListView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var searchText: String = ""
    @State private var showAddTaskView = false
    @State private var editingTask: Todo? = nil

    var filteredTodos: [Todo] {
        viewModel.todos.filter {
            searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.black.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    // Заголовок
                    Text("Задачи")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top)

                    // Поиск
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search", text: $searchText)
                            .foregroundColor(.white)
                        Image(systemName: "mic.fill")
                    }
                    .padding(10)
                    .background(Color(.systemGray5).opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
                    .padding(.top, 10)

                    // Список задач
                    List {
                        ForEach(filteredTodos) { todo in
                            TaskRowView(
                                todo: todo,
                                onToggle: { viewModel.toggleCompletion(for: todo) },
                                onEdit: { editTask(todo) },
                                onDelete: { deleteTask(todo) },
                                onShare: { shareTask(todo) }
                            )
                            .listRowBackground(Color.black)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)

                }

                // Кнопка "Добавить"
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("\(viewModel.todos.count) Задач")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        Spacer()

                        Button(action: {
                            showAddTaskView = true
                        }) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 20))
                                .padding(10)
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .sheet(isPresented: $showAddTaskView) {
                            TaskAddView(
                                todos: $viewModel.todos,
                                viewModel: viewModel,
                                editingTask: editingTask
                            )
                        }
                    }
                    .padding()
                }
                .background(Color(.darkGray))
                .ignoresSafeArea(edges: .bottom)
            }
            .onAppear {
                viewModel.fetchTodos()
            }
        }
    }

    //Утилиты и действия

    func fakeDate(for id: UUID) -> String {
        let hash = id.hashValue
        let day = String(format: "%02d", (hash % 28) + 1)
        let month = String(format: "%02d", ((hash % 12) + 1))
        let year = "24"
        return "\(day)/\(month)/\(year)"
    }

    func format(_ date: Date?) -> String {
        guard let date = date else { return "???" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }

    func deleteTask(_ task: Todo) {
        if let index = viewModel.todos.firstIndex(where: { $0.id == task.id }) {
            viewModel.todos.remove(at: index)
        }
    }

    func editTask(_ task: Todo) {
        editingTask = task
        showAddTaskView = true
    }

    func shareTask(_ task: Todo) {
        let text = "\(task.title)\n\(task.details ?? "")"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.first?.rootViewController?.present(av, animated: true)
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}

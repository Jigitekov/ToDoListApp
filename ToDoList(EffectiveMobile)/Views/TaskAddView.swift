import SwiftUI
import CoreData

struct TaskAddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @Binding var todos: [Todo]
    @ObservedObject var viewModel: TodoViewModel
    var editingTask: Todo? = nil
    
    @State private var taskText: String = ""
    @State private var taskDetails: String = ""
    @State private var dueDate: Date = Date()
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Задача")) {
                    TextField("Введите задачу", text: $taskText)
                        .focused($isTextFieldFocused)
                }

                Section(header: Text("Описание")) {
                    ZStack(alignment: .topLeading) {
                        if taskDetails.isEmpty {
                            Text("Введите описание")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }

                        TextEditor(text: $taskDetails)
                            .frame(minHeight: 100)
                    }
                }

                Section(header: Text("Дата окончания")) {
                    DatePicker("Выбери дату", selection: $dueDate, in: Date()..., displayedComponents: .date)
                }
            }
            .navigationTitle(editingTask != nil ? "Редактирование" : "Новая задача")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                          ToolbarItem(placement: .cancellationAction) {
                              Button("Отмена") {
                                  dismiss()
                              }
                          }

                          ToolbarItem(placement: .confirmationAction) {
                              Button("Сохранить") {
                                  if let editing = editingTask {
                                      let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
                                      fetchRequest.predicate = NSPredicate(format: "id == %@", editing.id as CVarArg)

                                      if let existing = try? viewContext.fetch(fetchRequest).first {
                                          existing.title = taskText
                                          existing.details = taskDetails
                                          existing.dueDate = dueDate
                                      }
                                  } else {
                                      let newTask = TaskEntity(context: viewContext)
                                      newTask.id = UUID()
                                      newTask.title = taskText
                                      newTask.details = taskDetails
                                      newTask.completed = false
                                      newTask.createdAt = Date()
                                      newTask.dueDate = dueDate
                                  }

                                  try? viewContext.save()
                                  viewModel.loadTodos()
                                  dismiss()
                              }
                              .disabled(taskText.isEmpty)
                          }
                      }
                      .onAppear {
                          if let task = editingTask {
                              taskText = task.title
                              taskDetails = task.details ?? ""
                              dueDate = task.dueDate ?? Date()
                          }

                          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                              isTextFieldFocused = true
                          }
                      }
                  }
              }
          }

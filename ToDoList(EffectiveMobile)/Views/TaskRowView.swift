import SwiftUI

struct TaskRowView: View {
    let todo: Todo
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onShare: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Button(action: onToggle) {
                    Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(todo.completed ? .yellow : .gray)
                }
                .buttonStyle(BorderlessButtonStyle())

                Text(todo.title)
                    .strikethrough(todo.completed)
                    .foregroundColor(todo.completed ? .gray : .white)
                    .font(.headline)
            }
            .contextMenu {
                Button("Редактировать", action: onEdit)
                Button("Поделиться", action: onShare)
                Button(role: .destructive, action: onDelete) {
                    Label("Удалить", systemImage: "trash")
                }
            }

            if let description = todo.details {
                Text(description)
                    .lineLimit(1)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.subheadline)
            }

            if let due = todo.dueDate {
                Text(format(due))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        Divider()
            .background(Color.gray.opacity(0.5))
    }

    private func format(_ date: Date?) -> String {
        guard let date = date else { return "???" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}

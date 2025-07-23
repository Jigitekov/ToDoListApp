import SwiftUI

struct TaskDetailView: View {
    let task: Todo

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(task.title)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            
            if let due = task.dueDate {
                Text(format(due))
                    .foregroundColor(.gray)
            }
            
            Divider().background(Color.gray)

            if let details = task.details, !details.isEmpty {
                Text(details)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Формат даты
    func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}

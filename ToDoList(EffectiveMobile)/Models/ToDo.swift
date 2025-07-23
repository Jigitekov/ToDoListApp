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

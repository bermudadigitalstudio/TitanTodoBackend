import Foundation

final class State {
  struct Todo {
    var title: String
    var completed: Bool
    var order: Int
    let id: String = UUID().uuidString
    func encode() -> [String:Any] {
      return [
        "title":title,
        "completed":completed,
        "url":"http://0.0.0.0:8000/todo/\(id)",
        "order":order
      ]
    }
    func encoded() -> String {
      return String(data: try! JSONSerialization.data(withJSONObject: encode(), options: []), encoding: .utf8)!
    }
  }
  private(set) var todos: [String:Todo] = [:]
  func upsert(_ t: Todo) {
    self.todos[t.id] = t
  }
  func clear() {
    self.todos = [:]
  }
  func remove(_ id: String) {
    self.todos[id] = nil
  }
  func encoded() -> String {
    let jsonAbleTodos = todos.map { $0.value.encode() }
    return String(data: try! JSONSerialization.data(withJSONObject: jsonAbleTodos, options: []), encoding: .utf8)!
  }
}

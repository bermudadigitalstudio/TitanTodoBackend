import Foundation

final class State {
  struct Todo {
    var title: String
    var completed: Bool
    var order: Int
    let id: String = UUID().uuidString
    func encode(withHost host: String) -> [String:Any] {
      return [
        "title":title,
        "completed":completed,
        "url":"http://\(host)/todo/\(id)",
        "order":order
      ]
    }
    func encoded(withHost host: String) -> String {
      return String(data: try! JSONSerialization.data(withJSONObject: encode(withHost: host), options: []), encoding: .utf8)!
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
  func encoded(withHost host: String) -> String {
    let jsonAbleTodos = todos.map { $0.value.encode(withHost: host) }
    return String(data: try! JSONSerialization.data(withJSONObject: jsonAbleTodos, options: []), encoding: .utf8)!
  }
}

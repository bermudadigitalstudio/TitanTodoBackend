import Titan
import TitanCORS
import Foundation

public func Build() -> Titan {
  let titan = Titan()
  let state = State()

  // Default response is 404 Not found
  titan.addFunction("*") { (_, res) -> Void in
    res.body = "Not found"
    res.code = 404
  }

  titan.get("/") { (req: RequestType, res: ResponseType) in
    return (req, Response(200, state.encoded()))
  }

  titan.post("/") { (req: RequestType, res: ResponseType) in
    guard let json = req.json as? [String:Any] else {
      return (req, Response(400, "Could not parse JSON"))
    }
    let newTodo = State.Todo(title: json["title"]! as! String, completed: false,
                             order: (json["order"] as? Int) ?? 0)
    state.upsert(newTodo)
    return (req, Response(200, newTodo.encoded()))
  }

  titan.delete("/") { (req: RequestType, res: ResponseType) in
    state.clear()
    return (req, Response(204, ""))
  }

  titan.get("/todo/*") { req, id, res in
    guard let todo = state.todos[id] else {
      return (req, res)
    }
    let newRes = Response(200, todo.encoded())
    return (req, newRes)
  }

  titan.patch("/todo/*") { req, id, res in
    guard var todo = state.todos[id] else {
      return (req, Response(404, "Could not find Todo with id:\n\(id)"))
    }
    guard let json = req.json as? [String:Any] else {
      return (req, Response(400, "Could not parse JSON"))
    }
    if let newTitle = json["title"] as? String {
      todo.title = newTitle
    }
    if let newCompletedNess = json["completed"] as? Bool {
      todo.completed = newCompletedNess
    }
    if let newOrder = json["order"] as? Int {
      todo.order = newOrder
    }
    state.upsert(todo)
    let newRes = Response(200, todo.encoded())
    return (req, newRes)
  }

  titan.delete("/todo/*") { req, id, res in
    state.remove(id)
    return (req, Response(204, ""))
  }

  // Configure CORS
  titan.addFunction(RespondToPreflight)
  titan.addFunction(AllowAllOrigins)
  return titan
}

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


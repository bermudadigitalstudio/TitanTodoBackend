import TitanCore
import Foundation

func addTodoCrudRoutes(titan: Titan) {
  let state = State()

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
}

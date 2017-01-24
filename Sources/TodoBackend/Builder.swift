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
      return (req, Response(400, ""))
    }

    state.store(State.Todo(title: json["title"]! as! String, completed: false))
    return (req, Response(200, req.body))
  }

  titan.delete("/") { (req: RequestType, res: ResponseType) in
    state.clear()
    return (req, Response(200, ""))
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
    func encode() -> [String:Any] {
      return [
        "title":title,
        "completed":completed
      ]
    }
  }
  private(set) var todos: [Todo] = []
  func store(_ t: Todo) {
    self.todos.append(t)
  }
  func clear() {
    self.todos = []
  }
  func encoded() -> String {
    let jsonAbleTodos = todos.map { $0.encode() }
    return String(data: try! JSONSerialization.data(withJSONObject: jsonAbleTodos, options: []), encoding: .utf8)!
  }
}


import Titan
import TitanCORS

public func Build() -> Titan {
  let titan = Titan()

  // Default response is 404 Not found
  titan.addFunction("*") { (_, res) -> Void in
    res.body = "Not found"
    res.code = 404
  }

  addTodoCrudRoutes(titan: titan)

  // Configure CORS
  titan.addFunction(RespondToPreflight)
  titan.addFunction(AllowAllOrigins)
  return titan
}


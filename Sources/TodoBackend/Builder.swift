import Titan
import TitanCORS

public func Build() -> Titan {
  let titan = Titan()

  // Default response is 404 Not found
  titan.addFunction { req, res in
    var newRes = res.copy()
    newRes.body = "Not found"
    newRes.code = 404
    return (req, res)
  }

  addTodoCrudRoutes(titan: titan)

  // Configure CORS
  TitanCORS.addInsecureCORSSupport(titan)
  return titan
}


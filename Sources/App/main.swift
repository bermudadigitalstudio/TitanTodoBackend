import TodoBackend
import TitanNestAdapter
import Curassow

let titanApp = TodoBackend.Build()
let nestApp = TitanNestAdapter.toNestApplication(titanApp.app)

Curassow.serve(nestApp)

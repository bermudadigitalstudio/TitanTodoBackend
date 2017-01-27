import XCTest
import TodoBackend
import TitanCore

final class BuilderTests: XCTestCase {
    var titan: Titan!
    override func setUp() {
        titan = Build()
    }
    func testCanBuild() {
        let _: Titan = Build() // type check only
    }
    func testCreateTodo() {
        let res = titan.app(request: Request("POST", "/", "{\"title\":\"todo\"}"))
        XCTAssertEqual(res.code, 200)
    }
}

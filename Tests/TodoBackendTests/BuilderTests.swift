import XCTest
import TodoBackend
import TitanCore

final class BuilderTests: XCTestCase {
    func testCanBuild() {
      let _: Titan = Build() // type check only
    }
}

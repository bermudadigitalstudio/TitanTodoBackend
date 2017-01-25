import PackageDescription

let package = Package(
    name: "TitanTodoExample",
    targets: [
      Target(name: "App", dependencies: ["TodoBackend"])
    ],
    dependencies: [
      .Package(url: "https://github.com/bermudadigitalstudio/Titan.git", majorVersion: 0, minor: 6),
      .Package(url: "https://github.com/bermudadigitalstudio/TitanCORS.git", majorVersion: 0, minor: 1),
      .Package(url: "https://github.com/bermudadigitalstudio/TitanNestAdapter.git", majorVersion: 0, minor: 2),
      .Package(url: "https://github.com/kylef/Curassow.git", majorVersion: 0, minor: 6),
    ]
)

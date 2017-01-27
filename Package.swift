import PackageDescription

let package = Package(
    name: "TitanTodoExample",
    targets: [
      Target(name: "App", dependencies: ["TodoBackend"])
    ],
    dependencies: [
      .Package(url: "https://github.com/bermudadigitalstudio/Titan.git", majorVersion: 0, minor: 7),
      .Package(url: "https://github.com/bermudadigitalstudio/TitanNestAdapter.git", majorVersion: 0, minor: 3),
      .Package(url: "https://github.com/kylef/Curassow.git", majorVersion: 0, minor: 6),
    ]
)

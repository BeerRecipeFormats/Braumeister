// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Braumeister",
  platforms: [.macOS(.v10_15)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .executable(name: "Braumeister", targets: ["Braumeister"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/thbonk/SwiftWebUI", branch: "develop"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .executableTarget(
      name: "Braumeister",
      dependencies: [
        "SwiftWebUI"
      ]),
  ]
)

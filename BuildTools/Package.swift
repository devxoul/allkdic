// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "BuildTools",
  platforms: [.macOS(.v14)],
  dependencies: [
    .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.58.7"),
  ]
)

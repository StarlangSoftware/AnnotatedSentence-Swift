// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnnotatedSentence",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "AnnotatedSentence",
            targets: ["AnnotatedSentence"]),
    ],
    dependencies: [
        .package(name: "WordNet", url: "https://github.com/StarlangSoftware/TurkishWordNet-Swift.git", .exact("1.0.0")),
        .package(name: "SentiNet", url: "https://github.com/StarlangSoftware/TurkishSentiNet-Swift.git", .exact("1.0.3")),
        .package(name: "DependencyParser", url: "https://github.com/StarlangSoftware/TurkishDependencyParser-Swift.git", .exact("1.0.1")),
        .package(name: "PropBank", url: "https://github.com/StarlangSoftware/TurkishPropBank-Swift.git", .exact("1.0.2")),
        .package(name: "FrameNet", url: "https://github.com/StarlangSoftware/TurkishFrameNet-Swift.git", .exact("1.0.0")),
        .package(name: "NamedEntityRecognition", url: "https://github.com/StarlangSoftware/TurkishNamedEntityRecognition-Swift.git", .exact("1.0.3"))],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AnnotatedSentence",
            dependencies: ["WordNet", "SentiNet", "DependencyParser", "NamedEntityRecognition", "PropBank", "FrameNet"]),
        .testTarget(
            name: "AnnotatedSentenceTests",
            dependencies: ["AnnotatedSentence"]),
    ]
)

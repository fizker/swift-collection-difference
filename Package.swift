// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "swift-collection-difference",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6),
	],
	products: [
		.library(
			name: "CollectionDifference",
			targets: ["CollectionDifference"]
		),
	],
	dependencies: [
	],
	targets: [
		.target(
			name: "CollectionDifference",
			dependencies: []
		),
		.testTarget(
			name: "CollectionDifferenceTests",
			dependencies: ["CollectionDifference"]
		),
	]
)

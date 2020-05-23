@testable import CollectionDifference
import XCTest

struct Data: Equatable, Identifiable {
	let id: String
	var name: String
	var value: Int
}

class UnorderedCollectionDifferenceTests: XCTestCase {
	let originalItems = [
		Data(id: "a", name: "A", value: 1),
		Data(id: "b", name: "B", value: 2),
		Data(id: "c", name: "C", value: 3),
		Data(id: "d", name: "D", value: 1),
		Data(id: "e", name: "E", value: 2),
	]

	func test_init_noChanges_findsNoChanges() {
		let diff = UnorderedCollectionDifference(original: originalItems, new: originalItems)

		XCTAssertEqual(diff.updates, [])
		XCTAssertEqual(diff.insertions, [])
		XCTAssertEqual(diff.removals, [])
		XCTAssertEqual(diff.allChanges, [])
	}

	func test_init_allKindsOfChanges_findsExpectedChanges() {
		let new = [
			Data(id: "b1", name: "B", value: 2),
			Data(id: "e", name: "E", value: 2),
			Data(id: "c", name: "C2", value: 3),
			Data(id: "d", name: "D", value: 11),
		]
		let diff = UnorderedCollectionDifference(original: originalItems, new: new)

		XCTAssertEqual(diff.updates, [
			Data(id: "c", name: "C2", value: 3),
			Data(id: "d", name: "D", value: 11),
		])
		XCTAssertEqual(diff.insertions, [
			Data(id: "b1", name: "B", value: 2),
		])
		XCTAssertEqual(diff.removals, [
			Data(id: "a", name: "A", value: 1),
			Data(id: "b", name: "B", value: 2),
		])
		XCTAssertEqual(diff.allChanges, [
			.removal(Data(id: "a", name: "A", value: 1)),
			.removal(Data(id: "b", name: "B", value: 2)),
			.update(Data(id: "c", name: "C2", value: 3)),
			.update(Data(id: "d", name: "D", value: 11)),
			.insertion(Data(id: "b1", name: "B", value: 2)),
		])
	}

	func test_allChanges_modifyingTheCollection_allChangesReflectTheChanges() {
		let new = [
			Data(id: "b1", name: "B", value: 2),
			Data(id: "e", name: "E", value: 2),
			Data(id: "c", name: "C2", value: 3),
			Data(id: "d", name: "D", value: 11),
		]
		var diff = UnorderedCollectionDifference(original: originalItems, new: new)

		XCTAssertEqual(diff.allChanges, [
			.removal(Data(id: "a", name: "A", value: 1)),
			.removal(Data(id: "b", name: "B", value: 2)),
			.update(Data(id: "c", name: "C2", value: 3)),
			.update(Data(id: "d", name: "D", value: 11)),
			.insertion(Data(id: "b1", name: "B", value: 2)),
		])

		diff.insertions.append(Data(id: "f", name: "foo", value: 2))
		XCTAssertEqual(diff.allChanges, [
			.removal(Data(id: "a", name: "A", value: 1)),
			.removal(Data(id: "b", name: "B", value: 2)),
			.update(Data(id: "c", name: "C2", value: 3)),
			.update(Data(id: "d", name: "D", value: 11)),
			.insertion(Data(id: "b1", name: "B", value: 2)),
			.insertion(Data(id: "f", name: "foo", value: 2)),
		])

		diff.removals = []
		XCTAssertEqual(diff.allChanges, [
			.update(Data(id: "c", name: "C2", value: 3)),
			.update(Data(id: "d", name: "D", value: 11)),
			.insertion(Data(id: "b1", name: "B", value: 2)),
			.insertion(Data(id: "f", name: "foo", value: 2)),
		])

		diff.updates = [ Data(id: "up", name: "bar", value: 1) ]
		XCTAssertEqual(diff.allChanges, [
			.update(Data(id: "up", name: "bar", value: 1)),
			.insertion(Data(id: "b1", name: "B", value: 2)),
			.insertion(Data(id: "f", name: "foo", value: 2)),
		])
	}

	static var allTests = [
		("test_init_noChanges_findsNoChanges", test_init_noChanges_findsNoChanges),
		("test_init_allKindsOfChanges_findsExpectedChanges", test_init_allKindsOfChanges_findsExpectedChanges),
	]
}

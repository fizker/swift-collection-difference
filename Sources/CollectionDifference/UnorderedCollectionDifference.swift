import Foundation

/// Calculates the diffs between two collections.
/// The order of elements are ignored.
public struct UnorderedCollectionDifference<T: Equatable & Identifiable> {
	public var updates: [T]
	public var insertions: [T]
	public var removals: [T]

	/// All changes in one array.
	public var allChanges: [DiffType] {
		removals.map { .removal($0) } + updates.map { .update($0) } + insertions.map { .insertion($0) }
	}

	public enum DiffType: Equatable {
		case update(T), insertion(T), removal(T)
	}

	public init<C>(original: C, new: C) where C: BidirectionalCollection, T == C.Element {
		let diff = new.difference(from: original)
		let removals: [T] = diff.removals.map {
			switch $0 {
			case let .insert(offset: _, element: element, associatedWith: _):
				return element
			case let .remove(offset: _, element: element, associatedWith: _):
				return element
			}
		}
		var updates = [T]()
		var insertions = [T]()

		var idsToRemove = Set(removals.map { $0.id })

		for c in diff.insertions {
			switch c {
			case let .insert(offset: _, element: element, associatedWith: _):
				if idsToRemove.contains(element.id) {
					updates.append(element)
					idsToRemove.remove(element.id)
				} else {
					insertions.append(element)
				}
			case .remove(offset: _, element: _, associatedWith: _):
				// Should not be there. We are iterating over insertions
				break
			}
		}

		self.updates = updates
		self.insertions = insertions
		self.removals = removals.filter { idsToRemove.contains($0.id) }
	}
}

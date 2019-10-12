import Foundation
import XCTest
@testable import Simplenote


// MARK: - NSPredicate+Simplenote Unit Tests
//
class NSPredicateSimplenoteTests: XCTestCase {

    ///
    ///
    func testPredicatesForSearchTextMatchesNotesContainingTheSpecifiedKeyword() {
        let entity = MockupEntity()
        entity.content = "some content here and maybe a keyword"

        let predicates = NSPredicate.predicatesForSearchText(searchText: "keyword")
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        XCTAssertTrue(compound.evaluate(with: entity))
    }

    ///
    ///
    func testPredicatesForSearchTextMatchesNotesContainingMultipleSpecifiedKeywords() {
        let entity = MockupEntity()
        entity.content = "some keyword1 here and maybe another keyword2 there"

        let predicates = NSPredicate.predicatesForSearchText(searchText: "keyword1 keyword2")
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        XCTAssertTrue(compound.evaluate(with: entity))
    }

    ///
    ///
    func testPredicatesForSearchTextWontMatchNotesContainingTheSpecifiedKeywords() {
        let entity = MockupEntity()
        entity.content = "some content here and maybe a keyword"

        let predicates = NSPredicate.predicatesForSearchText(searchText: "missing")
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        XCTAssertFalse(compound.evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForNotesWithStatus` matches notes with a Deleted status
    ///
    func testPredicateForNotesWithDeletedStatusMatchesDeletedNotes() {
        let entity = MockupEntity()
        entity.deleted = true
        XCTAssertTrue(NSPredicate.predicateForNotesWithStatus(deleted: true).evaluate(with: entity))
        XCTAssertFalse(NSPredicate.predicateForNotesWithStatus(deleted: false).evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForNotesWithStatus` matches notes with a Not Deleted status
    ///
    func testPredicateForNotesWithoutDeletedStatusMatchesDeletedNotes() {
        let entity = MockupEntity()
        entity.deleted = false
        XCTAssertTrue(NSPredicate.predicateForNotesWithStatus(deleted: false).evaluate(with: entity))
        XCTAssertFalse(NSPredicate.predicateForNotesWithStatus(deleted: true).evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForSystemTag` properly matches entities that contain a given systemTag
    ///
    func testPredicateForSystemTagMatchesEntitiesThatContainTheTargetSystemTag() {
        let systemTag = "pinned"
        let entity = MockupEntity()
        entity.systemTags = systemTag
        XCTAssertTrue(NSPredicate.predicateForSystemTag(with: systemTag).evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForSystemTag` will not match entities that dont contain a given systemTag
    ///
    func testPredicateForSystemTagDoesntMatchEntitiesThatContainTheTargetSystemTag() {
        let systemTag = "pinned"
        let entity = MockupEntity()
        XCTAssertFalse(NSPredicate.predicateForSystemTag(with: systemTag).evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForTag` matches JSON Arrays that contain a single value, matching our target
    ///
    func testPredicateForTagProperlyMatchesEntitiesThatContainSingleTags() {
        let tag = "Yosemite"
        let entity = MockupEntity()
        entity.tags = "[ \"" + tag + "\"]"
        XCTAssertTrue(NSPredicate.predicateForTag(with: tag).evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForTag` matches JSON Arrays that contain multiple values, one of them being our target
    ///
    func testPredicateForTagProperlyMatchesEntitiesThatContainMultipleTags() {
        let tag = "Yosemite"
        let entity = MockupEntity()
        entity.tags = "[ \"second\", \"third\", \"" + tag + "\" ]"
        XCTAssertTrue(NSPredicate.predicateForTag(with: tag).evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForTag` properly deals with slashes
    ///
    func testPredicateForTagProperlyHandlesTagsWithSlashes() {
        let tag = "\\Yosemite"
        let entity = MockupEntity()
        entity.tags = "[ \"\\\\Yosemite\" ]"
        XCTAssertTrue(NSPredicate.predicateForTag(with: tag).evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForTag` won't produce matches for entities that do not contain the target Tag
    ///
    func testPredicateForTagDoesntMatchEntitiesThatDontContainTheTargetTag() {
        let tag = "Missing"
        let entity = MockupEntity()
        entity.tags = "[ \"Tag\" ]"
        XCTAssertFalse(NSPredicate.predicateForTag(with: tag).evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForUntaggedNotes` matches a perfectly formed empty JSON Array
    ///
    func testPredicateForUntaggedNotesMatchesEmptyJsonArrays() {
        let entity = MockupEntity()
        entity.tags = "[]"
        XCTAssertTrue(NSPredicate.predicateForUntaggedNotes().evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForUntaggedNotes` matches a JSON Array with random spaces
    ///
    func testPredicateForUntaggedNotesMatchesEmptyJsonArraysWithRandomSpaces() {
        let entity = MockupEntity()
        entity.tags = "    [ ] "
        XCTAssertTrue(NSPredicate.predicateForUntaggedNotes().evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForUntaggedNotes` matches empty strings
    ///
    func testPredicateForUntaggedNotesMatchesEmptyStrings() {
        let entity = MockupEntity()
        entity.tags = ""
        XCTAssertTrue(NSPredicate.predicateForUntaggedNotes().evaluate(with: entity))
    }

    /// Verifies that `NSPredicate.predicateForUntaggedNotes` won't match a non empty JSON Array
    ///
    func testPredicateForUntaggedNotesWontMatchNonEmptyJsonArrays() {
        let entity = MockupEntity()
        entity.tags = "[\"tag\"]"
        XCTAssertFalse(NSPredicate.predicateForUntaggedNotes().evaluate(with: entity))
    }
}


// MARK: - MockupEntity: Convenience class to help us test NSPredicate(s)
//
@objcMembers
private class MockupEntity: NSObject {

    /// Entity's Contents
    ///
    dynamic var content: String?

    /// Deletion Status
    ///
    dynamic var deleted = false

    /// Entity's System Tags
    ///
    dynamic var systemTags: String?

    /// Entity's Tags
    ///
    dynamic var tags: String?
}

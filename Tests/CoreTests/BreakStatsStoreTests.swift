import Foundation
@testable import Core
import XCTest

final class BreakStatsStoreTests: XCTestCase {
    private func makeTempStore() -> BreakStatsStore {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        let url = dir.appendingPathComponent("break-stats.json")
        return BreakStatsStore(fileURL: url)
    }

    func testRecordingMicroBreakIncrementsCount() {
        let store = makeTempStore()
        let stats = store.recordBreak(kind: .micro)
        XCTAssertEqual(stats.todayCount(), 1)
    }

    func testRecordingMultipleBreaksAccumulates() {
        let store = makeTempStore()
        _ = store.recordBreak(kind: .micro)
        _ = store.recordBreak(kind: .micro)
        let stats = store.recordBreak(kind: .long)
        XCTAssertEqual(stats.todayCount(), 3)
        XCTAssertEqual(stats.dailyRecords.first?.microBreakCount, 2)
        XCTAssertEqual(stats.dailyRecords.first?.longBreakCount, 1)
    }

    func testConsecutiveDaysIncreaseStreak() {
        let store = makeTempStore()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current

        let day1 = formatter.date(from: "2026-04-01")!
        let day2 = formatter.date(from: "2026-04-02")!
        let day3 = formatter.date(from: "2026-04-03")!

        _ = store.recordBreak(kind: .micro, on: day1)
        _ = store.recordBreak(kind: .micro, on: day2)
        let stats = store.recordBreak(kind: .micro, on: day3)

        XCTAssertEqual(stats.currentStreak, 3)
        XCTAssertEqual(stats.longestStreak, 3)
    }

    func testSkippedDayResetsStreakButPreservesLongest() {
        let store = makeTempStore()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current

        let day1 = formatter.date(from: "2026-04-01")!
        let day2 = formatter.date(from: "2026-04-02")!
        let day4 = formatter.date(from: "2026-04-04")!

        _ = store.recordBreak(kind: .micro, on: day1)
        _ = store.recordBreak(kind: .micro, on: day2)
        let stats = store.recordBreak(kind: .micro, on: day4)

        XCTAssertEqual(stats.currentStreak, 1)
        XCTAssertEqual(stats.longestStreak, 2)
    }

    func testDailyRecordsTrimToSeven() {
        let store = makeTempStore()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current

        for day in 1...10 {
            let date = formatter.date(from: "2026-04-\(String(format: "%02d", day))")!
            _ = store.recordBreak(kind: .micro, on: date)
        }

        let stats = store.load()
        XCTAssertEqual(stats.dailyRecords.count, 7)
        XCTAssertEqual(stats.dailyRecords.first?.date, "2026-04-10")
    }

    func testSameDayDoesNotIncrementStreak() {
        let store = makeTempStore()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current

        let day1 = formatter.date(from: "2026-04-01")!
        _ = store.recordBreak(kind: .micro, on: day1)
        let stats = store.recordBreak(kind: .micro, on: day1)

        XCTAssertEqual(stats.currentStreak, 1)
        XCTAssertEqual(stats.todayCount(on: day1), 2)
    }

    func testPersistenceRoundTrip() {
        let store = makeTempStore()
        _ = store.recordBreak(kind: .micro)
        _ = store.recordBreak(kind: .long)

        let reloaded = store.load()
        XCTAssertEqual(reloaded.todayCount(), 2)
        XCTAssertEqual(reloaded.currentStreak, 1)
    }

    func testEmptyStatsReturnZero() {
        let stats = BreakStatsData.empty
        XCTAssertEqual(stats.todayCount(), 0)
        XCTAssertEqual(stats.currentStreak, 0)
        XCTAssertEqual(stats.longestStreak, 0)
    }
}

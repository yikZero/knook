import Foundation

public final class BreakStatsStore {
    public let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(fileURL: URL = BreakStatsStore.defaultFileURL) {
        self.fileURL = fileURL
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    }

    public func load() -> BreakStatsData {
        guard FileManager.default.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let decoded = try? decoder.decode(BreakStatsData.self, from: data)
        else {
            return .empty
        }
        return decoded
    }

    public func save(_ stats: BreakStatsData) {
        guard let data = try? encoder.encode(stats) else { return }
        try? FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true,
            attributes: nil
        )
        try? data.write(to: fileURL, options: .atomic)
    }

    public func recordBreak(kind: BreakKind, on date: Date = Date()) -> BreakStatsData {
        var stats = load()
        let todayKey = BreakStatsData.dateKey(for: date)

        if let index = stats.dailyRecords.firstIndex(where: { $0.date == todayKey }) {
            switch kind {
            case .micro: stats.dailyRecords[index].microBreakCount += 1
            case .long: stats.dailyRecords[index].longBreakCount += 1
            }
        } else {
            var record = DailyBreakRecord(date: todayKey)
            switch kind {
            case .micro: record.microBreakCount = 1
            case .long: record.longBreakCount = 1
            }
            stats.dailyRecords.append(record)
        }

        updateStreak(&stats, todayKey: todayKey)
        trimRecords(&stats)
        save(stats)
        return stats
    }

    private func updateStreak(_ stats: inout BreakStatsData, todayKey: String) {
        guard let lastDate = stats.lastBreakDate else {
            stats.currentStreak = 1
            stats.longestStreak = max(stats.longestStreak, 1)
            stats.lastBreakDate = todayKey
            return
        }

        if lastDate == todayKey {
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current

        if let last = formatter.date(from: lastDate),
           let today = formatter.date(from: todayKey) {
            let calendar = Calendar.current
            let daysBetween = calendar.dateComponents([.day], from: last, to: today).day ?? 0

            if daysBetween == 1 {
                stats.currentStreak += 1
            } else {
                stats.currentStreak = 1
            }
        } else {
            stats.currentStreak = 1
        }

        stats.longestStreak = max(stats.longestStreak, stats.currentStreak)
        stats.lastBreakDate = todayKey
    }

    private func trimRecords(_ stats: inout BreakStatsData) {
        stats.dailyRecords.sort { $0.date > $1.date }
        if stats.dailyRecords.count > 7 {
            stats.dailyRecords = Array(stats.dailyRecords.prefix(7))
        }
    }

    public static var defaultFileURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        return base
            .appendingPathComponent("knook", isDirectory: true)
            .appendingPathComponent("break-stats.json", isDirectory: false)
    }
}

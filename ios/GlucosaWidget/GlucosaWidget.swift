import SwiftUI
import WidgetKit

// NOTE: Xcode wiring (not representable as source files — requires Xcode GUI):
//  1. Add a Widget Extension target named "GlucosaWidget" (File → New → Target).
//  2. Set its Bundle Identifier to "<Runner bundle id>.GlucosaWidget".
//  3. Enable the App Groups capability on BOTH the Runner and GlucosaWidget
//     targets with group "group.com.ekerstudio.glucosa".
//  4. Assign GlucosaWidget.entitlements to the extension target.
// The Flutter side pushes data via WidgetSyncService (home_widget plugin),
// which writes into the shared UserDefaults suite read below.

private let appGroupId = "group.com.ekerstudio.glucosa"

private func statusColor(for status: String) -> Color {
    switch status {
    case "hypoglycemia", "hyperglycemia":
        return .red
    case "low", "high":
        return .orange
    case "inRange":
        return .green
    default:
        return .primary
    }
}

private func trendSymbol(for trend: String) -> String? {
    switch trend {
    case "up": return "↑"
    case "down": return "↓"
    default: return nil
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> GlucosaEntry {
        GlucosaEntry(
            date: Date(),
            hasData: true,
            headerTitle: "Glucosa",
            glucoseValue: "120",
            glucoseUnit: "mg/dL",
            status: "inRange",
            trend: "flat",
            trendText: "",
            lastEntryText: "Today, 08:30",
            noDataText: "No readings",
            tapToAddText: "Tap to add"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (GlucosaEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let timeline = Timeline(entries: [readEntry()], policy: .atEnd)
        completion(timeline)
    }

    private func readEntry() -> GlucosaEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        return GlucosaEntry(
            date: Date(),
            hasData: defaults?.bool(forKey: "has_data") ?? false,
            headerTitle: defaults?.string(forKey: "header_title") ?? "Glucosa",
            glucoseValue: defaults?.string(forKey: "glucose_value") ?? "--",
            glucoseUnit: defaults?.string(forKey: "glucose_unit") ?? "mg/dL",
            status: defaults?.string(forKey: "status") ?? "inRange",
            trend: defaults?.string(forKey: "trend") ?? "flat",
            trendText: defaults?.string(forKey: "trend_text") ?? "",
            lastEntryText: defaults?.string(forKey: "last_entry_text") ?? "",
            noDataText: defaults?.string(forKey: "no_data_text") ?? "No readings",
            tapToAddText: defaults?.string(forKey: "tap_to_add_text") ?? "Tap to add"
        )
    }
}

struct GlucosaEntry: TimelineEntry {
    let date: Date
    let hasData: Bool
    let headerTitle: String
    let glucoseValue: String
    let glucoseUnit: String
    let status: String
    let trend: String
    let trendText: String
    let lastEntryText: String
    let noDataText: String
    let tapToAddText: String
}

struct GlucosaWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        if !entry.hasData {
            VStack(spacing: 6) {
                Text(entry.headerTitle)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Spacer()
                Text(entry.noDataText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(entry.tapToAddText)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
        } else {
            switch family {
            case .systemSmall:
                SmallWidgetView(entry: entry)
            default:
                MediumWidgetView(entry: entry)
            }
        }
    }
}

struct SmallWidgetView: View {
    let entry: GlucosaEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.headerTitle)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Spacer()

            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(entry.glucoseValue)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(statusColor(for: entry.status))
                Text(entry.glucoseUnit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if !entry.trendText.isEmpty {
                HStack(spacing: 2) {
                    if let symbol = trendSymbol(for: entry.trend) {
                        Text(symbol).font(.system(size: 11, weight: .semibold))
                    }
                    Text(entry.trendText)
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(statusColor(for: entry.status))
            }

            Spacer()

            Text(entry.lastEntryText)
                .font(.system(size: 9))
                .foregroundColor(.secondary)
        }
        .padding(12)
    }
}

struct MediumWidgetView: View {
    let entry: GlucosaEntry

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.headerTitle)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)

                Spacer()

                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text(entry.glucoseValue)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(statusColor(for: entry.status))
                    Text(entry.glucoseUnit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Spacer()

                Text("Trend")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)

                if let symbol = trendSymbol(for: entry.trend), !entry.trendText.isEmpty {
                    Text("\(symbol) \(entry.trendText)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(statusColor(for: entry.status))
                } else {
                    Text("—")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                Text(entry.lastEntryText)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)

                Spacer()
            }
        }
        .padding(14)
    }
}

@main
struct GlucosaWidget: Widget {
    let kind: String = "GlucosaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GlucosaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Glucosa")
        .description("Shows the latest blood glucose reading and trend.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

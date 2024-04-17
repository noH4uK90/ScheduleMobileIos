//
//  ScheduleWidget.swift
//  ScheduleWidget
//
//  Created by Иван Спирин on 4/2/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct ScheduleWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text("21 ЯНВАРЯ 2024")
                    .font(.title)
                    .foregroundStyle(.secondary)
                    .padding(0)
                Divider()
                    .padding(0)
                ForEach(Range(0...4), id: \.self) { _ in
                    WidgetLessonView()
                        .padding(.vertical, 2)
                        //.frame(maxHeight: geometry.size.height / 4)
                }
            }
        }
    }
}

struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ScheduleWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    ScheduleWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .init())
}

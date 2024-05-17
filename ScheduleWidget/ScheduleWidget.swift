//
//  ScheduleWidget.swift
//  ScheduleWidget
//
//  Created by Иван Спирин on 4/2/24.
//

import WidgetKit
import SwiftUI
import Combine

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let day = Date().dayNumberOfWeek() == 7 ? 1 : Date().dayNumberOfWeek()
        let date = Date().dateForDayOfWeek(day: day)

        return SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), lessons: [], currentDate: date)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let day = Date().dayNumberOfWeek() == 7 ? 1 : Date().dayNumberOfWeek()
        let services = Services()
        let (lessons, date) = await (try? services.getLessons(for: day)) ?? ([], "")
        return SimpleEntry(date: Date(), configuration: configuration, lessons: lessons, currentDate: date)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let day = Date().dayNumberOfWeek() == 7 ? 1 : Date().dayNumberOfWeek()
            let services = Services()
            let (lessons, date) = await (try? services.getLessons(for: day)) ?? ([], "")
            let entry = SimpleEntry(date: entryDate, configuration: configuration, lessons: lessons, currentDate: date)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func getLessons(for day: Int) async throws -> [Lesson] {
//        @Inject var userDefaultsService: UserDefaultsProtocol
//        @Inject var timetableNetworkService: TimetableNetworkProtocol
//        @Inject var teacherNetworkService: TeacherNetworkProtocol
//
//        var lessons: [Lesson] = []
//
//        if let account = userDefaultsService.getAccount() {
//            switch account.role.name {
//            case Roles.student.rawValue:
//                if let group = userDefaultsService.getGroup() {
//                    lessons = try await timetableNetworkService.getLessons(groupId: group.id, day: day)
//                }
//            case Roles.teacher.rawValue:
//                lessons = try await teacherNetworkService.getLessons(accountId: account.id, day: day)
//            default:
//                lessons = []
//            }
//        }
//
//        if let lesson = lessons.last, lesson.timeStart ?? "" < Date().getCurrentTime() {
//            lessons = try await getLessons(for: day == 6 ? 1 : day + 1)
//        }
//
//        return lessons
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let lessons: [Lesson]
    let currentDate: String
}

struct ScheduleWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .leading) {
                Text(Date().convertToPrettyDate(entry.currentDate))
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .padding(0)
                Divider()
                    .padding(0)
                if let components = Date().differenceFromCurrentDate(from: entry.currentDate, withFormat: "yyyy-MM-dd"), components.day ?? 1 > 0 {
                    if let lesson = entry.lessons.first {
                        WidgetLessonView(lesson: lesson, date: entry.currentDate )
                            .widgetURL(URL(string: "aktSchedule://mySchedule"))
                            .padding(0)
                    } else {
                        Text("No lessons available")
                            .padding(0 )
                    }
                } else {
                    if let lesson = entry.lessons.first(where: { Date().compareTime(Date().getCurrentTime(), $0.timeStart ?? "") }) {
                        WidgetLessonView(lesson: lesson, date: entry.currentDate )
                            .widgetURL(URL(string: "aktSchedule://mySchedule"))
                            .padding(0)
                    } else {
                        Text("No lessons available")
                            .padding(0 )
                    }
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
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    ScheduleWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .init(), lessons: [], currentDate: Date().dateForDayOfWeek(day: Date().dayNumberOfWeek()))
}

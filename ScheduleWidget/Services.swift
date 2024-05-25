//
//  Services.swift
//  ScheduleWidgetExtension
//
//  Created by Иван Спирин on 5/17/24.
//

import Foundation

class Services {
    func getAccount() -> Account? {
        if
            let data = UserDefaults(suiteName: "group.dev.noh4uk.schedule")?
                .data(forKey: "account"),
            let account = try? JSONDecoder().decode(Account.self, from: data) {
            return account
        }
        return nil
    }

    func getGroup() -> GroupModel? {
        if
            let data = UserDefaults(suiteName: "group.dev.noh4uk.schedule")?
                .data(forKey: "group"),
            let group = try? JSONDecoder().decode(GroupModel.self, from: data) {
            return group
        }
        return nil
    }

    func getLessons(for day: Int) async throws -> ([Lesson], String) {
        var lessons: [Lesson] = []
        var date = Date().dateForDayOfWeek(day: day)
        if let account = getAccount(), account.role.name != Roles.employee.rawValue {
            switch account.role.name {
            case Roles.student.rawValue:
                lessons = try await getGroupLessons(day: day)
            case Roles.teacher.rawValue:
                lessons = try await getTeacherLessons(account: account, day: day)
            default:
                return (lessons, date)
            }

            let hasLessonWithDisicpline = lessons.contains { $0.discipline != nil }

            if let components = Date().differenceFromCurrentDate(from: date, withFormat: "yyyy-MM-dd"),
               components.day ?? 0 > 7 {
                return ([], Date().dateForDayOfWeek(day: Date().dayNumberOfWeek()))
            }

            if !hasLessonWithDisicpline {
                let nexDay = day == 6 ? 1 : day + 1
                (lessons, date) = try await getLessons(for: nexDay)
            }

            if let lesson = lessons.last(where: { $0.discipline != nil }),
               Date().compareTime(lesson.timeStart ?? "", Date().getCurrentTime()) {
                let nexDay = day == 6 ? 1 : day + 1
                (lessons, date) = try await getLessons(for: nexDay)
            }
        }
        return (lessons, date)
    }

    func getGroupLessons(day: Int) async throws -> [Lesson] {
        if let group = getGroup() {
            guard let url = URL(string: "http:37.18.102.140:5050/api/Timetable/Group") else {
                throw APIError.invalidResponse
            }

            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw APIError.invalidResponse
            }

            let date = Date().dateForDayOfWeek(day: day)

            components.queryItems = [
                URLQueryItem(name: "GroupId", value: "\(group.id)"),
                URLQueryItem(name: "Date", value: "\(date)")
            ]

            guard let urlComponents = components.url else {
                throw APIError.invalidResponse
            }
            var request = URLRequest(url: urlComponents)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let (data, _) = try await URLSession.shared.data(for: request)
            let timetables = try JSONDecoder().decode([Timetable].self, from: data)

            var lessons: [Lesson] = []
            if let timetable = timetables.first {
                lessons = timetable.lessons
//                if let dayItem = current.daysAndDate.first(where: { $0.key.tValue.id == day }) {
//                    if let timetable = dayItem.items.first {
//                        lessons = timetable.lessons
//                    }
//                }
            }
            return lessons
        }

        return []
    }

    func getTeacherLessons(account: Account, day: Int) async throws -> [Lesson] {
        let teacher = try await getTeacherAccount(account: account)
        guard let url = URL(string: "http:37.18.102.140:5050/api/Timetable/Teacher") else {
            throw APIError.invalidResponse
        }

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw APIError.invalidResponse
        }

        components.queryItems = [
            URLQueryItem(name: "TeacherId", value: "\(teacher.id)"),
            URLQueryItem(name: "Date", value: Date().dateForDayOfWeek(day: day))
        ]

        guard let urlComponents = components.url else {
            throw APIError.invalidResponse
        }
        var request = URLRequest(url: urlComponents)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Lesson].self, from: data)
    }

    func getTeacherAccount(account: Account) async throws -> Teacher {
        guard let url = URL(string: "http:37.18.102.140:5050/api/Teacher/Account/\(account.id)") else {
            throw APIError.invalidResponse
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Teacher.self, from: data)
    }
}

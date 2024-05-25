//
//  TimetableEndpoints.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation

enum TimetableEndpoints {
    case groupTimetable(groupId: Int, date: Date)
    case teacherTimetable(teacherId: Int, date: Date)

    var baseURL: URL { API.baseURL.appending(path: APITags.timetable.rawValue) }

    func path() -> String {
        switch self {
        case .groupTimetable:
            "Group"
        case .teacherTimetable:
            "Teacher"
        }
    }

    var absoluteURL: URL? {
        guard var urlComponents = API.getComponents(for: baseURL, with: self.path()) else {
            return nil
        }

        switch self {
        case .groupTimetable(let groupId, let date):
            urlComponents.queryItems = [
                URLQueryItem(name: "GroupId", value: "\(groupId)"),
                URLQueryItem(name: "Date", value: "\(date.format("yyyy-MM-dd"))")
            ]
        case .teacherTimetable(let teacherId, let date):
            urlComponents.queryItems = [
                URLQueryItem(name: "TeacherFullNameId", value: "\(teacherId)"),
                URLQueryItem(name: "Date", value: "\(date.format("yyyy-MM-dd"))")
            ]
        }

        return urlComponents.url
    }
}

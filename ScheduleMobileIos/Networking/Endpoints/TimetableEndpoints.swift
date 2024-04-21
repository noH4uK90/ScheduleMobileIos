//
//  TimetableEndpoints.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation

enum TimetableEndpoints {
    case currentTimetable(Int, Int = 7)

    var baseURL: URL { API.baseURL }

    func path() -> String {
        switch self {
        case .currentTimetable:
            "Timetable/Current"
        }
    }

    var absoluteURL: URL? {
        guard var urlComponents = API.getComponents(for: baseURL, with: self.path()) else {
            return nil
        }

        switch self {
        case .currentTimetable(let groupId, let dateCount):
            urlComponents.queryItems = [
                URLQueryItem(name: "GroupId", value: "\(groupId)"),
                URLQueryItem(name: "DateCount", value: "\(dateCount)")
            ]
        }

        return urlComponents.url
    }
}
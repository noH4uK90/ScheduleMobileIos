//
//  TeacherEndpoints.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/8/24.
//

import Foundation

enum TeacherEndpoints {
    case teachers(String)
    case teacherByAccount(Int)

    var baseURL: URL { API.baseURL.appending(path: APITags.teacher.rawValue) }

    func path() -> String {
        switch self {
        case .teachers:
            "FullName"
        case .teacherByAccount(let id):
            "Account/\(id)"
        }
    }

    var absoluteURL: URL? {
        guard var urlComponents = API.getComponents(for: baseURL, with: self.path()) else {
            return nil
        }

        switch self {
        case .teachers(let search):
            urlComponents.queryItems = [
                URLQueryItem(name: "Search", value: search),
            ]
        case .teacherByAccount:
            urlComponents.queryItems = []
        }

        return urlComponents.url
    }
}

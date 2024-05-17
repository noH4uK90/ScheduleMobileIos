//
//  GroupEndpoints.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation

enum GroupEndpoints {
    case courseGroups(Int)
    case groups(String)

    var baseURL: URL { API.baseURL.appending(path: APITags.group.rawValue) }

    func path() -> String {
        switch self {
        case .courseGroups(let course):
            "ByCourse/\(course)"
        case .groups:
            ""
        }
    }

    var absoluteURL: URL? {
        guard var urlComponents = API.getComponents(for: baseURL, with: self.path()) else {
            return nil
        }

        switch self {
        case .courseGroups:
            urlComponents.queryItems = []
        case .groups(let search):
            urlComponents.queryItems = [
                URLQueryItem(name: "Search", value: search)
            ]
        }

        return urlComponents.url
    }
}

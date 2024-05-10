//
//  GroupEndpoints.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation

enum GroupEndpoints {
    case group(String, Int)
    case courseGroups(Int)

    var baseURL: URL { API.baseURL.appending(path: APITags.group.rawValue) }

    func path() -> String {
        switch self {
        case .group:
            ""
        case .courseGroups(let course):
            "ByCourse/\(course)"
        }
    }

    var absoluteURL: URL? {
        guard var urlComponents = API.getComponents(for: baseURL, with: self.path()) else {
            return nil
        }

        switch self {
        case .group(let search, let page):
            urlComponents.queryItems = [
                URLQueryItem(name: "Search", value: search),
                URLQueryItem(name: "Page", value: "\(page)")
            ]
        case .courseGroups:
            urlComponents.queryItems = []
        }

        return urlComponents.url
    }
}

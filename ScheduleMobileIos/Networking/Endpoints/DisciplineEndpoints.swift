//
//  DisciplineEndpoints.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/26/24.
//

import Foundation

enum DisciplineEndpoints {
    case disciplines(search: String?)
    case groupDisciplines(groupId: Int)

    var baseURL: URL { API.baseURL.appending(path: APITags.discipline.rawValue) }

    func path() -> String {
        switch self {
        case .disciplines:
            ""
        case .groupDisciplines:
            "Group"
        }
    }

    var absoluteURL: URL? {
        guard var urlComponents = API.getComponents(for: baseURL, with: self.path()) else {
            return nil
        }

        switch self {
        case .disciplines(let search):
            urlComponents.queryItems = [
                URLQueryItem(name: "Search", value: search)
            ]
        case .groupDisciplines(let groupId):
            urlComponents.queryItems = [
                URLQueryItem(name: "GroupId", value: "\(groupId)")
            ]
        }

        return urlComponents.url
    }
}

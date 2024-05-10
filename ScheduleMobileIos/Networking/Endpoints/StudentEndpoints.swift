//
//  StudentEndpoints.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/7/24.
//

import Foundation

enum StudentEndpoints {
    case studentByAccount(Int)

    var baseURL: URL { API.baseURL.appending(path: APITags.student.rawValue) }

    func path() -> String {
        switch self {
        case .studentByAccount(let id):
            "Account/\(id)"
        }
    }

    var absoluteURL: URL? {
        guard var urlComponents = API.getComponents(for: baseURL, with: self.path()) else {
            return nil
        }

        switch self {
        case .studentByAccount:
            urlComponents.queryItems = []
        }

        return urlComponents.url
    }
}

//
//  AccountEndpoints.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation

enum AccountEndpoints {
    case login, refresh, logout, changePassword, restorePassword

    var baseURL: URL { API.baseURL.appending(path: APITags.account.rawValue) }

    func path() -> String {
        switch self {
        case .login:
            "login"
        case .refresh:
            "refresh"
        case .logout:
            "logout"
        case .changePassword:
            "change_password"
        case .restorePassword:
            "restore_password"
        }
    }

    var abosluteURL: URL? {
        guard var urlComponents = API.getComponents(for: baseURL, with: self.path()) else {
            return nil
        }

        switch self {
        case .login:
            urlComponents.queryItems = []
        case .refresh:
            urlComponents.queryItems = []
        case .logout:
            urlComponents.queryItems = []
        case .changePassword:
            urlComponents.queryItems = []
        case .restorePassword:
            urlComponents.queryItems = []
        }

        return urlComponents.url
    }
}

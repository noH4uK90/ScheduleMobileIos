//
//  NetworkManager.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation

enum Endpoints {
    case group(String, Int)

    var baseURL: URL { URL(string: "http://localhost:5050/api")! }

    func path() -> String {
        switch self {
        case .group:
            return "/Group"
        }
    }

    var absoluteURL: URL? {
        let queryURL = baseURL.appending(path: self.path())
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else {
            return nil
        }

        switch self {
        case .group(let search, let page):
            urlComponents.queryItems = [
                URLQueryItem(name: "Search", value: search),
                URLQueryItem(name: "Page", value: "\(page)")
            ]
        }

        return urlComponents.url
    }

}

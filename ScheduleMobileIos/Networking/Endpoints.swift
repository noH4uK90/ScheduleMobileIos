//
//  NetworkManager.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation

enum Endpoints {
    case group(String, Int)
    case currentTimetable(Int, Int = 7)

    var baseURL: URL { API.baseURL }

    func path() -> String {
        switch self {
        case .group:
            return "/Group"
        case .currentTimetable:
            return "/Timetable/Current"
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
        case .currentTimetable(let groupId, let dateCount):
            urlComponents.queryItems = [
                URLQueryItem(name: "GroupId", value: "\(groupId)"),
                URLQueryItem(name: "DateCount", value: "\(dateCount)")
            ]
        }

        return urlComponents.url
    }
}

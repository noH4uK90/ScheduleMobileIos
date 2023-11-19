//
//  NetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func getGroups(search: String, page: Int) throws -> AnyPublisher<PagedList<Group>, Error>
    func getCurrentTimeTable(groupId: Int) throws -> AnyPublisher<PagedList<CurrentTimetable>, Error>
}

class NetworkService: NetworkProtocol {
    @Inject private var network: DataTransferProtocol

    // MARK: - Group
    func getGroups(search: String, page: Int) throws -> AnyPublisher<PagedList<Group>, Error> {
        guard let url = Endpoints.group(search, page).absoluteURL else {
            throw APIError.invalidResponse
        }
        return network.fetch(url, PagedList<Group>.self)
    }

    // MARK: - Schedule
    func getCurrentTimeTable(groupId: Int) throws -> AnyPublisher<PagedList<CurrentTimetable>, Error> {
        guard let url = Endpoints.currentTimetable(groupId).absoluteURL else {
            throw APIError.invalidResponse
        }
        return network.fetch(url, PagedList<CurrentTimetable>.self)
    }
}

enum APIError: LocalizedError {
  /// Invalid request, e.g. invalid URL
  case invalidRequestError(String)

  /// Indicates an error on the transport layer, e.g. not being able to connect to the server
  case transportError(Error)

  /// Received an invalid response, e.g. non-HTTP result
  case invalidResponse

  /// Server-side validation error
  case validationError(String)

  /// The server sent data in an unexpected format
  case decodingError(Error)

  var errorDescription: String? {
    switch self {
    case .invalidRequestError(let message):
      return "Invalid request: \(message)"
    case .transportError(let error):
      return "Transport error: \(error)"
    case .invalidResponse:
      return "Invalid response"
    case .validationError(let reason):
      return "Validation Error: \(reason)"
    case .decodingError:
      return "The server returned data in an unexpected format. Try updating the app."
    }
  }
}

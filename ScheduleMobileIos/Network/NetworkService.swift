//
//  NetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func fetch<T: Codable>(_ url: URL, _ model: T.Type) -> AnyPublisher<T, Error>

    func post<TData: Codable, TResult: Codable>(_ url: URL, _ data: TData) throws -> AnyPublisher<TResult, Error>
}

struct Network: NetworkProtocol {
    func fetch<T: Codable>(_ url: URL, _ model: T.Type) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func post<TData: Codable, TResult: Codable>(_ url: URL, _ data: TData) throws -> AnyPublisher<TResult, Error> {
        let jsonData = try JSONEncoder().encode(data)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        return URLSession.shared.dataTaskPublisher(for: request)
            .map({ $0.data })
            .decode(type: TResult.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class NetworkService {
    static let shared = NetworkService(); private init() {}

    // MARK: - Group
    func getGroups(search: String) throws -> AnyPublisher<PagedList<Group>, Error> {
        guard let url = Endpoints.group(search).absoluteURL else {
            throw APIError.invalidResponse
        }
        return Network().fetch(url, PagedList<Group>.self)
    }

    // MARK: - Schedule
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

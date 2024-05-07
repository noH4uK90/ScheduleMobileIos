//
//  DataTransferService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/19/23.
//

import Foundation
import Combine

protocol DataTransferProtocol {
    func fetch<T: Codable>(_ url: URL, _ model: T.Type) -> AnyPublisher<T, Error>

    func post<TData: Codable>(_ url: URL, _ body: TData) throws

    func post<TData: Codable, TResult: Codable>(_ url: URL, _ body: TData) throws -> AnyPublisher<TResult, Error>
}

final class DataTransferService: DataTransferProtocol {
    private func createPostRequest<T: Codable>(_ url: URL, _ body: T) throws -> URLRequest {
        let jsonData = try JSONEncoder().encode(body)
        let secureSettings = SecureSettings()

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(secureSettings.accessToken ?? "")", forHTTPHeaderField: "authorization")
        request.httpBody = jsonData

        return request
    }

    private func refresh() throws -> AnyPublisher<AuthorizationResponse, any Error> {
        guard let url = AccountEndpoints.refresh.abosluteURL else {
            throw APIError.invalidResponse
        }

        let secureSettings = SecureSettings()
        let command = RefreshCommand(
            refreshToken: secureSettings.refreshToken ?? "",
            accessToken: secureSettings.accessToken ?? "")
        let request = try createPostRequest(url, command)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map({ $0.data })
            .decode(type: AuthorizationResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetch<T: Codable>(_ url: URL, _ model: T.Type) -> AnyPublisher<T, Error> {
        var decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Date().getLocalDateFormatt(locale: "ru_RU"))
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryCatch { [weak self] error -> AnyPublisher<(data: Data, response: URLResponse), Error> in
                guard let self = self, error.code == .userAuthenticationRequired else {
                    throw error
                }
                return try self.refresh()
                    .flatMap { authorizationResponse -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> in
                        guard
                            authorizationResponse.accessToken.isEmpty &&
                            authorizationResponse.refreshToken.isEmpty else {
                                return Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
                        }
                        return URLSession.shared.dataTaskPublisher(for: url)
                            .mapError { $0 as Error }
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .map({ $0.data })
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func post<TData: Codable>(_ url: URL, _ body: TData) throws {
        let request = try createPostRequest(url, body)

        URLSession.shared.dataTask(with: request)
    }

    func post<TData: Codable, TResult: Codable>(_ url: URL, _ body: TData) throws -> AnyPublisher<TResult, Error> {
        let request = try createPostRequest(url, body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryCatch { [weak self] error -> AnyPublisher<(data: Data, response: URLResponse), Error> in
                guard let self = self, error.code == .userAuthenticationRequired else {
                    throw error
                }
                return try self.refresh()
                    .flatMap { authorizationResponse -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> in
                        guard
                            authorizationResponse.accessToken.isEmpty &&
                            authorizationResponse.refreshToken.isEmpty else {
                                return Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
                        }
                        return URLSession.shared.dataTaskPublisher(for: url)
                            .mapError { $0 as Error }
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .map({ $0.data })
            .decode(type: TResult.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

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

    func post<TData: Codable, TResult: Codable>(_ url: URL, _ data: TData) throws -> AnyPublisher<TResult, Error>

    func refreshToken() -> AnyPublisher<Bool, Error>
}

final class DataTransferService: DataTransferProtocol {
    internal func refreshToken() -> AnyPublisher<Bool, Error> {
        Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetch<T: Codable>(_ url: URL, _ model: T.Type) -> AnyPublisher<T, Error> {

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryCatch { [weak self] error -> AnyPublisher<(data: Data, response: URLResponse), Error> in
                guard let self = self, error.code == .userAuthenticationRequired else {
                    throw error
                }
                return self.refreshToken()
                    .flatMap { isSuccess -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> in
                        guard isSuccess else {
                            return Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
                        }
                        return URLSession.shared.dataTaskPublisher(for: url)
                            .mapError { $0 as Error }
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
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

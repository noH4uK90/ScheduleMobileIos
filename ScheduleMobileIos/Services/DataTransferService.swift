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
}

class DataTransferService: DataTransferProtocol {
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

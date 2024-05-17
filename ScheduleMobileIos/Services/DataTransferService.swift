//
//  DataTransferService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/19/23.
//

import Foundation
import Combine

protocol DataTransferProtocol {
    func fetch<T: Codable>(_ url: URL, _ model: T.Type) throws -> AnyPublisher<T, Error>

    func post<TData: Codable>(_ url: URL, _ body: TData) throws -> AnyPublisher<Void, Error>

    func post<TData: Codable, TResult: Codable>(_ url: URL, _ body: TData) throws -> AnyPublisher<TResult, Error>
}

final class DataTransferService: DataTransferProtocol {
    private var bag = Set<AnyCancellable>()

    private func createGetRequest(_ url: URL) throws -> URLRequest {
        let secureSettings = SecureSettings()

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(secureSettings.accessToken ?? "")", forHTTPHeaderField: "Authorization")

        return request
    }

    private func createPostRequest<T: Codable>(_ url: URL, _ body: T) throws -> URLRequest {
        let jsonData = try JSONEncoder().encode(body)
        let secureSettings = SecureSettings()

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(secureSettings.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        return request
    }

    private func refresh() async throws {
        guard let url = AccountEndpoints.refresh.abosluteURL else {
            throw APIError.invalidResponse
        }

        let secureSettings = SecureSettings()
        let command = RefreshCommand(
            refreshToken: secureSettings.refreshToken ?? "",
            accessToken: secureSettings.accessToken ?? "")
        let request = try createPostRequest(url, command)
        let (data, response) = try await URLSession.shared.data(for: request)

        if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
            let authResponse = try JSONDecoder().decode(AuthorizationResponse.self, from: data)
            secureSettings.accessToken = authResponse.accessToken
            secureSettings.refreshToken = authResponse.refreshToken
            secureSettings.account = SecureStorage.Credentials(
                login: authResponse.account.login,
                password: authResponse.account.passwordHash)
        }
    }

    func fetch<T: Codable>(_ url: URL, _ model: T.Type) throws -> AnyPublisher<T, Error> {
        let request = try createGetRequest(url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Date().getLocalDateFormatt(locale: "ru_RU"))
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                switch response.statusCode {
                case 200...299:
                    let result = try JSONDecoder().decode(T.self, from: output.data)
                    return result
                case 401:
                    throw URLError(.userAuthenticationRequired)
                default:
                    let apiError = try JSONDecoder().decode(ApiError.self, from: output.data)
                    throw apiError
                }
            }
            .catch { error -> AnyPublisher<T, Error> in
                guard (error as NSError).code == URLError.userAuthenticationRequired.rawValue else {
                    return Fail(error: error).eraseToAnyPublisher()
                }

                return Future { promise in
                    Task {
                        do {
                            try await self.refresh()
                            _ = try self.fetch(url, T.self)
                                .receive(on: DispatchQueue.main)
                                .sink(
                                    receiveCompletion: { completion in
                                        switch completion {
                                        case .finished:
                                            break
                                        case .failure(let failure):
                                            promise(.failure(failure))
                                        }
                                    },
                                    receiveValue: { _ in }
                                )
                                .store(in: &self.bag)
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func post<TData: Codable>(_ url: URL, _ body: TData) throws -> AnyPublisher<Void, Error> {
        let request = try createPostRequest(url, body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                switch response.statusCode {
                case 200...299:
                    return ()
                case 401:
                    throw URLError(.userAuthenticationRequired)
                default:
                    let apiError = try JSONDecoder().decode(ApiError.self, from: output.data)
                    throw apiError
                }
            }
            .catch { error -> AnyPublisher<Void, Error> in
                guard (error as NSError).code == URLError.userAuthenticationRequired.rawValue else {
                    return Fail(error: error).eraseToAnyPublisher()
                }

                return Future { promise in
                    Task {
                        do {
                            try await self.refresh()
                            _ = try self.post(url, body)
                                .receive(on: DispatchQueue.main)
                                .sink(
                                    receiveCompletion: { completion in
                                        switch completion {
                                        case .finished:
                                            promise(.success(()))
                                        case .failure(let failure):
                                            promise(.failure(failure))
                                        }
                                    },
                                    receiveValue: { _ in }
                                )
                                .store(in: &self.bag)
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func post<TData: Codable, TResult: Codable>(_ url: URL, _ body: TData) throws -> AnyPublisher<TResult, Error> {
        let request = try createPostRequest(url, body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                switch response.statusCode {
                case 200...299:
                    let result = try JSONDecoder().decode(TResult.self, from: output.data)
                    return result
                case 401:
                    throw URLError(.userAuthenticationRequired)
                default:
                    let apiError = try JSONDecoder().decode(ApiError.self, from: output.data)
                    throw apiError
                }
            }
            .catch { error -> AnyPublisher<TResult, Error> in
                guard (error as NSError).code == URLError.userAuthenticationRequired.rawValue else {
                    return Fail(error: error).eraseToAnyPublisher()
                }

                return Future { promise in
                    Task {
                        do {
                            try await self.refresh()
                            _ = try self.post(url, body)
                                .receive(on: DispatchQueue.main)
                                .sink(
                                    receiveCompletion: { completion in
                                        switch completion {
                                        case .finished:
                                            break
                                        case .failure(let failure):
                                            promise(.failure(failure))
                                        }
                                    },
                                    receiveValue: { _ in }
                                )
                                .store(in: &self.bag)
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

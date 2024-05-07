//
//  AccountNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/6/24.
//

import Foundation
import Combine

protocol AccountNetworkProtocol {
    func login(login: String, password: String) throws -> AnyPublisher<AuthorizationResponse, Error>
    func logout() throws
}

final class AccountNetworkService: AccountNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func login(login: String, password: String) throws -> AnyPublisher<AuthorizationResponse, any Error> {
        guard let url = AccountEndpoints.login.abosluteURL else {
            throw APIError.invalidResponse
        }

        let command = LoginCommand(login: login, password: password)
        return try network.post(url, command)
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map({ $0.data })
//            .decode(type: AuthorizationResponse.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
    }

    func logout() throws {
        guard let url = AccountEndpoints.logout.abosluteURL else {
            throw APIError.invalidResponse
        }

        let secureSettings = SecureSettings()
        let command = LogoutCommand(
            accessToken: secureSettings.accessToken ?? "",
            refreshToken: secureSettings.refreshToken ?? "")
        try network.post(url, command)
    }
}

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
    func logout() throws -> AnyPublisher<Void, Error>
    func changePassword(accountId: Int, password: String, newPassword: String) throws -> AnyPublisher<Void, Error>
    func restorePassword(email: String) throws -> AnyPublisher<Void, Error>
}

final class AccountNetworkService: AccountNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func login(login: String, password: String) throws -> AnyPublisher<AuthorizationResponse, any Error> {
        guard let url = AccountEndpoints.login.abosluteURL else {
            throw APIError.invalidResponse
        }

        let command = LoginCommand(login: login, password: password)
        return try network.post(url, command)
    }

    func logout() throws -> AnyPublisher<Void, Error> {
        guard let url = AccountEndpoints.logout.abosluteURL else {
            throw APIError.invalidResponse
        }

        let secureSettings = SecureSettings()
        let command = LogoutCommand(
            accessToken: secureSettings.accessToken ?? "",
            refreshToken: secureSettings.refreshToken ?? "")
        return try network.post(url, command)
    }

    func changePassword(accountId: Int, password: String, newPassword: String) throws -> AnyPublisher<Void, any Error> {
        guard let url = AccountEndpoints.changePassword.abosluteURL else {
            throw APIError.invalidResponse
        }

        let command = ChangePasswordCommand(
            id: accountId,
            password: password,
            newPassword: newPassword)
        return try network.post(url, command)
    }

    func restorePassword(email: String) throws -> AnyPublisher<Void, Error> {
        guard let url = AccountEndpoints.restorePassword.abosluteURL else {
            throw APIError.invalidResponse
        }

        let command = RestorePasswordCommand(email: email)
        return try network.post(url, command)
    }
}

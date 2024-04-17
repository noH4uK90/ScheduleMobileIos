//
//  GroupNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation
import Combine

protocol GroupNetworkProtocol {
    func getGroups(search: String, page: Int) throws -> AnyPublisher<PagedList<Group>, Error>
}

final class GroupNetworkService: GroupNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func getGroups(search: String, page: Int) throws -> AnyPublisher<PagedList<Group>, any Error> {
        guard let url = GroupEndpoints.group(search, page).absoluteURL else {
            throw APIError.invalidResponse
        }
        return network.fetch(url, PagedList<Group>.self)
    }
}

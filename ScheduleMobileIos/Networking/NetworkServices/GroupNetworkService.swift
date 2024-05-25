//
//  GroupNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation
import Combine

protocol GroupNetworkProtocol {
    func getGroups(search: String) throws -> AnyPublisher<[GroupModel], Error>// AnyPublisher<PagedList<GroupModel>, Error>
}

final class GroupNetworkService: GroupNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func getGroups(search: String = "") throws -> AnyPublisher<[GroupModel], Error> {// AnyPublisher<PagedList<GroupModel>, any Error> {
        guard let url = GroupEndpoints.groups(search).absoluteURL else {
            throw APIError.invalidResponse
        }

        return try network.fetch(url, [GroupModel].self)
    }
}

//
//  GroupNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation
import Combine

protocol GroupNetworkProtocol {
    func getGroups(search: String, page: Int) throws -> AnyPublisher<PagedList<GroupModel>, Error>
    func getCourseGroups(id: Int) throws -> AnyPublisher<[Grouped<Speciality, GroupModel>], Error>
}

final class GroupNetworkService: GroupNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func getGroups(search: String, page: Int) throws -> AnyPublisher<PagedList<GroupModel>, any Error> {
        guard let url = GroupEndpoints.group(search, page).absoluteURL else {
            throw APIError.invalidResponse
        }
        return network.fetch(url, PagedList<GroupModel>.self)
    }

    func getCourseGroups(id: Int) throws -> AnyPublisher<[Grouped<Speciality, GroupModel>], any Error> {
        guard let url = GroupEndpoints.courseGroups(id).absoluteURL else {
            throw APIError.invalidResponse
        }
        return network.fetch(url, [Grouped<Speciality, GroupModel>].self)
    }
}

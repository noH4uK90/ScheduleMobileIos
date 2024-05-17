//
//  GroupNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation
import Combine

protocol GroupNetworkProtocol {
    func getCourseGroups(id: Int) throws -> AnyPublisher<[Grouped<Speciality, GroupModel>], Error>
    func getGroups(search: String) throws -> AnyPublisher<PagedList<GroupModel>, Error>
}

final class GroupNetworkService: GroupNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func getCourseGroups(id: Int) throws -> AnyPublisher<[Grouped<Speciality, GroupModel>], any Error> {
        guard let url = GroupEndpoints.courseGroups(id).absoluteURL else {
            throw APIError.invalidResponse
        }
        return try network.fetch(url, [Grouped<Speciality, GroupModel>].self)
    }

    func getGroups(search: String = "") throws -> AnyPublisher<PagedList<GroupModel>, any Error> {
        guard let url = GroupEndpoints.groups(search).absoluteURL else {
            throw APIError.invalidResponse
        }

        return try network.fetch(url, PagedList<GroupModel>.self)
    }
}

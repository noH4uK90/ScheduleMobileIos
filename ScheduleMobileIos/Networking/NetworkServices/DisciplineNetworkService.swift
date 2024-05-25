//
//  DisciplineNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/26/24.
//

import Foundation
import Combine

protocol DisciplineNetworkProtocol {
    func getDisciplines(search: String?) throws -> AnyPublisher<[Discipline], Error>

    func getGroupDisciplines(groupId: Int) throws -> AnyPublisher<[Discipline], Error>
}

final class DisciplineNetworkService: DisciplineNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func getDisciplines(search: String?) throws -> AnyPublisher<[Discipline], any Error> {
        guard let url = DisciplineEndpoints.disciplines(search: search).absoluteURL else {
            throw APIError.invalidResponse
        }

        return try network.fetch(url, [Discipline].self)
    }

    func getGroupDisciplines(groupId: Int) throws -> AnyPublisher<[Discipline], any Error> {
        guard let url = DisciplineEndpoints.groupDisciplines(groupId: groupId).absoluteURL else {
            throw APIError.invalidResponse
        }

        return try network.fetch(url, [Discipline].self)
    }


}

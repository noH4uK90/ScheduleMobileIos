//
//  TimetableNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation
import Combine

protocol TimetableNetworkProtocol {
    func getGroupTimetable(groupId: Int, date: Date) throws -> AnyPublisher<[Timetable], Error>

    func getTeacherTimetable(teacherId: Int, date: Date) throws -> AnyPublisher<[Timetable], Error>
}

final class TimetableNetworkService: TimetableNetworkProtocol {
    @Inject private var network: DataTransferProtocol
    private var bag = Set<AnyCancellable>()

    func getGroupTimetable(groupId: Int, date: Date) throws -> AnyPublisher<[Timetable], any Error> {
        guard let url = TimetableEndpoints.groupTimetable(groupId: groupId, date: date).absoluteURL else {
            throw APIError.invalidResponse
        }

        return try network.fetch(url, [Timetable].self)
    }

    func getTeacherTimetable(teacherId: Int, date: Date) throws -> AnyPublisher<[Timetable], any Error> {
        guard let url = TimetableEndpoints.teacherTimetable(teacherId: teacherId, date: date).absoluteURL else {
            throw APIError.invalidResponse
        }

        return try network.fetch(url, [Timetable].self)
    }
}

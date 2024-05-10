//
//  TeacherNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/8/24.
//

import Foundation
import Combine

protocol TeacherNetworkProtocol {
    func getTeacherByAccount(id: Int) throws -> AnyPublisher<Teacher, Error>
    func getTeacherLessons(teacherId: Int, date: String) throws -> AnyPublisher<[Lesson], Error>
}

final class TeacherNetworkService: TeacherNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func getTeacherByAccount(id: Int) throws -> AnyPublisher<Teacher, any Error> {
        guard let url = TeacherEndpoints.teacherByAccount(id).absoluteURL else {
            throw APIError.invalidResponse
        }

        return network.fetch(url, Teacher.self)
    }

    func getTeacherLessons(teacherId: Int, date: String) throws -> AnyPublisher<[Lesson], any Error> {
        guard let url = TeacherEndpoints.teacherLessons(teacherId, date).absoluteURL else {
            throw APIError.invalidResponse
        }

        return network.fetch(url, [Lesson].self)
    }
}

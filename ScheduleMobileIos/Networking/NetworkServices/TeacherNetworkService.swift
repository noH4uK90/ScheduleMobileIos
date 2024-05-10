//
//  TeacherNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/8/24.
//

import Foundation
import Combine

protocol TeacherNetworkProtocol {
    func getTeachers(search: String, page: Int) throws -> AnyPublisher<PagedList<Teacher>, Error>
    func getTeacherByAccount(id: Int) throws -> AnyPublisher<Teacher, Error>
    func getTeacherLessons(teacherId: Int, date: String) throws -> AnyPublisher<[Lesson], Error>
}

final class TeacherNetworkService: TeacherNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func getTeachers(search: String, page: Int) throws -> AnyPublisher<PagedList<Teacher>, any Error> {
        guard let url = TeacherEndpoints.teachers(search, page).absoluteURL else {
            throw APIError.invalidResponse
        }

        return network.fetch(url, PagedList<Teacher>.self)
    }

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

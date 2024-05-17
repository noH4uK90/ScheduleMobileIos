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
    func getTeacher(accountId: Int, completion: @escaping (Teacher) throws -> Void)
    func getLessons(accountId: Int, day: Int) async throws -> [Lesson]
}

final class TeacherNetworkService: TeacherNetworkProtocol {
    @Inject private var network: DataTransferProtocol
    private var bag = Set<AnyCancellable>()

    func getTeachers(search: String, page: Int) throws -> AnyPublisher<PagedList<Teacher>, any Error> {
        guard let url = TeacherEndpoints.teachers(search, page).absoluteURL else {
            throw APIError.invalidResponse
        }

        return try network.fetch(url, PagedList<Teacher>.self)
    }

    func getTeacherByAccount(id: Int) throws -> AnyPublisher<Teacher, any Error> {
        guard let url = TeacherEndpoints.teacherByAccount(id).absoluteURL else {
            throw APIError.invalidResponse
        }

        return try network.fetch(url, Teacher.self)
    }

    func getTeacherLessons(teacherId: Int, date: String) throws -> AnyPublisher<[Lesson], any Error> {
        guard let url = TeacherEndpoints.teacherLessons(teacherId, date).absoluteURL else {
            throw APIError.invalidResponse
        }

        return try network.fetch(url, [Lesson].self)
    }

    func getTeacher(accountId: Int, completion: @escaping (Teacher) throws -> Void) {
        Task {
            try getTeacherByAccount(id: accountId)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { value in
                        try? completion(value)
                    }
                )
                .store(in: &bag)
        }
    }

    func getLessons(accountId: Int, day: Int) async throws -> [Lesson] {
        return try await withCheckedThrowingContinuation { continuation in
            getTeacher(accountId: accountId) { teacher in
                Task {
                    do {
                        let lessonsPublisher = try self.getTeacherLessons(teacherId: teacher.id, date: Date().dateForDayOfWeek(day: day))

                        lessonsPublisher
                            .receive(on: DispatchQueue.main)
                            .sink(
                                receiveCompletion: { completion in
                                    if case .failure(let error) = completion {
                                        continuation.resume(throwing: error)
                                    }
                                },
                                receiveValue: { lessons in
                                    continuation.resume(returning: lessons)
                                }
                            )
                            .store(in: &self.bag)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}

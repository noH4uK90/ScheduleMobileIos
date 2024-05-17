//
//  StudentNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/7/24.
//

import Foundation
import Combine

protocol StudentNetworkProtocol {
    func getStudentByAccount(id: Int) throws -> AnyPublisher<Student, Error>
}

final class StudentNetworkService: StudentNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func getStudentByAccount(id: Int) throws -> AnyPublisher<Student, any Error> {
        guard let url = StudentEndpoints.studentByAccount(id).absoluteURL else {
            throw APIError.invalidResponse
        }

        return try network.fetch(url, Student.self)
    }
}

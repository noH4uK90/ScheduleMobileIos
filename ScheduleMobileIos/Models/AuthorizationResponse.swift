//
//  AuthorizationResponse.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/6/24.
//

import Foundation

struct AuthorizationResponse: Codable, Hashable {
    let accessToken: String
    let refreshToken: String
    let account: FullAccount
}

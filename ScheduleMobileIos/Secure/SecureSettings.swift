//
//  SecureSettings.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/21/24.
//

import Foundation

final class SecureSettings {
    @Credentials("account")
    var account: SecureStorage.Credentials?

    @Password("accessToken")
    var accessToken: String?

    @Password("refreshToken")
    var refreshToken: String?

    func clear() {
        account = nil
        accessToken = nil
        refreshToken = nil
    }
}

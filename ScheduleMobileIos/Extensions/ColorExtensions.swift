//
//  ColorExtension.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/16/24.
//

import Foundation
import SwiftUI

extension Color {
    static func random() -> Color {
        Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 0.5)
    }
}

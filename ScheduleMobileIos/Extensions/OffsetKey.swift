//
//  OffsetKey.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/18/24.
//

import Foundation
import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

//
//  SheduleViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation
import Combine

extension ScheduleView {
    @MainActor class ViewModel: ObservableObject {
        @Published var days = Date().daysOfWeek()
        @Published var selected: Int = Date().dayNumberOfWeek()
        @Published private var isLoaded = false
    }
}

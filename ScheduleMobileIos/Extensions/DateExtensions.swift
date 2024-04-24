//
//  DateExtensions.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/20/24.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int {
        var weekDay = (Calendar.current.dateComponents([.weekday], from: self).weekday ?? 1) - 1
        weekDay = weekDay == 0 ? 7 : weekDay
        return weekDay
    }

    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEEE"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    func daysOfWeek() -> [Int: String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEEEE"
        dateFormatter.locale = Locale.init(identifier: "ru_RU")
        var days = dateFormatter.shortWeekdaySymbols
        let sunday = days!.removeFirst()
        days!.append(sunday)

        return days!.enumerated().reduce(into: [:]) { $0[$1.offset + 1] = $1.element }
    }
}

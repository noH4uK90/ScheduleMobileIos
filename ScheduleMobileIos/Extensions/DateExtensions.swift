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

    func dateForDayOfWeek(day: Int) -> String {
        let currentWeekDay = dayNumberOfWeek()
        let daysToAdd = day >= currentWeekDay ? day - currentWeekDay : day + 7 - currentWeekDay

        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: daysToAdd, to: self) ?? Date()

        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "ru_RU")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: newDate)
    }

    func dayOfWeek() -> String {
        let dateFormatter = getLocalDateFormatt(locale: "ru_RU")
        return dateFormatter.string(from: self)
    }

    func daysOfWeek() -> [Int: String] {
        let dateFormatter = getLocalDateFormatt(locale: "ru_RU")
        var days = dateFormatter.shortWeekdaySymbols
        let sunday = days!.removeFirst()
        days!.append(sunday)

        return days!.enumerated().reduce(into: [:]) { $0[$1.offset + 1] = $1.element }
    }

    func getLocalDateFormatt(locale: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: locale)
        dateFormatter.timeStyle = .short
        dateFormatter.amSymbol = ""
        dateFormatter.pmSymbol = ""
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }

    func formatStringDate(date: String) -> String {
        let dateFormatter = getLocalDateFormatt(locale: "ru_RU")
        let newDate = dateFormatter.date(from: date)
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return dateFormatter.string(from: newDate!)
    }
}

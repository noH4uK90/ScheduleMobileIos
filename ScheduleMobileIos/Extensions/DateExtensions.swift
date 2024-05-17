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

    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }

    func getLocalDateFormatt(locale: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: locale)
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeStyle = .short
        dateFormatter.amSymbol = ""
        dateFormatter.pmSymbol = ""
        return dateFormatter
    }

    func formatStringDate(date: String) -> String {
        let dateFormatter = getLocalDateFormatt(locale: "ru_RU")
        let newDate = dateFormatter.date(from: date)
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return dateFormatter.string(from: newDate!)
    }

    func convertTime(_ time: String) -> String {
        let dateFormetter = DateFormatter()
        dateFormetter.locale = Locale.init(identifier: "en_US_POSIX")
        let date = dateFromString(time)
        dateFormetter.locale = Locale(identifier: "ru_RU")
        dateFormetter.dateFormat = "H:mm"
        return dateFormetter.string(from: date ?? Date())
    }

    func dateFromString(_ timeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let formats = ["h:mm a", "HH:mm", "H:mm"]

            for format in formats {
                dateFormatter.dateFormat = format
                if let date = dateFormatter.date(from: timeString) {
                    return date
                }
            }

        return nil
    }

    func compareTime(_ first: String, _ second: String) -> Bool {
        let firstDate = dateFromString(first)
        let secondDate = dateFromString(second)
        return firstDate ?? Date() < secondDate ?? Date()
    }

    func differenceFromCurrentDate(from dateString: String, withFormat format: String) -> DateComponents? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current

        guard let date = dateFormatter.date(from: dateString) else {
            print("Невозможно преобразовать строку в дату")
            return nil
        }

        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate, to: date)
        return components
    }

    func convertToPrettyDate(_ date: String, format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "d MMM yyyy, E"
        return dateFormatter.string(from: date ?? Date())
    }
}

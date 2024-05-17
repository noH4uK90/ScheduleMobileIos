//
//  AppIntent.swift
//  ScheduleWidget
//
//  Created by Иван Спирин on 4/2/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: false)
    var favoriteEmoji: Bool

    init(favoriteEmoji: Bool) {
        self.favoriteEmoji = favoriteEmoji
    }

    init() { }

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

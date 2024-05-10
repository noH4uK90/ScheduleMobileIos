//
//  DayPicker.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/10/24.
//

import SwiftUI

struct DayPicker: View {
    @Binding var selection: Int
    private var days = Date().daysOfWeek()

    init(selection: Binding<Int> = .constant(Date().dayNumberOfWeek())) {
        _selection = selection
    }

    var body: some View {
        Picker("Days",
               selection: $selection) {
            ForEach(days.sorted(by: <), id: \.key) { _, day in
                Text("\(day)")
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 24)
    }
}

#Preview {
    DayPicker()
}

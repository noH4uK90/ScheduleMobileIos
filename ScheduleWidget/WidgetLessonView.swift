//
//  LessonView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/2/24.
//

import SwiftUI

struct WidgetLessonView: View {
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .trailing) {
                Text("8:30")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("10:10")
                    .foregroundStyle(.placeholder)
            }
            VStack(alignment: .leading) {
                Text("МДК 01.01")
                    .font(.title3)
                    .fontWeight(.semibold)
                HStack {                 Spacer()
                    HStack {
                        Image(systemName: "door.left.hand.open")
                        Text("407")
                        Text("407")
                    }
                    .foregroundStyle(.blue.opacity(0.9))
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WidgetLessonView()
}

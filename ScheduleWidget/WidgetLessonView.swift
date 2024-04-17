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
                //.font(.system(size: 14))
            }
            //            Divider()
            //                .overlay(.foreground)
            //                .frame(maxHeight: 60)
            VStack(alignment: .leading) {
                Text("МДК 01.01")
                    .font(.title3)
                    .fontWeight(.semibold)
                HStack {
                    //                    Label("Преподаватель", systemImage: "person.fill")
                    //                        .font(.caption)
                    //                        .foregroundStyle(.secondary)
                    //                    Spacer()
                    HStack {
                        Image(systemName: "door.left.hand.open")
                        Text("407")
                        Text("407")
                    }
                    .foregroundStyle(.blue.opacity(0.9))

                }
                //                HStack {
                //                    Text("Преподаватель")
                //                        .font(.caption)
                //                        .foregroundStyle(.secondary)
                //                    Spacer()
                //                    Text("407")
                //                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WidgetLessonView()
}

//
//  LessonView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/2/24.
//

import SwiftUI

struct LessonView: View {
    @State var oneTeacher = false
    var body: some View {
        HStack(alignment: .top) {
            createTime()
            VStack(alignment: .leading) {
                Text("Математика")
                    .font(.title3)
                    .fontWeight(.semibold)

                HStack(spacing: 0) {
                    Image(systemName: "person.fill")
                        .padding(.trailing, 5)
                    Text(oneTeacher ? "Иванов И.И." : "Иванов И.И., Иванов И.И.")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)

                Spacer()

                HStack {
                    Text("407")
                        .cabinetTextStyle()

                    if !oneTeacher {
                        Text("407")
                            .cabinetTextStyle()
                    }
                }
                .font(.callout)
                .foregroundStyle(.blue)
            }

            Spacer()
        }
        .frame(maxHeight: 80)
        .padding(.horizontal, 5)
    }

    @ViewBuilder
    func createTime() -> some View {
        VStack(alignment: .center) {
            Text("8:30")
            Spacer()
            Text("10:10")
        }
        .font(.headline)
        .fontWeight(.semibold)
        .frame(maxHeight: 80)
        .padding(.horizontal, 3)
        .padding(.vertical, 3)
        .background(.blue.gradient)
        .foregroundStyle(.white)
        .cornerRadius(7)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )

        Divider()
            .frame(height: 85)
            .overlay(.foreground)
    }
}

  #Preview {
      LessonView()
  }

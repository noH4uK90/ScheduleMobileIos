//
//  LessonView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/2/24.
//

import SwiftUI

struct LessonView: View {
    @State var oneTeacher = false
    @State var oneCabinet = false
    var body: some View {
        HStack(alignment: .top) {
            createTime()
            VStack(alignment: .leading) {
                title
                teacher
                Spacer()
                cabinet
            }

            Spacer()
        }
        .frame(maxHeight: 80)
        .padding(.horizontal, 5)
    }

    var title: some View {
        Text("Математика")
            .font(.title3)
            .fontWeight(.semibold)
            .minimumScaleFactor(0.5)
    }

    var teacher: some View {
        HStack(spacing: 0) {
            Image(systemName: "person.fill")
                .padding(.trailing, 5)
                .unredacted()
            Text(oneTeacher ? "Иванов И.И." : "Иванов И.И., Иванов И.И.")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
        .minimumScaleFactor(0.5)
    }

    var cabinet: some View {
        HStack {
            Text("407")
                .cabinetTextStyle()

            if !oneCabinet {
                Text("407")
                    .cabinetTextStyle()
            }
        }
        .font(.callout)
        .foregroundStyle(.blue)
        .minimumScaleFactor(0.5)
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
        .minimumScaleFactor(0.5)

        Divider()
            .frame(height: 85)
            .overlay(.foreground)
    }
}

  #Preview {
      LessonView()
  }

//
//  TaskRowView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/18/24.
//

import SwiftUI

struct TaskRowView: View {
    @Bindable var task: TaskModel
    @Environment(\.modelContext) private var context
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                .overlay {
                    Circle()
                        .foregroundStyle(.clear)
                        .contentShape(.circle)
                        .frame(width: 50, height: 50)
                        .blendMode(.destinationOver)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()
                            }
                        }
                }

            VStack(alignment: .leading, spacing: 8) {
                Text(task.taskTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)

                Label(task.creationDate.format("H:mm"), systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.black)
            }
            .padding(15)
            .hSpacing(.leading)
            .background(task.tintColor, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .strikethrough(task.isCompleted, pattern: .solid, color: .black)
            .contentShape(.contextMenuPreview, .rect(cornerRadius: 15))
            .contextMenu {
                Button("Удалить задачу", role: .destructive) {
                    context.delete(task)
                    try? context.save()
                }
            }
            .offset(y: -8)
        }
    }

    var indicatorColor: Color {
        if task.isCompleted {
            return .green
        }

        return task.creationDate.isSameHour ? Color(.systemBlue) : (task.creationDate.isPast ? .red : .black)
    }
}

#Preview {
    TaskHomeView()
}

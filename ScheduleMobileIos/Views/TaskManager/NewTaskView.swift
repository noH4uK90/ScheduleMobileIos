//
//  NewTaskView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/18/24.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskColor: Color = .red.opacity(0.4)
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .hSpacing(.leading)

            VStack(alignment: .leading, spacing: 8) {
                Text("Задача")
                    .font(.caption)
                    .foregroundStyle(.gray)

                TextField("Прийти на пару", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            }
            .padding(.top, 5)

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Время задачи")
                        .font(.caption)
                        .foregroundStyle(.gray)

                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                }
                .padding(.top, 5)
                .padding(.trailing, -15)

                ColorPicker(selection: $taskColor, label: {
                    Text("Цвет задачи")
                        .font(.caption)
                        .foregroundStyle(.gray)
                })
            }

            Spacer(minLength: 0)

            Button(action: {
                let hexColor = taskColor.toHex()
                let task = TaskModel(taskTitle: taskTitle, creationDate: taskDate, tint: hexColor ?? "#000000")
                do {
                    context.insert(task)
                    try context.save()
                    dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            }, label: {
                Text("Создать задачу")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.black)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(taskColor, in: .rect(cornerRadius: 10))
            })
            .disabled(taskTitle == "")
            .opacity(taskTitle == "" ? 0.5 : 1)
        }
        .padding(15)
    }
}

//#Preview {
//    NewTaskView()
//        .vSpacing(.bottom)
//}

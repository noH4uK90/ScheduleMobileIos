//
//  TaskHome.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/18/24.
//

import SwiftUI
import SwiftData

struct TaskHomeView: View {
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @State private var createNewTask: Bool = false
    @Namespace private var animation
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            //headerView()
            DateWheel(currentDate: $currentDate, weekSlider: $weekSlider, currentWeekIndex: $currentWeekIndex, createWeek: $createWeek)

            ScrollView(.vertical) {
                VStack {
                    TasksView(currentDate: $currentDate)
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
        }
        .vSpacing(.top)
        .background(Color(UIColor.systemGroupedBackground))
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                createNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
                    .background(Color(UIColor.systemBlue).shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .circle)
            })
            .padding(15)
        }
//        .onAppear {
//            if weekSlider.isEmpty {
//                let currentWeek = Date().fetchWeek()
//
//                if let firstDate = currentWeek.first?.date {
//                    weekSlider.append(firstDate.createPreviousWeek())
//                }
//
//                weekSlider.append(currentWeek)
//
//                if let lastDate = currentWeek.last?.date {
//                    weekSlider.append(lastDate.createNextWeek())
//                }
//            }
//        }
        .sheet(isPresented: $createNewTask, content: {
            NewTaskView()
                .presentationDetents([.height(300)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(Color(UIColor.systemGroupedBackground))
        })
        //.preferredColorScheme(.light)
    }

    @ViewBuilder
    func headerView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 5) {
                Text(currentDate.format("LLLL"))
                    .foregroundStyle(.selection)

                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.gray)
            }
            .font(.title.bold())

            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
                .foregroundStyle(.secondary)

            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    weekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        }
        .hSpacing(.leading)
        .padding(15)
        .background(.bar)
    }

    @ViewBuilder
    func weekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)

                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(.selection)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            } else {
                                Circle()
                                    .fill(.bar)
                            }

                            if day.date.isToday {
                                Circle()
                                    .fill(.cyan)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 12)
                            }
                        }
                        .background(.bar.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
                .onChange(of: currentWeekIndex, initial: false) { _, newValue in
                    if newValue == 0 || newValue == (weekSlider.count - 1) {
                        createWeek = true
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX

                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }

    func paginateWeek() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
}

#Preview {
    TaskHomeView()
}

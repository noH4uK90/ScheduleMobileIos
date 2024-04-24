//
//  ContentView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import SwiftUI

struct GroupView: View {

    @EnvironmentObject var navigationService: NavigationService

    var body: some View {
        Content(navigationService: navigationService)
    }

    struct Content: View {

        @StateObject var viewModel: ViewModel

        init(navigationService: NavigationService) {
            _viewModel = StateObject(wrappedValue: ViewModel())
        }

        var body: some View {
            VStack {
                picker
                groups
//                    .redacted(reason: .placeholder)
                Spacer()
            }
        }

        var picker: some View {
            Picker("",
                   selection: $viewModel.selectedCourse) {
                ForEach(Range(1...4), id: \.self) { course in
                    Text("\(course) курс").tag(course)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 24)
        }

        var groups: some View {
            ScrollView {
                GroupsView(groupName: "ИСПП")
                GroupsView(groupName: "ИСС")
                GroupsView(groupName: "ИСПВ")
            }
            .padding(.horizontal, 24)

        }
    }
}

#Preview {
    GroupView()
        .environmentObject(NavigationService())
}

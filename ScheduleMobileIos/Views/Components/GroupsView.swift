//
//  GroupsView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/24/24.
//

import SwiftUI

struct GroupsView: View {

    @State var groupName: String

    @State private var columns: [GridItem] = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading)
    ]

    init(groupName: String) {
        self.groupName = groupName
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(groupName)
                    .font(.title3)
            }
            .frame(maxWidth: 60)

            Divider()
            
            LazyVGrid(columns: columns, alignment: .leading) {
                ForEach(Range(1...9), id: \.self) { group in
                    NavigationLink(destination: {
                        ScheduleView()
                            .navigationTitle(Tab.schedule.title)
                    }) {
                        Text("0\(group)")
                        Spacer()
                    }
                    .cabinetTextStyle()
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding(7)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 0.3)
        }
    }
}

#Preview {
    GroupsView(groupName: "ИСC")
}

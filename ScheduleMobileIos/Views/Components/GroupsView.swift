//
//  GroupsView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/24/24.
//

import SwiftUI

struct GroupsView: View {
    
    @State var specialityGroups: Grouped<Speciality, Group>

    @State private var columns: [GridItem] = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading)
    ]

    init(specialityGroups: Grouped<Speciality, Group>) {
        self.specialityGroups = specialityGroups
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(specialityGroups.key.name)
                    .font(.title3)
            }
            .frame(maxWidth: 60)

            Divider()
            
            LazyVGrid(columns: columns, alignment: .leading) {
                ForEach(specialityGroups.items, id: \.id) { group in
                    NavigationLink(destination: {
                        ScheduleView()
                            .navigationTitle(Tab.schedule.title)
                    }) {
                        Text("\(group.number)")
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
                .stroke(Color(.blue), lineWidth: 0.3)
        }
    }
}

//#Preview {
//    GroupsView(groupName: "ИСC")
//}

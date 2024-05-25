////
////  GroupsView.swift
////  ScheduleMobileIos
////
////  Created by Иван Спирин on 4/24/24.
////
//
//import SwiftUI
//
//struct GroupsView: View {
//
//    @State private var columns: [GridItem] = [
//        GridItem(.flexible(), alignment: .leading),
//        GridItem(.flexible(), alignment: .leading),
//        GridItem(.flexible(), alignment: .leading)
//    ]
//    
//    var body: some View {
//        HStack(alignment: .top) {
//            VStack(alignment: .leading) {
//                Text(specialityGroups.key.name)
//                    .font(.title3)
//            }
//            .frame(maxWidth: 60)
//
//            Divider()
//
//            LazyVGrid(columns: columns, alignment: .leading) {
//                ForEach(specialityGroups.items, id: \.id) { group in
//                    NavigationLink(destination: {
//                        GroupScheduleView(group: group)
//                            .navigationTitle(Tab.schedule.title)
//                    }, label: {
//                        Text("\(group.number)")
//                        Spacer()
//                    })
//                    .cabinetTextStyle()
//                }
//                ForEach((0...10), id: \.self) { number in
//                    Text("\(number)")
//                        .cabinetTextStyle()
//                }
//            }
//            .frame(maxWidth: .infinity)
//            Spacer()
//        }
//        .padding(7)
//        .overlay {
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color(.blue), lineWidth: 1)
//        }
//        .padding(1)
//    }
//}

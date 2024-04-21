//
//  ViewExtension.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/16/24.
//

import Foundation
import SwiftUI

// MARK: Cabinet text style
struct CabinetModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 5)
            .padding(.vertical, 1)
            .background(Color(.systemGray6))
            .cornerRadius(5)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(.systemGray6), lineWidth: 1)
            }
    }
}

extension View {
    func cabinetTextStyle() -> some View {
        self.modifier(CabinetModifier())
    }
}

// MARK: Set up tab
extension View {
    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}

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

// MARK: Hidden view
extension View {
    @ViewBuilder
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

// MARK: Custom spacer
extension View {
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }

    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }

    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

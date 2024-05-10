//
//  ChangePasswordView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/10/24.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Content(dismiss: { dismiss() })
    }

    struct Content: View {
        @StateObject private var viewModel: ViewModel
        var dismiss: () -> Void

        init(dismiss: @escaping () -> Void) {
            self.dismiss = dismiss
            _viewModel = StateObject(wrappedValue: ViewModel())
        }

        var body: some View {
            Form {
                oldPassword
                newPassword
                changeButton
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
            .alert(viewModel.alertMessage, isPresented: $viewModel.showingAlert) {
                Button("OK", role: .cancel) {
                    viewModel.action()
                }
            }
        }

        var oldPassword: some View {
            SecureInputView("Старый пароль", text: $viewModel.password)
        }

        var newPassword: some View {
            Section {
                SecureInputView("Новый пароль", text: $viewModel.newPassword)
                SecureInputView("Подтвердите пароль", text: $viewModel.confirmPassword)
            }
        }

        var changeButton: some View {
            Button("Сменить") {
                viewModel.change(dismiss: dismiss)
            }
        }
    }
}

//#Preview {
//    ChangePasswordView()
//}

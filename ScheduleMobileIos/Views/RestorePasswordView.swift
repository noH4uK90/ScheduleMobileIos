//
//  RestorePasswordView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/24/24.
//

import SwiftUI

struct RestorePasswordView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Content(dismiss: { dismiss() })
    }

    struct Content: View {
        @StateObject var viewModel: ViewModel
        var dismiss: () -> Void

        init(dismiss: @escaping () -> Void) {
            self.dismiss = dismiss
            _viewModel = StateObject(wrappedValue: ViewModel())
        }

        var body: some View {
            VStack {
                TextField("example@gmail.com", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)

                Button {
                    viewModel.restorePassword(dismiss: dismiss)
                } label: {
                    Text("Восстановить")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .alert(viewModel.alertMessage, isPresented: $viewModel.showingAlert) {
                    Button("OK", role: .cancel) {
                        viewModel.alertAction()
                    }
                }

            }
            .padding()
        }
    }
}

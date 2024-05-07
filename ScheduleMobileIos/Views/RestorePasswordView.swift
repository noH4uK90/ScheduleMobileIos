//
//  RestorePasswordView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/24/24.
//

import SwiftUI

struct RestorePasswordView: View {

    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var showingAlert = false

    var body: some View {
        VStack {
            TextField("example@gmail.com", text: $email)
                .textFieldStyle(.roundedBorder)

                Button {
                    showingAlert = true
                } label: {
                    Text("Восстановить")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .alert("Новый пароль выслан на Вашу электронную почту", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {
                        dismiss()
                    }
                }

        }
        .padding()
    }
}

#Preview {
    RestorePasswordView()
}

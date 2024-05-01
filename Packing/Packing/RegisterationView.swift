//
//  RegisterationView.swift
//  Packing
//
//  Created by 김소희 on 4/30/24.
//

import SwiftUI
import AuthenticationServices

extension AuthenticationViewModel {
    @ObservedObject static var shared = AuthenticationViewModel()
}

struct RegistrationView: View {
    @State private var email: String = ""
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @AppStorage("storedName") private var storedName: String = ""
    @AppStorage("storedEmail") private var storedEmail: String = ""
    @AppStorage("userID") private var userID: String = ""
    @StateObject private var authenticationViewModel = AuthenticationViewModel.shared

    var body: some View {
        ZStack {
            Color("mainColor").edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Text("Packing")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .shadow(color: .gray, radius: 2, x: 0, y: 1)
                Text("여행 목적에 맞는 짐 싸기")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
// MARK: EMAIL 넣을지말지.. 넣으면 심들꺼같기도 ..
                TextField("이메일을 입력해주세요.", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)

                Button("이메일로 계속하기") {
                    // Implement email continue action
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)

                Text("또는")
                    .foregroundColor(.gray)
                    .padding()

                HStack {
                    Button(action: {
                        authenticationViewModel.login() // Google login action
                    }) {
                        Image("googleIcon") // Ensure 'googleIcon' is in your assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    }

                    Button(action: {
                        performAppleLogin()
                    }) {
                        Image("macIcon") // Ensure 'appleIcon' is in your assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                }

                Spacer()
                if authenticationViewModel.state == .signedIn {
                    Text("Welcome, \(userName), \(userEmail)")
                        .foregroundColor(.black)
                        .font(.headline)
                }
            }
            .padding()
        }
        .onAppear {
            authenticationViewModel.restorePreviousSignIn()
        }
    }

    private func performAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.performRequests()
    }
}


#Preview {
    RegistrationView()
}

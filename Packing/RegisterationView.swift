//
//  RegisterationView.swift
//  Packing
//
//  Created by 장예진 on 4/30/24.
//

import SwiftUI
import AuthenticationServices

extension AuthenticationViewModel {
    @ObservedObject static var shared = AuthenticationViewModel()
}

//struct RegistrationView: View {
//    @State private var email: String = ""
//    @State private var userName: String = ""
//    @State private var userEmail: String = ""
//    @AppStorage("storedName") private var storedName: String = ""
//    @AppStorage("storedEmail") private var storedEmail: String = ""
//    @AppStorage("userID") private var userID: String = ""
//    @StateObject private var authenticationViewModel = AuthenticationViewModel.shared
//
//    var body: some View {
//        ZStack {
//            Color("mainColor").edgesIgnoringSafeArea(.all)
//
//            VStack {
//                Spacer()
//                Text("Packing")
//                    .bold()
//                    .font(.largeTitle)
//                    .foregroundColor(.black)
//                    .shadow(color: .gray, radius: 2, x: 0, y: 1)
//                Text("여행 목적에 맞는 짐 싸기")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//                Spacer()
//
//
//                HStack {
//                    Button(action: {
//                        authenticationViewModel.login()
//                    }) {
//                        Image("googleIcon")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50, height: 50)
//                            .padding()
//                            .background(Color.white)
//                            .clipShape(Circle())
//                    }
//
//                    Button(action: {
//                        performAppleLogin()
//                    }) {
//                        Image("macIcon")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50, height: 50)
//                            .padding()
//                            .background(Color.white)
//                            .clipShape(Circle())
//                    }
//                }
//
//                Spacer()
//                if authenticationViewModel.state == .signedIn {
//                    Text("Welcome, \(userName), \(userEmail)")
//                        .foregroundColor(.black)
//                        .font(.headline)
//                }
//            }
//            .padding()
//        }
//        .onAppear {
//            authenticationViewModel.restorePreviousSignIn()
//        }
//    }
//
//    private func performAppleLogin() {
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let controller = ASAuthorizationController(authorizationRequests: [request])
//        controller.performRequests()
//    }
//}


struct RegistrationView: View {
    
    
    @State private var email: String = ""
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @AppStorage("storedName") private var storedName: String = ""
    @AppStorage("storedEmail") private var storedEmail: String = ""
    @AppStorage("userID") private var userID: String = ""
    @StateObject private var authenticationViewModel = AuthenticationViewModel.shared
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        ZStack {
            if authViewModel.state == .signedIn {
                OnboardingView()
            } else {
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
                    
                    VStack(spacing: 16) {
                        SignInButton(
                            iconName: "googleIcon",
                            text: "Continue with Google",
                            action: {
                                authenticationViewModel.login()
                            }
                        )
                        
                        SignInButton(
                            iconName: "macIcon",
                            text: "Continue with Apple",
                            action: {
                                performAppleLogin()
                            }
                        )
                    }
                    
                    Spacer()
                    
                    // Display user information if signed in
                    if authenticationViewModel.state == .signedIn {
                        Text("Welcome, \(userName), \(userEmail)")
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                }
                .padding(.horizontal, 24)
                .onAppear {
                    authenticationViewModel.restorePreviousSignIn()
                }
            }
        }
    }

        private func performAppleLogin() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.performRequests()
        }
    }


struct SignInButton: View {
    var iconName: String
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text(text)
                    .foregroundColor(.black)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 1)
        }
    }
}

#Preview {
    RegistrationView()
}

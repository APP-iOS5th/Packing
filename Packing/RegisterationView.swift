//
//  RegisterationView.swift
//  Packing
//
//  Created by 김소희 on 4/30/24.
//

import SwiftUI
import AuthenticationServices

struct RegisterationView: View {
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    
    @AppStorage("storedName") private var storedName: String = "" {
        didSet {
            userName = storedName
        }
    }
    @AppStorage("storedEmail") private var storedEmail: String = "" {
        didSet {
            userEmail = storedEmail
        }
    }
    @AppStorage("userID") private var userID: String = ""
    
    var body: some View {
        Color(hex: 0xBDCDD6)
            .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Packing")
                    .font(.custom("New York-Bold", size: 30))
                    .font(.largeTitle)
                Text("여행의 목적에 맞는 짐싸기")
                    .font(.custom("New York-Bold", size: 20))
                    .font(.largeTitle)
            }
            ZStack {
                Color(hex: 0xBDCDD6)
                if userName.isEmpty {
                    SignInWithAppleButton(.signIn,
                                          onRequest: onRequest,
                                          onCompletion: onCompletion)
                    .signInWithAppleButtonStyle(.whiteOutline)
                    .frame(width: 200, height: 50)
                    .padding()
                    
                } else {
                    Text("Welcome, Packing \n\(userName), \(userEmail)")
                        .foregroundStyle(.black)
                        .font(.headline)
                }
            }
            .task { await authorize() }
            .background(Color(hex: 0xBDCDD6))
            .edgesIgnoringSafeArea(.all)
        }
    
    private func authorize() async {
        guard !userID.isEmpty else {
            userName = ""
            userEmail = ""
            return
        }
        guard let credentialState = try? await ASAuthorizationAppleIDProvider()
            .credentialState(forUserID: userID) else {
            userName = ""
            userEmail = ""
            return
        }
        switch credentialState {
        case .authorized:
            userName = storedName
            userEmail = storedEmail
        default:
            userName = ""
            userEmail = ""
        }
    }
    private func onRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    private func onCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResult):
            guard let credential = authResult.credential as? ASAuthorizationAppleIDCredential
            else { return }
            storedName = credential.fullName?.givenName ?? ""
            storedEmail = credential.email ?? ""
            userID = credential.user
        case .failure(let error):
            print("Authorization failed: " + error.localizedDescription)
        }
    }
}

#Preview {
    RegisterationView()
}

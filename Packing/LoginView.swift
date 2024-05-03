//
//  RegisterationView.swift
//  Packing
//
//  Created by 장예진 on 4/30/24.
//


import SwiftUI
import AuthenticationServices

// MARK: LogOut 수정, deprecated 

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var isOnboardingActive = false
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainColor").edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text("여행에 딱 필요한 짐을 쌀 땐")
                        .font(Font.custom("NanumSquareOTFB", size: 15))
                    Text("Packing")
                        .font(Font.custom("Graduate-Regular", size: 50))
                        .foregroundStyle(Color(hex: 0x566375))
                        .shadow(color: .gray, radius: 2, x: 0, y: 1)
//                        .bold()
                    Spacer()

                    loginButtons
                    Spacer()
                }
                .navigationDestination(isPresented: $isOnboardingActive) {
                    OnboardingView()
                }
                .alert("Login Error", isPresented: $showingAlert, presenting: authViewModel.errorMessage) { error in
                    Button("OK", role: .cancel) { }
                }
                .onChange(of: authViewModel.state) { _ in
                     if authViewModel.state == .signedIn {
                         isOnboardingActive = true
                    }
                }
            }
        }
        .onAppear {
            authViewModel.restorePreviousSignIn()
        }
    }

    var loginButtons: some View {
        VStack(spacing: 15) {
            Button(action: {
                authViewModel.login()
            }) {
                HStack {
                    Image("googleIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text("Sign in with Google")
                        .foregroundColor(.black)
                        .font(.system(size:18))
                }
                .frame(width: 320, height: 18)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }

            SignInWithAppleButton(.signIn,
                                  onRequest: { request in
                                      request.requestedScopes = [.fullName, .email]
                                  },
                                  onCompletion: { result in
                                      switch result {
                                      case .success(_):
                                          isOnboardingActive = true
                                      case .failure(let error):
                                          authViewModel.errorMessage = error.localizedDescription
                                          showingAlert = true
                                      }
                                  })
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)
        }
    }
}

#Preview {
    LoginView()
}

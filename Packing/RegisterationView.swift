//
//  RegisterationView.swift
//  Packing
//
//  Created by 장예진 on 4/30/24.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var isOnboardingActive = false
    @State private var showingAlert = false  // 에러 Alert 표시

    var body: some View {
        NavigationStack {
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
                    
                    HStack {
                        Button(action: {
                            authViewModel.login()
                        }) {
                            Image("googleIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            authViewModel.performAppleLogin()
                        }) {
                            Image("macIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                    Spacer()
                    
                    if authViewModel.state == .signedIn {
                        NavigationLink(destination: OnboardingView(), isActive: $isOnboardingActive) {
                            EmptyView()
                        }
                        .onAppear {
                            if authViewModel.state == .signedIn {
                                isOnboardingActive = true
                            }
                        }
                    }
                }
                .onAppear {
                    authViewModel.restorePreviousSignIn()
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Login Error"), message: Text(authViewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
                }
                .onChange(of: authViewModel.errorMessage) { _ in
                    showingAlert = authViewModel.errorMessage != nil
                }
            }
        }
    }
}

#Preview {
    RegistrationView()
}

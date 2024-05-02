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
                    Text("여행에 딱 필요한 짐을 쌀 땐")
                        .font(Font.custom("NanumSquareOTFB", size: 15))
                    Text("Packing")
                        .font(Font.custom("Graduate-Regular", size: 50))
                        .foregroundStyle(Color(hex: 0x566375))
                        .shadow(color: .gray, radius: 2, x: 0, y: 1)
                    Text("Packing과 함께라면")
                        .font(Font.custom("NanumSquareOTFL", size: 20))
                        .padding(.vertical, 1)
                    Text("완벽하게 준비할 수 있습니다!")
                        .font(Font.custom("NanumSquareOTFL", size: 20))
                        .frame(maxWidth: 550, alignment: .center)
                        .foregroundStyle(.black)
                        .padding(.bottom, 15)
//                        .multilineTextAlignment(.center)

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

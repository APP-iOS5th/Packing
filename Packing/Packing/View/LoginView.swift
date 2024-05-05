//
//  RegisterationView.swift
//  Packing
//
//  Created by 장예진 on 4/30/24.
//


import SwiftUI
import AuthenticationServices

// MARK: Logout 기능 추가
// MARK: Login 이후에는 시작하기랑 로그아웃 창 뜸
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var isMainViewActive = false
    @State private var showingAlert = false
    @State private var isNavigated = false // 네비게이션 발생을 한 번만 허용하게

    
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
                    
                    if authViewModel.state == .signedIn {
                        // 로그인 성공 시, 환영 메시지와 시작하기 버튼 표시하게함.
                        if let username = authViewModel.username {
                            Text("Hello, \(username)")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.vertical, 5)
                        }
                        Button("시작하기") {
                            isMainViewActive = true
                        }
                        .padding()
                        .frame(width: 100, height: 50)
                        .background(.gray)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)

                        Button("Logout") {
                            authViewModel.logout()
                        }
                        .frame(width: 100, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                        .padding()
                    } else {
                        loginButtons
                    }
                    Spacer()
                }
                .navigationDestination(isPresented: $isMainViewActive) {
                    OnboardingView()
                }
                .alert("Login Error", isPresented: $showingAlert, presenting: authViewModel.errorMessage) { error in
                    Button("OK", role: .cancel) { }
                }
//                .onChange(of: authViewModel.state) { _, _ in
//                    if authViewModel.state == .signedIn {
//                        isMainViewActive = true
//                        isNavigated = true
                .onChange(of: authViewModel.state) { newState, _ in
                    if newState == .signedIn && !isNavigated {
                        isMainViewActive = true
                        isNavigated = true
                    }
                }
            }
        }
        .onAppear {
            isMainViewActive = false
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
                                          isMainViewActive = true
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

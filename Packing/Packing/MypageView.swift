//
//  MypageView.swift
//  Packing
//
//  Created by 장예진 on 5/5/24.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct MyPageView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // 사용자 정보 표시
                if let username = authViewModel.username {
                    Text("Hello, \(username)")
                }
                if let email = authViewModel.email {
                    Text("Email: \(email)")
                }
                if let photoURL = authViewModel.photoURL {
                    AsyncImage(url: photoURL) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                }

                // 로그아웃 버튼
                Button("Logout") {
                    authViewModel.logout()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            .navigationTitle("My Page")
        }
    }
}
#Preview {
    MypageView()
}

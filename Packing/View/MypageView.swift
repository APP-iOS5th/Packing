//
//  MypageView.swift
//  Packing
//
//  Created by 장예진 on 5/5/24.
//
//
//import SwiftUI
//import Firebase
//import GoogleSignIn
//
//struct MyPageView: View {
//    @EnvironmentObject var authViewModel: AuthenticationViewModel
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Hello, \(authViewModel.username.isEmpty ? "Guest" : authViewModel.username)")
//                Text("Email: \(authViewModel.email.isEmpty ? "Not available" : authViewModel.email)")
//
//                if let photoURL = authViewModel.photoURL {
//                    AsyncImage(url: photoURL) { image in
//                        image.resizable()
//                            .aspectRatio(contentMode: .fill)
//                    } placeholder: {
//                        ProgressView()
//                    }
//                    .frame(width: 100, height: 100)
//                    .clipShape(Circle())
//                }
//
//                Button("Logout") {
//                    authViewModel.logout()
//                }
//                .padding()
//                .background(Color.red)
//                .foregroundColor(.white)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//            }
//            .padding()
//            .navigationTitle("My Page")
//        }
//    }
//}
//
//#Preview {
//    MyPageView()
//}

//
//  ProfileView.swift
//  Packing
//
//  Created by 장예진 on 5/1/24.
//


import SwiftUI

struct ProfileView: View {
    var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            AsyncImage(url: authenticationViewModel.photoURL) { image in
                image
                    .resizable()
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            Text("User: \(authenticationViewModel.username)")
                .foregroundStyle(.black)
            Text("Email: \(authenticationViewModel.email)")
                .foregroundStyle(.black)
            Button("Logout") {
                authenticationViewModel.logout()
            }
            .buttonStyle(.borderedProminent)
            .frame(width: 200, height: 30, alignment: .center)
            .padding(.top, 10)
        }
    }
}

#Preview {
    ProfileView(authenticationViewModel: AuthenticationViewModel())
}

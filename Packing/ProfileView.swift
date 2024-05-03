//
//  ProfileView.swift
//  Packing
//
//  Created by 장예진 on 5/1/24.
//

// MARK: updated

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Text("Welcome \(authViewModel.username)")
            Text("Email: \(authViewModel.email)")
//            Button("Logout", action: {
//                authViewModel.logout()
//            })
        }
    }
}

#Preview {
    ProfileView()
}

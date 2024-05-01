//
//  AuthenticationView.swift
//  Packing
//
//  Created by 장예진 on 5/1/24.
//
import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

extension UIApplication {
    static var currentRootViewController: UIViewController? {
        UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows
            .filter({ $0.isKeyWindow })
            .first?
            .rootViewController
    }
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    enum State {
        case busy
        case signedIn
        case signedOut
    }
    
    @Published var state: State = .busy
    private var authResult: AuthDataResult? = nil
    var username: String { authResult?.user.displayName ?? "" }
    var email: String { authResult?.user.email ?? "" }
    var photoURL: URL? { authResult?.user.photoURL }
    var userId: String { authResult?.user.uid ?? "" }
    
    func logout() {
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.disconnect()
        try? Auth.auth().signOut()
        authResult = nil
        state = .signedOut
    }
    
    func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error { print("Error: \(error.localizedDescription)")}
            Task {
                await self.signIn(user: user)
            }
        }
    }
    
    func login() {
        state = .busy
        guard let clientID = FirebaseApp.app()?.options.clientID,
              let rootViewController = UIApplication.currentRootViewController else {
            return
        }
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController, hint: nil) { result, error in
            if let error { print("Error: \(error.localizedDescription)")}
            Task {
                await self.signIn(user: result?.user)
            }
        }
    }
    
    private func signIn(user: GIDGoogleUser?) async {
        guard let user, let idToken = user.idToken else {
            state = .signedOut
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: user.accessToken.tokenString)
        
        do {
            authResult = try await Auth.auth().signIn(with: credential)
            state = .signedIn
        } catch {
            state = .signedOut
            print("Error: \(error.localizedDescription)")
        }
    }
}

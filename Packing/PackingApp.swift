//
//  PackingApp.swift
//  Packing
//
//  Created by 이융의 on 4/30/24.
//

import SwiftUI
import Firebase
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       FirebaseApp.configure()
       return true
   }
   
   func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       GIDSignIn.sharedInstance.handle(url)
   }
}

@main
struct PackingApp: App {
   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   var body: some Scene {
       WindowGroup {
           PackingListView(journey:Journey.sample[0])
       }
   }
}

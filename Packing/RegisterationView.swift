//
//  RegisterationView.swift
//  Packing
//
//  Created by 이융의 on 4/30/24.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
    }
}

//TODO : Register word  pixel 5 move

struct RegistrationView: View {
    @State private var username: String = ""
    @State private var profileImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var isRegistrationComplete = false

    var body: some View {
        if isRegistrationComplete {
            OnboardingView()
        } else {
            NavigationStack {
                VStack {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200) // 이미지 크기 조정
                            .clipShape(Circle())
                            .padding()
                    } else {
                        Button("Choose Profile Image") {
                            isShowingImagePicker = true
                        }
                        .padding()
                    }

                    TextField("Enter your name", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Complete Registration") {
                        completeRegistration()
                    }
                    .padding()
                    .disabled(username.isEmpty || profileImage == nil)
                }
                .navigationTitle("Register")
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(selectedImage: $profileImage, sourceType: .photoLibrary)
                }
            }
        }
    }

    func completeRegistration() {
        isRegistrationComplete = true
    }
}

#Preview {
    RegistrationView()
}

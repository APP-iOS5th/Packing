//
//  StorageManager.swift
//  Packing
//
//  Created by 어재선 on 5/2/24.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    static let shared = StorageManager()
    private init() { }
    
    private let storage = Storage.storage().reference()
    
    private var imagesReference: StorageReference {
        storage.child("images")
    }
    
    func saveImage(data: Data) async throws -> String {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let path = "\(UUID().uuidString).jpeg"
        let _ = try await imagesReference.child(path).putDataAsync(data, metadata: meta)
        let url = try await imagesReference.child(path).downloadURL()
        return url.absoluteString
    }
    
    func saveImage(image: UIImage) async throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw URLError(.cannotCreateFile)
        }
        return try await saveImage(data: data)
    }
}

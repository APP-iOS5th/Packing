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
    private init ( ) { }
    
    private let storage = Storage.storage().reference()
    
    private var imagesRefrence: StorageReference {
        storage.child("images")
    }
    
//    private func userReference(userId: String) -> StorageReference {
//        storage.child("users").child(userId)
//    }
    
    func getDate(path: String) async throws -> Data {
        try await imagesRefrence.child(path).data(maxSize: 3 * 12024 * 1024)
    }
    
    func saveImage(data: Data) async throws  -> (path: String, name: String){
        let meta = StorageMetadata()
        
        meta.contentType = "image/jpeg"
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await imagesRefrence.child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        return(returnedPath, returnedName)
        
    }
    
    func saveImage(image: UIImage) async throws  -> (path: String, name: String){
        // image.pngData()
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        
        return  try await saveImage(data: data)
    }
    
    
}

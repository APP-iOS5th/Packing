//
//  JourneyManager.swift
//  Packing
//
//  Created by 이융의 on 5/2/24.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

public class JourneyManager: ObservableObject {
    let storage = Storage.storage()
    
    func upload(image: UIImage) {
        // Create a storage reference
        let uniqueImageName = UUID().uuidString + ".jpg" // 각 이미지에 대한 고유 이름
        let storageRef = storage.reference().child("images/\(uniqueImageName)")
        
        
        // Resize the image to 200px with a custom extension
        let resizedImage = image.aspectFittedToHeight(200)
        
        // Convert the image into JPEG and compress the quality to reduce its size
        guard let data = resizedImage?.jpegData(compressionQuality: 0.2) else {
            print("이미지 압축 실패")
            return
        }

        // Change the content type to jpg. If you don't, it'll be saved as application/octet-stream type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // Upload the image
        storageRef.putData(data, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error while uploading file: ", error)
                return
            }
            if let metadata = metadata {
                print("Metadata: ", metadata)
            }
        }
    }
}

// resize image
extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage? {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


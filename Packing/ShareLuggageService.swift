//
//  ShareLuggageService.swift
//  Packing
//
//  Created by 김영훈 on 5/1/24.
//

import Firebase
import FirebaseFirestore

@Observable
class ShareLuggageService {
    var sharedLuggages: [ShareLuggage]
    var documentID: String
    private let dbCollection = Firestore.firestore().collection("PackingList")
    private var listener: ListenerRegistration?
    
    init(sharedLuggages: [ShareLuggage] = [], documentID: String) {
        self.sharedLuggages = sharedLuggages
        self.documentID = documentID
        
    }
    
//    func getDocumentData() async {
//        do {
//            let document = try await dbCollection.document(documentID).getDocument()
//            if document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//            } else {
//                print("Document does not exist")
//            }
//        } catch {
//            print("Error getting document: \(error)")
//        }
//    }
    
    func printData() {
        print(documentID)
        dbCollection.document(documentID).getDocument { (snapshot, error) in
            if error == nil && snapshot != nil && snapshot!.data() != nil {
                print(snapshot!.data() ?? "empty")
            } else{
                print("error")
            }
        }
    }
    
//    private func updateShareLuggages () async {
//        let docRef = dbCollection.document(documentID)
//        do {
//            let packingItem = try await docRef.getDocument(as: PackingItem.self)
//            sharedLuggages = packingItem.share
//        } catch {
//            print("error: \(error)")
//        }
//    }
    
    func updateShareLuggages () {
        let docRef = dbCollection.document(documentID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    if let personalData = data["personal"] as? [String: Any] {
                        print("personal data: \(personalData)")
                    }
                    if let shareData = data["share"] as? [[String: Any]] {
                        print("share data: \(shareData)")
                    }
                }
            } else {
                print("document does not exist")
            }
        }
    }
    
    //    // 특정 이름의 document를 가져오는 함수
    //    func getDocumentByName(name: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
    //        // 이름 필드를 기준으로 쿼리 생성
    //        let query = dbCollection.whereField("name", isEqualTo: name)
    //
    //        // 쿼리 실행
    //        query.getDocuments { (querySnapshot, error) in
    //            if let error = error {
    //                // 에러 처리
    //                print("Error getting documents: \(error)")
    //                completion(nil, error)
    //            } else {
    //                // 쿼리 결과 반환
    //                completion(querySnapshot?.documents, nil)
    //            }
    //        }
    //    }
    
}

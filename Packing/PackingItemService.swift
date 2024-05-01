//
//  ShareLuggageService.swift
//  Packing
//
//  Created by 김영훈 on 5/1/24.
//

import Firebase
import FirebaseFirestore

@Observable
class PackingItemService {
    var personalLuggages: [String: [PersonalLuggage]]
    var shareLuggages: [ShareLuggage]
    var documentID: String
    private let dbCollection = Firestore.firestore().collection("PackingList")
    private var listener: ListenerRegistration?
    
    init(personalLuggages: [String: [PersonalLuggage]] = [:], shareLuggages: [ShareLuggage] = [], documentID: String) {
        self.personalLuggages = personalLuggages
        self.shareLuggages = shareLuggages
        self.documentID = documentID
        updatePackingItems()
    }
    
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
    
    func updatePackingItems () {
        let docRef = dbCollection.document(documentID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = try? document.data(as: PackingItem.self) {
                    self.personalLuggages = data.personal
                    print("personalLuggages: \(self.personalLuggages)")
                    self.shareLuggages = data.share
                    print("shareLuggages: \(self.shareLuggages)")
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

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
        startRealtimeUpdates()
    }
    
//    func fetch() {
//        guard listener == nil else {return}
//        dbCollection
//    }
    
    private func startRealtimeUpdates() {
        listener = dbCollection.document(documentID).addSnapshotListener{ [self] documentSnapshot, error in
            guard let snapshot = documentSnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            updatePackingItems(snapshot: snapshot)
        }
    }
    
    private func updatePackingItems (snapshot: DocumentSnapshot) {
        if let data = try? snapshot.data(as: PackingItem.self) {
            self.personalLuggages = data.personal
            self.shareLuggages = data.share
        }
//        let docRef = dbCollection.document(documentID)
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                if let data = try? document.data(as: PackingItem.self) {
//                    self.personalLuggages = data.personal
//                    print("personalLuggages: \(self.personalLuggages)")
//                    self.shareLuggages = data.share
//                    print("shareLuggages: \(self.shareLuggages)")
//                }
//            } else {
//                print("document does not exist")
//            }
//        }
    }
}

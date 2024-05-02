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
    
    func fetch() {
        guard listener == nil else {return}
        dbCollection.document(documentID).getDocument{ (documentSnapshot, error) in
            guard let snapshot = documentSnapshot else {
                print("Error fetching snapshot: \(error!)")
                return
            }
            self.updatePackingItems(snapshot: snapshot)
        }
    }
    
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
    }
    
    func togglePersonalLuggage(showingMember: String, index: Int) {
        var updatedPersonalLuggages: [String: [[String:Any]]] = [:]
        for (key, value) in personalLuggages {
            var luggageArray: [[String: Any]] = []
            for luggage in value {
                luggageArray.append(luggage.dictionaryRepresentation())
            }
            updatedPersonalLuggages[key] = luggageArray
        }
        guard let luggages = updatedPersonalLuggages[showingMember], index < luggages.count else {
                print("Invalid index")
                return
            }
        
        if let isChecked = updatedPersonalLuggages[showingMember]![index]["isChecked"] as? Bool {
            updatedPersonalLuggages[showingMember]![index]["isChecked"] = !isChecked
            dbCollection.document(documentID).updateData(["personal" : updatedPersonalLuggages])
        }
    }
}

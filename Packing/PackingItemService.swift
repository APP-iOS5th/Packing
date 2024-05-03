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
    
    func toggleShareLuggage(showingMember: String, index: Int) {
        var updatedShareLuggages: [[String:Any]] = []
        for luggage in shareLuggages {
            updatedShareLuggages.append(["checkedPeople": luggage.checkedPeople, "name": luggage.name, "requiredCount": luggage.requiredCount])
        }
        guard index < updatedShareLuggages.count else{
            print("Invalid index")
            return
        }
        if var checkedPeople: [String] = updatedShareLuggages[index]["checkedPeople"] as? [String] {
            if let indexForRemove = checkedPeople.firstIndex(of: showingMember) {
                checkedPeople.remove(at: indexForRemove)
                updatedShareLuggages[index]["checkedPeople"] = checkedPeople
            } else {
                checkedPeople.append(showingMember)
                updatedShareLuggages[index]["checkedPeople"] = checkedPeople
            }
            dbCollection.document(documentID).updateData(["share" : updatedShareLuggages])
        }
    }
    func newPackingList(id: String, activities: [String], completion: @escaping (Bool, Error?) -> Void) {
        let dbCollection = Firestore.firestore().collection("PackingList")
        let people: [String] = ["나", "멤버2", "멤버3", "멤버4"]
        
        var personalLuggages: [String] = ["세면도구","여벌옷","충전기","개인 약"]
        var shareLuggages: [String : Int] = ["비상 약":1,"드라이기":1,"간식":2]

        for activity in activities {
            switch activity {
            case "해변":
                personalLuggages += ["수영복", "선글라스", "모자"]
                shareLuggages["해변 용품"] = 1
            case "캠핑":
                personalLuggages += ["모기퇴치제", "손전등"]
                shareLuggages["텐트"] = 1
                shareLuggages["캠핑 스토브"] = 1
            case "등산":
                personalLuggages += ["등산화", "등산복"]
            case "스키":
                personalLuggages += ["스키복", "보호대"]
                shareLuggages["스키 장비"] = 1
            case "자전거 타기":
                personalLuggages += ["자전거 헬멧", "장갑"]
                shareLuggages["수리 키트"] = 1
            case "음식 투어":
                personalLuggages += ["간식", "휴대용 포크"]
                shareLuggages["식욕"] = 1
            case "문화 체험", "관광":
                personalLuggages += ["카메라", "여행 가이드북"]
            case "수상 스포츠":
                personalLuggages += ["구명조끼", "방수 카메라"]
                shareLuggages["카약"] = 1
            default:
                personalLuggages = []
            }
        }

        var personalLuggageList: [String: [[String: Any]]] = [:]
        for person in people {
            var array: [[String: Any]] = []
            for personalLuggage in Set(personalLuggages) {  // Set
                array.append(["isChecked": false, "name": personalLuggage])
            }
            personalLuggageList[person] = array
        }

        var shareLuggageList: [[String: Any]] = []
        for (name, count) in shareLuggages {
            shareLuggageList.append(["checkedPeople": [], "name": name, "requiredCount": count])
        }

        dbCollection.document(id).setData(["personal": personalLuggageList, "share": shareLuggageList]) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }

    
    func deletePersonalLuggage(index: Int){
        var updatedPersonalLuggages: [String: [[String:Any]]] = [:]
        for (key, value) in personalLuggages {
            var luggageArray: [[String: Any]] = []
            for luggage in value {
                luggageArray.append(luggage.dictionaryRepresentation())
            }
            luggageArray.remove(at: index)
            updatedPersonalLuggages[key] = luggageArray
        }
        dbCollection.document(documentID).updateData(["personal" : updatedPersonalLuggages])
    }
    
    func deleteShareLuggage(index: Int) {
        var updatedShareLuggages: [[String:Any]] = []
        for luggage in shareLuggages {
            updatedShareLuggages.append(["checkedPeople": luggage.checkedPeople, "name": luggage.name, "requiredCount": luggage.requiredCount])
        }
        guard index < updatedShareLuggages.count else{
            print("Invalid index")
            return
        }
        updatedShareLuggages.remove(at: index)
        dbCollection.document(documentID).updateData(["share" : updatedShareLuggages])
    }
    
    func addPersonalLuggage(name: String){
        var updatedPersonalLuggages: [String: [[String:Any]]] = [:]
        for (key, value) in personalLuggages {
            var luggageArray: [[String: Any]] = []
            for luggage in value {
                luggageArray.append(luggage.dictionaryRepresentation())
            }
            luggageArray.append(["isChecked":false, "name":name])
            updatedPersonalLuggages[key] = luggageArray
        }
        dbCollection.document(documentID).updateData(["personal" : updatedPersonalLuggages])
    }
    
    func addShareLuggage(name: String,requiredCount: Int){
        var updatedShareLuggages: [[String:Any]] = []
        for luggage in shareLuggages {
            updatedShareLuggages.append(["checkedPeople": luggage.checkedPeople, "name": luggage.name, "requiredCount": luggage.requiredCount])
        }
        updatedShareLuggages.append(["checkedPeople":[], "name":name, "requiredCount":requiredCount])
        dbCollection.document(documentID).updateData(["share" : updatedShareLuggages])
    }
}

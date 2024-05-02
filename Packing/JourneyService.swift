//
//  JourneyService.swift
//  Packing
//
//  Created by 이융의 on 5/2/24.
//

import Firebase
import FirebaseFirestore

class JourneyService: ObservableObject {
    @Published var journeys: [Journey]
    private let dbCollection = Firestore.firestore().collection("Journey")
    private var listener: ListenerRegistration?
    
    init(journeys: [Journey] = []) {
        self.journeys = journeys
        startRealtimeUpdates()
    }
    
    func fetch() {
        guard listener == nil else { return }
        dbCollection.getDocuments { [self] querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            print("Successfully fetched journeys")
            updateJourneys(snapshot: snapshot)
        }
    }
    
    func addJourney(destination: String, activities: [TravelActivity], image: String, startDate: Date, endDate: Date, packingItemId: String) {
        let id = UUID().uuidString
        let activitiesString = activities.map { $0.rawValue }
        let newJourney: [String: Any] = [
            "id": id,
            "destination": destination,
            "activities": activitiesString,
            "image": image,
            "startDate": Timestamp(date: startDate),
            "endDate": Timestamp(date: endDate),
            "packingItemId": packingItemId
        ]
        
        dbCollection.addDocument(data: newJourney) { error in
            if let error = error {
                print("Error adding journey: \(error)")
            } else {
                self.fetch()
            }
        }
    }

    
    private func startRealtimeUpdates() {
        listener = dbCollection.addSnapshotListener { [self] querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let data = diff.document.data()
                    let id = data["id"] as? String ?? "Unknown ID"
                    let destination = data["destination"] as? String ?? "Unknown Destination"
                    let image = data["image"] as? String ?? "No Image"
                    let startDate = (data["startDate"] as? Timestamp)?.dateValue() ?? Date()
                    let endDate = (data["endDate"] as? Timestamp)?.dateValue() ?? Date()
                    let packingItemId = data["packingItemId"] as? String ?? "No Packing Item ID"
                    
                    let activities = (data["activities"] as? [String] ?? []).joined(separator: ", ")
                    
                    print("""
                    New journey added:
                    ID: \(id)
                    Destination: \(destination)
                    Image: \(image)
                    Start Date: \(startDate)
                    End Date: \(endDate)
                    Packing Item ID: \(packingItemId)
                    Activities: \(activities)
                    """)
                }
                if (diff.type == .modified) {
                    print("Modified journey: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed journey: \(diff.document.data())")
                }
            }
            updateJourneys(snapshot: snapshot)
        }
    }
    
    private func updateJourneys(snapshot: QuerySnapshot) {
        let journeys: [Journey] = snapshot.documents.compactMap { document in
            guard let data = document.data() as? [String: Any],
                  let id = data["id"] as? String,
                  let destination = data["destination"] as? String,
                  let activitiesData = data["activities"] as? [String],
                  let image = data["image"] as? String,
                  let startDateTimestamp = data["startDate"] as? Timestamp,
                  let endDateTimestamp = data["endDate"] as? Timestamp,
                  let packingItemId = data["packingItemId"] as? String else {
                print("Error decoding journey")
                return nil
            }

            let activities = activitiesData.compactMap(TravelActivity.init)  // String 배열을 TravelActivity 배열로 변환
            let startDate = startDateTimestamp.dateValue()
            let endDate = endDateTimestamp.dateValue()

            return Journey(
                id: id,
                destination: destination,
                activities: activities,
                image: image,
                startDate: startDate,
                endDate: endDate,
                packingItemId: packingItemId,
                docId: document.documentID
            )
        }
        self.journeys = journeys.sorted(by: { $0.startDate > $1.startDate })
        print("Updated journeys: \(journeys.map { $0.destination })")
    }

    func deleteJourney(_ journey: Journey) {
        guard let docId = journey.docId else {
            print("Error: Journey does not have a valid document ID")
            return
        }
        
        dbCollection.document(docId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
                self.fetch()
            }
        }
    }

}



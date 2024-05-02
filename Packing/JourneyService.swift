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
    
    // Adds a new journey to Firestore
    func addJourney(destination: String, activities: [String], image: String, startDate: Date, endDate: Date, packingItemId: String) {
        let newJourney = Journey(
            id: UUID().uuidString,
            destination: destination,
            activities: activities.compactMap { TravelActivity(rawValue: $0) },
            image: image,
            startDate: startDate,
            endDate: endDate,
            packingItemId: packingItemId,
            docId: nil
        )
        
        _ = try? dbCollection.addDocument(from: newJourney) { error in
            if let error = error {
                print("Error adding journey: \(error)")
            } else {
                self.fetch() // Optionally fetch all journeys again to refresh the local data
            }
        }
    }
    
    // Starts listening for real-time updates to the journeys collection
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
            do {
                var journey = try document.data(as: Journey.self)
                journey.docId = document.documentID  // 문서 ID 저장
                return journey
            } catch {
                print("Failed to decode journey: \(error.localizedDescription)")
                return nil
            }
        }
        self.journeys = journeys.sorted(by: { $0.startDate > $1.startDate })
        print("Updated journeys: \(journeys.map { $0.destination })")  // 로그 추가
    }

}



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
            updateJourneys(snapshot: snapshot)
        }
    }
    
    // Adds a new journey to Firestore
    func addJourney(destination: String, activities: [String], image: String, startDate: Date, endDate: Date, packingItemId: String) {
        let newJourney = Journey(
            id: UUID(),
            destination: destination,
            activities: activities.compactMap { TravelActivity(rawValue: $0) },
            image: image,
            startDate: startDate,
            endDate: endDate,
            packingItemId: packingItemId
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
                    print("New journey added: \(diff.document.data())")
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
    
    // Updates the local journeys array with the latest data from Firestore
    private func updateJourneys(snapshot: QuerySnapshot) {
        let journeys: [Journey] = snapshot.documents.compactMap { document in
            var journey = try? document.data(as: Journey.self)
            journey?.id = UUID(uuidString: document.documentID) ?? UUID()
            return journey
        }
        self.journeys = journeys.sorted(by: { $0.startDate > $1.startDate })
    }
}


